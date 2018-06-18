%% Option PRICING simulation with bond as the underlying asset
% This sim calculates the payoff for an option with a bond as the
% underlying asset.
% PO(T1) = max{A * Z(T1,T2) - K , 0}
% PO(T1) = the payoff of the option at time of expiry of the option (T1)
% Z(T1,T2) = the price of a bond at time T2 valued at T1
% K = the strike price of the option
% A = multiplying factor related to payoff
T1 = 2;
T2 = 5;
K = 82;
A = 100;

% Insert the parameters you wish to use here
gamma = 0.79; % 0.79
meanRate = 0.059; % 0.059
params = [gamma,meanRate];
spotInterestRate = 0.0037; % 0.0037
sigma_1year = 0.1; % 0.015

% Specifies details about the number of paths to run and time steps
% to use
noYears = 5;
deltaT = 1;
timeSteps = 1 + floor(noYears/deltaT);
noPaths = 10000;
TimeVector = linspace(0,noYears,timeSteps);

% The stochastic time should be independant to the time step chosen, to do
% this the term of sigma (previously calibrated to 1 year time steps) can
% be modified using the fact that for the sum of # normal
% distributions with equal std dev, the total std dev is:
% \sigma^2(total) = # * \sigma^2(individual). In our case the number of
% distributions in 1 year is 1/deltaT. So sigma for an individual time step
% would be sigma(1 time step) = sqrt(deltaT) * sigma (1 year).
sigma = sigma_1year*sqrt(deltaT);

InterestRate_Results = zeros(noPaths,timeSteps);

% Performs the simulation
for i = 1:noPaths
    
    InterestRate_Results(i,1) = spotInterestRate;    
    oldRate = spotInterestRate;
    
    for j = 2:timeSteps
         newRate = IterateRate(oldRate,params,sigma,deltaT);         
         InterestRate_Results(i,j) = newRate;
         oldRate = newRate;
    end
end

% Here we will do the actual calculation that works out at time T1 what the
% value of a bond expiring at time T2 would be.
price = ones(noPaths,1);
first_point = find(TimeVector==T2)-1;
last_point = find(TimeVector==T1);
for j= first_point:-1:last_point   
    price = price.*exp(-InterestRate_Results(:,j)*(TimeVector(j+1)-TimeVector(j)));  
end

PayOff = max((A*price)-K,0);
% To take into account the time value aspect of money by reducing the
% payoff by the interest rate path back to time t=0.
OptionPrice = PayOff;
if(last_point>1)
    for j= last_point-1:-1:1   
        OptionPrice = OptionPrice.*exp(-InterestRate_Results(:,j)*(TimeVector(j+1)-TimeVector(j)));  
    end    
end


histogram(OptionPrice);
Mean_OptionPrice = mean(OptionPrice)

hold off

function [newRate] = IterateRate(oldRate,params,sigma,deltaT)
    gamma = params(1);
    meanRate = params(2);
    WeinerProcess = normrnd(0,1);
    
    deltaRate = (gamma*(meanRate-oldRate)*deltaT)+(sigma*WeinerProcess);
    newRate = oldRate + deltaRate;    
end