% grafica variable de compuesto por hora
function evolucion(sd,var,clim,color)
    % reordenamiento de datos
    aux = reshape(var,8,[]);
    X = zeros(size(aux));
    X(1:end-1,:) = aux(2:end,:);
    X(end,:) = aux(1,:);
    % grillas para figura
    if(length(var) == length(sd.orig.diario.t.date))
        tt(1) = sd.orig.diario.t.date(1)+hours(15);
        tt(2) = sd.orig.diario.t.date(end)-hours(6);
    elseif(length(var) == length(sd.orig.quinc.t.date))
        tt(1) = sd.orig.quinc.t.date(1)-days(22);
        tt(2) = sd.orig.quinc.t.date(end)-days(24);
    elseif(length(var) == length(sd.orig.mensual.t.date))
        tt(1) = sd.orig.mensual.t.date(1)-days(15);
        tt(2) = sd.orig.mensual.t.date(end)-days(15);
    elseif(length(var) == length(sd.comp.diario.t.date))
        tt(1) = sd.comp.diario.t.date(1)+hours(15);
        tt(2) = sd.comp.diario.t.date(end)-hours(6);
    elseif(length(var) == length(sd.comp.quinc.t.date))
        tt(1) = sd.comp.quinc.t.date(1)-days(22);
        tt(2) = sd.comp.quinc.t.date(end)-days(24);
    elseif(length(var) == length(sd.comp.mensual.t.date))
        tt(1) = sd.comp.mensual.t.date(1)-days(15);
        tt(2) = sd.comp.mensual.t.date(end)-days(15);
    end
    tt = datenum(tt);
    hh = [3,24];
    % busqueda de zonas sin datos
    alpha = ones(size(X));
    alpha(isnan(X)) = 0;
    % figura de tablero con tipos de datos
    imagesc(tt,hh,X,'alphadata',alpha)
    % manejo de colores
    caxis(clim)
    cb = colorbar;
    colormap(color)
    % ticks
    n = numel(X);
    nc.orig = [length(sd.orig.diario.t.date), ...
        length(sd.orig.quinc.t.date), ...
        length(sd.orig.mensual.t.date)];
    nc.comp = [length(sd.comp.diario.t.date), ...
        length(sd.comp.quinc.t.date), ...
        length(sd.comp.mensual.t.date)];
    if(ismember(n,nc.orig))
        xticks(datenum(tt(1):years(2):tt(end)))
        datetick('x','keeplimits')
    elseif(ismember(n,nc.comp))
        tc = [31,29,31,30,31,30,31,31,30,31,30,31];
        for i = 1:length(tc)
            d(i) = sum(tc(1:i));
        end
        newticks = datenum(year(tt(1)),month(tt(1)),d,24,0,0);
        xticks(newticks)
        datetick('x','mmm')
    end
    yticks(3:3:24)
    % variables para grilla
    tg = datenum(tt(1)-days(5):days(5):tt(end)+days(5));
    hhg = [1.5,4.5,7.5,10.5,13.5,16.5,19.5];
    aux = ones(size(tg));
    % creacion de grilla horizontal
    hold on
    for hg = hhg
        plot(tg,aux*hg,'ok','markersize',0.5)
    end
    % etiquetas
    ylabel('hrs')
    title(cb,'octas')
    % detalles finales
    axis tight
%     set(gca,'color',1*[1,1,1])
    set(gcf,'color','w')
    
end