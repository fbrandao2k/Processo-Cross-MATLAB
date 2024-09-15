function varargout = cross_process(varargin)
% cross_process MATLAB code for cross_process.fig
%      cross_process, by itself, creates a new cross_process or raises the existing
%      singleton*.
%
%      H = cross_process returns the handle to a new cross_process or the handle to
%      the existing singleton*.
%
%      cross_process('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in cross_process.M with the given input arguments.
%
%      cross_process('Property','Value',...) creates a new cross_process or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cross_process_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cross_process_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cross_process

% Last Modified by GUIDE v2.5 19-Nov-2017 00:54:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cross_process_OpeningFcn, ...
                   'gui_OutputFcn',  @cross_process_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cross_process is made visible.
function cross_process_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cross_process (see VARARGIN)

%CrossDrive stores the CrossSolver and CrossDraw that are used
handles.drive = CrossDrive();

%Print the initial information and initialize the moments
handles.drive.getSolver().printModelInfo(1);
handles.drive.getSolver().initMoments();
handles.drive.getSolver().printResults(1);
handles.drive.getDraw().modelStepInfo(handles.uitable1,1);

%setting the table column and width
handles.drive.getDraw().adjustTableWidth(hObject, handles, 0)

%set the pop menu of the tolerances
set(handles.popupmenu4, 'Value', 2);

% Choose default command line output for cross_process
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(hObject,'Units','pixels');

%plot all axis
SetAllAxes(handles.drive.getDraw(), handles);

%add mouse events
handles.dragSupport = 0;
handles.dragArrows = 0;
handles.emouse = CrossMouseEvents(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = cross_process_OutputFcn(hObject, eventdata, handles)  %#ok<INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles) 
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_as_Callback(hObject, eventdata, handles)
% hObject    handle to save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supinitToggle_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to supinitToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supinitToggle_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to supinitToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%It changes the initial condition of the first support to clamped or
%supported
function supinitToggle_OnCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to supinitToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.supinitToggle, 'CData', imread('images/clamped.JPG') );
%handles.drive.getSolver().supinit = 1;
handles.drive.setSolverSupInit(1);

handles.drive.getSolver().restartCross();
handles.drive.getSolver().printResults(1);

handles.drive.getDraw().modelStepInfo(handles.uitable1,1);

set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');

SetAllAxes(handles.drive.getDraw(), handles);

guidata(hObject, handles);



% --------------------------------------------------------------------
%It changes the initial condition of the first support to clamped or
%supported
function supinitToggle_OffCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to supinitToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.supinitToggle, 'CData', imread('images/supported_begin.jpg') );
handles.drive.getSolver().supinit = 0;

handles.drive.getSolver().restartCross();
handles.drive.getSolver().printResults(1);

handles.drive.getDraw().modelStepInfo(handles.uitable1,1);

set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');

SetAllAxes(handles.drive.getDraw(), handles);



% --------------------------------------------------------------------
%Insert a new support to the beam
function insertToggle_OnCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to supinitToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.emouse.getMouseStatus(), 'DELETING_NODE') == 1
    set( handles.removeToggle, 'State', 'Off' );
end
set(handles.text3, 'String', 'Insira um novo apoio no interior da viga contínua.');

handles.emouse.setNodeInsertionAction();





% --------------------------------------------------------------------
%Insert new support Button off
function insertToggle_OffCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to supinitToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%txt = get(handles.text3, 'String');
 if strcmp( get(handles.text3, 'String'), 'O apoio interno nao pode ser inserido: tamanho inferior ao minimo permitido ou ponto fora da viga.')
     return
 end

 if handles.drive.getSolver().moreStepsToGo() == 1
            set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');
       else
            set(handles.text3, 'String','Solucao iterativa da viga contínua convergiu.');
 end

 handles.emouse.setMouseDefault();


