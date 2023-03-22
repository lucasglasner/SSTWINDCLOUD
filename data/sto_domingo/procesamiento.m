% practica, enero 2018
% "caracterizacion de la nubosidad costera en la region 
% centro-norte de chile y su relación con los vientos"
% profesor: jose rutllant
close all; clear all; clc
cd /home/alvaro/Documents/MATLAB/practica/matlab/sd/
%% procesamiento de datos
% >>carga de datos<<
sd = loadsynops; % synops de santo domingo
% >>arreglo de datos<<
sd = fixrange(sd);
% >>promedios de datos<<
sd = promedios(sd,'quinc'); % quincenal
sd = promedios(sd,'mensual'); % mensual
% >>limpieza de workspace
clc
% >>compuestos<<
[sd,c] = cp(sd); % diario
sd = cppromedios(sd,c,'quinc'); % quincenal
sd = cppromedios(sd,c,'mensual'); % mensual
% >>anomalias<< (utilizando promedios simples)
sd = anomalias(sd,'diario'); % diarias
sd = anomalias(sd,'quinc'); % quincenales
sd = anomalias(sd,'mensual'); % mensuales
% >>guardar variables procesadas
save sd.mat sd
% indicador de que finalizo de ejecutarse el script
disp('ok')

