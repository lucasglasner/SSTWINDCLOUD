% obtencion de anomalias por hora
function sd = anomalias(sd,tipo)
    % tipo de compuesto
    if(strcmp(tipo,'diario'))
        vel = sd.comp.diario.vel;
        u = sd.comp.diario.u;
        v = sd.comp.diario.v;
        nub.oct = sd.comp.diario.nub.oct;
    elseif(strcmp(tipo,'quinc'))
        vel = sd.comp.quinc.vel;
        u = sd.comp.quinc.u;
        v = sd.comp.quinc.v;
        nub.oct = sd.comp.quinc.nub.oct;
    elseif(strcmp(tipo,'mensual'))
        vel = sd.comp.mensual.vel;
        u = sd.comp.mensual.u;
        v = sd.comp.mensual.v;
        nub.oct = sd.comp.mensual.nub.oct;
    end
    % reordenamiento de datos
    X.vel = reshape(vel,8,[]);
    X.u = reshape(u,8,[]);
    X.v = reshape(v,8,[]);
    X.nub.oct = reshape(nub.oct,8,[]);
    % obtencion de anomalias
    if(strcmp(tipo,'diario'))
        diario.vel = X.vel - nanmean(X.vel,2);
        diario.u = X.u - nanmean(X.u,2);
        diario.v = X.v - nanmean(X.v,2);
        diario.nub.oct = X.nub.oct - nanmean(X.nub.oct,2);
        % vectores de tiempo
        sd.anom.diario.t.date = sd.comp.diario.t.date;
        sd.anom.diario.t.num = sd.comp.diario.t.num;
        % vuelta a ordenamiento original de datos
        sd.anom.diario.vel = reshape(diario.vel,length(sd.comp.diario.t.date),[]);
        sd.anom.diario.u = reshape(diario.u,length(sd.comp.diario.t.date),[]);
        sd.anom.diario.v = reshape(diario.v,length(sd.comp.diario.t.date),[]);
        sd.anom.diario.nub.oct = reshape(diario.nub.oct,length(sd.comp.diario.t.date),[]);
    elseif(strcmp(tipo,'quinc'))
        quinc.vel = X.vel - nanmean(X.vel,2);
        quinc.u = X.u - nanmean(X.u,2);
        quinc.v = X.v - nanmean(X.v,2);
        quinc.nub.oct = X.nub.oct - nanmean(X.nub.oct,2);
        % vectores de tiempo
        sd.anom.quinc.t.date = sd.comp.quinc.t.date;
        sd.anom.quinc.t.num = sd.comp.quinc.t.num;
        % vuelta a ordenamiento original de datos
        sd.anom.quinc.vel = reshape(quinc.vel,length(sd.comp.quinc.t.date),[]);
        sd.anom.quinc.u = reshape(quinc.u,length(sd.comp.quinc.t.date),[]);
        sd.anom.quinc.v = reshape(quinc.v,length(sd.comp.quinc.t.date),[]);
        sd.anom.quinc.nub.oct = reshape(quinc.nub.oct,length(sd.comp.quinc.t.date),[]);
    elseif(strcmp(tipo,'mensual'))
        mensual.vel = X.vel - nanmean(X.vel,2);
        mensual.u = X.u - nanmean(X.u,2);
        mensual.v = X.v - nanmean(X.v,2);
        mensual.nub.oct = X.nub.oct - nanmean(X.nub.oct,2);
        % vectores de tiempo
        sd.anom.mensual.t.date = sd.comp.quinc.t.date;
        sd.anom.mensual.t.num = sd.comp.quinc.t.num;
        % vuelta a ordenamiento original de datos
        sd.anom.mensual.vel = reshape(mensual.vel,length(sd.comp.mensual.t.date),[]);
        sd.anom.mensual.u = reshape(mensual.u,length(sd.comp.mensual.t.date),[]);
        sd.anom.mensual.v = reshape(mensual.v,length(sd.comp.mensual.t.date),[]);
        sd.anom.mensual.nub.oct = reshape(mensual.nub.oct,length(sd.comp.mensual.t.date),[]);
    end
end