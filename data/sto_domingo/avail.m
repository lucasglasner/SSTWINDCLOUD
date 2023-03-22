% ver disponibilidad y tipos de datos
function avail(sd)
    % reordenamiento de datos
    X = reshape(sd.orig.diario.nub.oct,8,[]);
    % arreglo de matriz de datos
    if(~iscell(X))
        X = num2cell(X);
    end
    % matriz de identificacion del tipo de dato
    Z = nan(size(X));
    % clasificacion de datos
    for i = 1:length(X(:))
        if(ischar(X{i}))
            if(isempty(X{i}))
                Z(i) = -2;
            else
                if(ismember(X{i},sd.orig.diario.nub.desc.inap))
                    Z(i) = -1;
                elseif(ismember(X{i},[sd.orig.diario.nub.desc.des;...
                        sd.orig.diario.nub.desc.par;sd.orig.diario.nub.desc.nub; ...
                        sd.orig.diario.nub.desc.cub]))
                    Z(i) = 0;
                else
                    Z(i) = -2;
                end
            end
        elseif(isnumeric(X{i}))
            if(isnan(X{i}))
                Z(i) = -2;
            else
                if(X{i}>=0 && X{i}<=8)
                    Z(i) = 2;
                else
                    Z(i) = 1;
                end
            end
        end
    end
    % grillas para figura
    tt(1) = sd.orig.diario.t.date(1)+hours(15);
    tt(2) = sd.orig.diario.t.date(end)-hours(15);
    tt = datenum(tt);
    hh = [3,24];
    % definicion de colores
%     c = [1 1 0;1 0 1;1 0 0;0 0 1;0 1 0];
    c = [1,0,0;0.5,1,0];
    % figura de tablero con tipos de datos
    imagesc(tt,hh,Z)
    % manejo de colores
    colormap(c)
    caxis([-2 2])
    % ticks
    xticks(datenum(tt(1):years(2):tt(2)))
    yticks(3:3:24)
    datetick('x','keepticks')
    % variables para grilla
    tg = datenum(tt(1):days(75):tt(end));
    hhg = [4.5,7.5,10.5,13.5,16.5,19.5,22.5];
    aux = ones(size(tg));
    % creacion de grilla horizontal
    hold on
    for hg = hhg
        plot(tg,aux*hg,'ok','markersize',0.5)
    end
    % etiquetas
    ylabel('hrs')
    % detalles finales
    axis tight
    set(gcf,'color','w')
end

