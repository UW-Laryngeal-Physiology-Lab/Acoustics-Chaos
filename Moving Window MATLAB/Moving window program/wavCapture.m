   function varargout = wavCapture(varargin)
% WAVCAPTURE MATLAB code for wavCapture.fig
%      WAVCAPTURE, by itself, creates a new WAVCAPTURE or raises the existing
%      singleton*.
%
%      H = WAVCAPTURE returns the handle to a new WAVCAPTURE or the handle to
%      the existing singleton*.
%
%      WAVCAPTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVCAPTURE.M with the given input arguments.
%
%      WAVCAPTURE('Property','Value',...) creates a new WAVCAPTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wavCapture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wavCapture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wavCapture

% Last Modified by GUIDE v2.5 06-May-2013 20:18:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wavCapture_OpeningFcn, ...
                   'gui_OutputFcn',  @wavCapture_OutputFcn, ...
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


% --- Executes just before wavCapture is made visible.
function wavCapture_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wavCapture (see VARARGIN)

% Choose default command line output for wavCapture
handles.output = hObject;

% initialize parameters. Time unit is SECONDS
set(handles.editTimeStep,'string','0.250');     % capture a slice every timeStep time.
set(handles.editSliceWidth,'string','0.500');   % the slice length for each slice.
handles.settingIsCorrect = 0;
handles.nSlices = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wavCapture wait for user response (see UIRESUME)
% uiwait(handles.figureWavCapture);


% --- Outputs from this function are returned to the command line.
function varargout = wavCapture_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtoolOpenFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolOpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.pr=procedure;   % reinitialize handles.pr
% if(procedureOpen(handles.pr,f.path))
%     handles.HRMpath=f.path;
%     handles.currentSwallow=[];
%     handles.whichAxes=0;
%     handles.iclick=0;
%     procedureDisplay(handles.pr,handles.axesProcedureView);
%     set(handles.listboxMeasureRegions,'String','Measure Region');
%     set(handles.textSwallowLabel,'String',f.path);
% end

% load the .wav file
f=file.Get('*.wav','Open Procedure File',[]);
if ~f.exist, return; end
handles.wav = wav(f);
fprintf(1,'Open the following .wav file successfully:\n%s\n', f.fullname);

% plot audio waveform
plot(handles.axesAudio, handles.wav.time, handles.wav.data);
set(handles.axesAudio,'xlim', [0, handles.wav.length]);
set(handles.axesAudio,'ylim', [handles.wav.vmin, handles.wav.vmax]);

% print the wav file information
info = handles.wav.readInfo.fmt;
s1 = ['nChannels = ', num2str(info.nChannels)];
s2 = ['nSamplesPerSec = ', num2str(info.nSamplesPerSec)];
s3 = ['nBitsPerSample = ', num2str(info.nBitsPerSample)];
s4 = ['totalLength[Sec] = ', num2str(handles.wav.length)];
str = sprintf('\n%s\n\n%s\n\n%s\n\n%s\n\n',s1,s2,s3,s4);
set(handles.textAudioInfo,'string',str);

handles.nSlices = 0;
guidata(hObject,handles);


% --------------------------------------------------------------------
function uipushtoolSaveFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolSaveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'wav'), return; end
% check validity of settings
if handles.nSlices == 0
    pushbuttonOK_Callback(handles.pushbuttonOK, eventdata, handles);
    handles=guidata(gcf);
    if ~handles.settingIsCorrect, return; end
end

% construct the new folder name in which the wav slices will be saved
str = [handles.wav.wavfile.name(1:end-4) ' Width=' num2str(handles.sliceWidth) ' Sec'];
folderName = fullfile(handles.wav.wavfile.path,str);
warning off MATLAB:mkdir:DirectoryExists
mkdir(folderName);
% [msg,msgid] = lastwarn   % use lastwarn to display warning message id

% save audio slices files
for i = 1: handles.nSlices
    set(handles.sliderAudio,'value',i);
    updataDrawing(handles);
    sw = getappdata(handles.axesAudioSlice,'subwav');
    fName = [num2str(sw.time(1), '%.3f') ' S' '.wav'];
    wavwrite(sw.data, handles.wav.sampleRate, handles.wav.nBits, ...
                fullfile(folderName, fName));
    pause(0.05);
