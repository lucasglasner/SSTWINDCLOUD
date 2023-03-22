function sd = loadsynops()
    % datos relevantes de estacion
    sd.prop.lat = -33.655;
    sd.prop.lon = -71.61;
    sd.orig.diario.t.dt = 3; % paso de tiempo (3 horas) [hrs]
    % parametros
    yi = 2000;
    yf = 2016;
    % carga de datos
    td = [];
    var = [];
    for yr = yi:yf
        filename = ['synops/SYNOP_',num2str(yr)];
        aux = readtable(filename);
        td = [td;datetime(aux.Var2,aux.Var3,aux.Var4,aux.Var5,aux.Var6,0)];
        var = fixsynops(var,aux.Var7);
    end
    % correcion de valores
    mask = (~(isnan(var.dir) & isnan(var.vel) & isnan(var.nub.oct)) & ...
        (var.dir <= 360) & (var.nub.oct < 9));
    var.dir(~mask) = nan;
    var.vel(~mask) = nan;
    var.u(~mask) = nan;
    var.v(~mask) = nan;
    var.nub.oct(~mask) = nan;
    % arreglo final
    sd.orig.diario.t.date = td;
    sd.orig.diario.t.num = datenum(td);
    sd.orig.diario.dir = var.dir;
    sd.orig.diario.vel = var.vel;
    sd.orig.diario.u = var.u;
    sd.orig.diario.v = var.v;
    sd.orig.diario.nub.oct = var.nub.oct;
end