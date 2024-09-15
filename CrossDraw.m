%% CrossDraw class
%
% This class implements methods to plot graphical results
% from the Cross process of continuous beams.
%
%% Author
% Luiz Fernando Martha
%
%% History
% @version 1.00
%
% Initial version: September 2017
%%%
% Initially prepared for the course CIV 2801 - Fundamentos de Computação
% Gráfica, 2017, second term, Department of Civil Engineering, PUC-Rio.
%
%% Class definition
classdef CrossDraw
    %% Public attributes    
     properties (SetAccess = public, GetAccess = public)
        solver;
     end
    
     
 %% Constructor method    
methods
    
     function this = CrossDraw(solver)
         if (nargin > 0)
             this.solver = solver;
         end
     end

end

%% Class (static) auxiliary functions
methods (Static)
        %------------------------------------------------------------------
        % Plots a square with defined center coordinates, side length and
        % color.
        % This method is used to draw nodal points and rotation constraints
        % on 2D models.
        % Input arguments:
        %  x: center coordinate on the X axis
        %  y: center coordinate on the Y axis
        %  l: side length
        %  c: color (RGB vector)
        function square(x,y,l,c)
            X = [x - l/2, x + l/2, x + l/2, x - l/2];
            Y = [y - l/2, y - l/2, y + l/2, y + l/2];
            fill(X, Y, c);
        end
        
        %------------------------------------------------------------------
        % Plots a triangle with defined top coordinates, height, base,
        % orientation, and color.
        % This method is used to draw translation constraints on 2D models.
        % Input arguments:
        %  x: top coordinate on the X axis
        %  y: top coordinate on the Y axis
        %  h: triangle height
        %  b: triangle base
        %  ang: angle (in radian) between the axis of symmetry and the
        %       horizontal direction (counterclockwise) - 0 rad when
        %       triangle is pointing left
        %  c: color (RGB vector)
        function triangle(x,y,h,b,ang,c)
            cx = cos(ang);
            cy = sin(ang);
            X = [x, x + h * cx + b/2 * cy, x + h * cx - b/2 * cy];
            Y = [y, y + h * cy - b/2 * cx, y + h * cy + b/2 * cx];
            fill(X, Y, c);
        end
        
        %------------------------------------------------------------------
        % Plots a circle with defined center coordinates, radius and color.
        % This method is used to draw hinges on 2D models.
        % Input arguments:
        %  x: center coordinate on the X axis
        %  y: center coordinate on the Y axis
        %  r: circle radius
        %  c: color (RGB vector)
        function circle(x,y,r,c)
            circ = 0 : pi/50 : 2*pi;
            xcirc = x + r * cos(circ);
            ycirc = y + r * sin(circ);
            plot(xcirc, ycirc, 'color', c);
        end
        
        %------------------------------------------------------------------
        % Plots an arrow with defined beggining coordinates, length,
        % arrowhead height, arrowhead base, orientation, and color.
        % This method is used to draw load symbols on 2D models.
        % Input arguments:
        %  x: beggining coordinate on the X axis
        %  y: beggining coordinate on the Y axis
        %  l: arrow length
        %  h: arrowhead height
        %  b: arrowhead base
        %  ang: pointing direction (angle in radian with the horizontal
        %       direction - counterclockwise) - 0 rad when pointing left
        %  c: color (RGB vector)
        function arrow2D(x,y,l,h,b,ang,c)
            cx = cos(ang);
            cy = sin(ang);
            X = [x, x + l * cx];
            Y = [y, y + l * cy];
            line(X, Y, 'Color', c);
            CrossDraw.triangle(x, y, h, b, ang, c);
        end
end

