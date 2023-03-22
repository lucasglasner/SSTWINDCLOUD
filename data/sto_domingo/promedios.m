% obtiene promedios quincenales y mensuales de todo el periodo de medicion
function sd = promedios(sd,tipo)
    % tiempo inicial y final
    ti = sd.orig.diario.t.date(1);
    tf = sd.orig.diario.t.date(end);
    sti = datestr(ti,'dd-mmmm-yyyy');
    stf = datestr(tf,'dd-mmmm-yyyy');
    % horas de interes
    hrs = unique(hour(sd.orig.diario.t.date));
    % promedios quincenales de cada variable
    if(strcmp(tipo,'quinc'))
        kc = ((months(sti,stf,0)+1)*2)*8;
    elseif(strcmp(tipo,'mensual'))
        kc = ((months(sti,stf,0)+1)*1)*8;
    end
    k = 1;
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
                if(leapyear(year(ti)))
                    dt = 29;
                else
                    dt = 28;
                end
            end
        end
        % tiempo intermedio
        tk = ti + days(dt);
        % mascara con dias de interes
        mask = (sd.orig.diario.t.date >= ti & sd.orig.diario.t.date < tk);
        % calculo de promedios
        vel = nanmean(reshape(sd.orig.diario.vel(mask),8,[]),2);
        u = nanmean(reshape(sd.orig.diario.u(mask),8,[]),2);
        v = nanmean(reshape(sd.orig.diario.v(mask),8,[]),2);
        nub.oct = nanmean(reshape(sd.orig.diario.nub.oct(mask),8,[]),2);
        if(strcmp(tipo,'quinc'))
            % vector de tiempo anual (aprox. cada 15 dias)
            sd.orig.quinc.t.date(k:k+7) = tk + hours(hrs);
            sd.orig.quinc.t.num(k:k+7) = datenum(tk + hours(hrs));
            % nuevas variables
            sd.orig.quinc.vel(k:k+7) = vel;
            sd.orig.quinc.u(k:k+7) = u;
            sd.orig.quinc.v(k:k+7) = v;
            sd.orig.quinc.nub.oct(k:k+7) = nub.oct;
        elseif(strcmp(tipo,'mensual'))
            % vector de tiempo anual (aprox. cada 15 dias)
            sd.orig.mensual.t.date(k:k+7) = tk + hours(hrs);
            sd.orig.mensual.t.num(k:k+7) = datenum(tk + hours(hrs));
            % nuevas variables
            sd.orig.mensual.vel(k:k+7) = vel;
            sd.orig.mensual.u(k:k+7) = u;
            sd.orig.mensual.v(k:k+7) = v;
            sd.orig.mensual.nub.oct(k:k+7) = nub.oct;
        end
        % actualizacion de indice y tiempo inicial
        k = k + 8;
        ti = tk;
    end
end