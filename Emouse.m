%% Emouse class
%
% This is an abstract class to facilitate the development of applications
% that handle mouse events on canvas (axes: the drawing area of a GUI
% application in MATLAB).
%
%% Description
%
% The abstract *Emouse* class presents, in addition to the constructor 
% method, 4 private concrete methods (implemented) and 3 abstract methods
% that must be implemented by the client user. Its use is achieved by
% creating a client subclass that inherits its properties and implements
% the 3 abstract methods:
%%%
% * *downAction*: This method must be implemented with the procedures to
%                 be performed when the user presses a mouse button.
%%%
% * *moveAction*: This method must be implemented with the procedures to
%                 be performed when the user moves the mouse.
%%%
% * *upAction*: This method must be implemented with the procedures to
%               be performed when the user releases the mouse button that
%               was pressed.
%
% The constructor of the abstract *Emouse* class has 2 input arguments: 
%%%
% * The handle to the target *figure* object (dialog).
%%%
% * The handle to the initial current *axes* object (canvas) in the
%   target figure. 
%
% These arguments must be provided by the client user.
% It is possible to have more than one *axes* in the *figure*.
% The current axes is updated to the axes found at the position of the
% mouse in the button down event.
% It is assumed that the Units property of the *figure* and all their
% *axes* are consistent.
%
%% Authors
%%%
% * Emersson Duvan Torres Sánchez (emersson80@hotmail.com)
%%%
% * Luiz Fernando Martha (lfm@tecgraf.puc-rio.br)
%
%% History
% @version 1.01
%
% Initial version: October 2017
%%%
% Initially prepared for the MSc dissertation "Desenvolvimento de uma
% classe no contexto da POO para gerenciamento genérico de eventos de
% mouse em um canvas no ambiente MATLAB.
% Modified for the course CIV 2801 - Fundamentos de Computação Gráfica,
% 2017, second term, Department of Civil Engineering, PUC-Rio.
%
%% Class definition
classdef Emouse < handle

    %% Public attributes
    properties (Access = protected)
        dialog = [];                % dialog (figure) associated to mouse events.
        canvas = [];                % canvas (axes) associated to mouse events.
        mouseButtonMode = 'up';     % Button mouse states, 'up' or 'down'.
        whichMouseButton = 'none';  % 'none', 'left', 'right', 'center',
                                    % or 'double click' at button mouse down.
        currentPosition = [];       % x and y coordinates of the current pointer position.
        eventdata;
        handles;
        
        %if canvas_number and allAxesInFigure are not
        %properties, they will vary
        canvas_number = 0;          % canvas in which the mouse is clicked, canvas_number=2 is the moment diagram
                                    % canvas_number=4 is the beam and arrow axis (axes1)
        allAxesInFigure = [];       % collection of all canvas

    end
    
    %% Constructor method
    methods
        %------------------------------------------------------------------
        % Constructor method, intended to initialize an object of this
        % class.
        % This method associates the mouse button down, mouse move,
        % and mouse button up events on the target figure (dialog) with
        % the private eButtonDown, eMouseMove, and eButtonUp methods,
        % respectively.
        % Input arguments:
        %  dlg: handle to the target figure object (dialog).
        function this = Emouse(dlg, eventdata, handles)
            this.dialog = dlg;
            this.eventdata = eventdata;
            this.handles = handles;
            this.canvas = [];
            set(this.dialog, 'WindowButtonDownFcn', @this.eButtonDown);
            set(this.dialog, 'WindowButtonMotionFcn', @this.eMouseMove);
            set(this.dialog, 'WindowButtonUpFcn', @this.eButtonUp);
            this.allAxesInFigure = findall(this.dialog,'type','axes'); %collecting all the canvas
            this.handles.moveArrows = 0;
        end
    end
    
    %% Abstract methods
    methods (Abstract)
        %------------------------------------------------------------------
        % This method must be implemented by a client subclass with the
        % procedures to be performed when the user presses a mouse button 
        downAction(this)

        %------------------------------------------------------------------
        % This method must be implemented by a client subclass with the
        % procedures to be performed when when the user moves the mouse.
        moveAction(this)

        %------------------------------------------------------------------
        % This method must be implemented by a client subclass with the
        % procedures to be performed when the when the user releases the
        % mouse button that was pressed.
        upAction(this)
    end
    
    %% Private methods
    methods (Access = private)
        %------------------------------------------------------------------
        % This method is a callback function associated with mouse button
        % down events on the target canvas.
        % The method finds, in the list of axes (canvases) of the 
        % target figure (dialog), the axes (canvas) in which the button
        % down position is located.
        % The method also determines which button was pressed, updates the
        % whichMouseButton property with this information, sets the
        % mouseButtonMode property to down, sets the current position to
        % the mouse button down position, and calls the abstract
        % downAction method.
        function eButtonDown(this,~,~)
            
            % it contains ths positions in this order [ left_canvas1, right_canvas1, bottom_canvas1, top_bottom1, ..., 
            % left_canvas4, right_canvas4,bottom_canvas4,top_bottom4 ]
            canvas_positions = zeros(1,4*4);      
            
            % Find the target canvas.
            figPt = get(this.dialog, 'CurrentPoint');
            
            for i=1:size(this.allAxesInFigure,1)
                limits = getpixelposition( this.allAxesInFigure(i) );
                canvas_positions(4*i-3) = limits(1);                %left position of canvas i
                canvas_positions(4*i-2) = limits(1) + limits(3);    %right position of canvas i
                canvas_positions(4*i-1) = limits(2);                %bottom position of canvas i
                canvas_positions(4*i) = limits(2) + limits(4);      %top position of canvas i
            end
            
             
            for i=1:4
                left = canvas_positions(4*i-3);           
                right = canvas_positions(4*i-2);  
                bottom = canvas_positions(4*i-1);                
                top = canvas_positions(4*i);        
                
                if (figPt(1) >= left && figPt(1) <= right && ...
                    figPt(2) >= bottom && figPt(2) <= top)
                    this.canvas = this.allAxesInFigure(i);
                    this.canvas_number = i;
                    break
                end
            end
            % Do nothing if button down event was not on a canvas.
            if size(this.canvas,2) < 1
                return
            end
            
            % Get which button was pressed.
            this.whichMouseButton = get(this.dialog, 'SelectionType');

            if strcmp(this.whichMouseButton,'alt')
                this.whichMouseButton = 'right';
            end
            if strcmp(this.whichMouseButton,'normal')
                this.whichMouseButton = 'left';
            end
            if strcmp(this.whichMouseButton,'extend')
                this.whichMouseButton = 'center';
            end           
            if strcmp(this.whichMouseButton,'open')
                this.whichMouseButton = 'double click';
            end
            
            % Set button mode as down, get button down location, and
            % call client (subclass) button down action method.
            this.mouseButtonMode = 'down';
            pt = get(this.canvas, 'CurrentPoint');
            xP = pt(1, 1);
            yP = pt(1, 2);
            this.currentPosition = [xP yP];
            %canvas_number=2 is the moment diagram
            %canvas_number=4 is the beam and arrow axis (axes1)
            if this.canvas_number == 2 || this.canvas_number == 4
                this.downAction();
            end
        end
        
        %------------------------------------------------------------------
        % This method is a callback function associated with mouse move
        % events on the target figure (dialog).
        % It sets the current position to the current mouse position on
        % the target axes (canvas) and calls the abstract moveAction
        % method.
        function eMouseMove(this,~,~)
            
            % Do nothing if button down event was not on a canvas.
            if this.whichMouseButton == 'none'
                return
            end
            
            % Get current mouse location, and call client (subclass)
            % mouse move action method.
            pt = get(this.canvas, 'CurrentPoint');
            xP = pt(1, 1);
            yP = pt(1, 2);
            this.currentPosition = [xP yP];
            this.moveAction();
        end
        
        %------------------------------------------------------------------
        % This method is a callback function associated with mouse button
        % up events on the target figure (dialog).
        % It sets the mouseButtonMode property to up, sets the current
        % position to the mouse button up position on the target axes
        % (canvas), and calls the abstract upAction method.
        function eButtonUp(this,~,~)
            
            % Do nothing if button down event was not on a canvas.
            if this.whichMouseButton == 'none'
               return
            end
            
            %Call client (subclass) button up action method.
            this.upAction();

            % Reset mouse button type and target canvas for next
            % sequence of button down - mouse move - button up events.
            this.whichMouseButton = 'none';
            
        end
        
        %------------------------------------------------------------------
        % Initializes property values of an Emouse object.
        function this = clean(this)
            this.dialog = [];
            this.canvas = [];
            this.mouseButtonMode = 'up';
            this.whichMouseButton = 'none';
            this.currentPosition = [];
        end
    end
end
