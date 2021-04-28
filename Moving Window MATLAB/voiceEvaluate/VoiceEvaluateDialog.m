function varargout = VoiceEvaluateDialog(varargin)
% VOICEEVALUATEDIALOG MATLAB code for VoiceEvaluateDialog.fig
%      VOICEEVALUATEDIALOG, by itself, creates a new VOICEEVALUATEDIALOG or raises the existing
%      singleton*.
%
%      H = VOICEEVALUATEDIALOG returns the handle to a new VOICEEVALUATEDIALOG or the handle to
%      the existing singleton*.
%
%      VOICEEVALUATEDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOICEEVALUATEDIALOG.M with the given input arguments.
%
%      VOICEEVALUATEDIALOG('Property','Value',...) creates a new VOICEEVALUATEDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VoiceEvaluateDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VoiceEvaluateDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VoiceEvaluateDialog

% Last Modified by GUIDE v2.5 24-Sep-2015 15:13:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VoiceEvaluateDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @VoiceEvaluateDialog_OutputFcn, ...
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


% --- Executes just before VoiceEvaluateDialog is made visible.
function VoiceEvaluateDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VoiceEvaluateDialog (see VARARGIN)

% Choose default command line output for VoiceEvaluateDialog
handles.output = hObject;

iniBars_Callback( hObject, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VoiceEvaluateDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VoiceEvaluateDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FileListbox.
function FileListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileListbox
idxClickSel = get(hObject,'value');
if idxClickSel ~= handles.fileInfo.idxCurrentFile && idxClickSel~=1 && idxClickSel ~=2;
    handles.fileInfo.currentFileName = handles.fileInfo.allFileNames(idxClickSel);
    handles.fileInfo.idxCurrentFile = idxClickSel;
    
    set(handles.CurrentFileEdit,'string',handles.fileInfo.allFileNames(idxClickSel));
    guidata(hObject,handles);
end
iniBars_Callback(hObject,handles);

% --- Executes during object creation, after setting all properties.
function FileListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selDirBtn.
function selDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldDir = get(handles.CurrentFolderEdit,'string');

if ~isfield(handles,'fileInfo')
    return;
else
    if ~isfield(handles.fileInfo,'outputExcelFileName')
        return;
    end
end
fileInfo.outputExcelFileName = handles.fileInfo.outputExcelFileName;

[currentFileName,fileFolder] = uigetfile('*.wav','Select a wav file');
[fileFolder,currentFileName,extFileName] = fileparts(fullfile(fileFolder,currentFileName));

dirOutput=dir(fullfile(fileFolder,'*.wav'));
allFileNames={dirOutput.name};
idxCurrentFile = 1;
for n = 1 : length(allFileNames)
    if strcmp(allFileNames{n},[currentFileName,extFileName])
        idxCurrentFile = n;
        break;
    end
end

set(handles.CurrentFolderEdit,'string',fileFolder);
set(handles.CurrentFileEdit,'string',[currentFileName,extFileName]);
set(handles.FileListbox,'string',allFileNames);
set(handles.FileListbox,'value',idxCurrentFile);

fileInfo.currentFileName = currentFileName;
fileInfo.fileFolder = fileFolder;
fileInfo.extFileName = extFileName;
fileInfo.allFileNames = allFileNames;
fileInfo.idxCurrentFile = idxCurrentFile;

handles.fileInfo = fileInfo;

if ~strcmp(oldDir,fileFolder)
    handles.cellEvaluateResult = [];
    handles.cellEvaluateResult{1,1} = 'File Name';
    handles.cellEvaluateResult{1,2} = 'Overall Severity';
    handles.cellEvaluateResult{1,3} = 'Roughness';
    handles.cellEvaluateResult{1,4} = 'Breathiness';
    handles.cellEvaluateResult{1,5} = 'Strain';
    handles.cellEvaluateResult{1,6} = 'Pitch';
    handles.cellEvaluateResult{1,7} = 'Loundness';
    handles.cellEvaluateResult{1,8} = 'Pitch LH';
    handles.cellEvaluateResult{1,9} = 'Loundness LH';
end

guidata(hObject,handles);

iniBars_Callback(hObject,handles);
%--------------------------------------------------------------------------



function CurrentFolderEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentFolderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentFolderEdit as text
%        str2double(get(hObject,'String')) returns contents of CurrentFolderEdit as a double

%--------------------------------------------------------------------------



% --- Executes during object creation, after setting all properties.
function CurrentFolderEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentFolderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------



function CurrentFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentFileEdit as text
%        str2double(get(hObject,'String')) returns contents of CurrentFileEdit as a double
%--------------------------------------------------------------------------




% --- Executes during object creation, after setting all properties.
function CurrentFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------

% --- Executes on button press in PreFileBtn.
function PreFileBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PreFileBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = handles.fileInfo.idxCurrentFile;
if idx <= 3
    return;
end
idx = idx - 1;
handles.fileInfo.currentFileName = handles.fileInfo.allFileNames(idx);
handles.fileInfo.idxCurrentFile = idx;
  
set(handles.CurrentFileEdit,'string',handles.fileInfo.allFileNames(idx));
set(handles.FileListbox,'value',idx);
guidata(hObject,handles);

iniBars_Callback(hObject,handles);
%--------------------------------------------------------------------------


% --- Executes on button press in NextFileBtn.
function NextFileBtn_Callback(hObject, eventdata, handles)
% hObject    handle to NextFileBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = handles.fileInfo.idxCurrentFile;
if idx == length(handles.fileInfo.allFileNames)
    return;
end
idx = idx + 1;
handles.fileInfo.currentFileName = handles.fileInfo.allFileNames(idx);
handles.fileInfo.idxCurrentFile = idx;
  
set(handles.CurrentFileEdit,'string',handles.fileInfo.allFileNames(idx));
set(handles.FileListbox,'value',idx);
guidata(hObject,handles);

iniBars_Callback(hObject,handles);
%--------------------------------------------------------------------------

% --- Executes on button press in SaveExcelBtn.
function SaveExcelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveExcelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'fileInfo')
    return;
