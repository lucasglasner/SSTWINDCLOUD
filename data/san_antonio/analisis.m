% ANÁLISIS + FIGURAS
%--------------------------------------------------------------------------
% DEFINICIÓN DE PARÁMETROS

% directorio con datos arreglados
root.data = ['/home/alvaro/Documents/MMC/cursos/obligatorios/', ...
    'práctica_profesional-GF4901/output/'];

% directorio con otros datos (como las lineas de costa)
root.input = ['/home/alvaro/Documents/MMC/cursos/obligatorios/', ...
    'práctica_profesional-GF4901/input/'];

% nombre de archivo con datos
file.data = 'PANUL_2000-2016.nc';

% nombre de archivo con regiones de chile
file.reg = 'chile_regiones.nc';

%--------------------------------------------------------------------------
% ANÁLISIS

% agrupamiento 
c = grouping(root,file,'uv');

% correlaciones
% PROXIMAMENTE

%--------------------------------------------------------------------------
% GRÁFICOS

% mapa de localidades
fig = figure;
localmap(root,file,fig)

% disponibilidad de datos
fig = figure;
available(root,file,fig)

% conteo de datos
fig = figure;
countdata(root,file,fig)

% climatología de variables [ff,dd,cc,u,v]
fig = figure;
climatology(root,file,fig,'ff')

%--------------------------------------------------------------------------
% DEFINICIÓN DE FUNCIONES

% agrupamiento de horas por estación
function c = grouping(root,file,windcoo)
    
    % revisión de existencia de archivo
    if(~exist([root.data,file.data],'file'))
        disp('>> archivo no existe')
        return
    end
    
    % carga da datos
    t = datetime(2000,1,1,ncread([root.data,file.data],'time'),0,0);
    ff = ncread([root.data,file.data],'ff');
    dd = ncread([root.data,file.data],'dd');
    cc = ncread([root.data,file.data],'cc');
    
    % cálculo de climatologías
    ff = nanmean(reshape(ff,8,365,[]),3);
    dd = nanmean(reshape(dd,8,365,[]),3);
    cc = nanmean(reshape(cc,8,365,[]),3);
    
    % horas que se buscan agrupar
    h = hour(t(1:8));
    
    % vector de tiempo auxiliar (para diferenciar estaciones)
    tk = (datetime(2001,1,1):days(1):datetime(2001,12,31))';
    
    % nombres de estaciones
    station(1).name = 'verano';
    station(2).name = 'otoño';
    station(3).name = 'invierno';
    station(4).name = 'primavera';
    
    % definición de meses de estaciones
    station(1).mm = [12,1,2]; % verano
    station(2).mm = [3,4,5]; % otoño
    station(3).mm = [6,7,8]; % invierno
    station(4).mm = [9,10,11]; % primavera
    
    % análisis por estación
    for k = 1:length(station)
        
        % máscara de estación
        mask = ismember(month(tk),station(k).mm);
        
        % corte de datos
        ffk = ff(:,mask);
        ddk = dd(:,mask);
        cck = cc(:,mask);
    
        % creación de matriz con medias
        X = zeros(length(h),3);

        % medias y varianzas de variables de viento
        if(strcmp(windcoo,'ffdd')) % viento en coordenadas polares

            % medias de velocidad y dirección del viento
            X(:,1) = nanmean(ffk,2);
            X(:,2) = nanmean(ddk,2);

        % según viento en coordenadas cartesianas
        elseif(strcmp(windcoo,'uv'))

            % cambio de coordenadas polares a cartesianas 
            [uk,vk] = uv(ffk,ddk);

            % medias de viento zonal y meridional
            X(:,1) = nanmean(uk,2);
            X(:,2) = nanmean(vk,2);
        end
        
        % media de nubosidad
        X(:,3) = nanmean(cck,2);
        
        % numero de grupos
        N = 2;
        
        % agrupamiento
        tree = linkage(X,'single','seuclidean');
        c = cluster(tree,'maxclust',N);

        % mostrar información
        disp(['>> ',station(k).name])
        for n = 1:N
            disp(['>>>> grupo ',num2str(n),': ', ...
                hours_str(h(c == n)),' hrs'])
        end

    end
    disp(' ')
end

%-----x-----x-----x-----x
% arreglo de horas según agrupamiento
function hstr = hours_str(h)
    
    % creación de arreglo
    hstr = [];
    
    % arreglo de vector con horas
    for i = 1:length(h)
        
        % no se agrega coma al final
        if(i == length(h))
            hstr = cat(2,hstr,num2str(h(i)));
            
        % agrega coma entremedio
        else
            hstr = cat(2,hstr,[num2str(h(i)),', ']);
        end
    end
end

%-----x-----x-----x-----x


%-----x-----x-----x-----x


