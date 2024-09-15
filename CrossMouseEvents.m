%% Class definition
classdef CrossMouseEvents < Emouse
    
    %% Public attributes
    properties (Access = protected)
        firstPosition = [];       % x and y coordinates of the first pointer position.
        mouseAction = 'MOUSE_DEFAULT'; % type of mouse action:
                                       % MOUSE_DEFAULT, INSERTING_NODE,
                                       % DELETING_NODE
    end
    
    %% Constructor method
    methods
        function this = CrossMouseEvents(fig, eventdata, handles)
            this = this@Emouse(fig, eventdata, handles);
        end
    end
    
    %% Class static auxiliary functions
    methods (Static)
        %------------------------------------------------------------------
        %index is the position of the closer support in relation to the
        %point clicked by the mouse
        %index = 0 is the firs support.
        %index = nnode+1 is the last one.
        function index = findCloserSupport(handles,xCurrentPosition)
             index = 0;
             dist = 50;
             pos = handles.drive.getSolver().support_positions;
             if isempty(pos)
                 if handles.drive.getSolver().membs(1).len - xCurrentPosition  >= xCurrentPosition
                     index = 0;
                 else
                     index = 1;
                 end
                 return
             end
             if xCurrentPosition < pos(1)
                 if pos(1)-xCurrentPosition > xCurrentPosition
                    index = 0; %first support
                    return
                 else
                     index = 1;
                     return
                 end
             end
             for i = 1:handles.drive.getSolver().nnode
                 m = abs( xCurrentPosition - pos(i));
                 if m < dist
                     dist = m;
                     index = i;
                 end
             end
             if pos(i) + handles.drive.getSolver().membs(i+1).len - xCurrentPosition < m
                 index = i+1; %last support
             end
        end
    
        %------------------------------------------------------------------
        %This function creates a copy of a list without modifying the 
        %original list 
        function membs = copyMembs (original, n)
            membs(1,n) = CrossMember();
            for i = 1:n
                membs(i).EI = original(i).EI;
                membs(i).len = original(i).len;
                membs(i).q = original(i).q ;
            end
        end
    
        %------------------------------------------------------------------
        %It calculates the distance from the support index
        function distance = calculateDistance ( handles, currentPosition, index )
            if index == 0 %first support
                distance = currentPosition;
                return
            elseif index == handles.drive.getSolver().nnode + 1  %last support
                pos = handles.drive.getSolver().support_positions;
                last_node = handles.drive.getSolver().nnode ;
                last_member = last_node+1;
                if isempty(pos)
                    distance = -(handles.drive.getSolver().membs(1).len-currentPosition);
                    return
                end
                distance = currentPosition - ( pos(last_node) + handles.drive.getSolver().membs(last_member).len );
                return
            else
                pos = handles.drive.getSolver().support_positions;
                distance = currentPosition - pos(index);
                return
            end
        end
    
    end 
    
    %% Public methods
    methods
        
        %------------------------------------------------------------------
        %A group of actions that occurs when the mouse is clicked in the
        %first canvas or the third canvas
        %this.handles.moveArrows: indicates if it is possible to move the
        %charges up and down(=1) or not (=0) 
        %this.handles.moveSupport: indicates if it is possible to move the
        %suports right/left(=1) or not (=0) 
        function this = downAction(this)
            axes(this.canvas);
            this.handles.moveSupport = 0;
            %if the canvas clicked is with the Moment Diagram
            if this.canvas_number == 2
                this.ActionMoment();
            %if the canvas clicked is with the Beam and the charges
            elseif this.canvas_number == 4
                if strcmp(this.mouseAction, 'INSERTING_NODE') == 1
                    this.ActionInsertion();
                elseif strcmp(this.getMouseStatus(),'DELETING_NODE') == 1
                    this.ActionDeletion();
                else
                    %Enable increasing or decreasing the arrows (charge)
                    this.firstPosition = this.currentPosition;
                    this.handles.moveArrows = 1; 
                    %Start moving support
                    if this.handles.drive.getSolver().nnode ~= 0
                        if this.currentPosition(2) >-1 &&  this.currentPosition(2) < 0.2
                            %this.firstPosition = this.currentPosition;
                            this.handles.moveSupport = 1;
                            return
                        end
                    end
                end
            end
        end
        
        %------------------------------------------------------------------
        %It has two objectives: the first is to move the supports and
        %the second is to move the arrows (charges)
        function this = moveAction(this)
            if this.handles.moveSupport == 1
                    %Start moving the support
                        nnode = this.handles.drive.getSolver.nnode;
                        for i =  1:nnode
                            %support selected
                            if abs(this.currentPosition(1) - this.handles.drive.getSolver.support_positions(i)) < 1
                                this.handles.moveArrows = 0;
                                index = this.findCloserSupport( this.handles, this.currentPosition(1) );
                                %ready to move!
                                if index ~= 0 && index ~= (nnode+1)
                                    future_size_left= this.handles.drive.getSolver.membs(index).len - (this.firstPosition(1)-this.currentPosition(1));
                                    future_size_right = this.handles.drive.getSolver.membs(index+1).len + (this.firstPosition(1)-this.currentPosition(1));
                                    if  future_size_right >= 2.2 &&  future_size_left >= 2.2
                                        this.handles.drive.getSolver.membs(index).len = future_size_left;
                                        this.handles.drive.getSolver.membs(index+1).len = future_size_right;
                                    else% if this.handles.drive.getSolver.membs(index).len < 2.2
                                        this.firstPosition = this.currentPosition;
                                        this.upAction();
                                        return
                                    end
                                    %lengths updated, restarting cross process
                                    this.firstPosition = this.currentPosition;
                                    cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                    this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                    return
                                end
                            end
                        end
            end
            %start moving the arrows (charges)
            if this.handles.moveArrows == 1
                
                        index = this.findCloserSupport(this.handles, this.currentPosition(1));
                        
                        if this.handles.drive.getSolver.nmemb == 1
                                this.handles.drive.getSolver.membs(1).q = this.handles.drive.getSolver.membs(1).q + ( this.currentPosition(2)-this.firstPosition(2) );
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                this.firstPosition = this.currentPosition;
                                return
                        end
                        
                        if index == 0
                                index = index +1;
                                this.handles.drive.getSolver.membs(index).q = this.handles.drive.getSolver.membs(index).q + ( this.currentPosition(2)-this.firstPosition(2) );
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                this.firstPosition = this.currentPosition;
                                return
                        end
                        
                        if index == this.handles.drive.getSolver.nmemb
                                this.handles.drive.getSolver.membs(index).q = this.handles.drive.getSolver.membs(index).q + ( this.currentPosition(2)-this.firstPosition(2) );
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                this.firstPosition = this.currentPosition;
                                return
                        end
                            
                        if this.handles.drive.getSolver.support_positions(index) - this.currentPosition(1) > 0 
                            %charge clicked is on the left of the support index
                            %if this.currentPosition(2) <= abs(this.handles.drive.getSolver.membs(index).q)
                                %ready for action
                                this.handles.drive.getSolver.membs(index).q = this.handles.drive.getSolver.membs(index).q + ( this.currentPosition(2)-this.firstPosition(2) );
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                this.firstPosition = this.currentPosition;
                                return
                            %end
                        else
                                %charge clicked is on the right of the support index
                                %if this.currentPosition(2) <= abs ( this.handles.drive.getSolver.membs(index+1).q )
                                    %ready for action
                                    this.handles.drive.getSolver.membs(index+1).q = this.handles.drive.getSolver.membs(index+1).q + ( this.currentPosition(2)-this.firstPosition(2) );
                                    cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                    this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                    this.firstPosition = this.currentPosition;
                                    return
                                %end
                        end             
            end
        end
        
        %------------------------------------------------------------------
        %When the button's mouse is released
        function this = upAction(this)
            this.handles.moveSupport = 0;
            this.handles.moveArrows = 0;
        end
        
        
        %------------------------------------------------------------------
        %It accomplishes one step of Cross
        function this = ActionMoment(this)
            for i = 1:this.handles.drive.getSolver.nnode
                if abs(this.currentPosition(1) - this.handles.drive.getSolver.support_positions(i))<= 0.1588 && abs(this.currentPosition(2))<0.9
                        
                        if this.handles.drive.getSolver().nodeStepSolver(i) == 1 
                            this.handles.drive.getSolver().printResults(1);
                            this.handles.drive.getDraw().modelStepInfo(this.handles.uitable1,2);
                            this.handles.drive.getDraw().SetAllAxes(this.handles)
                            if this.handles.drive.getSolver().moreStepsToGo() == 0
                                set(this.handles.text3, 'String','Solucao iterativa da viga contínua convergiu.');
                            end
                        end
                 break
                end
            end
        end
        
        %------------------------------------------------------------------
        %It insert a new support and does the cross process again
        function this = ActionInsertion(this)
            if abs(this.currentPosition(2)) > 0.2 
                        set(this.handles.text3, 'String','O apoio interno nao pode ser inserido: tamanho inferior ao minimo permitido ou ponto fora da viga.');
                        set( this.handles.insertToggle, 'State', 'Off' );
                        this.setMouseDefault();
                        return
                    else
                        %index is the position of the closer support.
                        %index = 0 is the firs support.
                        %index = nnode+1 is the last one.
                        index = this.findCloserSupport( this.handles, this.currentPosition(1) );
                        distance = this.calculateDistance( this.handles, this.currentPosition(1), index );
                        if abs(distance) < 2.2 
                            set(this.handles.text3, 'String','O apoio interno nao pode ser inserido: tamanho inferior ao minimo permitido ou ponto fora da viga.');
                            set( this.handles.insertToggle, 'State', 'Off' );
                            this.setMouseDefault();
                            return
                        else
                            %add support
                            this.handles.drive.getSolver().nmemb = this.handles.drive.getSolver().nmemb + 1;
                            this.handles.drive.getSolver().nnode = this.handles.drive.getSolver().nnode + 1;
                            nmemb = this.handles.drive.getSolver().nmemb;
                            nnode = this.handles.drive.getSolver().nnode;
                            if distance > 0 %adding after the closer support
                                old_membs =this.copyMembs ( this.handles.drive.getSolver().membs, nmemb-1 ) ;
                                this.handles.drive.getSolver().membs(index+1).len = distance;
                                this.handles.drive.getSolver().membs(index+2).EI = old_membs(index+1).EI;
                                this.handles.drive.getSolver().membs(index+2).len = old_membs(index+1).len - distance;
                                this.handles.drive.getSolver().membs(index+2).q = old_membs(index+1).q;
                                for i = (index+3):(nmemb)
                                    this.handles.drive.getSolver().membs(i).EI = old_membs(i-1).EI;
                                    this.handles.drive.getSolver().membs(i).len = old_membs(i-1).len;
                                    this.handles.drive.getSolver().membs(i).q = old_membs(i-1).q;
                                end
                                if nnode == 0 || nnode == 1
                                    %this.handles.drive.getSolver().nodes = [];
                                    %this.handles.drive.getSolver().nodes(1,1) = CrossNode();
                                else
                                    this.handles.drive.getSolver().nodes(1, nnode) = CrossNode();
                                end
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                set( this.handles.insertToggle, 'State', 'Off' );
                                this.setMouseDefault();
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2)
                                return
                            else
                                %distance < 0    %adding before the closest support
                                old_membs =this.copyMembs ( this.handles.drive.getSolver().membs, nmemb-1 ) ;
                                this.handles.drive.getSolver().membs(index).len = old_membs(index).len + distance;
                                this.handles.drive.getSolver().membs(index+1).EI = old_membs(index).EI;
                                this.handles.drive.getSolver().membs(index+1).len = abs(distance);
                                this.handles.drive.getSolver().membs(index+1).q = old_membs(index).q;
                                for i = (index+2):(nmemb)
                                    this.handles.drive.getSolver().membs(i).EI = old_membs(i-1).EI;
                                    this.handles.drive.getSolver().membs(i).len = old_membs(i-1).len;
                                    this.handles.drive.getSolver().membs(i).q = old_membs(i-1).q;
                                end
                                if nnode == 0
                                    this.handles.drive.getSolver().nodes(1) = CrossNode();
                                else
                                    this.handles.drive.getSolver().nodes(1, nnode) = CrossNode();
                                end
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                set( this.handles.insertToggle, 'State', 'Off' );
                                this.setMouseDefault();
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2)
                                return
                            end 
                        end       
            end
        end
        
        %------------------------------------------------------------------
        %It deletes one support and accomplishes the cross process again
        function this = ActionDeletion(this)
            if this.currentPosition(2) <-0.9 ||  this.currentPosition(2) > 0.2
                        set( this.handles.removeToggle, 'State', 'Off' );
                        set(this.handles.text3, 'String','O apoio nao foi encontrado.');
                        this.setMouseDefault();  
                        return
                    else

                        nnode = this.handles.drive.getSolver.nnode;
                        %only one node
                        disp( this.handles.drive.getSolver.support_positions )
                        if nnode == 1
                            if abs(this.currentPosition(1) - this.handles.drive.getSolver.membs(1).len ) < 0.8
                                this.handles.drive.getSolver().nmemb = 1;
                                this.handles.drive.getSolver().nnode = 0;
                                this.handles.drive.getSolver().membs(1).len = this.handles.drive.getSolver().membs(1).len + this.handles.drive.getSolver().membs(2).len;
                                this.handles.drive.getSolver().membs(2) = [];
                                this.handles.drive.getSolver().nodes(1,2) = CrossNode();
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                this.handles.drive.getSolver().support_positions = [];
                                this.handles.drive.getSolver().matrix_moments = [];
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                set( this.handles.removeToggle, 'State', 'Off' );
                                this.setMouseDefault();
                                return
                            end
                            return
                        end

                        for i =  1:nnode
                            %remove the selected support
                            if abs(this.currentPosition(1) - this.handles.drive.getSolver.support_positions(i)) < 0.8
                                this.handles.drive.getSolver().nmemb = this.handles.drive.getSolver().nmemb - 1;
                                this.handles.drive.getSolver().nnode = this.handles.drive.getSolver().nnode - 1;
                                nmemb = this.handles.drive.getSolver().nmemb;
                                nnode = this.handles.drive.getSolver().nnode;
                                old_membs =this.copyMembs ( this.handles.drive.getSolver().membs, nmemb+1 ) ;

                                this.handles.drive.getSolver().membs(i).len = old_membs(i).len + old_membs(i+1).len;

                                if i~=nnode+1
                                    for j = (i+1):(nmemb)
                                        this.handles.drive.getSolver().membs(j).EI = old_membs(j+1).EI;
                                        this.handles.drive.getSolver().membs(j).len = old_membs(j+1).len;
                                        this.handles.drive.getSolver().membs(j).q = old_membs(j+1).q;
                                    end
                                else
                                    j=nnode+1;
                                end
                                this.handles.drive.getSolver().membs(j+1) = [];
                                this.handles.drive.getSolver().nodes(1, nnode) = CrossNode();
                                this.handles.drive.getDraw.adjustTableWidth(this.dialog, this.handles, 2);
                                this.handles.drive.getSolver().support_positions = [];
                                this.handles.drive.getSolver().matrix_moments = [];
                                cross_process('restartButton_ClickedCallback',this.dialog,this.eventdata,this.handles); %restart Cross Solution
                                set( this.handles.removeToggle, 'State', 'Off' );
                                this.setMouseDefault();

                                return
                            end

                        end
            end
        end
    end
    
  %% Set and Get  
  methods      
            function this = setNodeInsertionAction(this)
                this.mouseAction = 'INSERTING_NODE';
            end

            function this = setMouseDefault(this)
                this.mouseAction = 'MOUSE_DEFAULT';
            end

            function this = setNodeDeletionAction(this)
                this.mouseAction = 'DELETING_NODE';
            end

            function mouseStatus = getMouseStatus(this)
                mouseStatus = this.mouseAction;
            end
     end
end