% --------------------------------------------------------------------
%It changes the initial condition of the last support to clamped or
%supported
function supendToggle_OffCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to supendToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.supendToggle, 'CData', imread('images/clamped_end.jpg') );
handles.drive.getSolver().supend = 1;
handles.drive.getSolver().restartCross();
handles.drive.getSolver().printResults(1);
handles.drive.getDraw().modelStepInfo(handles.uitable1,1);
set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');
SetAllAxes(handles.drive.getDraw(), handles);


% --------------------------------------------------------------------
function supendToggle_OnCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to supendToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.supendToggle, 'CData', imread('images/supported_end.jpg') );
handles.drive.getSolver().supend = 0;
handles.drive.getSolver().restartCross();
handles.drive.getSolver().printResults(1);
handles.drive.getDraw().modelStepInfo(handles.uitable1,1);
set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');
SetAllAxes(handles.drive.getDraw(), handles);

% --------------------------------------------------------------------
function supendToggle_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to supendToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
% menu of the tolerances
function popupmenu4_Callback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

%gets the selected option
content = get(handles.popupmenu4,'Value');
handles.drive.getSolver().setMomentToler(content);
handles.drive.getSolver().restartCross();

handles.drive.getDraw().modelStepInfo(handles.uitable1,1);

set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');

handles.drive.getDraw().SetAllAxes(handles);


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%Restart the Cross Process
function restartButton_ClickedCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to restartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.drive.getSolver().restartCross();
%handles.drive.getSolver().printResults(1);
handles.drive.getDraw().modelStepInfo(handles.uitable1,1);
set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');
SetAllAxes(handles.drive.getDraw(), handles);


% --------------------------------------------------------------------
%Accomplishes one step of the Cross Process
function stepCrossButton_ClickedCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to stepCrossButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = handles.drive.getSolver().autoStepSolver();
if a > 0
    handles.drive.getSolver().printResults(1);
    handles.drive.getDraw().modelStepInfo(handles.uitable1,2);
    SetAllAxes(handles.drive.getDraw(), handles);  
    
end

if handles.drive.getSolver().moreStepsToGo() == 0
    set(handles.text3, 'String','Solucao iterativa da viga contínua convergiu.');
    m = get(handles.uitable1, 'Data');
    m = str2double(m);
    m = [m; handles.drive.getSolver.matrix_moments];
    C = num2cell(m);
    fun = @(x) sprintf( '%.*f', handles.drive.getSolver.decplc, x);
    D = cellfun(fun, C, 'UniformOutput',0);
    set(handles.uitable1,'Data',D);
end
        
 
% --------------------------------------------------------------------
% Complete Cross solution
function crossSolutionButton_ClickedCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to crossSolutionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.drive.getSolver().goThruSolver(handles.uitable1);
handles.drive.getSolver().printResults(1);

if handles.drive.getSolver().moreStepsToGo() == 1
        set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');
    else
        set(handles.text3, 'String','Solucao iterativa da viga contínua convergiu.');
end
    
SetAllAxes(handles.drive.getDraw(), handles);  


% --------------------------------------------------------------------
%Remove a support
function removeToggle_OnCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to removeToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(handles.emouse.getMouseStatus(), 'INSERTING_NODE') == 1
    set( handles.insertToggle, 'State', 'Off' );
end
set(handles.text3, 'String', 'Remova um apoio no interior da viga contínua.');

handles.emouse.setNodeDeletionAction();


% --------------------------------------------------------------------
%Toggle button to remove support turns off
function removeToggle_OffCallback(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to removeToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 if handles.drive.getSolver().moreStepsToGo() == 1
        set(handles.text3, 'String', 'Momentos não estão em equilíbrio.');
    else
        set(handles.text3, 'String','Solucao iterativa da viga contínua convergiu.');
 end
 handles.emouse.setMouseDefault();
 

        
% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('teste')
%setting the table column and width
try
    handles.drive.getDraw().adjustTableWidth(hObject, handles, 1)
catch
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles) %#ok<INUSL>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
cla(handles.axes1, 'reset');
cla(handles.axes2, 'reset');
cla(handles.axes3, 'reset');
cla(handles.axes4, 'reset');
delete(hObject);
clear all, clc; %#ok<CLALL,DUALC>
