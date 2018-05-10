%Created by Pablo Say 

function varargout = grade_calculatorVer3(varargin)
% GRADE_CALCULATORVER3 MATLAB code for grade_calculatorVer3.fig
%      GRADE_CALCULATORVER3, by itself, creates a new GRADE_CALCULATORVER3 or raises the existing
%      singleton*.
%
%      H = GRADE_CALCULATORVER3 returns the handle to a new GRADE_CALCULATORVER3 or the handle to
%      the existing singleton*.
%
%      GRADE_CALCULATORVER3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRADE_CALCULATORVER3.M with the given input arguments.
%
%      GRADE_CALCULATORVER3('Property','Value',...) creates a new GRADE_CALCULATORVER3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before grade_calculatorVer3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to grade_calculatorVer3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help grade_calculatorVer3

% Last Modified by GUIDE v2.5 16-Apr-2018 11:13:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @grade_calculatorVer3_OpeningFcn, ...
                   'gui_OutputFcn',  @grade_calculatorVer3_OutputFcn, ...
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


% --- Executes just before grade_calculatorVer3 is made visible.
function grade_calculatorVer3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to grade_calculatorVer3 (see VARARGIN)

% Choose default command line output for grade_calculatorVer3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes grade_calculatorVer3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = grade_calculatorVer3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in calcFullGrade.
function calcFullGrade_Callback(hObject, eventdata, handles)
% hObject    handle to calcFullGrade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function calcFullGrade_Callback computes the total grade the user has
%given the inputs in uitable gradeTable

tableData = get(handles.gradeTable, 'data');
[~,columns]= size(tableData);

%calculates each subgrade on uitable gradesTable
for i = 1:columns
    
    singleCol = tableData(:,i);
    
    % if cell is empty, element is rewritten as {''}
    for j = 1:length(singleCol)
        if isempty(singleCol{j}) == 1
            singleCol(j) = {''};
        end
        %stops function is NaN found in table
        if isnan(singleCol{j}) == 1
            msgbox(['Error: Ensure the selected column is not empty and' ...
               ' contains',' no NaNs'], 'Error','error');
            return
        end
        
        %stops function is a negative value is found
        if singleCol{j} < 0
            msgbox(['Error: Ensure the selected column contains',...
                ' no negative values'], 'Error','error');
            return
        end
    end
    singleCol(strcmp('', singleCol)) = []; 
   
    gradesMat = str2double(string(singleCol)); %converts from cell to array 
                                               %for computation
                                               
    %try-catch checks if singleCol is an empty column - if so, function 
    %stops to prevent crash
    try
       
        %weights of individual subgrades are stored into a seperate array, 
        %then replaced with zero as to not interfere with subGrade 
        %computation
        gradesWeight(i) = gradesMat(1);  %#ok<AGROW>
    
    catch
        msgbox(['Error: Empty columns found. Ensure there are no' ...
            ' empty columns present in the table.'],'Error','error');
        return 
    end 
    gradesMat(1) = 0;
    
    %each individual subgrade is stored in array subGrade for future use 
    subGrade(i) = (gradesWeight(i) * sum(gradesMat))/...
        (100*(length(gradesMat)-1)); %#ok<AGROW> 

end

totalGrade = (100*(sum(subGrade)))/(sum(gradesWeight));

%if user input causes a NaN answer, the output is replaced by this error
%message
if isnan(totalGrade) == 1
    msgbox(['Error: Ensure the selected column is not empty and contains',...
        ' no NaNs'], 'Error','error');
    return
end

set(handles.fullGradeOutput, 'string', totalGrade);

% --- Executes on button press in calcSub.
function calcSub_Callback(hObject, eventdata, handles)
% hObject    handle to calcSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function calcSub takes a column from uitable gradesTable and computes how
%many points have been earned within that subgrade

tableData = get(handles.gradeTable, 'data'); 

singleCol = str2double(get(handles.columnNum, 'string')); 

%checks if user input is valid- stops function if invalid to prevent crash
if isnan(singleCol) == 1
    msgbox(['Error: Input to select column invalid.' ...
        ' Input must be numeric'],'Error','error');
    return
end
try 
    dataSelect = tableData(:,singleCol);
catch 
    msgbox('Error: Column Number given does not exist in current table',...
        'Error','error');
    return
end 

