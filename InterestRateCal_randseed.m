function InterestRateCal_randseed()

    CalFile = load('CalibrationData.mat');
    CalData = CalFile.CalibrationData;
    
    Expiry = CalData(1:end,1);
    RealPrices = CalData(1:end,2);
    ZCRates = CalData(1:end,3); 
    
    init_gamma = 0.74;
    init_meanRate = 0.0579;
    init_spotInterestRate = 0.0095;
    init_params = [init_gamma,init_meanRate,init_spotInterestRate];
    
    sigma = 0.015;
    t = 0;
    
    tempfwrdrates = ZCRates(2:end) + ...
        (ZCRates(2:end)-ZCRates(1:end-1)).*(Expiry(2:end)./(Expiry(2:end)-Expiry(1:end-1)));
    
    ForwardRates = [ZCRates(1); tempfwrdrates];
    
%   Creates random starting positions for the optimization
    no_Seeds = 10000;
    Param_Seeds = [];
    
    for i = 1:no_Seeds
        rand_gamma = normrnd(init_gamma,sqrt(init_gamma)/10);   
        rand_meanRate = normrnd(init_meanRate,sqrt(init_meanRate)/10);
        rand_spotInterestRate = normrnd(init_spotInterestRate,sqrt(init_spotInterestRate)/10);
        % abs() is used to avoid negative starting seeds, inelegant but
        % effective
        Param_Seeds(i,:) = [abs(rand_gamma),abs(rand_meanRate),abs(rand_spotInterestRate)];
    end
    
    hold off
    plot(Expiry,RealPrices,'r')
    hold on    
    prefitPrices = VasicekPricing(t,Expiry,init_params,sigma);    
    plot(Expiry,prefitPrices,'b')
    
%   Preamble for the least square non-linear solver
    funcIR = @(params)VasicekCalibrate(t,Expiry,params,sigma,RealPrices);    
    lb = [0,0,0];
    ub = [2,0.1,0.1];
    options = optimoptions(@lsqnonlin,'OptimalityTolerance',1E-9,...
        'FunctionTolerance',1E-9)
    
%   Keeps track of best fit residual and stores parameters    
    [solved_params,resnorm] = lsqnonlin(funcIR,init_params,[],[],options);
    best_fit_params = solved_params;
    best_fit_residual = resnorm;
    
%   Runs through the seeds and performs a least squares fit on each seed keeping
%   the data if it better than the previous best fit.
    for i = 1:no_Seeds
        [solved_params,resnorm] = lsqnonlin(funcIR,Param_Seeds(i,:),lb,[],options);
        
        if (resnorm < best_fit_residual)
            best_fit_params = solved_params;
            best_fit_residual = resnorm
        end
    end
    
    fittedPrices = VasicekPricing(t,Expiry,best_fit_params,sigma);
    
    plot(Expiry,fittedPrices,'g')
    
    final_gamma = best_fit_params(1)
    final_meanRate = best_fit_params(2)
    final_spotinterest = best_fit_params(3)    
    final_sigma = sigma
    
    
end

function [diff] = VasicekCalibrate(t,Expiry,params,sigma,RealPrices)
    diff = (VasicekPricing(t,Expiry,params,sigma)-RealPrices).^2;
end

function [price] = VasicekPricing(t,Expiry,params,sigma)    
    % Unpacks parameters
    gamma = params(1);
    meanRate = params(2);
    rt = params(3);
    price = exp(Afunc(t,Expiry,gamma,sigma,meanRate)-(Bfunc(t,Expiry,gamma).*rt));
end


function [output] = Afunc(t,Expiry,gamma,sigma,meanRate)
    part1 = (Bfunc(t,Expiry,gamma)-(Expiry-t))*(meanRate-((sigma^2)/(2*(gamma^2))));
    part2 = ((sigma*Bfunc(t,Expiry,gamma)).^2)/(4*gamma);
    output = part1 - part2;
end

function [output] = Bfunc(t,Expiry,gamma)
    output = (1/gamma)*(1-exp(-gamma*(Expiry-t)));
end


