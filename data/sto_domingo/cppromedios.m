% crea compuesto anual (mensual) de todas las variables
function sd = cppromedios(sd,c,tipo)
    % tiempo inicial y final
    ti = sd.comp.diario.t.date(1);
    tf = sd.comp.diario.t.date(end);
    sti = datestr(ti,'dd-mmmm-yyyy');
    stf = datestr(tf,'dd-mmmm-yyyy');
    % horas de interes
    hrs = unique(hour(sd.comp.diario.t.date));
    % promedios quincenales de cada variable
    if(strcmp(tipo,'quinc'))
        kc = ((months(sti,stf,1)+1)*2)*8;
    elseif(strcmp(tipo,'mensual'))
        kc = ((months(sti,stf,1)+1)*1)*8;
    end
    k = 1; 
    j = 1;
    while k <= kc
        % ajuste de rango temporal
        if(ismember(month(ti),[1,3,5,7,8,10,12]))
            if(strcmp(tipo,'quinc'))
                if(day(ti) < 16)
                    dt = 15;
                else
                    dt = 16;
                end
            elseif(strcmp(tipo,'mensual'))
                dt = 31;
            end
        elseif(ismember(month(ti),[4,6,9,11]))
            if(strcmp(tipo,'quinc'))
                dt = 15;
            elseif(strcmp(tipo,'mensual'))
                dt = 30;
            end
        elseif(month(ti) == 2)
            if(strcmp(tipo,'quinc'))
                if(day(ti) < 15)
                    dt = 14;
                else
                    dt = 15;
                end
            elseif(strcmp(tipo,'mensual'))
                dt = 29;
            end
        end
        % tiempo intermedio
        tk = ti + days(dt);
        % mascara con dias de interes
        mask = (sd.comp.diario.t.date >= ti & sd.comp.diario.t.date < tk);
        % cuenta de datos para hacer promedios
        cc = sum(reshape(c(mask),8,[]),2);
        % calculo de promedios
        vel = nanmean(reshape(sd.comp.diario.vel(mask),8,[]),2);
        u = nanmean(reshape(sd.comp.diario.u(mask),8,[]),2);
        v = nanmean(reshape(sd.comp.diario.v(mask),8,[]),2);
        nub.oct = nanmean(reshape(sd.comp.diario.nub.oct(mask),8,[]),2);
        if(strcmp(tipo,'quinc'))
            % vector de tiempo anual (aprox. cada 15 dias)
            sd.comp.quinc.t.date(k:k+7) = tk + hours(hrs);
            sd.comp.quinc.t.num(k:k+7) = datenum(tk + hours(hrs));
            % nuevas variables
            sd.comp.quinc.vel(k:k+7) = vel;
            sd.comp.quinc.u(k:k+7) = u;
            sd.comp.quinc.v(k:k+7) = v;
            sd.comp.quinc.nub.oct(k:k+7) = nub.oct;
            sd.comp.quinc.ndata(k:k+7) = cc;
        elseif(strcmp(tipo,'mensual'))
            % vector de tiempo anual (aprox. cada 15 dias)
            sd.comp.mensual.t.date(k:k+7) = tk + hours(hrs);
            sd.comp.mensual.t.num(k:k+7) = datenum(tk + hours(hrs));
            % nuevas variables
            sd.comp.mensual.vel(k:k+7) = vel;
            sd.comp.mensual.u(k:k+7) = u;
            sd.comp.mensual.v(k:k+7) = v;
            sd.comp.mensual.nub.oct(k:k+7) = nub.oct;
            sd.comp.mensual.ndata(k:k+7) = cc;
        end
        % actualizacion de indice y tiempo inicial
        k = k + 8; 
        j = j + 1;
        ti = tk + days(0);
    end
end