%replaces all empty cells from table with {''}
for j = 1:length(dataSelect)
    
    if isempty(dataSelect{j}) == 1
        dataSelect(j) = {''};  
    end
    
    %stops function is NaN found in table
    if isnan(dataSelect{j}) == 1
        msgbox(['Error: Ensure the selected column is has no empty cells',...
            ' or NaNs'], 'Error','error');
        return
    end
    
        %stops function is a negative value is found
    if dataSelect{j} < 0
        msgbox(['Error: Ensure the selected column contains',...
            ' no negative values'], 'Error','error');
        return
    end
    
end

%stores grade weight into under seperate variable to seperate the number
%from the grades for future use

gradeWeight = str2double(string(dataSelect(1)));
dataSelect(1) = {0}; 

%deletes any elements in cell array marked with {''}
dataSelect(strcmp('', dataSelect)) = []; 

%computes subGrade
sumData = sum(str2double(string(dataSelect)));
subGrade = (gradeWeight * sumData)/(100*(length(dataSelect)-1));  

%Supresses output if output is NaN (acts as backup in event of unknown 
%input)  
if isnan(subGrade) == 1 
    msgbox(['Error: Ensure the selected column has no empty cells and ',...
        ' contains no NaNs'], 'Error','error');
    return
end

set (handles.subGradeOutput,'string',subGrade);
set (handles.worthText,'string',gradeWeight);




function columnNum_Callback(hObject, eventdata, handles)
% hObject    handle to columnNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of columnNum as text
%        str2double(get(hObject,'String')) returns contents of columnNum as a double
% --- Executes during object creation, after setting all properties.

function columnNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to columnNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function saveButton_Callback takes user input for file name and saves
%variables within table

tableData = get(handles.gradeTable, 'data');  
tableColNames = (get(handles.gradeTable,'columnname'))';

name = get(handles.fileName, 'string');

%makes tableColNames equal in horizontal length to tableData in order to
%vertically concatenate them properly.
while length(tableColNames) ~= length(tableData(1,:))
    tableColNames(1,end+1) = {''}; %#ok<AGROW>
end
    
fullTable = vertcat(tableColNames,tableData); %#ok<NASGU>

%if no name is given, the function returns to prevent an nameless file from
%being created
if (name == "")
    msgbox('Invalid: Please input a name','Error','error');
    return
end

fid = strtrim([name '.mat']);
try 
    save(fid,'fullTable')
    msgbox('Save Successful')
catch 
    msgbox(['Error: Something went wrong.'...
        ' Try a different name and try again'], 'Error','error')
end 

 


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function loadButton_Callback loads file requested by user and sets
%properties of loaded table to editable and numeric

name = get(handles.loadFile, 'string');
fid = strtrim([name '.mat']);
fid(isspace(fid)) = []; 

%stops function if file is not found or no name has been given
if (name == "")
    msgbox('Error: Please input a name','Error','error');
    return
end
try 
    load(fid);
catch
    msgbox(['Error: File not found.', ' Ensure the file is located in', ...
        ' the same current folder as the grade calculator program'],...
        'Error', 'error');
    return
end

%Try/Catch attempts to store column titles in a seperate cell array; throws
%error if the cell array cannot be found
try
    tableColNames = fullTable(1,:); %#ok<NODEF>
catch 
    msgbox(['Error: Cell Array not found. Ensure cell array from' ...
        ' loaded file is titled "fullTable".'], 'Error', 'error')
    return
end

%In cell array fullTable, the first row will always contain the colummn
%names. This clears the column names from the data loaded onto the table 
fullTable(1,:) = [];

set(handles.gradeTable, 'data',fullTable,'ColumnName',tableColNames)

%sets Column Format and Column Edit Properties
tableSize = size (fullTable);
columnEdit = true(1,tableSize(:,end)); 

char  = {'numeric'};
for i = 1:tableSize(2)
    char{end+1} = 'numeric'; %#ok<AGROW>
end

set (handles.gradeTable,'ColumnFormat', char,'ColumnEditable', columnEdit);





function loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loadFile as text
%        str2double(get(hObject,'String')) returns contents of loadFile as a double

% --- Executes during object creation, after setting all properties.
function loadFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName as text
%        str2double(get(hObject,'String')) returns contents of fileName as a double

% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function finalWeight_Callback(hObject, eventdata, handles)
% hObject    handle to finalWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finalWeight as text
%        str2double(get(hObject,'String')) returns contents of finalWeight as a double

% --- Executes during object creation, after setting all properties.
function finalWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finalWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on selection change in finalPopUp.
function finalPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to finalPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns finalPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from finalPopUp

%function finalPopUp_Callback takes data from uitable gradeTable and 
%calculates what the user needs to achieve on the final based on their 
%chosen goal and how much the final is worth in the class

