%Version en la que los puntos de atraccion son generados por los nodos


clc;clear all;
tic
%Parámetros fijos
iter=100;              %Número máximo de iteraciones
Na=8;                %Número de puntos de atracción generados 

Ra=0.20;                   %Radio de atracción      %Ra = 0.2 | 0.25  ;
Re=0.12;                   %Radio de eliminación   %Re = 0.15 | 0.17;
G=0.10;                    %Parámetro de atracción  %G = 0.05 | 0.08;
Rg=0.20;                   %Radio de generacion
K=5;                       %Parámetro de repulsion
D=1.2;                       %Parametro de separacion (%Ra)

%Generamos el primer nodo en el centro y definimos los siguientes campos:
NODOS = zeros(7,1);
NODOS(1,1)=0;             %Coordenada X
NODOS(2,1)=0;             %Coordenada Y
NODOS(3,1)=0;               %Generacion
NODOS(4,1)=0;               %Padre
NODOS(5,1)=0;               %Obsoleto, de momento es falso ==> 0
NODOS(6,1)=0;               %Eliminacion, si es ==1 ==> no calcular de nuevo puntos a eliminar
NODOS(7,1)=0;               %¿Se han generado los puntos de atraccion? =1 si; =0 no

figure
plot(NODOS(1,1),NODOS(2,1),'r.','MarkerSize',10)
axis equal
axis([-3,3,-3,3])
hold on

nc=0;

%Generacion de los primeros puntos de atraccion
RANDOM = -Ra+2*Ra*rand(2,8*Na);
XYoriginal = NODOS([1 2],1)+RANDOM;       %Coord. puntos de atracción
XY = XYoriginal;
modulo = vecnorm(RANDOM);                 %Como queremos que sea circular eliminamos los puntos que estan fuera del radio
XY(:,find(modulo>Ra))=NaN;
NODOS(7,1)=1;

A=plot(XY(1,:),XY(2,:),'g.','MarkerSize',10);





    

for k=1:iter
    NODOSLONG = length(NODOS(1,:));
    for j=1:length(NODOS(1,:))
        
        if NODOS(5,j)==1                    %Si obsoleto=1 ==> No se hacen mas calculos
            dist(j) = {XY-NODOS([1,2],j)};
            norma(j) = {vecnorm(cell2mat(dist(j)))};
            NORMA = cell2mat(norma(j));
            NORMA(NORMA>Ra) = NaN;
            norma(j) = {NORMA};
            NORMA = cell2mat(norma(j));
            XY(:,find(NORMA<Re))=NaN;
                        
            continue
        else
            dist(j) = {XY-NODOS([1,2],j)};
            distrep(j) = {NODOS([1,2],:)-NODOS([1,2],j)};
            norma(j) = {vecnorm(cell2mat(dist(j)))};                                    %Distancia ptos atractores a los nodos
            normarep(j) = {vecnorm(cell2mat(distrep(j)))};
            NORMA = cell2mat(norma(j));
            NORMAREP = cell2mat(normarep(j));
%             NORMAREP(NORMAREP==0)=NaN;
%             if min(NORMAREP)<0.01
%                 NODOS(5,j)=1;
%                 continue
%             end
            
            NORMA(NORMA>Ra) = NaN;                                              %Condicion radio de atraccion
            NORMAREP(NORMAREP>Ra) = NaN;
            norma(j) = {NORMA};
            normarep(j) = {NORMAREP};
            NORMA = cell2mat(norma(j));
            NORMAREP = cell2mat(normarep(j));
        end
        
        
        %minimo = min(NORMA);
        %DISTANCIA = cell2mat(dist(j));
        
        if  sum(NORMA,'omitnan')==0                                         %Si ningun pto de atraccion esta lo suficientemente cerca Obsoleto=1
            NODOS(5,j)=1;
            continue
        elseif cell2mat(normarep(j))==0
            n2 = cell2mat(dist(j))./cell2mat(norma(j));
            %n3 = DISTANCIA(:,find(NORMA==min(NORMA)))/minimo;
            n3 = sum(n2,2,'omitnan');
            n = n3/norm(n3);
        else
            n2 = cell2mat(dist(j))./cell2mat(norma(j));
            n2rep = K*1./(1+NODOS(3,:)).*cell2mat(distrep(j))./cell2mat(normarep(j));
            %n3 = DISTANCIA(:,find(NORMA==min(NORMA)))/minimo;
            n3 = sum(n2,2,'omitnan')-sum(n2rep,2,'omitnan');
            n = n3/norm(n3);                                                %Vector  normal de crecimiento
        end
        
        NuevoNODO = NODOS([1,2],j)+G*n;                                     %Generacion de nuevos nodos
        NuevoNODO(3,1) = k;
        NuevoNODO(4,1) = j;
        NuevoNODO(5,1) = 0;
        NuevoNODO(6,1) = 0;
        NuevoNODO(7,1) = 0;
        
        
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
        
        %plot([NODOS(1,NuevoNODO(4,1)),NuevoNODO(1,1)],[NODOS(2,NuevoNODO(4,1)),NuevoNODO(2,1)],'b','LineWidth',25/k) %16/k |0.92^k*25
        
        plot([NODOS(1,NuevoNODO(4,1)),NuevoNODO(1,1)],[NODOS(2,NuevoNODO(4,1)),NuevoNODO(2,1)],'b','LineWidth',25/k)
        %plot(NuevoNODO(1,1),NuevoNODO(2,1),'r.','MarkerSize',10)
        
        
        
        XY(:,find(NORMA<Re))=NaN;
        
        if NODOS(7,j)==0
            RANDOM = -Rg+2*Rg*rand(2,Na);
            modulo = vecnorm(RANDOM);                 %Como queremos que sea circular eliminamos los puntos que estan fuera del radio
            RANDOM(:,find(modulo>Rg))=NaN;
            XYoriginal = NODOS([1 2],length(NODOS(1,:)))+D*Ra*n+RANDOM;       %Coord. puntos de atracción
            XY = [XY XYoriginal];
            
            NODOS(7,j)=1;
        end
        
        
        
        dist(length(NODOS(1,:))) = {XY-NODOS([1,2],length(NODOS(1,:)))};
        norma(length(NODOS(1,:))) = {vecnorm(cell2mat(dist(length(NODOS(1,:)))))};                                    %Distancia ptos atractores a los nodos
        NORMA = cell2mat(norma(length(NODOS(1,:))));
        NORMA(NORMA>Ra) = NaN;                                              %Condicion radio de atraccion
        norma(length(NODOS(1,:))) = {NORMA};
        NORMA = cell2mat(norma(length(NODOS(1,:))));
        
        XY(:,find(NORMA<Re))=NaN;
        
    end
    
    delete(A);
    A=plot(XY(1,isfinite(XY(1,:))),XY(2,isfinite(XY(1,:))),'g.','MarkerSize',10);
    title(['Iteracion nº',num2str(k)])
    %plot(NODOS(1,:),NODOS(2,:),'r.','MarkerSize',8)
    shg
    %
    %pause(0.1)
    parar = input('Introduce algo');

end


    


%plot(XYoriginal(1,:),XYoriginal(2,:),'g.','MarkerSize',10)










toc