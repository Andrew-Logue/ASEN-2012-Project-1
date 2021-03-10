close all;   % Close all open figure windows
clc;         % Clear the command window

% Reading in SampleC Data %
data = dlmread('SampleC.csv',',',1,0); % Read in depth data from .csv
time = data(:,1);
temp1_cal = data(:,2);
temp_water = data(:,3);
temp_air = data(:,4);
temp2_cal = data(:,5);

% Calculate thye avergae temp of the sample from the two calorimeter readings
sample_avgtemp = (temp1_cal+temp2_cal)/2;
% Specific heat of the calorimeter
C_c = 0.895; % J/(gC)
% Mass of calorimeter
m_c = 510; % g
% Mass of sample
m_s = 17.615; % g
% Time sample added (index)
time_added = 290;

% Calculate initial temperature of the calorimeter
T0 = sample_avgtemp(time_added,1);
% Calculate initial temperature of the sample
T1 = mean(temp_water(1:time_added));
% Calculate final temperature of the calorimeter and sample at equilibrium
T2 = max(sample_avgtemp);
max_index = find(sample_avgtemp==T2);
[length,~] = size(sample_avgtemp);

% Specific heat of the sample
C_s = (m_c*C_c*(T2-T0))/(m_s*(T1-T2)); % J/(gC)

% Get lines of best fit before the sample is added
xFit_pre = linspace(0, max_index, 500);
linearCoefficients_pre = polyfit(time(1:time_added), sample_avgtemp(1:time_added), 1);
yFit_pre = polyval(linearCoefficients_pre, xFit_pre);

% Get lines of best fit after the equilibrium has been reached
xFit_post = linspace(time(time_added,1), time(length,1), 500);
linearCoefficients_post = polyfit(time(max_index:length), sample_avgtemp(max_index:length), 1);
yFit_post = polyval(linearCoefficients_post, xFit_post);

% Plot
figure(1)
hold on
scatter(time, sample_avgtemp, 3, '*', 'MarkerEdgeColor', 'k')
plot(xFit_pre, yFit_pre, 'g-', 'LineWidth', 1)
plot(xFit_post, yFit_post, 'r-', 'LineWidth', 1)
plot(time(time_added,1), T0, 'm*')
plot(time(max_index,1), T2, 'c*')
title('Temperature Profile From Calorimeter')
xlabel('Time (Seconds)')
ylabel('Temperature (Celsius)')
legend('Calorimeter readings','T0 Regression Line', 'T2 Regression Line', 'T0', 'T2')
hold off