function modelolineal(var1,var2)
    % arreglo de datos
    A = reshape(var1,8,[]); % separada por hora {0:3:21}
    B = reshape(var2,8,[]); % separada por hora {0:3:21}
    C(1,:) = nanmean(A([2,3,4,5],:),1); % temprano (var1)
    C(2,:) = nanmean(A([1,6,7,8],:),1); % tarde (var1)
    D(1,:) = nanmean(B([2,3,4,5],:),1); % temprano (var2)
    D(2,:) = nanmean(B([1,6,7,8],:),1); % tarde (var2)
    % comparacion por periodo
    periodo = {'Temprano','Tarde'};
    for i = 2:2
        disp(periodo{i})
        % separacion de variables
        x = C(i,:)';
        y = D(i,:)';
        % creacion de tabla
        tbl = table(x,y);
        % calculo de estadisticos
        mdl = fitlm(tbl);
        anv = anova(mdl,'summary');
        % mostrar resultados
        disp(mdl)
        disp(anv)
        disp('-----')
    end
end