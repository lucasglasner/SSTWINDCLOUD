% arreglo de datos para que queden temporalmente equiespaciados
function sd = fixrange(sd)
    % parametros
    ti = datetime(2000,1,1,3,0,0);
    tf = datetime(2016,7,1,0,0,0);
    % nuevas variables
    td = (ti:hours(sd.orig.diario.t.dt):tf)';
    tn = datenum(td);
    dir = nan(size(td));
    vel = nan(size(td));
    u = nan(size(td));
    v = nan(size(td));
    nub.oct = nan(size(td));
    % reemplazo de valores existentes en nuevas variables
    for i = 1:length(sd.orig.diario.t.date)
        % busqueda de indices en arreglo de fechas completas
        mask = (td == sd.orig.diario.t.date(i));
        if(~mask) % si no se encontro ningun indice
            continue
        end
        % relleno
        dir(mask) = sd.orig.diario.dir(i);
        vel(mask) = sd.orig.diario.vel(i);
        u(mask) = sd.orig.diario.u(i);
        v(mask) = sd.orig.diario.v(i);
        nub.oct(mask) = sd.orig.diario.nub.oct(i);
    end
    % actualizacion de estructura
    sd.orig.diario.t.date = td;
    sd.orig.diario.t.num = tn;
    sd.orig.diario.dir = dir;
    sd.orig.diario.vel = vel;
    sd.orig.diario.u = u;
    sd.orig.diario.v = v;
    sd.orig.diario.nub.oct = nub.oct;
end