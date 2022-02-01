clc;clear all;
tic
%Parámetros fijos
iter=100;              %Número máximo de iteraciones
Na=9000;                %Número de puntos de atracción %Na = 5000;

Ra=0.12;                  %Radio de atracción      %Ra = 0.2 | 0.25  ;
Re=0.07;                  %Radio de eliminación   %Re = 0.15 | 0.17;
G=0.05;                  %Parámetro de atracción  %G = 0.05 | 0.08;

%Generamos la superficie aleatoria de puntos de atracción, en este caso una
%sup. de 1x1
XYoriginal = -3+6*rand(2,Na);       %Coord. puntos de atracción
XY = XYoriginal;
modulo = vecnorm(XY);
XY(:,find(modulo>3))=NaN;

%Generamos el primer nodo en el centro y definimos los siguientes campos:
NODOS = zeros(7,1);
NODOS(1,1)=0;             %Coordenada X
NODOS(2,1)=-3;             %Coordenada Y
NODOS(3,1)=0;               %Generacion
NODOS(4,1)=0;               %Padre
NODOS(5,1)=0;               %Obsoleto, de momento es falso ==> 0
NODOS(6,1)=0;               %Eliminacion, si es ==1 ==> no calcular de nuevo puntos a eliminar
NODOS(7,1)=1;               %Si ==1 ==> se le han asignado los puntos de atraccion para R<Ra  

A=plot(XY(1,:),XY(1,:),'g.','MarkerSize',10);
axis equal
axis([-3,3,-3,3])
hold on

nc=0;


dist(1) = {XY-NODOS([1,2],1)};
norma(1) = {vecnorm(cell2mat(dist(1)))};                                    %Distancia ptos atractores a los nodos
NORMA = cell2mat(norma(1));
NORMA(NORMA>Ra) = NaN;                                              %Condicion radio de atraccion
norma(1) = {NORMA};
NODOS(7,1)=1;


for k=1:iter
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
        
        plot([NODOS(1,NuevoNODO(4,1)),NuevoNODO(1,1)],[NODOS(2,NuevoNODO(4,1)),NuevoNODO(2,1)],'b','LineWidth',25/k) %16/k |0.92^k*25
        
        %shg
        
%         if NODOS(6,j)==0 
%             XY(:,find(NORMA<Re))=NaN;
%             NODOS(6,j)=1; 
%         end
        
        if NODOS(7,length(NODOS(1,:)))==0
            dist(length(NODOS(1,:))) = {XY-NODOS([1,2],length(NODOS(1,:)))}; 
            norma(length(NODOS(1,:))) = {vecnorm(cell2mat(dist(length(NODOS(1,:)))))};                                %Calculamos las distancias al nuevo nodo
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
    
    delete(A);
    A=plot(XY(1,isfinite(XY(1,:))),XY(2,isfinite(XY(1,:))),'g.','MarkerSize',10);
    title(['Iteracion nº',num2str(k)])
    %plot(NODOS(1,:),NODOS(2,:),'r.','MarkerSize',8)
    shg
    %
    %pause(0.1)
     %parar = input('Introduce algo');
end


    


%plot(XYoriginal(1,:),XYoriginal(2,:),'g.','MarkerSize',10)










toc