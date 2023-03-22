% crea compuesto anual (diario) de todas las variables
function [sd,c] = cp(sd)
    % vector de tiempo anual
    sd.comp.diario.t.date = sd.orig.diario.t.date(year(sd.orig.diario.t.date)==2004);
    sd.comp.diario.t.num = datenum(sd.comp.diario.t.date);
    % promedios por hora
    for i = 1:length(sd.comp.diario.t.date)
        % busqueda de indices
        mask = (month(sd.orig.diario.t.date)==month(sd.comp.diario.t.date(i)) ...
            & day(sd.orig.diario.t.date)==day(sd.comp.diario.t.date(i)) ...
            & hour(sd.orig.diario.t.date)==hour(sd.comp.diario.t.date(i)));
        % nuevas variables
        sd.comp.diario.vel(i) = nanmean(sd.orig.diario.vel(mask));
        sd.comp.diario.u(i) = nanmean(sd.orig.diario.u(mask));
        sd.comp.diario.v(i) = nanmean(sd.orig.diario.v(mask));
        sd.comp.diario.nub.oct(i) = nanmean(sd.orig.diario.nub.oct(mask));
        % cuenta de datos para hacer promedios
        sd.comp.diario.ndata(i) = sum(~isnan(sd.orig.diario.nub.oct(mask)));
    end
    % reordenamiento de datos
    sd.comp.diario.vel = sd.comp.diario.vel';
    sd.comp.diario.u = sd.comp.diario.u';
    sd.comp.diario.v = sd.comp.diario.v';
    sd.comp.diario.nub.oct = sd.comp.diario.nub.oct';
    sd.comp.diario.ndata = sd.comp.diario.ndata';
    % detalles finales
    c = sd.comp.diario.ndata;
end