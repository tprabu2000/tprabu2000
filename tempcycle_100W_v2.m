%%
% tempcycycle_v2.m
%
% This code show how Arria10 FPGA junction temperature vary with: ambient, power, air-flow and heat-sink types
% 
% 30 August 2017 
%%

clf
clear

%%
% air-flow is LFM
% Junction temperature is TJ
% Junction temperature maximum is TJMAX = 100 degree-C
% Ambient temperature is TA
% Power desipation from FPGA is PD
% temperature resistance between the junction and case is ThJC
% temperature resistance between the case and heatsink is ThCS
% temperature resistance between the heatsink and ambient is ThSA
% temperature resistance between the junction and ambient is ThJA
% 
%%

%% 
% range of possible values
%%
LFM = [100, 200, 300] ;   % linear feet per minute 
TJMAX = 100;  % degree-C
ThCS = [0.035, 0.068, 0.6, 0.7, 0.8, 0.9, 1.25];  % degree-C/Watts 
TA = [15, 17, 25, 27, 32.5];  % degree-C
PD = [10, 20, 30, 38, 41, 97];
ThJC = [0.14];
ThJA =[6.6, 6.6, 5.3, 4.3];  % in deg-C/Watts at still, 100, 200 and 400 LFM airflow

% http://www.myheatsinks.com/calculate/thermal-resistance-round-pin/#
% Thermal Resistance Calculator – Plate Fin Heat Sink
%  Input: Parametric Values
%  Width: 40 mm   Length: 40 mm  Height: 12 mm
%  Base Thickness: 3 mm    Fin Thickness: 2 mm   Number of Fins: 13 
%  Calculation Result: Thermal Resistance for 100, 200 and 300 LFM

% Material: Aluminum (pure)
ThSA_Al_13Fins = [3.24, 1.94, 1.53]; % Degree-C/W
%  Material: Copper (pure)
ThSA_Cu_13Fins = [3.23, 1.93, 1.52]; % Degree-C/W

% Thermal Resistance Calculator for Round Pin Heat Sink
% Width: 40 mm  Length: 40 mm   Height: 10 mm
% Base Thickness: 3 mm  Pin Diameter: 2 mm
% Number of Rows: 10  Pins Per Row: 10
% for 100, 200, 300 LFM

% Material: Aluminum (pure)
ThSA_Al_10Pins = [2.24, 1.60, 1.31]; % Degree-C/W
% Material: Copper (pure)
ThSA_Cu_10Pins = [2.22, 1.58, 1.29]; % Degree-C/W

% Material: Aluminum (pure)
% Width: 40 mm  Length: 40 mm   Height: 12 mm   Base Thickness: 3 mm
% Pin Diameter: 2 mm   Number of Rows: 13  Pins Per Row: 13
ThSA_Al_13Pins = [ 0.88, 0.63, 0.52 ]; % Degree-C/W

ThSA(1)  = ThSA_Al_10Pins(2);
ThSA(2) = ThSA_Al_10Pins(3);
ThSA(3) = ThSA_Al_13Pins(1);
ThSA(4) = ThSA_Al_13Pins(3);


titletexts = [ '  Airflow 200 LFM and 10-Pins'; '  Airflow 300 LFM and 10-Pins';  '  Airflow 100 LFM and 13-Pins';  '  Airflow 100 LFM and 13-Pins' ];  

ncase = length(ThSA);
for Thidx=1:ncase

ThTotal =  ThJC + ThCS(1) + ThSA(Thidx)

lincol = [ 'bX:'; 'bd:';  'bO:'; 'rs:'; 'r>-'; 'rs-'];  
subplot(1,ncase,Thidx)

npwr = length(PD);
for pidx=1:npwr

    PWR = PD(pidx);

    TJ = TA + ThTotal * PWR;
    plot(TA, TJ, lincol(pidx,:),'LineWidth',2.5 );
    lg(pidx,:) = strcat( num2str(PWR), ' W');
    hold on
    grid on
 
end;

set(gca, 'yTick', [30 50 70 80 100 110])
set(gca, 'yTicklabel', {'30 C','50 C', '70 C', '80 C', '100 C', '110 C'},'FontSize',12)

set(gca, 'xTick', [15 18 25 27 32 ])

set(gca, 'xTicklabel', {'15C','18C', '25 ', '27C','32C'},'FontSize',10)

legend( lg, 'Location', 'NorthWest' )
xlabel('Ambient tempertaure','FontSize',13)
ylabel('FPGA junction temperature','FontSize',13)

fignum = strcat('Plot-', num2str(Thidx));
titlestr = strcat(fignum,  titletexts(Thidx,:) );
title(titlestr, 'FontSize',14)


xlim([ 12 37])
ylim([ 25 110])
 
end