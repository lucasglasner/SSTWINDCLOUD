% practica, enero 2018
% "caracterizacion de la nubosidad costera en la region 
% centro-norte de chile y su relación con los vientos"
% profesor: jose rutllant
close all; clear all; clc
cd /home/alvaro/Documents/MATLAB/practica/matlab/sd/
%% carga de datos (ya procesados de script "procesamiento.m")
load sd.mat

%% calculo de correlaciones
% >>limpieza de terminal<<
% clc
% >>variables a correlacionar<<
var1 = sd.comp.diario.nub.oct; % debiese estar relacionada con nubosidad
var2 = sd.comp.diario.v; % variables como {vel,u,v,etc.}
var2 = abs(var2); % para comparar magnitud de velocidad
% >>tipo de relacion<<
r1 = 0; % 0 horaria {0:3:21} vs {0:3:21}
r2 = 3; % 1 {temp,tard,noch} vs {temp,tard,noch}
r3 = 4; % 2 {temp1} vs {tard1}
        % 3 {temp2,tard2} vs {temp2,tard2}
        % 4 {temp2} vs {tard2}
% **temp1 = {3:9}, tard1 = {12:18}, noch1 = {21:24}
% **temp2 = {3:12}, tard2 = {15:24}
% >>correlaciones<<
correlaciones(var1,var2,r1); 
correlaciones(var1,var2,r2); 
correlaciones(var1,var2,r3); 
% >>limpiar workspace<<
% clear var1 var2

% TAREA PENDIENTE: CONDICIONAR PROMEDIOS (SI NO SE CUMPLE UNA CANTIDAD
% MINIMA DE DATOS, DESCARTAR PROMEDIO)
%% figuras
% >>variable(s) a mostrar<<
var1 = sd.comp.diario.nub.oct;
var2 = sd.comp.diario.v;
var2 = abs(var2); % para comparar magnitud de velocidad
% >>propiedades de colores<<
color = 'redblue';
% lim = [-max(abs(var2(:))),max(abs((var2(:))))];
lim = [-3,3];
lim1 = [min(var1(:)),max(var1(:))];
% lim2 = [min(var2(:)),max(var2(:))];
lim2 = [0,7];
% >>tipo de relacion<<
r = 3;
titulo = '|v|';
% >>figura(s)<<
% figure; mapa(sd); % localidad de estaciones
% figure; avail(sd); % disponibilidad de datos
% figure; evolucion(sd,var1,lim1,flipud(gray)); % clima / meteo
% figure; evolucion(sd,var2,lim,color); % clima / meteo
% figure; dispersion(var1,var2,lim1,lim2,r,titulo); % grafico de dispersion
% >>limpiar workspace<<
% clear var1 var2 clim relacion