%% Public methods
 methods (Access = public)
     
     %------------------------------------------------------------------
     % Draws a continuous beam model with applied loads.
     % n=1 drawing only in the first axis (continuos beam with loads)
     % n=4 drawing only in the fourth plot (Iterative beam)
    function model(draw,axes_model, n)
        axes(axes_model);
        hold on;
        %It calculates the maximum load to use later to adjust zoom
         qmax = 0;
        for i = 1:draw.solver.nmemb
            if abs( draw.solver.membs(i).q ) >qmax
                qmax = abs( draw.solver.membs(i).q );
            end
        end

        if draw.solver.supinit == 0
            draw.triangle(0,0,0.6,0.3,-pi/2,[0 0 1]);
            draw.circle(0,0,0.1,[0 0 1]);
            else
                draw.triangle(0,0,0.6,0.3,-pi/2,[0 0 1]);
                draw.square(0,0,0.3,[0 0 1]);
        end
        line([0,draw.solver.membs(1).len],[0,0]);
        total_length = draw.solver.membs(1).len;
        % Drawing the arrows and texts
        if n == 1
            txt = sprintf( '%.*f',draw.solver.decplc, draw.solver.membs(1).len );
            txt = num2str(txt);
            txt = [ txt , ' m' ];
            txt2 = sprintf( '%.*f',draw.solver.decplc, draw.solver.membs(1).q );
            txt2 = num2str(txt2);
            txt2 = [ txt2 , ' kN/m' ];
            text(total_length/2, -1.3, txt, 'Color', [0.2 0.2 0.2]);
            text(total_length/2, -0.5, txt2, 'Color', [0 0 0]);
            
            if draw.solver.nmemb == 1
                q1 = draw.solver.membs(1).q*qmax/1.5;
            else
                q1 = draw.solver.membs(1).q;
            end
            for x = 0: draw.solver.membs(1).len/(2*round(draw.solver.membs(1).len)) :(draw.solver.membs(1).len)
                draw.arrow2D(x,0,q1*1.5/qmax,0.2*abs(q1)/q1,0.2,pi/2,[0,0,0]);
            end
            draw.arrow2D(draw.solver.membs(1).len,0,q1*1.5/qmax,0.2*abs(q1)/q1,0.2,pi/2,[0,0,0]);
            line([0,draw.solver.membs(1).len],[q1*1.5/qmax,q1*1.5/qmax],'Color','black');
        end
        %Drawing distribution coefficients
        if n == 4
            txt = sprintf('%.*f',draw.solver.decplc,draw.solver.dist_coef(1));
            text(draw.solver.membs(1).len-1,0.5,txt, 'Color', 'blue'); 
        end
        if draw.solver.nmemb == 2
            draw.solver.support_positions(1) = total_length;
        end
        if draw.solver.nmemb > 2 
            for i = 2:draw.solver.nmemb-1
                draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                draw.solver.support_positions(i-1) = total_length;
                line([total_length,total_length+draw.solver.membs(i).len],[0,0]);
                % Drawing the arrows and texts
                if n == 1
                    txt = sprintf( '%.*f',draw.solver.decplc, draw.solver.membs(i).len );
                    txt = num2str(txt);
                    txt = [ txt , ' m' ]; %#ok<AGROW>
                    txt2 = sprintf( '%.*f',draw.solver.decplc, draw.solver.membs(i).q );
                    txt2 = num2str(txt2);
                    txt2 = [ txt2 , ' kN/m' ]; %#ok<AGROW>
                    text(total_length+draw.solver.membs(i).len/2, -1.3, txt, 'Color', [0.2 0.2 0.2]);
                    text(total_length+draw.solver.membs(i).len/2, -0.5, txt2, 'Color', [0 0 0]);
                    for x = total_length: draw.solver.membs(i).len/(2*round(draw.solver.membs(i).len)) :(total_length+draw.solver.membs(i).len)
                        qi = draw.solver.membs(i).q;
                        draw.arrow2D(x,0,qi*1.5/qmax,0.2*abs(qi)/qi,0.2,pi/2,[0,0,0])
                    end
                    draw.arrow2D(total_length+draw.solver.membs(i).len,0,qi*1.5/qmax,0.2*abs(qi)/qi,0.2,pi/2,[0,0,0])
                    line([total_length,total_length+draw.solver.membs(i).len],[qi*1.5/qmax,qi*1.5/qmax],'Color','black');
                end
                %Drawing distribution coefficients
                if n == 4
                     txt = sprintf('%.*f',draw.solver.decplc,draw.solver.dist_coef(2*i-2));
                     txt2 = sprintf('%.*f',draw.solver.decplc,draw.solver.dist_coef(2*i-1));
                     text(total_length+0.5, 0.5, txt, 'Color', 'blue');
                     text(total_length+draw.solver.membs(i).len-0.5, 0.5, txt2, 'Color', 'blue');
                end
                total_length = total_length + draw.solver.membs(i).len ;
            end
        draw.solver.support_positions(i) = total_length;
        line([total_length,total_length+draw.solver.membs(i).len],[0,0]);
        end
        if draw.solver.nmemb > 1  
            draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);   
            total_length = total_length + draw.solver.membs(draw.solver.nmemb).len;
            line([total_length-draw.solver.membs(draw.solver.nmemb).len, total_length],[0,0]);
        end
        axis([-0.5,total_length+0.5,-2,2]);
        % Drawing the arrows and texts
        if draw.solver.nmemb > 1
            if n == 1  
                    txt = sprintf( '%.*f',draw.solver.decplc, draw.solver.membs(draw.solver.nmemb).len );
                    txt = num2str(txt);
                    txt = [ txt , ' m' ];
                    txt2 = sprintf( '%.*f',draw.solver.decplc, draw.solver.membs(draw.solver.nmemb).q );
                    txt2 = num2str(txt2);
                    txt2 = [ txt2 , ' kN/m' ];
                    text(total_length-draw.solver.membs(draw.solver.nmemb).len/2, -1.3, txt, 'Color', [0.2 0.2 0.2]);
                    text(total_length-draw.solver.membs(draw.solver.nmemb).len/2, -0.5, txt2, 'Color', [0 0 0]);
                    step = draw.solver.membs(draw.solver.nmemb).len/(2*round(draw.solver.membs(draw.solver.nmemb).len));
                    qn = draw.solver.membs(draw.solver.nmemb).q;
                    for x = total_length-draw.solver.membs(draw.solver.nmemb).len: step : total_length
                        draw.arrow2D(x,0,qn*1.5/qmax,0.2*abs(qn)/qn,0.2,pi/2,[0,0,0]);
                    end
                    line([total_length-draw.solver.membs(draw.solver.nmemb).len,total_length],[qn*1.5/qmax,qn*1.5/qmax],'Color','black');
            end
            %Drawing distribution coefficients
            if n == 4
                     txt = sprintf('%.*f',draw.solver.decplc,draw.solver.dist_coef(2*draw.solver.nmemb-2));
                     text(total_length-draw.solver.membs(draw.solver.nmemb).len+0.5, 0.5, txt, 'Color', 'blue');
            end
        end
        if draw.solver.supend == 0
                draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                draw.circle(total_length,0,0.1,[0 0 1]);
        else
                draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                draw.square(total_length,0,0.3,[0 0 1]);
        end 
        set(gca, 'YLim',[-2 2]);
        set(gca, 'xtick',[]);
        set(gca, 'ytick',[]);
    end
   %%%%%%% FINAL - CROSSDRAW: 01 %%%%%%%    
   
   
   %------------------------------------------------------------------
    % Draws a continuous beam model with its deformed configuration.
    function deformedConfig(draw, axes_deform)
         axes(axes_deform);
         hold on;
         scaleplot = 40; %scale of the plots
         minDeform = 0;
         maxDeform = 0;
