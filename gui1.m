function varargout = gui1(varargin)
% GUI1 MATLAB code for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1

% Last Modified by GUIDE v2.5 17-May-2017 23:43:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
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

global equation maxIterations epsilon;
% End initialization code - DO NOT EDIT


% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)
clc
% Choose general command line output for gui1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get general command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in read.
function read_Callback(hObject, eventdata, handles)
% hObject    handle to read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid = fopen('equation.txt', 'r');
global equation
equation = fgets(fid);
set(handles.equation, 'String', equation);


% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
% hObject    handle to solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thechoice = get(handles.methods,'SelectedObject');
choice = get(thechoice,'String');
global equation maxIterations epsilon;
syms x xlower xupper xo;
equation = get(handles.equation, 'String');
maxIterations = str2num(get(handles.maxIterations, 'String'));
epsilon = str2num(get(handles.epsilon, 'String'));
switch choice
    case char('General-Method')
        xlower = str2num(get(handles.xl, 'String'));
        xupper = str2num(get(handles.xu, 'String'));
    case char('Bisection')
        xlower = str2num(get(handles.xl, 'String'));
        xupper = str2num(get(handles.xu, 'String'));
        %function [ isValid, xl, xu, root, totalTime, itr_count ,errors ] = Bisection( equation, max_itr, epsilon, xlower, xupper )
        [ isValid, xl, xu, root, totalTime, itr_count, errors ] = Bisection(equation, maxIterations, epsilon, xlower, xupper);
        if(isValid == 1) 
            set(handles.time, 'String', totalTime);
            set(handles.answer, 'String', root(length(root)));
            set(handles.numIterations, 'String', itr_count);
            root(length(root) + 1) =  root(length(root));
            errors(length(errors) + 1) = errors(length(errors));
            answer = zeros(length(xu),4);
            answer(:,1) = xl;
            answer(:,2) = xu;
            answer(:,3) = root;
            answer(:,4) = errors;
            columns = {'xl' , 'xu' ,'root','errors'};
            set(handles.table,'ColumnName' ,columns);
            set(handles.table,'Data' ,answer);
            ezplot(equation);zoom on
            xlabel('X');
            ylabel('f(X)');
        else
           set(handles.time, 'String', '0');
           set(handles.answer, 'String', 'Invalid');
           set(handles.iterations, 'String', '0');       
        end    
    case char('False-Position')
        xlower = str2num(get(handles.xl, 'String'));
        xupper = str2num(get(handles.xu, 'String'));
        %function [ isValid, xl, xu, root, totalTime, itr_count ,errors ] = falseposition( equation, max_itr, epsilon, xlower, xupper )
        [ isValid, xl, xu, root, totalTime, itr_count, errors ] = Falseposition(equation, maxIterations, epsilon, xlower, xupper);
        if(isValid == 1) 
            set(handles.time, 'String', totalTime);
            set(handles.answer, 'String', root(length(root)));
            set(handles.numIterations, 'String', itr_count);
            root(length(root) + 1) =  root(length(root));
            errors(length(errors) + 1) = errors(length(errors));
            answer = zeros(length(xu),4);
            answer(:,1) = xl;
            answer(:,2) = xu;
            answer(:,3) = root;
            answer(:,4) = errors;
            columns = {'xl' , 'xu' ,'root','errors'};
            set(handles.table,'ColumnName' ,columns);
            set(handles.table,'Data' ,answer);
            ezplot(equation);zoom on
            xlabel('X');
            ylabel('f(X)');
        else
           set(handles.time, 'String', '0');
           set(handles.answer, 'String', 'Invalid');
           set(handles.numIterations, 'String', '0');       
        end
    case char('Fixed-Point')
        xo = str2num(get(handles.xo, 'String'));
        %function [ root ,totalTime,iteration,isDiv, errors ] = FixedPoint( g,max_itr,default_epsilon,initx )
        [ root ,totalTime,iteration,isDiv, errors ] = FixedPoint( equation,maxIterations,epsilon,xo );
        set(handles.time, 'String', totalTime);
        set(handles.answer, 'String', root(length(root)));
        set(handles.numIterations, 'String', iteration);
        root(length(root) + 1) =  root(length(root));
        errors(length(errors) + 1) = errors(length(errors));
        answer = zeros(length(root),4);
        answer(:,1) = root;
        answer(:,2) = errors;
        columns = {'root','errors'};
        set(handles.table,'ColumnName' ,columns);
        set(handles.table,'Data' ,answer);
        ezplot(diff(equation));zoom on
        xlabel('X');
        ylabel('f(X)');
    case char('Newton-Raphson')
        xo = str2num(get(handles.xo, 'String'));
        %function [invalid, root, total_time, error, itr_count] = Newton(initial_guess, max_iteration, epsilon, equation)
        [isValid, root, totalTime, errors, itr_count] = Newton(xo, maxIterations, epsilon, equation);
        if(isValid == 1) 
            set(handles.time, 'String', totalTime);
            set(handles.answer, 'String', root(length(root)));
            set(handles.numIterations, 'String', itr_count);
            root(length(root) + 1) =  root(length(root));
            errors(length(errors) + 1) = errors(length(errors));
            answer = zeros(length(root),4);
            answer(:,1) = root;
            answer(:,2) = errors;
            columns = {'root','errors'};
            set(handles.table,'ColumnName' ,columns);
            set(handles.table,'Data' ,answer);
            ezplot(diff(equation));zoom on
            xlabel('X');
            ylabel('f(X)');
        else
            set(handles.time, 'String', '0');
            set(handles.answer, 'String', 'Invalid');
            set(handles.numIterations, 'String', '0');       
        end
    case char('Secant')
        xlower = str2num(get(handles.xl, 'String'));
        xupper = str2num(get(handles.xu, 'String'));
        %function [ invalid, root, totalTime, errors, itr_count ] = Secant( equation, max_itr, epsilon, intial_guess0, intial_guess1 )
        [ invalid, root, totalTime, errors, itr_count ] = Secant( equation, maxIterations, epsilon, xlower, xupper);
        if(invalid == 0)
            set(handles.time, 'String', totalTime);
            set(handles.answer, 'String', root(length(root)));
            set(handles.numIterations, 'String', itr_count);
            answer = zeros(length(root),2);
            answer(:,1) = root;
            answer(:,2) = errors;
            columns = {'root','errors'};
            set(handles.table,'ColumnName' ,columns);
            set(handles.table,'Data' ,answer);
            ezplot(diff(equation));zoom on
            xlabel('X');
            ylabel('f(X)');
        else
           set(handles.time, 'String', '0');
           set(handles.answer, 'String', 'Invalid');
           set(handles.numIterations, 'String', '0');
        end
    case char('Bierge-Vieta')
        xo = str2num(get(handles.xo, 'String'));
        %function [root, errors, itr_count, TotalTime] = BirgeVieta(equation, intial_guess, max_itr, default_eplison)
        [ root, errors, itr_count, totalTime ] = BirgeVieta(equation, xo, maxIterations, epsilon);
        set(handles.time, 'String', totalTime);
        set(handles.answer, 'String', root(length(root)));
        set(handles.numIterations, 'String', itr_count);
        root(length(root) + 1) =  root(length(root));
        errors(length(errors) + 1) = errors(length(errors));
        answer = zeros(length(root),4);
        answer(:,1) = root;
        answer(:,2) = errors;
        columns = {'root','errors'};
        set(handles.table,'ColumnName' ,columns);
        set(handles.table,'Data' ,answer);
        ezplot(diff(equation));zoom on
        xlabel('X');
        ylabel('f(X)');
