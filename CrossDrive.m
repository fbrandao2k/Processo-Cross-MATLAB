%% CrossDrive class
% This class stores the CrossSolver and the CrossDraw that will be used in
% all the program
%
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
classdef CrossDrive
    %% Public attributes    
     properties (SetAccess = private, GetAccess = private)
        solver;             % handle to an object of the CrossSolver class  
        draw;               %draw the plots
     end
    
     
 %% Constructor method    
methods
    
     function this = CrossDrive()
             this.solver = CrossSolver();
             this.draw = CrossDraw(this.solver);
     end

end

%% Set and Get methods
 methods 
     
     function solver = getSolver(this)
         solver = this.solver;
     end
     
     function this = setSolverSupInit(this, supinit)
         this.solver.supinit = supinit;
     end
     
     function draw = getDraw(this)
         draw = this.draw;
     end
 end
end