%%%%%%% COMPLETE HERE - CROSSDRAW: 02 %%%%%%%
         %if draw.solver.supinit == 0
            %draw.triangle(0,0,0.6,0.3,-pi/2,[0 0 1]);
            %draw.circle(0,0,0.1,[0 0 1]);
             %else
                %draw.triangle(0,0,0.6,0.3,-pi/2,[0 0 1]);
                %draw.square(0,0,0.3,[0 0 1])
         %end
         line([0,draw.solver.membs(1).len],[0,0]);
         total_length = draw.solver.membs(1).len;         
         if draw.solver.nmemb > 2 
             
             for i = 2:draw.solver.nmemb-1
                %draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                line([total_length,total_length+draw.solver.membs(i).len],[0,0]);
                total_length = total_length + draw.solver.membs(i).len ;
             end   
            line([total_length,total_length+draw.solver.membs(i).len],[0,0]);
         end
         if draw.solver.nmemb > 1
             %draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
             total_length = total_length + draw.solver.membs(draw.solver.nmemb).len;
             line([total_length-draw.solver.membs(draw.solver.nmemb).len, total_length],[0,0]);
         end
         axis([-0.5,total_length+0.5,-2,2]);
         if draw.solver.supend == 0
                %draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                %draw.circle(total_length,0,0.1,[0 0 1]);
             else
                    %draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                    %draw.square(total_length,0,0.3,[0 0 1]);
         end
         %drawing the deforations
         q = draw.solver.membs(1).q;
         L = draw.solver.membs(1).len;
         x = 0:0.1:draw.solver.membs(1).len;
         x2 = x.*x;
         x3 = x2.*x;
         x4 = x3.*x;      
         if draw.solver.nmemb > 1
             if draw.solver.supinit == 0
                     D1 = q*L^3/48;
                     D2 = -draw.solver.nodes(1).rot*draw.solver.membs(1).EI;
                     C1 = (- q*L^3 + 12*D1 + 12*D2)/(2*L^2);
                     C2 = -(- q*L^3 + 48*D1 + 24*D2)/(12*L);
                     w = (q.*x4/24+C1.*x3/6+C2.*x2/2+D1*x)/draw.solver.membs(1).EI;
                     indexmin =  min(w) == w;
                     minDeform = abs( w(indexmin) );
                     indexmax =  max(w) == w;
                     maxDeform = w(indexmax);
             else
                     D1 = 0;
                     D2 = -draw.solver.nodes(1).rot*draw.solver.membs(1).EI;
                     C1 = (- q*L^3 + 12*D1 + 12*D2)/(2*L^2);
                     C2 = -(- q*L^3 + 48*D1 + 24*D2)/(12*L);
                     w = (q.*x4/24+C1.*x3/6+C2.*x2/2+D1)/draw.solver.membs(1).EI;
                     indexmin =  min(w) == w;
                     minDeform = abs( w(indexmin) );
                     indexmax =  max(w) == w;
                     maxDeform = w(indexmax);
             end 
             plot(x,-w*scaleplot,'Color','blue');
             sum_length = draw.solver.membs(1).len;
             if draw.solver.nmemb > 2 
                 for i = 2:draw.solver.nmemb-1
                     D1 = -draw.solver.nodes(i-1).rot*draw.solver.membs(i).EI;
                     D2 = -draw.solver.nodes(i).rot*draw.solver.membs(i).EI;
                     q = draw.solver.membs(i).q;
                     L = draw.solver.membs(i).len;
                     x = 0:0.1:draw.solver.membs(i).len;
                     x2 = x.*x;
                     x3 = x2.*x;
                     x4 = x3.*x;
                     C1 = (- q*L^3 + 12*D1 + 12*D2)/(2*L^2);
                     C2 = -(- q*L^3 + 48*D1 + 24*D2)/(12*L);
                     w = (q.*x4/24+C1.*x3/6+C2.*x2/2+D1*x)/draw.solver.membs(i).EI;
                     plot(x+sum_length,-w*scaleplot,'Color','blue');
                     sum_length = sum_length+draw.solver.membs(i).len;
                     indexmin =  min(w) == w;
                     indexmax =  max(w) == w;
                     if abs(w(indexmin)) > abs( minDeform )
                        minDeform = abs(w(indexmin));
                     end
                     if w(indexmax)>maxDeform
                        maxDeform = w(indexmax);
                     end
                 end
             end
             x = 0:0.1:draw.solver.membs(draw.solver.nmemb).len;
             q = draw.solver.membs(draw.solver.nmemb).q;
             L = draw.solver.membs(draw.solver.nmemb).len;
             x2 = x.*x;
             x3 = x2.*x;
             x4 = x3.*x;
             if draw.solver.supend == 0
                    D1 = -draw.solver.nodes(draw.solver.nnode).rot*draw.solver.membs(draw.solver.nnode).EI;
                    D2 = -q*L^3/48;
                    C1 = (- q*L^3 + 12*D1 + 12*D2)/(2*L^2);
                    C2 = -(- q*L^3 + 48*D1 + 24*D2)/(12*L);
                    w = (q.*x4/24+C1.*x3/6+C2.*x2/2+D1*x)/draw.solver.membs(draw.solver.nnode).EI;
                    indexmin =  min(w) == w;
                    indexmax =  max(w) == w;
                    if abs(w(indexmin)) > abs(minDeform)
                       minDeform = abs(w(indexmin));
                    end
                    if w(indexmax)>maxDeform
                       maxDeform = w(indexmax);
                    end
             else
                             D1 = -draw.solver.nodes(draw.solver.nnode).rot*draw.solver.membs(draw.solver.nnode).EI;
                             D2 = 0;
                             C1 = (- q*L^3 + 12*D1 + 12*D2)/(2*L^2);
                             C2 = -(- q*L^3 + 48*D1 + 24*D2)/(12*L);
                             w = (q.*x4/24+C1.*x3/6+C2.*x2/2+D1*x)/draw.solver.membs(draw.solver.nnode).EI;
                             indexmin =  min(w) == w;
                             indexmax =  max(w) == w;
                             if abs(w(indexmin)) > abs(minDeform)
                                minDeform = abs(w(indexmin));
                             end
                             if w(indexmax)>maxDeform
                                maxDeform = w(indexmax);
                             end
              end
              plot(x+sum_length,-w*scaleplot,'Color','blue');
         else
             %nmemb = 1
             if draw.solver.supinit == 0
                    D1 = q*L^3/48;
                 else
                     D1 = 0;
             end
             if draw.solver.supend == 0
                     D2 = -q*L^3/48;
                 else
                     D2 = 0;
             end
             C1 = (- q*L^3 + 12*D1 + 12*D2)/(2*L^2);
             C2 = -(- q*L^3 + 48*D1 + 24*D2)/(12*L);
             w = (q.*x4/24+C1.*x3/6+C2.*x2/2+D1*x)/draw.solver.membs(1).EI;
             indexmin =  min(w) == w;
             indexmax =  max(w) == w;
             if abs(w(indexmin)) > abs(minDeform)
                       minDeform = abs(w(indexmin));
             end
             if w(indexmax)>maxDeform
                       maxDeform = w(indexmax);
             end
             plot(x,-w*scaleplot,'Color','blue');
         end  
          limit = max(abs(minDeform), abs(maxDeform));
          limit = limit(1);
          
          draw.triangle(0,0,0.6*limit/0.0177,0.3,-pi/2,[0 0 1]);
          for i=1:(draw.solver.nmemb-1)
              draw.triangle(draw.solver.support_positions(i),0,0.6*limit/0.0177,0.3,-pi/2,[0 0 1]);
          end
          if draw.solver.nmemb == 1
              draw.triangle(draw.solver.membs(draw.solver.nmemb).len,0,0.6*limit/0.0177,0.3,-pi/2,[0 0 1]);
          else
              draw.triangle(draw.solver.support_positions(i)+draw.solver.membs(draw.solver.nmemb).len,0,0.6*limit/0.0177,0.3,-pi/2,[0 0 1]);
          end
          
          set(gca, 'YLim',[-2*limit/(0.0177) 2*limit/(0.0177)]);
          set(gca, 'xtick',[]);
          set(gca, 'ytick',[]);
