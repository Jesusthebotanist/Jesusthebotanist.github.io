%% *Load Data* 

%Clear Enviornment and Read in Data
clear all; close all; clc;
cd '/Volumes/GoogleDrive/My Drive/Projects/Jesusthebotanist.github.io'; 
floralData = readtable('assets/code/scent/compounds.csv'); 

%Move to the FathomToolBox folder for relavant functions. 
cd ..
cd '/Volumes/GoogleDrive/My Drive/Projects/Jesusthebotanist.github.io/assets/code/scent/FathomToolBox/'
%% *NMDS Analysis*
% NMDS was calculated with both built-in Matlab function 'mdscale' and the
% Fathom toolkit function 'F_nmds.' (Jones 2015). Similar results were 
% obtained therefore, we used 'mdscale' for all downstream analysis. 

% Extract only scent data
floralScent = floralData(:,8:end);
floralScent = table2array(floralScent).';

% Calculate Bray-Curtis distance with Fathom Package
F_dissimilaritiesBC = f_braycurtis(floralScent);
    
% 2-axis nMDS with Matlab 'mdscale'
[F_Y,F_stress,F_disparities] = mdscale(F_dissimilaritiesBC,2,...
    'criterion','stress','Start','random','Replicates',500); 

% 2-axis NMDS with Fathom Package 'f_nmds'
F_Fathom_nmds = f_nmds(F_dissimilaritiesBC,2);   

% Compare Stress Value Output of Floral Data Between Matlab and 
% Fathom Functions
disp ({'Matlab mdscale function 2 Axis Floral stress value =', F_stress});
disp ({'Fathom f_nmds function 2 Axis Floral stress value =',...
        F_Fathom_nmds.stress});
%% *nMDS Plot*
% Generate two dimensional nMDS plot (Figure 2b). 

% 2-Axis nMDS plot with Pollination Syndrome Labels
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