end



% --- Executes when selected object is changed in methods.
function methods_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in methods 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
thechoice = get(handles.methods,'SelectedObject');
choice = get(thechoice,'String');
syms xl xu xo;
switch choice
    case char('General-Method')
        set(handles.xl, 'Enable', 'on');
        set(handles.xu, 'Enable', 'on');
        set(handles.xo, 'Enable', 'on');
    case char('Bisection')
        set(handles.xl, 'Enable', 'on');
        set(handles.xu, 'Enable', 'on');
        set(handles.xo, 'Enable', 'off');
    case char('False-Position')
        set(handles.xl, 'Enable', 'on');
        set(handles.xu, 'Enable', 'on');
        set(handles.xo, 'Enable', 'off');
    case char('Fixed-Point')
        set(handles.xl, 'Enable', 'off');
        set(handles.xu, 'Enable', 'off');
        set(handles.xo, 'Enable', 'on');
    case char('Newton-Raphson')
        set(handles.xl, 'Enable', 'off');
        set(handles.xu, 'Enable', 'off');
        set(handles.xo, 'Enable', 'on');
    case char('Secant')
        set(handles.xl, 'Enable', 'on');
        set(handles.xu, 'Enable', 'on');
        set(handles.xo, 'Enable', 'off');
    case char('Bierge-Vieta')
        set(handles.xl, 'Enable', 'off');
        set(handles.xu, 'Enable', 'off');
        set(handles.xo, 'Enable', 'on');
