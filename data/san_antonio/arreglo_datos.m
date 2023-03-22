% ARREGLO DE DATOS DE FARO PUNTA PANUL, SAN ANTONIO
%--------------------------------------------------------------------------
% DEFINICIÓN DE PARÁMETROS

% directorio con datos de la armadada (guacala)
root.data = ['/home/alvaro/documents/MMC/cursos/práctica_profesional_GF4901' ...
    '/input/csv/'];

% directorio para salidas de datos arreglados
root.out = ['/home/alvaro/Documents/MMC/cursos/práctica_profesional_GF4901' ...
    '/output/'];

% ventana de tiempo
yrs.yri = 2000;
yrs.yrf = 2016;

%--------------------------------------------------------------------------
% PROCESAMIENTO

% arreglo de datos
[t,ff,dd,cc] = fixdata(root,yrs);

% guardar datos en archivo netcdf
save_data(root,yrs,t,ff,dd,cc)

%--------------------------------------------------------------------------
% DEFINICIÓN DE FUNCIONES

% proceso principal
function [t,ff,dd,cc] = fixdata(root,yrs)

    % mostrar mensaje inicial
    disp('>> arreglando datos...')
    
    % inicialización de variables
    t = datetime([],0,0);
    ff = [];
    dd = [];
    cc = [];
    
    % procesamiento de datos por año
    for yr = yrs.yri:yrs.yrf
        
        % nombre de archivo
        file = ['Panul_',num2str(yr),'.csv'];
        
        % revisión de existencia de archivo
        if(~exist([root.data,file],'file'))
            continue
        else
            disp(['>>>> cargando año ',num2str(yr)])
        end
        
        % carga de archivo
        data = readtable([root.data,file],'delimiter',';');
        
        % separación de variables
        t = cat(1,t,datetime(data.YEAR,data.MONTH,data.DAY,data.UTC,0,0));
        ffi = fixcell(data.INT);
        ddi = fixcell(data.DIR);
        cci = fixcell(data.NUB);
        
        % cambio de formato, de celdas a números (salvo nubosidad)
        ffi = cell2mat(ffi);
        ddi = cell2mat(ddi);
        
        % cambio de formato y arreglo de variables c/r a nubosidad
        [cci,mask_cci] = fixcloudcover(cci);
        ffi(mask_cci) = nan;
        ddi(mask_cci) = nan;
        cci(mask_cci) = nan;
        
        % máscaras para ajustes c/r a variables de viento
        mask_ffi = (ffi < 0 | ffi > 100);
        mask_ddi = (ddi < 0 | ddi > 360);
        
        % arreglos c/r a variables de viento
        ffi(mask_ffi | mask_ddi) = nan;
        ddi(mask_ffi | mask_ddi) = nan;
        cci(mask_ffi | mask_ddi) = nan;
        
        % concatenación de variables finales
        ff = cat(1,ff,ffi);
        dd = cat(1,dd,ddi);
        cc = cat(1,cc,cci);
    end
    disp(' ')
    
    % equiespaciamiento de variables
    [~,ff] = fixrange(t,ff);
    [~,dd] = fixrange(t,dd);
    [t,cc] = fixrange(t,cc);
    
    % eliminar 29 de febreros
    [~,ff] = fixleapyear(t,ff);
    [~,dd] = fixleapyear(t,dd);
    [t,cc] = fixleapyear(t,cc);
    
end

%-----x-----x-----x-----x
% transforma elementos de una celda a números (si es posible)
function x = fixcell(x)

    % revisa si entrada es una celda o un vector
    if(iscell(x))
        
        % máscara de celda vacía
        mask = cellfun(@isempty,x);

        % se llenan las celdas vacías con nans
        x(mask) = {nan};

        % función local para determinar si char es un número
        isnum = @(a) ischar(a) & ...
            (length(a)==sum(ismember(a,'0123456789')));

        % nueva máscara de celdas con char pero que realmente son números
        mask = cellfun(isnum,x);

        % se convierten char a números
        x(mask) = num2cell(str2double(string(x(mask))));
    
    % si no es una celda, se asume que es un vector (con números)
    else
        
        % se retorna como celda
        x = num2cell(x);
    end       
end