%%%%%%% COMPLETE HERE - CROSSDRAW: 02 %%%%%%%
    end
 
        %------------------------------------------------------------------
        % Draws a continuous beam model with its bending moment diagram
        % indicating the values at the ends and the maximum value of
        % non-linear diagrams.
    
     function bendingMomDiagram(draw,axes_momdiagram)
         axes(axes_momdiagram);
         hold on;
         
         %calculating the maximum moment to use later in the adjust of the
         %zoom
         maxMoment = 0;
         for i = 1:length(draw.solver.matrix_moments)
             if abs(draw.solver.matrix_moments(i)) > maxMoment
                 maxMoment = abs(draw.solver.matrix_moments(i));
             end
         end
         if draw.solver.nmemb == 1
             maxMoment = abs( draw.solver.membs(1).q*draw.solver.membs(1).len^2/8 );
         end
         
         %%%%%%% COMPLETE HERE - CROSSDRAW: 03 %%%%%%%
         if draw.solver.supinit == 0
            draw.triangle(0,0,0.6,0.3,-pi/2,[0 0 1]);
            draw.circle(0,0,0.1,[0 0 1]);
             else
                draw.triangle(0,0,0.6,0.3,-pi/2,[0 0 1]);
                draw.square(0,0,0.3,[0 0 1])
         end
         line([0,draw.solver.membs(1).len],[0,0]);
         total_length = draw.solver.membs(1).len;         
         if draw.solver.nmemb > 2  
             for i = 2:draw.solver.nmemb-1

                if abs(abs(draw.solver.matrix_moments(2*i-2))-abs(draw.solver.matrix_moments(2*i-1)))>(10^-(draw.solver.decplc))
                        draw.triangle(total_length,0,0.6,0.3,-pi/2,[1 0 0]);
                    else
                        draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                end
                line([total_length,total_length+draw.solver.membs(i).len],[0,0]);
                total_length = total_length + draw.solver.membs(i).len ;
             end   
         end
         if draw.solver.nmemb > 1 
             if abs(abs(draw.solver.matrix_moments(2*draw.solver.nmemb-2))-abs(draw.solver.matrix_moments(2*draw.solver.nmemb-1)))>(10^-(draw.solver.decplc))
                    draw.triangle(total_length,0,0.6,0.3,-pi/2,[1 0 0]);
                else
                    draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
             end
         end
         if draw.solver.nmemb > 2 
            line([total_length,total_length+draw.solver.membs(i).len],[0,0]);
         end
         if draw.solver.nmemb > 1 
             total_length = total_length + draw.solver.membs(draw.solver.nmemb).len;
             line([total_length-draw.solver.membs(draw.solver.nmemb).len, total_length],[0,0]);
         end
         axis([-0.5,total_length+0.5,-2,2]);
         if draw.solver.supend == 0
                draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                draw.circle(total_length,0,0.1,[0 0 1]);
             else
                    draw.triangle(total_length,0,0.6,0.3,-pi/2,[0 0 1]);
                    draw.square(total_length,0,0.3,[0 0 1]);
         end
         
         %drawing moments
         if draw.solver.supinit == 0
             draw.solver.matrix_moments(1) = 0;
         end
         Mi = draw.solver.matrix_moments(1);
         Mf = draw.solver.matrix_moments(2);
         q = draw.solver.membs(1).q;
         L = draw.solver.membs(1).len;
         x = 0:0.1:draw.solver.membs(1).len;
         x2 = x.*x;
         M = q*x2/2-q*L*x/2+(-Mf-Mi)*x/L+Mi;
         indexmin =  min(M) == M;
         xmin = x(indexmin);
         xmin = xmin(1);
         Mmin = M(indexmin);
         Mmin = Mmin(1);
         indexmax =  max(M) == M;
         Mmax = M(indexmax);
         xmax = x(indexmax);
         line([0,0],[0,Mi*1.5/maxMoment],'Color','blue');
         line([draw.solver.membs(1).len,draw.solver.membs(1).len ], [0,-Mf*1.5/maxMoment ], 'Color', 'blue');
         plot(x, M*1.5/maxMoment,'Color', 'blue' );
         txt = sprintf('%.*f',draw.solver.decplc,abs(Mi));
         text(0,0.5,txt, 'Color', 'blue', 'FontWeight', 'bold' );
         txt = sprintf('%.*f',draw.solver.decplc,abs(Mf));
         text(draw.solver.membs(1).len-0.9,-Mf*1.5/maxMoment,txt, 'Color', 'blue', 'FontWeight', 'bold');
         txt = sprintf('%.*f',draw.solver.decplc,abs(Mmin) );
         txt2 = sprintf('%.*f',draw.solver.decplc,abs(Mmax) );
         if draw.solver.membs(1).q >= 0
            %if abs(Mmin) - abs(draw.solver.matrix_moments(2)) >2
                text(xmin,Mmin*1.5/maxMoment-0.2,txt, 'Color', 'blue','FontWeight', 'bold');
            %end
         else
              text(xmax,Mmax*1.5/maxMoment+0.2,txt2, 'Color', 'blue','FontWeight', 'bold');
         end
         sum_length = draw.solver.membs(1).len;
         if draw.solver.nmemb > 2 
             for i = 2:draw.solver.nmemb-1
                 Mi = draw.solver.matrix_moments(2*i-1);
                 %Mi=Mi(1);
                 Mf = draw.solver.matrix_moments(2*i);
                 q = draw.solver.membs(i).q;
                 L = draw.solver.membs(i).len;
                 x = 0:0.1:draw.solver.membs(i).len;
                 x2 = x.*x;
                 M = q*x2/2-q*L*(x)/2+(-Mf-Mi)*(x)/L+Mi;
                 indexmin =  min(M) == M;
                 xmin = x(indexmin);
                 Mmin = M(indexmin);
                 indexmax =  max(M) == M;
                 Mmax = M(indexmax);
                 Mmax = Mmax(1);
                 xmax = x(indexmax);
                 line([sum_length+draw.solver.membs(i).len, sum_length+draw.solver.membs(i).len ], [0,-Mf*1.5/maxMoment ], 'Color', 'blue')
                 line([sum_length, sum_length], [0,Mi*1.5/maxMoment ], 'Color', 'blue')
                 plot(x+sum_length, M*1.5/maxMoment,'Color', 'blue' );
                 txt = sprintf('%.*f',draw.solver.decplc,abs(Mi));
                 text(sum_length,Mi*1.5/maxMoment+0.2,txt, 'Color', 'blue', 'FontWeight', 'bold');
                 txt = sprintf('%.*f',draw.solver.decplc,abs(Mf) );
                 text(sum_length+draw.solver.membs(i).len-0.8,-Mf*1.5/maxMoment+0.2,txt, 'Color', 'blue','FontWeight', 'bold');
                 if draw.solver.membs(i).q >= 0
                    txt = sprintf('%.*f',draw.solver.decplc,abs(Mmin) );
                    text(xmin+sum_length,Mmin*1.5/maxMoment-0.5,txt, 'Color', 'blue','FontWeight', 'bold');
                 else 
                     txt = sprintf('%.*f',draw.solver.decplc,abs(Mmax) );
                     text(xmax+sum_length,Mmax*1.5/maxMoment-0.5,txt, 'Color', 'blue','FontWeight', 'bold');
                 end
                 sum_length = sum_length+draw.solver.membs(i).len;

             end
         end
         if draw.solver.nmemb > 1 
             x = 0:0.1:draw.solver.membs(draw.solver.nmemb).len;
             Mi = draw.solver.matrix_moments(2*draw.solver.nmemb-1);
             Mf = draw.solver.matrix_moments(2*draw.solver.nmemb);
             q = draw.solver.membs(draw.solver.nmemb).q;
             L = draw.solver.membs(draw.solver.nmemb).len;
             x2 = x.*x;
             M = q*x2/2-q*L*(x)/2+(-Mf-Mi)*(x)/L+Mi;
             indexmin =  min(M) == M;
             xmin = x(indexmin);
             Mmin = M(indexmin);
             indexmax =  max(M) == M;
             Mmax = M(indexmax);
             Mmax = Mmax(1);
             xmax = x(indexmax);
             line([sum_length+draw.solver.membs(draw.solver.nmemb).len, sum_length+draw.solver.membs(draw.solver.nmemb).len ], [0,-Mf*1.5/maxMoment ], 'Color', 'blue')
             line([sum_length, sum_length], [0,Mi*1.5/maxMoment ], 'Color', 'blue')
             plot(x+sum_length, M*1.5/maxMoment,'Color', 'blue' );
             txt = sprintf('%.*f',draw.solver.decplc,abs(Mi));
             text(sum_length,Mi*1.5/maxMoment+0.2,txt, 'Color', 'blue', 'FontWeight', 'bold');
             txt = sprintf('%.*f',draw.solver.decplc,abs(Mf) );
             text(sum_length+draw.solver.membs(draw.solver.nmemb).len-0.5,-Mf*1.5/maxMoment+0.2,txt, 'Color', 'blue', 'FontWeight', 'bold');
             if draw.solver.membs(draw.solver.nmemb).q >= 0
                txt = sprintf('%.*f',draw.solver.decplc,abs(Mmin) );
                text(xmin+sum_length,Mmin*1.5/maxMoment-0.2,txt, 'Color', 'blue','FontWeight', 'bold');
             else
                txt = sprintf('%.*f',draw.solver.decplc,abs(Mmax) );
                text(xmax+sum_length,Mmax*1.5/maxMoment-0.2,txt, 'Color', 'blue','FontWeight', 'bold');
             end
         end
         set(gca, 'YLim',[-2 2]);
         set(gca, 'xtick',[]);
         set(gca, 'ytick',[]);
     end
   %%%%%%% FINAL - CROSSDRAW: 03 %%%%%%%    
   
        %------------------------------------------------------------------
        % Plots model information from the corresponding step.
        % n = 2 = one step cross
        function modelStepInfo(draw, table_steps,n)
