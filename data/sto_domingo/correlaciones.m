% correlaciones entre variables
function aux = correlaciones(var1,var2,relacion)
    % opciones de matrices
    A = reshape(var1,8,[]); % separada por hora {0:3:21}
    B = reshape(var2,8,[]); % separada por hora {0:3:21}
    C(1,:) = nanmean(A([2,3,4],:),1); % separada por {temp,tard,noch}
    C(2,:) = nanmean(A([5,6,7],:),1); % separada por {temp,tard,noch}
    C(3,:) = nanmean(A([1,8],:),1); % separada por {temp,tard,noch}
    D(1,:) = nanmean(B([2,3,4],:),1); % separada por {temp,tard,noch}
    D(2,:) = nanmean(B([5,6,7],:),1); % separada por {temp,tard,noch}
    D(3,:) = nanmean(B([1,8],:),1); % separada por {temp,tard,noch}
    E(1,:) = nanmean(A([2,3,4,5],:),1); % separada por {temp,tard}
    E(2,:) = nanmean(A([1,6,7,8],:),1); % separada por {temp,tard}
    F(1,:) = nanmean(B([2,3,4,5],:),1); % separada por {temp,tard}
    F(2,:) = nanmean(B([1,6,7,8],:),1); % separada por {temp,tard}
    % correlaciones segun tipo
    if(relacion == 0)
        % extraccion de variables
        x = A;
        y = B;
        for i = 1:8
            % mascara para excluir datos sin informacion
            mask = ~(isnan(x(i,:)) & isnan(y(i,:)));
            % calculo de correlacion
            aux = corrcoef(x(i,mask),y(i,mask));
            if(size(aux)==[2,2])
                r(i) = aux(1,2);
            else
                r(i) =nan;
            end
        end
    elseif(relacion == 1)
        % extraccion de variables
        x = C;
        y = D;
        for i = 1:3
            % marcara para excluir datos sin informacion
            mask = ~(isnan(x(i,:)) & isnan(y(i,:)));
            % calculo de correlacion
            aux = corrcoef(x(i,mask),y(i,mask));
            if(size(aux)==[2,2])
                r(i) = aux(1,2);
            else
                r(i) =nan;
            end
            r(i) = aux(1,2);
        end
    elseif(relacion == 2)
        % extraccion de variables
        x = C(1,:);
        y = D(2,:);
        % marcara para excluir datos sin informacion
        mask = ~(isnan(x) & isnan(y));
        % calculo de correlacion
        aux = corrcoef(x(mask),y(mask));
        if(size(aux)==[2,2])
                r = aux(1,2);
        else
            r =nan;
        end
        r = aux(1,2);
    elseif(relacion == 3)
        % extraccion de variables
        x = E;
        y = F;
        for i = 1:2
            % marcara para excluir datos sin informacion
            mask = ~(isnan(x(i,:)) & isnan(y(i,:)));
            %calculo de correlacion
            aux = corrcoef(x(i,mask),y(i,mask));
            if(size(aux)==[2,2])
                r(i) = aux(1,2);
            else
                r(i) =nan;
            end
            r(i) = aux(1,2);
        end
    elseif(relacion == 4)
        % extraccion de variables
        x = E(1,:);
        y = F(2,:);
        % marcara para excluir datos sin informacion
        mask = ~(isnan(x) & isnan(y));
        % calculo de correlacion
        aux = corrcoef(x(mask),y(mask));
        if(size(aux)==[2,2])
                r = aux(1,2);
        else
            r =nan;
        end
        r = aux(1,2);
    end
    % escribe resultados en pantalla
    disp('------------------')
    for i = 1:length(r)
        disp(['|corr n°',num2str(i),': ',num2str(round(r(i),3)),' |'])
    end
    disp('------------------')
end