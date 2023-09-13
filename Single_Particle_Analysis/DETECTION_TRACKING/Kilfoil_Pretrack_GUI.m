function varargout = Kilfoil_Pretrack_GUI(varargin)
% KILFOIL_PRETRACK_GUI MATLAB code for Kilfoil_Pretrack_GUI.fig
%      KILFOIL_PRETRACK_GUI, by itself, creates a new KILFOIL_PRETRACK_GUI or raises the existing
%      singleton*.
%
%      H = KILFOIL_PRETRACK_GUI returns the handle to a new KILFOIL_PRETRACK_GUI or the handle to
%      the existing singleton*.
%
%      KILFOIL_PRETRACK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KILFOIL_PRETRACK_GUI.M with the given input arguments.
%
%      KILFOIL_PRETRACK_GUI('Property','Value',...) creates a new KILFOIL_PRETRACK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Kilfoil_Pretrack_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Kilfoil_Pretrack_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Kilfoil_Pretrack_GUI

% Last Modified by GUIDE v2.5 25-Apr-2011 14:08:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Kilfoil_Pretrack_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Kilfoil_Pretrack_GUI_OutputFcn, ...
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


% --- Executes just before Kilfoil_Pretrack_GUI is made visible.
function Kilfoil_Pretrack_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Kilfoil_Pretrack_GUI (see VARARGIN)

% Choose default command line output for Kilfoil_Pretrack_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Create the subplots
tifName = 'e.tif';
tifInfo = imfinfo(tifName);

im = imread(tifName,1);
axes(handles.ImgAxis);
imagesc(im); colormap gray;
axis equal

handles.basepath = pwd;
set(handles.BasepathEditText,'String',pwd);

% Determine the slider ranges and steps
numFrames = length(tifInfo);
if numFrames == 1
    maxfilestep = 1;
    minfilestep = 0;
else
    maxfilestep = 10/(numFrames-1);
    minfilestep = 1/(numFrames-1);
end
    
% % Create the subplots
% im = imread('fov1/fov1_0001.tif');
% axes(handles.ImgAxis);
% imagesc(im); colormap gray;
% 
% handles.basepath = pwd;
% set(handles.BasepathEditText,'String',pwd);
% 
% % Determine the slider ranges and steps
% numFrames = length(dir('fov1/*.tif'));
% if numFrames == 1
%     maxfilestep = 1;
%     minfilestep = 0;
% else
%     maxfilestep = 10/(numFrames-1);
%     minfilestep = 1/(numFrames-1);
% end

maxint = double(max(max(im)));
maxsz = max(size(im));
maxfeatsize = floor(0.1*maxsz);
maxintInt = floor((maxfeatsize/4)*maxint);
maxRg = maxfeatsize;
minfeatstep = 1/(maxfeatsize-1);
maxfeatstep = 5/(maxfeatsize-1);
% minRgstep = 0.1/(maxfeatsize-1);
% maxRgstep = 1/(maxfeatsize-1);
minIntstep = 10/(maxintInt);
maxIntstep = 100/(maxintInt);


set(handles.FeatSizeSlider,'Max',maxfeatsize,'SliderStep',...
    [minfeatstep maxfeatstep]);
set(handles.RgSlider,'Max',maxRg,'SliderStep',[minfeatstep maxfeatstep],'Value',...
    maxRg);
set(handles.RgEdit,'String',maxRg);
set(handles.IntIntensitySlider,'Max',maxintInt,'SliderStep',...
    [minIntstep maxIntstep]);
set(handles.MasscutSlider,'Max',maxint,'SliderStep',...
    [10/maxint 100/maxint]);
set(handles.FrameSlider,'Max',numFrames,'SliderStep',[minfilestep maxfilestep]);

handles.im = im;
update_features(hObject,handles);

% UIWAIT makes Kilfoil_Pretrack_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Kilfoil_Pretrack_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

featsize = get(handles.FeatSizeSlider,'Value');
barint = get(handles.IntIntensitySlider,'Value');
barrg = get(handles.RgSlider,'Value');
barcc = get(handles.EccSlider,'Value');
IdivRg = 0;
fovn = 1;
masscut = get(handles.MasscutSlider,'Value');
Imin = 0;
field = 2;