%%%%%%% COMPLETE HERE - CROSSDRAW: 04 %%%%%%%
            if n == 2
                %converts to the correct decimal places
                m = get(table_steps, 'Data');
                m = str2double(m);
                m = [m; draw.solver.balancing_moments];
                C = num2cell(m);
            end
            if n ==1
                C = num2cell(draw.solver.matrix_moments);
            end
                fun = @(x) sprintf( '%.*f', draw.solver.decplc, x);
                D = cellfun(fun, C, 'UniformOutput',0);
                set(table_steps, 'Data', D);
 %%%%%%% FINAL - CROSSDRAW: 04 %%%%%%%               
        end
        
        
        %It adjusts the width of the columns of the table
        %n = 0 adjusts at the beginning
        %n = 1 adjusts when the window is resized
        %n = 2 adjusts when supports are modified
        function adjustTableWidth (draw, hObject, handles, n) %#ok<INUSL>
            width_window = get(hObject, 'Position');
            width_window = width_window(3);
            if n == 0    
                handles.uitable1.ColumnWidth{1} = width_window*4/22 ;
                handles.uitable1.ColumnWidth{2} = width_window*4/22 ;
                handles.uitable1.ColumnWidth{3} = width_window*3/22 ;
                handles.uitable1.ColumnWidth{4} = width_window*3/22 ;
                handles.uitable1.ColumnWidth{5} = width_window*4/22 ;
                handles.uitable1.ColumnWidth{6} = width_window*4/22 ;
                columnName = {};
                columnName(1,handles.drive.getSolver().nmemb) = {'string'};
                for i=1:(handles.drive.getSolver().nmemb+1)*2-2
                    name = {strcat('Momento',' ',num2str(i))};
                    columnName(i) = name;
                end
                set(handles.uitable1, 'ColumnName', columnName);
            elseif n == 1
                nnode = handles.drive.getSolver.nnode;
                if nnode == 0
                    handles.uitable1.ColumnWidth{1} = width_window/2 ;
                    handles.uitable1.ColumnWidth{2} = width_window/2 ;
                    columnName = {};
                    columnName(1) = {'Momento1'};
                    columnName(2) = {'Momento2'};
                    set(handles.uitable1, 'ColumnName', columnName);
                else
                    total_length = handles.drive.getSolver.support_positions(nnode) + handles.drive.getSolver.membs(nnode+1).len;
                    for i = 1:(nnode+1)
                        handles.uitable1.ColumnWidth{2*i-1} = width_window*(handles.drive.getSolver().membs(i).len/(2*total_length)) ;
                        handles.uitable1.ColumnWidth{2*i} = width_window*(handles.drive.getSolver().membs(i).len/(2*total_length)) ;
                    end
                end
            elseif n == 2
                 nnode = handles.drive.getSolver.nnode;
                if nnode == 0
                    handles.uitable1.ColumnWidth{1} = width_window/2 ;
                    handles.uitable1.ColumnWidth{2} = width_window/2 ;
                    columnName = {};
                    columnName(1) = {'Momento1'};
                    columnName(2) = {'Momento2'};
                    set(handles.uitable1, 'ColumnName', columnName);
                else
                    total_length = handles.drive.getSolver.support_positions(nnode) + handles.drive.getSolver.membs(nnode+1).len;
                    for i = 1:(nnode+1)
                        handles.uitable1.ColumnWidth{2*i-1} = width_window*(handles.drive.getSolver().membs(i).len/(2*total_length)) ;
                        handles.uitable1.ColumnWidth{2*i} = width_window*(handles.drive.getSolver().membs(i).len/(2*total_length)) ;
                    end
                    columnName = {};
                    columnName(1,handles.drive.getSolver().nmemb) = {'string'};
                    for i=1:(handles.drive.getSolver().nmemb+1)*2-2
                        name = {strcat('Momento',' ',num2str(i))};
                        columnName(i) = name;
                    end
                    set(handles.uitable1, 'ColumnName', columnName);
                end 
            end
        end
                
    
       % Plots in all the axes
       % n = 1 is the the beam model and n=4 is for the iteration
       function SetAllAxes(draw,handles)
            cla(handles.axes1, 'reset');
            draw.model(handles.axes1, 1);
            cla(handles.axes2, 'reset');
            draw.deformedConfig(handles.axes2);
            cla(handles.axes3, 'reset');
            draw.bendingMomDiagram(handles.axes3);
            cla(handles.axes4, 'reset');
            draw.model(handles.axes4,4);
      end
end

end

