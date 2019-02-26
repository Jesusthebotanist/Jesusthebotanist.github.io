%% Thalictrum Scent NMDS and ANOSIM 
% Last updated March 10, 2018
%
% This script accompanies the manuscript 'Scent Matters: Repeated loss of 
% insect attraction by floral scent accompanies transitions to wind 
% pollination.'  
% 
% Non-multidimensioanl Scaling (NMDS) and ANalysis Of 
% SIMilarity (ANOSIM) are computed with Thalictrum Scent data. 
% 
% This scritp calls functions from the 'Fathom Toolbox for Matlab'
% Citation: Jones, D. L. 2015. Fathom Toolbox for Matlab: software for multivariate ecological and oceanographic data analysis. College of Marine Science, University of South Florida, St. Petersburg, FL, USA.
%% *Load Data* 
% Data description: Rows are individual samples (species), Columns are 
% measurments for each sample as follows,
%
% * _SpeciesName_Abbreviation_: Three letter species apperciation
% * _NameAs_number_: Name of Species as a number
% * _Pollination_Syndrome_: 1 Insect, 2 Wind
% * _Time_(min)_: Scent Collection Time
% * _Mass_(g)_: Mass of tissue in grams
% * _Mass*time_: Time_(min) * Mass_(g)
% * The remainder of columns are emission rates (ng emitted/g tissue * min) for biochemicals emitted by samples 

%Clear Enviornment and Read in Data
clear all; close all; clc;
cd '/Volumes/GoogleDrive/My Drive/Projects/Jesusthebotanist.github.io' 
floralData = readtable('assets/code/scent/compounds.csv'); 

%Move to the FathomToolBox folder for relavant functions. 
cd ..
cd 'assets/code/scent/FathomToolBox'
%% *NMDS Analysis*
% NMDS was calculated with both built in Matlab 'mdscale' function and
% Fathom toolkit function 'F_nmds.' Similar results were obtained
% therefore, we used 'mdscale' for all downstream analysis. 

%Extract only scent data
floralScent = floralData(:,8:end);

floralScent = table2array(floralScent).';

%Calculate Bray-Curtis distance with Fathom Package
F_dissimilaritiesBC = f_braycurtis(floralScent);
    
%2 axis nMDS with Matlab 'mdscale'
[F_Y,F_stress,F_disparities] = mdscale(F_dissimilaritiesBC,2,...
    'criterion','stress','Start','random','Replicates',500); 

%2 axi NMDS with Fathom Package 'f_nmds'
F_Fathom_nmds = f_nmds(F_dissimilaritiesBC,2);   

%Compare Stress Value Output of Floral Data Between Matlab and 
%Fathom Functions
disp ({'Matlab mdscale function 2 Axis Floral stress value =', F_stress});
disp ({'Fathom f_nmds function 2 Axis Floral stress value =',...
        F_Fathom_nmds.stress});
%% *NMDS Plot*
% The following section generates the NMDS plot.
%
% Note: Plots are generated with Matlab 'gscatter' function which labeles
% individual. However in order to see labels you must highlight points 
% with your mouse curser. See 'gscatter' help for more detail. 

%2-Axis nMDS plot with Pollination Syndrome Labels
figure(1);
    gscatter(F_Y(:,1),F_Y(:,2),...
        (table2array(floralData(:,{'Pollination_Syndrome'}))),'br','..>');
        legend('Insect','Wind');
        xlabel('NMDS 1');
        ylabel('NMDS 2');
        title({
             'Floral nMDS'
             ['Stress = ', num2str(F_stress)]; 
             });      
    gname(table2array(floralData(:,{'Species_Name_Abbreviation'})));
%% *1- Way ANOSIM* 
% Calculate 1-way ANOSIM using Fathom Toolbox 'f_anosim' funciton. 

% ANOSIM - Group by Species
[F_r,F_p] = f_anosim(F_dissimilaritiesBC,...
            (table2array(floralData(:,{'F_name_number'}))),1,1000,1);
           
% ANOSIM - Group by Pollination syndrome
[FP_r, FP_p] = f_anosim(F_dissimilaritiesBC,...
               (table2array(floralData(:,{'Pollination_Syndrome'}))),...
               1,1000,1);