%-----x-----x-----x-----x
% ver localidades de interés
function localmap(root,file,fig)
    
    % COORDENADAS DE INTERÉS
    % ----------------------
    % faro punta panul, san antonio
    lati.sa = -33.575;
    loni.sa = -71.625;
    
    % santo domingo
    lati.sd = -33.655;
    loni.sd = -71.610;
    
    % lengua de vaca
    lati.ldv = -30.24;
    loni.ldv = -71.63;
    
    % cerro moreno
    lati.cm = -23.44;
    loni.cm = -70.44;
    % ----------------------
    
    % revisión de existencia de archivo
    if(~exist([root.input,file.reg],'file'))
        disp('>> archivo no existe')
        return
    end
    
    % carga de bordes de regiones de chile
    lat = double(ncread([root.input,file.reg],'lat'));
    lon = double(ncread([root.input,file.reg],'lon'));
    
    % límites de mapa
    latlim = [-34,-23];
    lonlim = [-77,-69.25];
    
    % limpiar figura existente
    clf(fig)
    
    % creación de mapa
    axesm('mercator','maplatlim',latlim,'maplonlim',lonlim, ...
        'mlinelocation',2,'plinelocation',2)
    axis('off')
    box('on')
    framem('on')
    gridm('on')
    mlabel('south') 
    plabel('east')
    
    % dibujo de bordes
    plotm(lat,lon,'.k','handlevisibility','off')
    
    % dibujo de localidades
    plt(1) = plotm(lati.sa,loni.sa,'o','markersize',7, ...
        'markeredgecolor','k','markerfacecolor','y');
    plt(2) = plotm(lati.sd,loni.sd,'o','markersize',7, ...
        'markeredgecolor','k','markerfacecolor','g');
    plt(3) = plotm(lati.ldv,loni.ldv,'o','markersize',7, ...
        'markeredgecolor','k','markerfacecolor','c');
    plt(4) = plotm(lati.cm,loni.cm,'o','markersize',7, ...
        'markeredgecolor','k','markerfacecolor','r');
    
    % cruz extra para cada punto
    plotm(lati.sa,loni.sa,'+','markersize',1,'markeredgecolor','k', ...
        'handlevisibility','off')
    plotm(lati.sd,loni.sd,'+','markersize',1,'markeredgecolor','k', ...
        'handlevisibility','off')
    plotm(lati.ldv,loni.ldv,'+','markersize',1,'markeredgecolor','k', ...
        'handlevisibility','off')
    plotm(lati.cm,loni.cm,'+','markersize',1,'markeredgecolor','k', ...
        'handlevisibility','off')
    
    % etiquetas
    legend(plt,{'Faro Punta Panul','Santo Domingo','Lengua de Vaca', ...
        'Cerro Moreno'});
    
    % detalles finales
    set(fig,'color','w')
end

%-----x-----x-----x-----x
% ver disponibilidad de datos
function available(root,file,fig)
    
    % revisión de existencia de archivo
    if(~exist([root.data,file.data],'file'))
        disp('>> archivo no existe')
        return
    end
    
    % carga de datos
    t = datetime(2000,1,1,ncread([root.data,file.data],'time'),0,0);
    cc = ncread([root.data,file.data],'cc');
    
    % disponibilidad de datos
    av = ~isnan(reshape(cc,8,[]));
    
    % nuevos vectores de tiempo para graficar información
    tav = datenum(datetime(year(t(1)),month(t(1)),day(t(1)),12,0,0): ...
        days(1):datetime(year(t(end)),month(t(end)),day(t(end)),12,0,0))';
    hav = hour(t(1:8));
    
    % parámetros para figura
    color = flipud(gray(2));
    
    % limpiar figura existente
    clf(fig)
    
    % graficar disponibilidad
    imagesc(tav,hav,av)
    
    % colores
    colormap(color)
    cb = colorbar;
    cb.Ticks = [0.25,0.75];
    
    % etiquetas
    datetick('x','yyyy','keeplimits')
    yticks(hav)
    ylabel('Horas')
    cb.TickLabels = {'x','o'};
    ylabel(cb,'Disponibilidad')
    
    % detalles finales
    set(fig,'color','w')
    axis('tight')
end

