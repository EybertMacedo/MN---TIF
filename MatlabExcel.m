function varargout = MatlabExcel(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MatlabExcel_OpeningFcn, ...
                   'gui_OutputFcn',  @MatlabExcel_OutputFcn, ...
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


% --- Executes just before MatlabExcel is made visible.
function MatlabExcel_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MatlabExcel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MatlabExcel_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Exportación~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% --------------------------------------------------------------------
function menu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Exportar_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ExportarExcel_Callback(hObject, eventdata, handles)

[nombre, direccion] = uiputfile({'*.xlsx', 'Archivo de Excel'}, ...
                                'Guardar como'); 
Encabezado = get(handles.uitable1, 'ColumnName')'; 
Tabla = get(handles.uitable1, 'Data');
xlswrite([direccion, nombre], [Encabezado ; Tabla]);

% --------------------------------------------------------------------
function ExportarTexto_Callback(hObject, eventdata, handles)

[nombre, direccion, seleccion] = uiputfile({'*.txt', 'Archivo de texto' ; ...
                                 '*.csv', 'Archivo CSV'}, ...
                                'Guardar como');
Encabezado = get(handles.uitable1, 'ColumnName'); 
Encabezado{8} = 'Order_num'; 

T = array2table(get(handles.uitable1, 'Data'), 'VariableNames', Encabezado);

if seleccion == 1
    writetable(T, [direccion, nombre], 'Delimiter', '\t');
elseif seleccion == 2
    writetable(T, [direccion, nombre], 'Delimiter', ',');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Importación~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% --------------------------------------------------------------------
function Importar_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ImportarExcel_Callback(hObject, eventdata, handles)


[nombre, direccion] = uigetfile({'*.xlsx', 'Archivo de Excel'}, ...
                                'Escoge un archivo'); 
[M, string, full] = xlsread([direccion, nombre]);
NombresCol = full(1,:);
full(1,:) = [];
NumeracionFilas = 1:size(full, 1); 
set(handles.uitable1, 'Data', full, 'ColumnName', NombresCol, ...
    'ColumnEditable', logical(1:size(full,2)), 'RowName', NumeracionFilas);
guidata(hObject, handles);


% --------------------------------------------------------------------
function ImportarTexto_Callback(hObject, eventdata, handles)

[nombre, direccion] = uigetfile({'*.txt', 'Archivo de texto' ; ...
                                 '*.csv', 'Archivo CSV'}, ...
                                'Escoge un archivo'); 
M = table2cell(readtable([direccion, nombre], 'ReadVariableNames', false));
NombresCol = M(1,:); 
M(1,:) = []; 
NumeracionFilas = 1:size(M, 1);
set(handles.uitable1, 'Data', M, 'ColumnName', NombresCol, ...
    'ColumnEditable', logical(1:size(M,2)), 'RowName', NumeracionFilas);
guidata(hObject, handles);

%~~~~~~~~~~~~~~~~~~~~~~~Cambiar formato de columnas~~~~~~~~~~~~~~~~~~~~~~~%

% --------------------------------------------------------------------
function Editar_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function FormatoNumerico_Callback(hObject, eventdata, handles)

T = get(handles.uitable1, 'Data');
texto = {['Ingresa el número de columna en' newline 'la cual cambiar el formato']};
titulo = 'Cambiar formato';
numlines = 1;
default = {'6'};
respuesta = inputdlg(texto,titulo,numlines,default);
col = str2num(respuesta{1});

for i = 1:size(T,1)
iter = T{i,col};
editado(i,1) = num2cell(str2num(iter));
end

T(:,col) = editado;
set(handles.uitable1, 'Data', T);
guidata(hObject, handles);

% --------------------------------------------------------------------
function FormatoString_Callback(hObject, eventdata, handles)

T = get(handles.uitable1, 'Data');
texto = {['Ingresa el número de columna en' newline 'la cual cambiar el formato']};
titulo = 'Cambiar formato';
numlines = 1;
default = {'6'};
respuesta = inputdlg(texto,titulo,numlines,default);
col = str2num(respuesta{1});

editado = cellstr(num2str(cell2mat(T(:,col))));
T(:,col) = editado;
set(handles.uitable1, 'Data', T);
guidata(hObject, handles);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~Hoja de cálculo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)


Indices = eventdata.Indices;

if Indices(2) == 6 || Indices(2) == 7
    Calcular_Callback(handles.Calcular, [], handles)
end

% --- Executes on button press in Calcular.
function Calcular_Callback(hObject, eventdata, handles)

T = get(handles.uitable1, 'Data');
handles.valorventas = sum(cell2mat(T(:,6)));
handles.valorunidades = sum(cell2mat(T(:,7)));
set(handles.Ventas, 'String', num2str(handles.valorventas));
set(handles.Unidades, 'String', num2str(handles.valorunidades));
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
T = get(handles.uitable1, 'Data');
figure
x = cell2mat(T(:,8));
y = cell2mat(T(:,6));
minx=min(x);
maxx=max(x);
miny=min(y);
maxy=max(y);
xx = minx:.25:maxx;
yy = spline(x,y,xx);
plot(x,y,'o',xx,yy)
xlim([minx maxx]);
ylim([miny maxy]);
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
T = get(handles.uitable1, 'Data');
figure
x = cell2mat(T(:,8));
y = cell2mat(T(:,7));
minx=min(x);
maxx=max(x);
miny=min(y);
maxy=max(y);
xx = minx:.25:maxx;
yy = spline(x,y,xx);
plot(x,y,'o',xx,yy)
xlim([minx maxx]);
ylim([miny maxy]);
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