handles.output = [featsize barint barrg barcc IdivRg fovn masscut Imin field];

varargout{1} = handles.output;



function BasepathEditText_Callback(hObject, eventdata, handles)
% hObject    handle to BasepathEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BasepathEditText as text
%        str2double(get(hObject,'String')) returns contents of BasepathEditText as a double


% --- Executes during object creation, after setting all properties.
function BasepathEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BasepathEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function FeatSizeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FeatSizeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

currval = round(get(hObject,'Value'));
set(handles.FeatSizeSlider,'Value',currval);
set(handles.FeatSizeEdit,'String',currval);
% update_features(hObject,handles);


% --- Executes during object creation, after setting all properties.
function FeatSizeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FeatSizeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function FeatSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FeatSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FeatSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of FeatSizeEdit as a double


% --- Executes during object creation, after setting all properties.
function FeatSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FeatSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function IntIntensitySlider_Callback(hObject, eventdata, handles)
% hObject    handle to IntIntensitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

currval = round(get(hObject,'Value'));
set(hObject,'Value',currval);
set(handles.IntIntensityEdit,'String',currval);
% update_features(hObject,handles);

% --- Executes during object creation, after setting all properties.
function IntIntensitySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntIntensitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function IntIntensityEdit_Callback(hObject, eventdata, handles)
% hObject    handle to IntIntensityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntIntensityEdit as text
%        str2double(get(hObject,'String')) returns contents of IntIntensityEdit as a double


% --- Executes during object creation, after setting all properties.
function IntIntensityEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntIntensityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function RgSlider_Callback(hObject, eventdata, handles)
% hObject    handle to RgSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
currval = round(get(hObject,'Value'));
set(hObject,'Value',currval);
set(handles.RgEdit,'String',currval);
% update_features(hObject,handles);


% --- Executes during object creation, after setting all properties.
function RgSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RgSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function RgEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RgEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RgEdit as text
%        str2double(get(hObject,'String')) returns contents of RgEdit as a double


% --- Executes during object creation, after setting all properties.
function RgEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RgEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function EccSlider_Callback(hObject, eventdata, handles)
% hObject    handle to EccSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
currval =get(hObject,'Value');
currval = sprintf('%0.2f',currval);
currval = str2double(currval);
set(hObject,'Value',currval);
set(handles.EccEdit,'String',currval);
% update_features(hObject,handles);


% --- Executes during object creation, after setting all properties.
function EccSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EccSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function EccEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EccEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EccEdit as text
%        str2double(get(hObject,'String')) returns contents of EccEdit as a double


% --- Executes during object creation, after setting all properties.
function EccEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EccEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function MasscutSlider_Callback(hObject, eventdata, handles)
% hObject    handle to MasscutSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

currval = round(get(hObject,'Value'));
set(hObject,'Value',currval);
set(handles.MasscutEdit,'String',currval);
% update_features(hObject,handles);

% --- Executes during object creation, after setting all properties.
function MasscutSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MasscutSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function MasscutEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MasscutEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MasscutEdit as text
%        str2double(get(hObject,'String')) returns contents of MasscutEdit as a double


% --- Executes during object creation, after setting all properties.
function MasscutEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MasscutEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function FrameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

currval = round(get(hObject,'Value'));
set(handles.FrameSlider,'Value',currval);
set(handles.FrameEdit,'String',currval);

% Load the new image
tifName = 'e.tif';
handles.im = imread(tifName,currval);
guidata(hObject,handles);
% update_features(hObject,handles);



% --- Executes during object creation, after setting all properties.
function FrameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function FrameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameEdit as text
%        str2double(get(hObject,'String')) returns contents of FrameEdit as a double


