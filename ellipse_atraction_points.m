function [XY,XYlimits] = ellipse_atraction_points(iter_ellipse,Na_0)


r=1;           %Radio coordenadas elipticas

% N_ellipse = 15; %Numero de veces que crece la elipse
% Na_0 = 1e3;      %Numero de puntos de atracción iniciales
% a_0=0.35;         %Radios mayor y menor de la elipse iniciales
% b_0=0.5;


% a = zeros(1,N_ellipse);
% b = zeros(1,N_ellipse);

% for iter_ellipse=1:N_ellipse
    
    b = @(iter_ellipse) 522.2/(1+exp(-0.1571*(iter_ellipse-1-21.9)));
    a = @(iter_ellipse) 462/(1+exp(-0.1571*(iter_ellipse-1-21.9)));
    
    a_iter = a(iter_ellipse);
    b_iter = b(iter_ellipse);
    
    A = pi*a_iter*b_iter;
    
    if iter_ellipse==1
        A_prev = 726.64;
    else
        A_prev = pi*a(iter_ellipse-1)*b(iter_ellipse-1);
    end    
    Na = floor(Na_0*A/A_prev);    %/A_0            %Numero de puntos de atraccion       
    phi = linspace(0,2*pi,Na);                    %Coordenada eliptica phi ajustada para que el      
                                  %número de puntos que forma la elipse crezca con el tamaño
    
    
    
    x = a_iter*r*sin(phi);                             %Coordenadas x e y de la elipse
    y = b_iter*(1+r*cos(phi));
    
    if iter_ellipse==1
        r1 = rand(1,Na);                      %Generacion de puntos aleatorios, mismo numero de puntos que conforman la elipse
        r2 = r1.^(1/2);                                %Reajuste para homogeneizar la distribucion de puntos
        
        x1 = a_iter*r2.*sin(phi);                           %Coordenadas de los puntos de atraccion
        y1 = b_iter*(1+r2.*cos(phi));
    else
        randomvector = (rand(1,Na));
        a_prev = a(iter_ellipse-1);
        b_prev = b(iter_ellipse-1);
        a1 = a_prev+(a_iter-a_prev)*randomvector;
        b1 = b_prev+(b_iter-b_prev)*randomvector;
        
        x1 = a1.*sin(phi);
        y1 = b1.*(1+cos(phi));
    end
    

%     plot(x1,y1,'g.') 
%     hold on
%     plot(x,y)
%     axis equal
%     shg
%     pause(0.5)
% end

XY = [x1;y1];
XYlimits = [x;y];
end