tableData = get(handles.gradeTable, 'data'); 
[~,columns]= size(tableData);

%calculates each subgrade from each column on uitable gradesTable

for i = 1:columns
    
    singleCol = tableData(:,i);
    
    % if cell is empty, cell marked with {''} and deleted
    for j = 1:length(singleCol)
        
        if isempty(singleCol{j}) == 1 
            singleCol(j) = {''}; 
        end
        
    end
    
    singleCol(strcmp('', singleCol)) = [];
   
    %converts cell into double to allow for computation
    gradesMat = str2double(string(singleCol)); 
   
    %weights of individual subgrades are stored into a seperate array, then
    %replaced with zero as to not interfere with subGrade computation
    try
        gradesWeight(i) = gradesMat(1);  %#ok<AGROW>
        
        gradesMat(1) = 0;
        
        %each individual subgrade is stored in array subGrade
        subGrade(i) = (gradesWeight(i) * sum(gradesMat))/...
            (100*(length(gradesMat)-1)); %#ok<AGROW>
        
    catch
        msgbox(['Invalid: Ensure there are no empty columns present in',...
            ' the table'],'Error','error');
        return
    end
    
end

%calculates and verifies totalGrade. If NaN, funuction stops and displays
%error message
totalGrade = (100*(sum(subGrade)))/(sum(gradesWeight));
if isnan(totalGrade) == 1
    msgbox(['Error: Ensure the each column contains no empty cells',...
        ' and contains no NaNs'], 'Error','error');
    return
end

selectedGrade = get(handles.finalPopUp, 'Value');
finalWeight = str2double(get(handles.finalWeight, 'string'));

%checks if user input is valid for Final Exam Worth from the editable text
%box. 
if isnan(finalWeight) == 1
    msgbox(['Error: Final Exam Worth input invalid.'...
        ' Please Input Final Exam Worth (Numeric)'],'Error','error');
    return
end
if finalWeight <= 0 
    msgbox(['Error: Final Exam worth was found to be negative or zero.'...
        ' Please Input Final Exam Worth (Numeric)'],'Error','error');
    return
end

sumWeight = sum(gradesWeight);

%Switch/Case runs different (but similar) computations based on user's
%choice for their grade goal
switch selectedGrade
    case 1 %User accidentally selects "Select Goal" 
        msgbox('Invalid: Please choose a goal', 'Error','error');

    case 2 %User selects A (90%)
        A = 90;
        totalWeight = sumWeight + finalWeight;
        x = (totalGrade*sumWeight)/100;
        y = (A*totalWeight)/100;
        z = y-x;
        finalGrade = (z*100)/finalWeight;
        set (handles.finalOutput, 'string', finalGrade);
    
    case 3 %user selects B (80%)
        B = 80;
        totalWeight = sumWeight + finalWeight;
        x = (totalGrade*sumWeight)/100;
        y = (B*totalWeight)/100;
        z = y-x;
        finalGrade = (z*100)/finalWeight;
        set (handles.finalOutput, 'string', finalGrade);
    
    case 4 %user selects C (70%)
        C =70;
        totalWeight = sumWeight + finalWeight;
        x = (totalGrade*sumWeight)/100;
        y = (C*totalWeight)/100;
        z = y-x;
        finalGrade = (z*100)/finalWeight;
        set (handles.finalOutput, 'string', finalGrade);
    
    case 5 %user selects F (60%)
        F = 60;        
        totalWeight = sumWeight + finalWeight;
        x = (totalGrade*sumWeight)/100;
        y = (F*totalWeight)/100;
        z = y-x;
        finalGrade = (z*100)/finalWeight;
        set (handles.finalOutput, 'string', finalGrade);
end




% --- Executes during object creation, after setting all properties.
function finalPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finalPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in addRowButton.
function addRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to addRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function addRowButton_Callback adds an editable row to uitable gradeTable

tableData = get(handles.gradeTable, 'data');
tableData(end+1,:) = {[]};  
set(handles.gradeTable, 'data', tableData)


% --- Executes on button press in addColumnButton.
function addColumnButton_Callback(hObject, eventdata, handles)
% hObject    handle to addColumnButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%tableAdjust variable represents the cells in the uitable

%function addColumnButton_Callback adds an editable columnn to uitable 
%gradeTable

tableData = get(handles.gradeTable, 'data');
tableData(:,end+1) = {[]}; 

%sets logical array of 1's for each column in table to set them as editable
tableSize = size (tableData); 
columnEdit = true(1,tableSize(:,end));  

%sets each column in gradeTable as numeric
characters  = {'numeric'};