% --- Executes during object creation, after setting all properties.
function FrameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function FeatSizeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FeatSizeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in PathPushButton.
function PathPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to PathPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FeaturesPushButton.
function FeaturesPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to FeaturesPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1;
    update_features(hObject,handles);
    toggle_buttons(handles,get(hObject,'Tag'));
    % Plot the Image
    axes(handles.ImgAxis);
    im = handles.im;
    M = handles.MT;
    Mrej = handles.Mrej;
    featsize = get(handles.FeatSizeSlider,'Value');
    imagesc(im),colormap gray;
    hold on
    % Making a circle the size of the feature around each feature.
    theta = 0:0.001:2*pi;
    for c = 1:length(M(:,1))
        cx = M(c,1) + featsize*cos(theta)*2;
        cy = M(c,2) + featsize*sin(theta)*2;
        plot(cx,cy,'g-','linewidth',1.5)
    end
    if( ~isempty(Mrej)>0 )
        plot( Mrej(:,1), Mrej(:,2), 'r.' );
    end
    axis equal;
    hold off
end

% --- Executes on button press in RawImgPushButton.
function RawImgPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to RawImgPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 1;
    update_features(hObject,handles);
    toggle_buttons(handles,get(hObject,'Tag'));
    % Plot the Image
    axes(handles.ImgAxis);
    im = handles.im;
    imagesc(im); colormap gray;
    axis equal
end



% --- Executes on button press in FilteredImgPushButton.
function FilteredImgPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to FilteredImgPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1;
    update_features(hObject,handles);
    toggle_buttons(handles,get(hObject,'Tag'));
    % Plot the image
    im = handles.im;
    featsize = get(handles.FeatSizeSlider,'Value');
    b = bpass(im,1,featsize);
    axes(handles.ImgAxis);
    imagesc(b); colormap gray
    axis equal
end



% --- Executes on button press in IntEccPushButton.
function IntEccPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to IntEccPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1;
    update_features(hObject,handles);
    toggle_buttons(handles,get(hObject,'Tag'));
    axes(handles.PlotAxis);
    MT = handles.MT;
    plot(MT(:,5),MT(:,3),'ko'); logy;
    xlabel('Eccentricity');
    ylabel('Intensity');
end

% --- Executes on button press in IntRgPushButton.
function IntRgPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to IntRgPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1;
    update_features(hObject,handles);
    toggle_buttons(handles,get(hObject,'Tag'));
    axes(handles.PlotAxis);
    MT = handles.MT;
    plot(MT(:,4),MT(:,3),'ko');
    xlabel('Radius of Gyration'); logy;
    ylabel('Intensity');
end

% --- Executes on button press in EccRgPushButton.
function EccRgPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to EccRgPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1;
    update_features(hObject,handles);
    toggle_buttons(handles,get(hObject,'Tag'));
    axes(handles.PlotAxis);
    MT = handles.MT;
    plot(MT(:,5),MT(:,4),'ko');
    xlabel('Eccentricity');
    ylabel('Radius of Gyration');
end


function toggle_buttons(handles,caller)
toggleStringsImages = {'RawImgPushButton','FilteredImgPushButton',...
    'FeaturesPushButton'};
toggleStringsPlots = {'IntRgPushButton','EccRgPushButton',...
    'IntEccPushButton'};
if max(ismember(toggleStringsImages,caller))==1
    swapStateStrings = toggleStringsImages(~ismember(toggleStringsImages,caller));
    for i = swapStateStrings
       eval(strcat('set(handles.',char(i),',''Value'',0)'));
    end
else
    swapStateStrings = toggleStringsPlots(~ismember(toggleStringsPlots,caller));
    for i = swapStateStrings
       eval(strcat('set(handles.',char(i),',''Value'',0)'));
    end
end

function update_features(hObject, handles)
    basepath = strcat(handles.basepath,'/');
    featsize = get(handles.FeatSizeSlider,'Value');
    barint = get(handles.IntIntensitySlider,'Value');
    barrg = get(handles.RgSlider,'Value');
    barcc = get(handles.EccSlider,'Value');
    IdivRg = 0;
    fovn = 1;
    frame = get(handles.FrameSlider,'Value');
%     masscut = 
%     Imin = 0;
    Imin = get(handles.MasscutSlider,'Value');
    masscut = 0;
    field = 2;
    [M2,MT,Mrej] = mpretrack_init(basepath, featsize, barint, barrg, barcc,...
        IdivRg, fovn, frame, masscut, Imin, field);
    handles.M2 = M2;
    handles.MT = MT;
    handles.Mrej = Mrej;
    guidata(hObject,handles);
