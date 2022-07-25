clc;clear all;
tic
% fh=figure();
% fh.WindowState='maximized';


%Parámetros fijos
iter=100;                %Número máximo de iteraciones
iter_ellipse=41;          %Numero de crecimientos de la elipse
k_0=0;                   %Correccion al numero de iteraciones

Ra=56;                  %Radio de atracción      %Ra = 0.07    56
Re=49;                  %Radio de eliminación   %Re = 0.052    49
G=12;                  %Parámetro de atracción  %G = 0.015   12.0

%Generamos la superficie aleatoria de puntos de atracción

%iter_ellipse = 1;   %Veces que ha crecido la elipse
Na_0 = 0.3e3;         %Numero de puntos de atracción iniciales    Na_0=0.2e1
%a_0=0.35;              %Radios mayor y menor de la elipse iniciales a_0=0.35
%b_0=0.5;                                                           %b_0=0.5

[XY,XYlimits] = ellipse_atraction_points(1,Na_0);

%A = plot(XY(1,:),XY(2,:),'g.','MarkerSize',10);
% hold on
%plot(XYlimits(1,:),XYlimits(2,:),'k','LineWidth',2)
%axis equal
% axis equal
% axis([-450,450,0,950])



%Generamos el primer nodo en el centro y definimos los siguientes campos:
NODOS = zeros(8,1);
NODOS(1,1)=0;             %Coordenada X
NODOS(2,1)=0;             %Coordenada Y
NODOS(3,1)=0;               %Generacion
NODOS(4,1)=0;               %Padre
NODOS(5,1)=0;               %Obsoleto, de momento es falso ==> 0
NODOS(6,1)=0;               %Eliminacion, si es ==1 ==> no calcular de nuevo puntos a eliminar
NODOS(7,1)=0;               %Si ==1 ==> se le han asignado los puntos de atraccion para R<Ra  
NODOS(8,1)=1;               %Iteracion de la elipse    



dist(1) = {XY-NODOS([1,2],1)};
norma(1) = {vecnorm(cell2mat(dist(1)))};                                    %Distancia ptos atractores a los nodos
NORMA = cell2mat(norma(1));
NORMA(NORMA>Ra) = NaN;                                              %Condicion radio de atraccion
norma(1) = {NORMA};
NODOS(7,1)=1;


%plot(NODOS(1,1),NODOS(2,1),'r.','MarkerSize',15)
hold on
axis equal
axis([-550,550,0,1050])

input('Di algo');
fig=figure(1);
grid on
grid minor

for i=2:iter_ellipse

    for k=(1+k_0):(iter+k_0)
        
        NODOSLONG = length(NODOS(1,:));
        for j=1:length(NODOS(1,:))
            
            if NODOS(5,j)==1                    %Si obsoleto=1 ==> No se hacen mas calculos
                continue
            else
                NORMA = cell2mat(norma(j));
            end

            %minimo = min(NORMA);
            %DISTANCIA = cell2mat(dist(j));
            
            if  sum(NORMA,'omitnan')==0                                         %Si ningun pto de atraccion esta lo suficientemente cerca Obsoleto=1
                NODOS(5,j)=1;
                
                continue
            else
                n2 = cell2mat(dist(j))./cell2mat(norma(j));
                %n3 = DISTANCIA(:,find(NORMA==min(NORMA)))/minimo;
                n3 = sum(n2,2,'omitnan');
                n = n3/norm(n3);                                                %Vector  normal de crecimiento
            end
            
            NuevoNODO = NODOS([1,2],j)+G*n;                                     %Generacion de nuevos nodos
            NuevoNODO(3,1) = k;
            NuevoNODO(4,1) = j;
            NuevoNODO(5,1) = 0;
            NuevoNODO(6,1) = 0;
            NuevoNODO(7,1) = 0;
            NuevoNODO(8,1) = i-1;
            
            for m=1:length(NODOS(1,:))
                if NuevoNODO(1,1)==NODOS(1,m) && NuevoNODO(2,1)==NODOS(2,m)
                    vector_igual=1;
                    break
                else
                    vector_igual=0;
                end
            end
            
            if vector_igual==1
                continue
            end
            
            NODOS = [NODOS NuevoNODO];
            
            %Codigo para guardar capturas
            
            
            
           % 
            plot([NODOS(1,NuevoNODO(4,1)),NuevoNODO(1,1)],[NODOS(2,NuevoNODO(4,1)),NuevoNODO(2,1)],'b','LineWidth',0.96^k*25) %16/k |0.92^k*25
            %plot([NODOS(1,NuevoNODO(4,1)),NuevoNODO(1,1)],[NODOS(2,NuevoNODO(4,1)),NuevoNODO(2,1)],'r.','MarkerSize',10)
            title(['Day ',num2str(i-1)])
            xlabel('x $[\mu m]$','interpreter','latex')
            ylabel('y $[\mu m]$','interpreter','latex')