for i = 1:tableSize(2)
    characters{end+1} = 'numeric'; %#ok<AGROW>
end

set (handles.gradeTable,'data',tableData,'ColumnFormat', ...
    characters,'ColumnEditable', columnEdit);

% --- Executes on button press in clearNaN.
function clearNaN_Callback(hObject, eventdata, handles)
% hObject    handle to clearNaN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function clearNaN_Callback removes all NaNs present in 
%uitable gradesTables

tableData = get(handles.gradeTable, 'data');
[~,columns]= size(tableData);

%removes NaNs from uitable gradesTable one column at a time
for i = 1:columns
   
    %stores individual column from table in singleCol to remove NaNs
    singleCol = tableData(:,i);       
    for j = 1:length(singleCol)
        if isnan(singleCol{j}) == 1
            tableData(j,i) = {[]};
        end
    end

set(handles.gradeTable, 'data', tableData)

end

% --- Executes on button press in deleteRowButton.
function deleteRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function deleteRowButton_Callback removes the bottom row 
%from uitable gradeTable

tableData = get(handles.gradeTable, 'data');
[rows,~] = size(tableData);

%prevents user from deleting last row to prevent unintened results of 
%uitable manipulation

if rows == 2
    msgbox('Error: Can no longer delete rows from table','Error', 'error')
else
    tableData(end,:) = [];
    set(handles.gradeTable, 'data', tableData)
end

% --- Executes on button press in deleteColumnButton.
function deleteColumnButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteColumnButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% function deleteColumnButton deleted the farthest column on uitable
% gradeTable

tableData = get(handles.gradeTable, 'data');

[~,columns] = size(tableData);

if columns == 1
    msgbox('Error: Can no longer delete columns from table','Error', ...
        'error')
else

    %try-catch attempts to delete column name if possible
   try  
    tableColNames = (get(handles.gradeTable,'columnname'))';
    tableColNames(columns) = [];
   catch 
   end 
   
    set(handles.gradeTable, 'ColumnName', tableColNames)   
    tableData(:,end) = [];
    set(handles.gradeTable, 'data', tableData)
end

% --- Executes on button press in clearTableButton.
function clearTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function clearTableButton deletes all elements from uitable gradesTable

tableAdjust = get(handles.gradeTable, 'data');
tableAdjust(:,:) = {[]};
set(handles.gradeTable, 'data', tableAdjust)





function colName_Callback(hObject, eventdata, handles)
% hObject    handle to colName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colName as text
%        str2double(get(hObject,'String')) returns contents of colName as a double

% --- Executes during object creation, after setting all properties.
function colName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function colNum_Callback(hObject, eventdata, handles)
% hObject    handle to colNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colNum as text
%        str2double(get(hObject,'String')) returns contents of colNum as a double
% --- Executes during object creation, after setting all properties.

function colNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in colRename.
function colRename_Callback(hObject, eventdata, handles)
% hObject    handle to colRename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function colRename_Callback allows the user to rename a chosen column
colName = get(handles.colName, 'string');
colNum = get(handles.colNum, 'string');
tableData = get(handles.gradeTable, 'data');

colNum = str2double(string(colNum));

%checks if the user gave an input that results in NaN
if isnan(colNum) == 1
    msgbox ('Error: Column Number given is not a number','Error', 'error')
    return
end

%checks if user attempts to change name of nonexistent column; prevents
%user from manipulating table in unexpected ways
[~,columns]= size(tableData);
if colNum > columns
    msgbox ('Error: Column Number given does not exist in current table',...
        'Error', 'error')
    return
end

tableColNames = (get(handles.gradeTable,'columnname'))';

%attempts to set the table's properties to set columns as numeric and
%editable- else the function stops
try
    tableColNames(colNum) = {char(colName)};
    set(handles.gradeTable, 'ColumnName',tableColNames)
  
    
    tableData = get(handles.gradeTable, 'data');
    tableSize = size (tableData);
    columnEdit = true(1,tableSize(:,end));
    
    %sets each column in gradeTable as numeric
    characters  = {'numeric'};
    
    for i = 1:tableSize(2)
        characters{end+1} = 'numeric'; %#ok<AGROW>
    end
    
    set (handles.gradeTable,'data',tableData,'ColumnFormat', ...
        characters,'ColumnEditable', columnEdit);
    
catch
    msgbox (['Error: Column Number given caused an unexpected result.',...
        ' Ensure column number given is a whole positive number'], ...
        'Error', 'error')
    return
end


% --- Executes during object deletion, before destroying properties.
function gradeTable_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to gradeTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
