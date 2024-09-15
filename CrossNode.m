%% CrossNode class
%
% This class defines a node of a continuous beam for the Cross Process.
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
classdef CrossNode < matlab.mixin.SetGet
    %%
    % <https://www.mathworks.com/help/matlab/ref/matlab.mixin.setget-class.html
    % See documentation on *matlab.mixin.setget* handle super-class>.
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        dl = 0;            % left moment distribution coefficient
        dr = 0;            % right moment distribution coefficient
        tl = 0;            % left moment carry-over (transmission) factor
        tr = 0;            % right moment carry-over (transmission) factor
        rot = 0;           % node rotation
    end
    
    %% Constructor method
    methods
        %------------------------------------------------------------------
        function node = CrossNode(dl,dr,tl,tr,rot)
            if (nargin > 0)
                node.dl = dl;
                node.dr = dr;
                node.tl = tl;
                node.tr = tr;
                node.rot = rot;
            end
        end
    end
    
    %% Public set methods
    methods
        %------------------------------------------------------------------
        % Sets left moment distribution coefficient.
        function node = set.dl(node,dl)
            node.dl = dl;
        end
        
        %------------------------------------------------------------------
        % Sets right moment distribution coefficient.
        function node = set.dr(node,dr)
            node.dr = dr;
        end
        
        %------------------------------------------------------------------
        % Sets left moment carry-over (transmission) factor.
        function node = set.tl(node,tl)
            node.tl = tl;
        end
        
        %------------------------------------------------------------------
        % Sets right moment carry-over (transmission) factor.
        function node = set.tr(node,tr)
            node.tr = tr;
        end
        
        %------------------------------------------------------------------
        % Sets node rotation.
        function node = set.rot(node,rot)
            node.rot = rot;
        end
    end
    
    %% Public get methods
    methods
        %------------------------------------------------------------------
        % Gets left moment distribution coefficient.
        function dl = get.dl(node)
            dl = node.dl;
        end
        
        %------------------------------------------------------------------
        % Gets right moment distribution coefficient.
        function dr = get.dr(node)
            dr = node.dr;
        end
        
        %------------------------------------------------------------------
        % Gets left moment carry-over (transmission) factor.
        function tl = get.tl(node)
            tl = node.tl;
        end
        
        %------------------------------------------------------------------
        % Gets right moment carry-over (transmission) factor.
        function tr = get.tr(node)
            tr = node.tr;
        end
        
        %------------------------------------------------------------------
        % Gets node rotation.
        function rot = get.rot(node)
            rot = node.rot;
        end
    end
    
    %% Public methods
    methods
        %------------------------------------------------------------------
        % Cleans data structure of a CrossNode object.
        function node = clean(node)
            node.dl = 0;
            node.dr = 0;
            node.tl = 0;
            node.tr = 0;
            node.rot = 0;
        end
    end
end