%             baseFileName = sprintf('figure_%d.png',k+1);
%             fullFileName = fullfile('C:\','Users','Usuario','Desktop','Fisica','Prácticas Externas','simulacion','Capturas',baseFileName);
%             saveas(fig,fullFileName,'png')
            
%             %delete(fig);
            shg
            
            if NODOS(6,j)==0
                XY(:,find(NORMA<Re))=NaN;
                NODOS(6,j)=1;
            end
           
            if NODOS(7,length(NODOS(1,:)))==0
                dist(length(NODOS(1,:))) = {XY-NODOS([1,2],length(NODOS(1,:)))};
                norma(length(NODOS(1,:))) = {vecnorm(cell2mat(dist(length(NODOS(1,:)))))};   %Calculamos las distancias al nuevo nodo
                NORMA = cell2mat(norma(length(NODOS(1,:))));
                NORMA(NORMA>Ra)=NaN;                                          %Condicion radio de atraccion
                norma(length(NODOS(1,:))) = {NORMA};
                NODOS(7,length(NODOS(1,:)))=1;
            end
            
            
            if NODOS(6,length(NODOS(1,:)))==0
                XY(:,find(NORMA<Re))=NaN;
                NODOS(6,length(NODOS(1,:)))=1;
            end
            %         if NODOS(6,j)==1 && NODOS(6,j+1)==1
            %             continue
            %         end
            
            [x,y]=find(isnan(XY));
            
            for l=1:length(NODOS(1,:))
                NORMA = cell2mat(norma(l));
                NORMA(y)= NaN;
                norma(l) = {NORMA};
            end
            %
            %         NORMA(y)= NaN;
            %         NORMA2(y) = NaN;
            %         norma(j) = {NORMA};
            %         norma(length(NODOS(1,:))) = {NORMA2};
            %
            
            
        end
        if sum(XY(1,:),'omitnan')==0
            break
        end
        
        if NODOSLONG==length(NODOS(1,:))
            break
        end
        
        %delete(A);
        %A=plot(XY(1,isfinite(XY(1,:))),XY(2,isfinite(XY(1,:))),'g.','MarkerSize',10);
        %title(['Iteracion nº',num2str(k),', elipse iter nº',num2str(i-1)])
        %title(['Day ',num2str(i-1)])
        
        xlabel('x $[\mu m]$','interpreter','latex')
        ylabel('y $[\mu m]$','interpreter','latex')
        %plot(NODOS(1,:),NODOS(2,:),'r.','MarkerSize',8)
        %shg

        %
        %pause(0.1)
        %parar = input('Introduce algo');
    end
    
    
    k_0=k;
    [XY,XYlimits] = ellipse_atraction_points(i,Na_0);
    
    for j=1:length(NODOS(1,:))
        
        if NODOS(8,j)==(i-1)
            NODOS(5,j)=0;
            NODOS(6,j)=0;
            dist(j) = {XY-NODOS([1,2],j)};
            norma(j) = {vecnorm(cell2mat(dist(j)))};                                %Calculamos las distancias al nuevo nodo
            NORMA = cell2mat(norma(j));
            NORMA(NORMA>Ra)=NaN;                                          %Condicion radio de atraccion
            norma(j) = {NORMA};
            NODOS(7,j)=1;
        end
    end
    
    %A = plot(XY(1,:),XY(2,:),'g.','MarkerSize',10);
    %plot(XYlimits(1,:),XYlimits(2,:),'r')
    
    
end



toc