%-----x-----x-----x-----x
% arreglo de datos de nubosidad (valores + formato)
function [cc,mask] = fixcloudcover(cc)

    % descripciones de nubosidad a cambiar
    despejado = ["DESP";"DES";"des";"DESP.";"DES.";"des."];
    parcial = ["PARC";"PAR";"PARC.";"PAR.";"PN"];
    nublado = ["NUB";"NC";"NBDO";"NUB.";"NC.";"NDBO.";"UB"; ...
        "NUBL.";"NUBL,";"NDBO"];
    cubierto = ["CBTO";"CUB";"CBTO.";"CUB.";"CUB "];
    inapreciable = ["INAP";"INAPC";"INAPRE";"INAPR";"INA"; ...
        "INAP.";"INAPC.";"INAPRE.";"INAPR.";"INA.";"OSC";"/"];
    
    % cambio de descripciones a valores
    cc(ismember(string(cc),despejado)) = {0.1};
    cc(ismember(string(cc),parcial)) = {2.5};
    cc(ismember(string(cc),nublado)) = {5.1};
    cc(ismember(string(cc),cubierto)) = {7.9};
    cc(ismember(string(cc),inapreciable)) = {nan};

    % cambio de formato, de cell a números
    cc = cell2mat(cc);
    
    % ajuste de octas
    cc(cc < 0 | cc > 8) = nan;
    
    % máscara con valores que son nans
    mask = isnan(cc);
end

%-----x-----x-----x-----x
% equiespaciamiento de variables
function [tt,xx] = fixrange(t,x)

    % parámetros temporales
    dt = hours(3);
    
    % rango de tiempo
    ti = datetime(year(t(1)),1,1,0,0,0);
    tf = datetime(year(t(end)),12,31,21,0,0);
    
    % nuevo arreglo de tiempo
    tt = (ti:dt:tf)';
    
    % inicialización de nuevo arreglo de variable
    xx = nan(size(tt));
    
    % arreglo de variable de interés
    xx(ismember(tt,t)) = x;
end

%-----x-----x-----x-----x
% eliminar 29 de febreros
function [t,x] = fixleapyear(t,x)

    % máscara con fechas a eliminar
    mask = (month(t)==2 & day(t)==29);
    
    % nuevo arreglo de variables
    t = t(~mask);
    x = x(~mask);
end

%-----x-----x-----x-----x
% guardar datos en archivo netcdf
function save_data(root,yrs,t,ff,dd,cc)

    % nombre del archivo netcdf
    if(yrs.yri==yrs.yrf)
        yr = num2str(yrs.yri);
    else
        yr = [num2str(yrs.yri),'-',num2str(yrs.yrf)];
    end
    file = ['PANUL_',yr,'.nc'];
    
    % mostrar mensaje inicial
    disp(['>> guardando datos en ',file,'...'])
    
    % revisa existencia del archivo (y lo borra si es que existe)
    if(exist([root.out,file],'file'))
        disp('>>>> borrando archivo existente')
        delete([root.out,file])
    end
    
    % arreglo de tiempo
    t = hours(t-datetime(2000,1,1,0,0,0));
    
    % creación de archivo netcdf
    nccreate([root.out,file],'time', ...
        'Dimensions',{'time',Inf}, ...
        'Datatype','int32', ...
        'Format','netcdf4');
    nccreate([root.out,file],'ff', ...
        'Dimensions',{'time',Inf}, ...
        'Datatype','single', ...
        'Format','netcdf4');
    nccreate([root.out,file],'dd', ...
        'Dimensions',{'time',Inf}, ...
        'Datatype','single', ...
        'Format','netcdf4');
    nccreate([root.out,file],'cc', ...
        'Dimensions',{'time',Inf}, ...
        'Datatype','single', ...
        'Format','netcdf4');
    
    % escribir datos en archivo
    ncwrite([root.out,file],'time',int32(t));
    ncwrite([root.out,file],'ff',single(ff));
    ncwrite([root.out,file],'dd',single(dd));
    ncwrite([root.out,file],'cc',single(cc));
    
    % escribir atributos de cada variable
    ncwriteatt([root.out,file],'time', ...
        'units','hours since 2000-01-01 00:00:00.0')
    ncwriteatt([root.out,file],'time','long_name','Time')
    ncwriteatt([root.out,file],'time','calendar','gregorian')
    ncwriteatt([root.out,file],'ff','units','m s**-1')
    ncwriteatt([root.out,file],'ff', ...
        'long_name','Wind speed at Punta Panul lighthouse')
    ncwriteatt([root.out,file],'ff', ...
        'standard_name','wind_speed_at_punta_panul_lighthouse')
    ncwriteatt([root.out,file],'dd','units','degrees')
    ncwriteatt([root.out,file],'dd', ...
        'long_name','Wind direction at Punta Panul lighthouse')
    ncwriteatt([root.out,file],'dd', ...
        'standard_name','wind_direction_at_punta_panul_lighthouse')
    ncwriteatt([root.out,file],'cc','units','oktas')
    ncwriteatt([root.out,file],'cc', ...
        'long_name','Cloud cover at Punta Panul lighthouse')
    ncwriteatt([root.out,file],'cc', ...
        'standard_name','cloud_cover_at_punta_panul_lighthouse')
    
    % fin
    disp(' ')
end


