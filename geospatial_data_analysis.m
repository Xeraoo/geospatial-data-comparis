% Author: Tymoteusz Maj
% Date: 18.10.2024
% Description: Analysis of geospatial data comparing two datasets from 
% Geoportal1 and Up42, with an additional focus on Digital Terrain Model (DTM) 
% uncertainty analysis. The script calculates key statistics, compares datasets, 
% visualizes data, and evaluates DTM accuracy and uncertainty.

% Load data from the CSV file into a MATLAB table.
data = readtable('z_geoportal_up42.csv');

% Rounding the values in the geoportal1 and up421 columns.
geoportal1_rounded = round(data.geoportal1); 
up421_rounded = round(data.up421); 

% Filling missing values in the up421 column with the mean of the available data.
up421_filled = data.up421;
up421_filled(isnan(up421_filled)) = mean(up421_filled, 'omitnan');

% Calculating basic statistics for the Geoportal1 dataset (rounded).
MAE_geoportal = mean(abs(geoportal1_rounded)); 
SD_geoportal = std(geoportal1_rounded); 
ME_geoportal = mean(geoportal1_rounded); 
RMSE_geoportal = sqrt(mean(geoportal1_rounded.^2)); 

% Calculating basic statistics for the Up42 dataset (filled with mean values).
MAE_up42 = mean(abs(up421_filled)); 
SD_up42 = std(up421_filled); 
ME_up42 = mean(up421_filled); 
RMSE_up42 = sqrt(mean(up421_filled.^2)); 

% Displaying the statistics for the Geoportal1 dataset.
disp('Statistics for Geoportal (Rounded):');
disp(['Mean Absolute Error (MAE): ', num2str(MAE_geoportal)]);
disp(['Standard Deviation (SD): ', num2str(SD_geoportal)]);
disp(['Mean Error (ME): ', num2str(ME_geoportal)]);
disp(['Root Mean Square Error (RMSE): ', num2str(RMSE_geoportal)]);

% Displaying the statistics for the Up42 dataset.
disp('Statistics for Up42 (Filled):');
disp(['Mean Absolute Error (MAE): ', num2str(MAE_up42)]);
disp(['Standard Deviation (SD): ', num2str(SD_up42)]);
disp(['Mean Error (ME): ', num2str(ME_up42)]);
disp(['Root Mean Square Error (RMSE): ', num2str(RMSE_up42)]);

% Comparing statistics between the Geoportal1 and Up42 datasets.
disp('Comparison between Geoportal and Up42:');
disp(['Difference in MAE: ', num2str(MAE_up42 - MAE_geoportal)]);
disp(['Difference in SD: ', num2str(SD_up42 - SD_geoportal)]);
disp(['Difference in ME: ', num2str(ME_up42 - ME_geoportal)]);
disp(['Difference in RMSE: ', num2str(RMSE_up42 - RMSE_geoportal)]);

% Check if SD equals RMSE for both datasets (this happens when ME = 0).
if ME_geoportal == 0 && ME_up42 == 0
    disp('For both datasets, SD equals RMSE because ME is zero.');
else
    disp('For one or both datasets, SD does not equal RMSE because ME is not zero.');
end

% DTM Uncertainty Analysis: Assessing DTM Accuracy
% DTM accuracy can be evaluated using RMSE and Standard Deviation (SD). 
% The lower the RMSE and SD, the higher the accuracy of the DTM.

disp('*** DTM Uncertainty Analysis ***');
% Calculate uncertainty metrics for the DTM (assuming up421 corresponds to DTM data).
disp(['DTM Accuracy (RMSE for Up42): ', num2str(RMSE_up42)]);
disp(['DTM Standard Deviation (SD for Up42): ', num2str(SD_up42)]);

if RMSE_up42 < 1 && SD_up42 < 1
    disp('The DTM is considered highly accurate based on low RMSE and SD values.');
elseif RMSE_up42 < 2 && SD_up42 < 2
    disp('The DTM has moderate accuracy.');
else
    disp('The DTM accuracy is low. Consider improving data sources or models.');
end

% Visualization of the results through scatter plot and histograms.
figure;
subplot(2,2,1); 
scatter(geoportal1_rounded, up421_filled, 'filled');
xlabel('Geoportal1 (Rounded)');
ylabel('Up42 (Filled)');
title('Scatter plot: Geoportal1 vs Up42');
grid on;

% Creating a histogram of values for Geoportal1.
subplot(2,2,2); 
histogram(geoportal1_rounded, 20); 
xlabel('Geoportal1 Values (Rounded)');
ylabel('Frequency');
title('Histogram of Geoportal1 (Rounded)');
grid on;

% Creating a histogram of values for Up42.
subplot(2,2,3); 
histogram(up421_filled, 20); 
xlabel('Up42 Values (Filled)');
ylabel('Frequency');
title('Histogram of Up42 (Filled)');
grid on;

% Adding a general title to the figure.
sgtitle('Analysis of Geoportal1 and Up42 Data, Including DTM Uncertainty'); 
