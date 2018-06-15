function InterestRate_Calibration()
    CalFile = load('CalibrationData.mat');
    CalData = CalFile.CalibrationData;
    
    init_gamma = 0.065;
    init_sigma = 0.015;
    init_meanRate = 0.06;
        
    tempfwrd = CalData(2:end,3) + ...
        (CalData(2:end,3)-CalData(1:end-1,3)).*(CalData(2:end,1)./(CalData(2:end,1)-CalData(1:end-1,1)));
    
    ForwardRates = [CalData(1,3); tempfwrd];    
    plot(CalData(:,1),ForwardRates)
    
    parameters = [init_gamma,init_sigma,init_meanRate];
    
    
    
    
end

function [price] = VasicekPricing(t,Expiry,parameters,rt)
    gamma = parameters(1);
    sigma = parameters(2);
    meanRate = parameters(3);
    price = exp(Afunc(t,Expiry,gamma,sigma,meanRate)-(Bfunc(t,Expiry,gamma)*rt));
end


function [output] = Afunc(t,Expiry,gamma,sigma,meanRate)
    part1 = (Bfunc(t,Expiry,gamma)-(Expiry-t))*(meanRate-((sigma^2)/(2*(gamma^2))));
    part2 = ((sigma*Bfunc(t,Expiry,gamma))^2)/(4*gamma);
    output = part1 - part2;
end

function [output] = Bfunc(t,Expiry,gamma)
    output = (1/gamma)*(1-exp(-gamma*(Expiry-t)));
end


