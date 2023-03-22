% grafica mapa con localizacion de lugar(es)
function mapa(sd)
    % extraccion de variables
    lat = sd.prop.lat;
    lon = sd.prop.lon;
    % limites de mapa
    dm = 3; % delta meridiano
    dp = 4; % delata paralelo
    latlim = [lat-dp,lat+dp];
    lonlim = [lon-dm,lon+dm];
    % creacion de mapa con estaciones
    axesm('mercator','maplatlim',latlim,'maplonlim',lonlim,'mlinelocation',2,'plinelocation',2);
    axis off
    box on
    framem
    gridm 
    mlabel('south') 
    plabel('east')
    % dibujo de bordes
    reg = load('regiones.mat');
    plotm(reg.lat,reg.lon,'.k','markersize',3)
    clear reg
    % posicion estacion el panul, san antonio
    plotm(lat,lon,'o','markersize',7,'markeredgecolor','k','markerfacecolor','y')
    plotm(lat,lon,'+','markersize',1,'markeredgecolor','k')
    textm(lat,lon-2.4,['Faro Punta';'   Panul  '])
    % detalles finales
    set(gcf,'color','w')
end