else
    if ~isfield(handles.fileInfo,'outputExcelFileName')
        return;
    end
end

xlsFileName = handles.fileInfo.outputExcelFileName;

if exist(xlsFileName,'file')
    delete(xlsFileName);
end

xlsSheetName = 'sheet1';
xlswrite(xlsFileName,handles.cellEvaluateResult);%,xlsSheetName);

sizeCell = size(handles.cellEvaluateResult);
rowSum = sizeCell(1);
for n = 2:rowSum
    fname = handles.cellEvaluateResult{n,1};
    xlswrite(xlsFileName,fname,xlsSheetName,['A' num2str(n) ':A' num2str(n)]);
end

%--------------------------------------------------------------------------

function iniBars_Callback(hObject,handles)
% hObject    handle to SaveExcelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'hAxes')
    hAxes = cell(1,6);
    hAxes{1} = handles.axesOverallSeverity;
    hAxes{2} = handles.axesRoughness;
    hAxes{3} = handles.axesBreathiness;
    hAxes{4} = handles.axesStrain;
    hAxes{5} = handles.axesPitch;
    hAxes{6} = handles.axesLoudness;
else
    hAxes = handles.hAxes;
end

if ~isfield(handles,'hTxtNum')
    hTxtNum = cell(1,6);
    hTxtNum{1} = handles.textNumOverallSeverity;
    hTxtNum{2} = handles.textNumRoughness;
    hTxtNum{3} = handles.textNumBreathiness;
    hTxtNum{4} = handles.textNumStrain;
    hTxtNum{5} = handles.textNumPitch;
    hTxtNum{6} = handles.textNumLoudness;
else
    hTxtNum = handles.hTxtNum;
end

if ~isfield(handles,'hNumPatch')
    hNumPatch = cell(1,6);
    for n=1:6
        iniAxes(hAxes{n});
        axes(hAxes{n});
        hNumPatch{n} = patch( ...
                           'XData', [0 1 1 0], ...
                           'YData', [0 0 1 1] );
        set(hAxes{n}, 'ButtonDownFcn', {@setEvaluateNumByClick,hNumPatch{n},hTxtNum{n}});
        set(hNumPatch{n}, 'ButtonDownFcn', {@setEvaluateNumByClick,hNumPatch{n},hTxtNum{n}});
        set(hTxtNum{n},'string','0');
    end
else
    hNumPatch = handles.hNumPatch;
    for n=1:6
        iniAxes(hAxes{n});
        axes(hAxes{n});
        set(hNumPatch{n},...
            'XData', [0 1 1 0], ...
            'YData', [0 0 1 1] );
        set(hAxes{n}, 'ButtonDownFcn', {@setEvaluateNumByClick,hNumPatch{n},hTxtNum{n}});
        set(hNumPatch{n}, 'ButtonDownFcn', {@setEvaluateNumByClick,hNumPatch{n},hTxtNum{n}});
        set(hTxtNum{n},'string','0');
    end
end

handles.hAxes = hAxes;
handles.hTxtNum = hTxtNum;
handles.hNumPatch = hNumPatch;   
guidata(hObject,handles);

