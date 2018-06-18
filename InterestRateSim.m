
% Insert the parameters you wish to use here
gamma = 0.79; % 0.79
meanRate = 0.06;
params = [gamma,meanRate];
spotInterestRate = 0.01;
sigma_1year = 0.015;

% Specifies details about the number of paths to run and time steps
% to use
noYears = 5;
deltaT = 1;
timeSteps = 1 + floor(noYears/deltaT);
noPaths = 1000;
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

hold off

% Fits a normal distribution to the data to extract the mean and std dev of
% the result for each year (not including the initial year 0)
Mean_IR = zeros(timeSteps,1);
Mean_IR(1) = spotInterestRate;
StdDev_IR = zeros(timeSteps,1);

for i = 2:timeSteps
   histfit(InterestRate_Results(:,i));
   tempDataStruct = fitdist(InterestRate_Results(:,i),'Normal');
   hold on
   
   Mean_IR(i) = tempDataStruct.mu;
   StdDev_IR(i) = tempDataStruct.sigma;   
end

TimeVector.'
Mean_IR
StdDev_IR


function [newRate] = IterateRate(oldRate,params,sigma,deltaT)
    gamma = params(1);
    meanRate = params(2);
    WeinerProcess = normrnd(0,1);
    
    deltaRate = (gamma*(meanRate-oldRate)*deltaT)+(sigma*WeinerProcess);
    newRate = oldRate + deltaRate;    
end