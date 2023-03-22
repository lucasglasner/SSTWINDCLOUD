% crea graficos de dispersion entre 2 variables
function dispersion(var1,var2,lim1,lim2,relacion,titulo)
    % opciones de matrices
    A = reshape(var1,8,[]); % separada por hora {3:3:24}
    B = reshape(var2,8,[]); % separada por hora {3:3:24}
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
    % dispersion segun relacion
    if(relacion == 0)
        % arreglos para subplots
        hr = {'00','03','06','09','12','15','18','21'};
        for i = 1:length(hr)
            % extraccion de variables
            x = A(i,:);
            y = B(i,:);
            % dispersion
            subplot(3,3,i)
            hold on
            h = plot(x,y,'o','markersize',7);
            % limites
            xlim(lim1)
            ylim(lim2)
            % ajuste de recta
            p = polyfit(x,y,1);
            v = polyval(p,lim1);
            plot(lim1,v,'--k')
            % etiquetas
            xlabel('octas')
            ylabel('m/s')
            title([hr{i},' hrs'])
            % detalles finales
            grid on
            set(h,'markerfacecolor','y','markeredgecolor','k')
            set(gcf,'color','w')
        end
    elseif(relacion == 1)
        % arreglos para subplots
        aux = [1,2,5,6;3,4,7,8;14,15,18,19];
        per = {'Mañana','Tarde','Noche'};
        for i = 1:3
            % extraccion de variables
            x = C(i,:);
            y = D(i,:);
            % dispersion
            subplot(5,4,aux(i,:))
            hold on
            h = plot(x,y,'o','markersize',7);
            % limites
            xlim(lim1)
            ylim(lim2)
            % ajuste de recta
            p = polyfit(x,y,1);
            v = polyval(p,lim1);
            plot(lim1,v,'--k')
            % etiquetas
            xlabel('octas')
            ylabel('m/s')
            title(per{i})
            % detalles finales
            grid on
            set(h,'markerfacecolor','y','markeredgecolor','k')
            set(gcf,'color','w')
        end
    elseif(relacion == 2)
        % extraccion de variables
        x = C(1,:);
        y = D(2,:);
        % dispersion
        h = plot(x,y,'o','markersize',7);
        % limites
        xlim(lim1)
        ylim(lim2)
        % ajuste de recta
        p = polyfit(x,y,1);
        v = polyval(p,lim1);
        hold on
        plot(lim1,v,'--k')
        % etiquetas
        xlabel('octas')
        ylabel('m/s')
        title('Mañana vs tarde')
        % detalles finales
        grid on
        set(h,'markerfacecolor','y','markeredgecolor','k')
        set(gcf,'color','w')
    elseif(relacion == 3)
        % arreglos para subplots
        per = {'Mañ. vs Mañ.','Tarde vs Tarde'};
        for i = 2:2
            % extraccion de variables
            x = E(i,:)';
            y = F(i,:)';
            % calculo de intervalo de confianza
            mdl = fitlm(table(x,y));
            anv = anova(mdl,'summary');
            MSE = anv.MeanSq(3);
            % ajuste de recta
            p = polyfit(x,y,1);
            v = polyval(p,lim1);
%             subplot(1,2,i)
            hold on
            plot(lim1,v,'k','linewidth',2)
            plot(lim1,v+1.96*MSE,'r','linewidth',1.5)
            plot(lim1,v-1.96*MSE,'r','linewidth',1.5)
            % dispersion
            h = plot(x,y,'o','markersize',4);
            % limites
            xlim(lim1)
            ylim(lim2)
            % etiquetas
            xlabel('octas')
            ylabel('m/s')
            title(titulo)
            % detalles finales
            grid on
            set(h,'markerfacecolor','y','markeredgecolor','k')
            set(gcf,'color','w')
        end
    elseif(relacion == 4)
        % extraccion de variables
        x = E(1,:);
        y = F(2,:);
        % dispersion
        h = plot(x,y,'o','markersize',7);
        % limites
        xlim(lim1)
        ylim(lim2)
        % ajuste de recta
        p = polyfit(x,y,1);
        v = polyval(p,lim1);
        hold on
        plot(lim1,v,'--k')
        % etiquetas
        xlabel('octas')
        ylabel('m/s')
        title('Mañana vs tarde')
        % detalles finales
        grid on
        set(h,'markerfacecolor','y','markeredgecolor','k')
        set(gcf,'color','w')
    end
    
end