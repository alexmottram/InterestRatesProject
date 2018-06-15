function InterestRate_Calibration()
    CalFile = load('CalibrationData.mat');
    CalData = CalFile.CalibrationData;
    
    for i = 1:size(CalData(:,1))
        ForwardRates = ()
    end
    
    
    plot(CalData(:,1),CalData(:,2))
    
    
    
end

function [price] = VasicekPricing(t,Expiry,gamma,sigma,meanRate,rt)
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