set(handles.radioPitchLH1,'Value',1);
set(handles.radioPitchLH2,'Value',0);
set(handles.radioLoudnessLH1,'Value',1);
set(handles.radioLoudnessLH2,'Value',0);
%--------------------------------------------------------------------------  
function iniAxes(hAxes)
set(hAxes,...
'XLim', [0 100], ...
'YLim', [0 1],...
'Box', 'on', ...
'ytick', [], ...
'xtick', [0,12,43,80]);
set(hAxes,'XTickLabel',{' ';'MI';'MO';'SE'},'FontSize',8);
%--------------------------------------------------------------------------
function setEvaluateNumByClick(h, e,hNumPatch,hTxt)
[x,y]=ginput(1);
theNum = round(x);

% colormin = 1.5;
% colormax = 2.8;
% 
% thiscolor = rand(1, 3);
% while (sum(thiscolor) < colormin) || (sum(thiscolor) > colormax)
%     thiscolor = rand(1, 3);
% end
thiscolor = [];
MI_Color = [0.5437    0.9848    0.7157];
MO_Color =[ 0.1190    0.4984    0.95970];
SE_Color = [0.6074    0.1917    0.7384];

if theNum <= 25
    thiscolor = MI_Color;
end
if theNum <= 60 && theNum > 25
    thiscolor = MO_Color;
end
if theNum > 60
    thiscolor = SE_Color;
end

% rectangle('Position',[0,0,theNum,1],'facecolor',thiscolor);
set(hNumPatch,...
    'XData', [0 theNum theNum 0], ...
    'YData', [0 0 1 1] );
set(hNumPatch, 'FaceColor', thiscolor);
set(hTxt,'String',num2str(theNum));

%--------------------------------------------------------------------------


% --- Executes on button press in selExcelFileBtn.
function selExcelFileBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selExcelFileBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[currentFileName,fileFolder] = uiputfile('*.xlsx','Save evaluate result as a xlsx file');
outputExcelFileName = fullfile(fileFolder,currentFileName);

set(handles.SaveExcelFileNameEdit,'string',outputExcelFileName);

handles.fileInfo.outputExcelFileName = outputExcelFileName;
guidata(hObject,handles);
iniBars_Callback(hObject,handles);



function SaveExcelFileNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SaveExcelFileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaveExcelFileNameEdit as text
%        str2double(get(hObject,'String')) returns contents of SaveExcelFileNameEdit as a double


% --- Executes during object creation, after setting all properties.
function SaveExcelFileNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveExcelFileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveToCellBtn.
function SaveToCellBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveToCellBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sizeCell = size(handles.cellEvaluateResult);
rowSum = sizeCell(1);
rowNum = rowSum + 1;
if rowSum > 1
    for n=2:rowSum
        bExist = strcmp(handles.cellEvaluateResult{n,1},handles.fileInfo.currentFileName);
        if ~bExist
            continue;
        end
        rowNum = n;
        break;
    end
end

handles.cellEvaluateResult{rowNum,1} = handles.fileInfo.currentFileName;
for n=1:6
    handles.cellEvaluateResult{rowNum,n+1} = get(handles.hTxtNum{n},'string');
end

if get(handles.radioPitchLH1,'Value')>0.1
    handles.cellEvaluateResult{rowNum,8} = 'Low';
else
    handles.cellEvaluateResult{rowNum,8} = 'High';
end

if get(handles.radioLoudnessLH1,'Value')>0.1
    handles.cellEvaluateResult{rowNum,9} = 'Low';
else
    handles.cellEvaluateResult{rowNum,9} = 'High';
end

guidata(hObject,handles);
k=5;


% --- Executes on button press in PlayBtn.
function PlayBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PlayBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileName = strcat(handles.fileInfo.fileFolder ,'\', handles.fileInfo.currentFileName );
fileName = fileName{1};
[wavData,fsamp] = wavread(fileName);
soundsc(wavData, fsamp);


% --- Executes on button press in radioPitchLH1.
function radioPitchLH1_Callback(hObject, eventdata, handles)
% hObject    handle to radioPitchLH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioPitchLH1
set(handles.radioPitchLH2,'Value',0);

% --- Executes on button press in radioPitchLH2.
function radioPitchLH2_Callback(hObject, eventdata, handles)
% hObject    handle to radioPitchLH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioPitchLH2
set(handles.radioPitchLH1,'Value',0);


% --- Executes on button press in radioLoudnessLH1.
function radioLoudnessLH1_Callback(hObject, eventdata, handles)
% hObject    handle to radioLoudnessLH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioLoudnessLH1
set(handles.radioLoudnessLH2,'Value',0);


% --- Executes on button press in radioLoudnessLH2.
function radioLoudnessLH2_Callback(hObject, eventdata, handles)
% hObject    handle to radioLoudnessLH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioLoudnessLH2
set(handles.radioLoudnessLH1,'Value',0);
