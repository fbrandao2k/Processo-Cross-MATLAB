%% CrossMember class
%
% This class defines a member of a continuous beam for the Cross Process.
% Euler-Bernoulli flexural behavior is assumed (Navier beam theory).
%
%% Author
% Luiz Fernando Martha
%
%% History
% @version 1.00
%
% Initial version: August 2017
%%%
% Initially prepared for the course CIV 2801 - Fundamentos de Computação
% Gráfica, 2017, second term, Department of Civil Engineering, PUC-Rio.
%
%% Class definition
classdef CrossMember < matlab.mixin.SetGet
    %%
    % <https://www.mathworks.com/help/matlab/ref/matlab.mixin.setget-class.html
    % See documentation on *matlab.mixin.setget* handle super-class>.
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        EI = 0;            % flexural stiffness
        len = 0;           % member length
        q = 0;             % vertical distributed load (top-down positive)
        ml = 0;            % left end moment
        mr = 0;            % right end moment
        k = 0;             % rotational stiffness coefficient
    end
    
    %% Constructor method
    methods
        %------------------------------------------------------------------
        function memb = CrossMember(EI,len,q)
            if (nargin > 0)
                memb.EI = EI;
                memb.len = len;
                memb.q = q;
                memb.ml = 0;
                memb.mr = 0;
                memb.k = 0;
            end
        end
    end
    
    %% Public set methods
    methods
        %------------------------------------------------------------------
        % Sets flexural stiffness.
        function memb = set.EI(memb,EI)
            memb.EI = EI;
        end
        
        %------------------------------------------------------------------
        % Sets member length.
        function memb = set.len(memb,len)
            memb.len = len;
        end
        
        %------------------------------------------------------------------
        % Sets vertical distributed load (top-down positive).
        function memb = set.q(memb,q)
            memb.q = q;
        end
        
        %------------------------------------------------------------------
        % Sets left end moment.
        function memb = set.ml(memb,ml)
            memb.ml = ml;
        end
        
        %------------------------------------------------------------------
        % Sets right end moment.
        function memb = set.mr(memb,mr)
            memb.mr = mr;
        end
        
        %------------------------------------------------------------------
        % Sets rotational stiffness coefficient.
        function memb = set.k(memb,k)
            memb.k = k;
        end
    end
    
    %% Public get methods
    methods
        %------------------------------------------------------------------
        % Gets flexural stiffness.
        function EI = get.EI(memb)
            EI = memb.EI;
        end
        
        %------------------------------------------------------------------
        % Gets member length.
        function len = get.len(memb)
            len = memb.len;
        end
        
        %------------------------------------------------------------------
        % Gets vertical distributed load (top-down positive).
        function q = get.q(memb)
            q = memb.q;
        end
        
        %------------------------------------------------------------------
        % Gets left end moment.
        function ml = get.ml(memb)
            ml = memb.ml;
        end
        
        %------------------------------------------------------------------
        % Gets right end moment.
        function mr = get.mr(memb)
            mr = memb.mr;
        end
        
        %------------------------------------------------------------------
        % Gets rotational stiffness coefficient.
        function k = get.k(memb)
            k = memb.k;
        end
    end
    
    %% Public methods
    methods
        %------------------------------------------------------------------
        % Cleans data structure of a CrossMember object.
        function memb = clean(memb)
            memb.EI = 0;
            memb.len = 0;
            memb.q = 0;
            memb.ml = 0;
            memb.mr = 0;
            memb.k = 0;
        end
    end
end