%-----x-----x-----x-----x
% conteo de datos por hora del día
function countdata(root,file,fig)
    
    % revisión de existencia de archivo
    if(~exist([root.data,file.data],'file'))
        disp('>> archivo no existe')
        return
    end
    
    % carga de datos
    t = datetime(2000,1,1,ncread([root.data,file.data],'time'),0,0);
    cc = ncread([root.data,file.data],'cc');
    
    % reordenamiento de variable (para conteo de datos)
    cc = reshape(cc,8,365,[]);
    
    % conteo
    N = zeros(8,365);
    for i = 1:8
        for j = 1:365
            N(i,j) = sum(~isnan(squeeze(cc(i,j,:))));
        end
    end

    % nuevos vectores de tiempo para graficar información
    tN = datenum(datetime(2001,1,1,12,0,0):days(1): ...
        datetime(2001,12,31,12,0,0))';
    hN = hour(t(1:8));
        
    % parámetros para figura
    color = jet;
    
    % limpiar figura existente
    clf(fig)
    
    % graficar disponibilidad
    imagesc(tN,hN,N)
    
    % colores
    colormap(color)
    cb = colorbar;
    
    % etiquetas
    xticks(datenum(datetime(2001,(1:12)',15,12,0,0)))
    datetick('x','mmm','keeplimits','keepticks')
    yticks(hN)
    ylabel('Horas')
    ylabel(cb,'Número de datos')
    
    % detalles finales
    set(fig,'color','w')
    axis('tight')
end

%-----x-----x-----x-----x
% climatología de variables
function climatology(root,file,fig,var)
    
    % revisión de existencia de archivo
    if(~exist([root.data,file.data],'file'))
        disp('>> archivo no existe')
        return
    end
    
    % carga de tiempo
    t = datetime(2000,1,1,ncread([root.data,file.data],'time'),0,0);
    
    % DEFINICIÓN Y CARGA DE VARIABLES A MOSTRAR
    % -----------------------------------------
    % velocidad del viento
    if(strcmp(var,'ff'))
        
        % carga de datos
        x = ncread([root.data,file.data],'ff');
        
        % parámetros de gráfico
        label = 'Velocidad del viento [m/s]';
        color = jet;
        clim = [0,20];
        
    % dirección del viento
    elseif(strcmp(var,'dd'))
        
        % carga de datos
        x = ncread([root.data,file.data],'dd');
        
        % parámetros de gráfico
        label = 'Dirección del viento [°]';
        color = jet;
        clim = [0,360];
        
    % nubosidad
    elseif(strcmp(var,'cc'))
        
        % carga de datos
        x = ncread([root.data,file.data],'cc');
        
        % parámetros de gráfico
        label = 'Nubosidad [octas]';
        color = flipud(gray);
        clim = [0,8];
        
    % viento zonal
    elseif(strcmp(var,'u'))
        
        % carga de datos
        [x,~] = uv(ncread([root.data,file.data],'ff'), ...
            ncread([root.data,file.data],'dd'));
        
        % parámetros de gráfico
        label = 'Viento zonal [m/s]';
        color = redblue;
        clim = [-10,10];
        
    % viento meridional
    elseif(strcmp(var,'v'))
        
        % carga de datos
        [~,x] = uv(ncread([root.data,file.data],'ff'), ...
            ncread([root.data,file.data],'dd'));
        
        % parámetros de gráfico
        label = 'Viento meridional [m/s]';
        color = redblue;
        clim = [-10,10];
        
    end
    % -----------------------------------------
    
    % cálculo de climatología
    x = nanmean(reshape(x,8,365,[]),3);
    
    % nuevos vectores de tiempo para graficar información
    tx = datenum(datetime(2001,1,1,12,0,0):days(1): ...
        datetime(2001,12,31,12,0,0))';
    hx = hour(t(1:8));

    % limpiar figura existente
    clf(fig)
    
    % graficar disponibilidad
    imagesc(tx,hx,x)
    
    % colores
    colormap(color)
    cb = colorbar;
    caxis(clim)
    
    % etiquetas
    xticks(datenum(datetime(2001,(1:12)',15,12,0,0)))
    datetick('x','mmm','keeplimits','keepticks')
    yticks(hx)
    ylabel('Horas')
    ylabel(cb,label)
    
    % detalles finales
    set(fig,'color','w')
    axis('tight')
        


end

%-----x-----x-----x-----x
% cambio de coordenadas de variables de viento a cartesianas
function [u,v] = uv(ff,dd)

    % cálculo de coordenadas cartesianas
    u = ff.*sind(dd-180);
    v = ff.*cosd(dd-180);
end

%-----x-----x-----x-----x
% color 'redblue'
function c = redblue(m)
    %REDBLUE    Shades of red and blue color map
    %   REDBLUE(M), is an M-by-3 matrix that defines a colormap.
    %   The colors begin with bright blue, range through shades of
    %   blue to white, and then through shades of red to bright red.
    %   REDBLUE, by itself, is the same length as the current figure's
    %   colormap. If no figure exists, MATLAB creates one.
    %
    %   For example, to reset the colormap of the current figure:
    %
    %             colormap(redblue)
    %
    %   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, 
    %   COLORMAP, RGBPLOT.

    %   Adam Auton, 9th October 2009

    if(nargin < 1)
        m = size(get(gcf,'colormap'),1); 
    end

    if (mod(m,2) == 0)
        % From [0 0 1] to [1 1 1], then [1 1 1] to [1 0 0];
        m1 = m*0.5;
        r = (0:m1-1)'/max(m1-1,1);
        g = r;
        r = [r; ones(m1,1)];
        g = [g; flipud(g)];
        b = flipud(r);
    else
        % From [0 0 1] to [1 1 1] to [1 0 0];
        m1 = floor(m*0.5);
        r = (0:m1-1)'/max(m1,1);
        g = r;
        r = [r; ones(m1+1,1)];
        g = [g; 1; flipud(g)];
        b = flipud(r);
    end

    c = [r g b];
end