end



% --- Executes on button press in solveAll.
function solveAll_Callback(hObject, eventdata, handles)
% hObject    handle to solveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global equation;
setappdata(0,'equation',equation);
closereq;
gui11();


function equation_Callback(hObject, eventdata, handles)
% hObject    handle to equation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of equation as text
%        str2double(get(hObject,'String')) returns contents of equation as a double


% --- Executes during object creation, after setting all properties.
function equation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to equation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xl_Callback(hObject, eventdata, handles)
% hObject    handle to xl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xl as text
%        str2double(get(hObject,'String')) returns contents of xl as a double


% --- Executes during object creation, after setting all properties.
function xl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxIterations_Callback(hObject, eventdata, handles)
% hObject    handle to maxIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIterations as text
%        str2double(get(hObject,'String')) returns contents of maxIterations as a double


% --- Executes during object creation, after setting all properties.
function maxIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in general.
function general_Callback(hObject, eventdata, handles)
% hObject    handle to general (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of general


% --- Executes on button press in bisection.
function bisection_Callback(hObject, eventdata, handles)
% hObject    handle to bisection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bisection


% --- Executes on button press in falsePosition.
function falsePosition_Callback(hObject, eventdata, handles)
% hObject    handle to falsePosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of falsePosition


% --- Executes on button press in fixedPoint.
function fixedPoint_Callback(hObject, eventdata, handles)
% hObject    handle to fixedPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixedPoint


% --- Executes on button press in newtonRaphson.
function newtonRaphson_Callback(hObject, eventdata, handles)
% hObject    handle to newtonRaphson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of newtonRaphson


% --- Executes on button press in secant.
function secant_Callback(hObject, eventdata, handles)
% hObject    handle to secant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of secant


% --- Executes on button press in biergeVieta.
function biergeVieta_Callback(hObject, eventdata, handles)
% hObject    handle to biergeVieta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of biergeVieta


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function xo_Callback(hObject, eventdata, handles)
% hObject    handle to xo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xo as text
%        str2double(get(hObject,'String')) returns contents of xo as a double


% --- Executes during object creation, after setting all properties.
function xo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xu_Callback(hObject, eventdata, handles)
% hObject    handle to xu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xu as text
%        str2double(get(hObject,'String')) returns contents of xu as a double


% --- Executes during object creation, after setting all properties.
function xu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsilon_Callback(hObject, eventdata, handles)
% hObject    handle to epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsilon as text
%        str2double(get(hObject,'String')) returns contents of epsilon as a double


% --- Executes during object creation, after setting all properties.
function epsilon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numIterations_Callback(hObject, eventdata, handles)
% hObject    handle to numIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numIterations as text
%        str2double(get(hObject,'String')) returns contents of numIterations as a double


% --- Executes during object creation, after setting all properties.
function numIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function answer_Callback(hObject, eventdata, handles)
% hObject    handle to answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of answer as text
%        str2double(get(hObject,'String')) returns contents of answer as a double


% --- Executes during object creation, after setting all properties.
function answer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