end


% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.settingIsCorrect = 0;
handles.timeStep = str2double(get(handles.editTimeStep, 'string'));
handles.sliceWidth = str2double(get(handles.editSliceWidth, 'string'));

if isfield(handles,'wav') %isfield
    % get the total number of slices
    n = (handles.wav.length - handles.sliceWidth) / handles.timeStep;
    handles.nSlices = floor(n) + 1;
    if handles.nSlices <=0  % incorrect settings
        fprintf(2,'\n\n  Incorrect settings! \n\n');
        return; 
    end
    
    % updata the slider value
    sliderMin = 1;
    sliderMax = handles.nSlices;
    set(handles.sliderAudio,'min',sliderMin);
    set(handles.sliderAudio,'max',sliderMax);
    set(handles.sliderAudio,'sliderstep', [1,1]/(sliderMax-sliderMin));
    set(handles.sliderAudio,'value',sliderMin);
    updataDrawing(handles);
end

handles.settingIsCorrect = 1;
guidata(hObject,handles);



% --- Executes on slider movement.
function sliderAudio_Callback(hObject, eventdata, handles)
% hObject    handle to sliderAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

i = get(handles.sliderAudio,'value');
% stop the slider from becoming non-integer values
set(handles.sliderAudio,'value',round(i));
disp(round(i));
updataDrawing(handles);


function updataDrawing(handles)
% updata 'axesAudio' and 'axesAudioSlice' drawings with the slider value.

% plot audio waveform slice
ind = get(handles.sliderAudio,'value');
tStart = handles.timeStep * (ind -1);
tEnd = tStart + handles.sliceWidth;
sw = subwav(handles.wav, tStart, tEnd);
% backup the data to axes
setappdata(handles.axesAudioSlice, 'subwav',sw);
plot(handles.axesAudioSlice, sw.time, sw.data);
set(handles.axesAudioSlice,'xlim', [sw.time(1), sw.time(end)]);

% add a rectangle in the axesAudio, 'sliceRegion', which is the audio slcie
% region from tStart to tEnd, filled with color.
hsliceRegion = getappdata(handles.axesAudio,'hsliceRegion');
delete(hsliceRegion); % delete the old rectangle if it exists.
    % define the filled rectangle
    %   point 1           point 4
    %   point 2           point 3
xx = [tStart, tStart, tEnd, tEnd];
yy = [handles.wav.vmax, handles.wav.vmin, handles.wav.vmin, handles.wav.vmax];
set(gcf,'CurrentAxes', handles.axesAudio);
hold on
hfill=fill(xx,yy,'y');
uistack(hfill,'bottom');    % set layer to bottom
setappdata(handles.axesAudio,'hsliceRegion',hfill);
hold off









% --- Executes during object creation, after setting all properties.
function sliderAudio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editTimeStep_Callback(hObject, eventdata, handles)
% hObject    handle to editTimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTimeStep as text
%        str2double(get(hObject,'String')) returns contents of editTimeStep as a double


% --- Executes during object creation, after setting all properties.
function editTimeStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSliceWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editSliceWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSliceWidth as text
%        str2double(get(hObject,'String')) returns contents of editSliceWidth as a double



% --- Executes during object creation, after setting all properties.
function editSliceWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSliceWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtoolSpeaker_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolSpeaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% play the wav file
subwav = getappdata(handles.axesAudioSlice,'subwav');
sampleRate = handles.wav.sampleRate;
sound(subwav.data, sampleRate); 


% --------------------------------------------------------------------
function uipushtoolHelp_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% print the 'help' information

s1 = 'Program developed in Mar 6 2013, voice lab, UW-Madison';
s2 = 'How to use:';
s3 = '1. open an .wav type audio file';
s4 = '2. set the time step and slice width';
s5 = '3. examine the audio slices by click the slider';
s6 = '4. click SAVE to save all these audio slices';
s7 = '5. click SPEAKER to play the current audio slice'

str = sprintf('%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n',s1,s2,s3,s4,s5,s6,s7);

helpdlg(str,'About the Program');

