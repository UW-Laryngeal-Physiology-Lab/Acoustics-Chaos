classdef file
    %file: This class is file class, and its methods are file related
    %operations, such as creat, import data, save and so on.
    
    properties
        name='';
        path='';
        type='';
        fullname='';
        exist=0;
    end
    
    methods
        % constructor funcion, used to create an object of file class
        function f=file(path,name)
            if nargin~=2
                f.name='';
                f.path='';
                f.type='';
                f.fullname='';
                f.exist=0;
            else
                f.name=name;
                f.path=path;
                f.fullname=fullfile(path,name);
                if exist(f.fullname,'file')
                    f.exist=1;
                else
                    f.exist=0;
                end
                % find index of '.' in filename.
                dotIndex=strfind(name,'.');
                if isempty(dotIndex) % can not find '.'
                    f.type='';
                else    % find 1 or more '.', use the last index
                    f.type=name(dotIndex(end):end);
                end
            end
        end
        
               
        % 'fileImportData' function is used to load the file f.fullname.
        function data=fileImportData(f)
            if f.exist
                data=importdata(f.fullname);
            % filename is not empty, but file does not exist.
            elseif ~isempty(f.name)
                data=[];
                fprintf(2,'File does not exist:\n%s\n',f.fullname);
            else %filename is empty
                data=[];
            end
        end
        
%         % 'fileSave' function is used to save data to file f.fullname.
%         function fileSave(f,v)
%             eval('disp(v)');
%             save(f.fullname,'v');
%             disp('Save file finished!');
%         end

    end
    
    methods(Static)
        % 'file.Get' function uses uigetfile dialog to get a file.
        %   It can get the file path and file name. If uigetfile does not
        %   succeed or get an empty file, it will send a error message. If
        %   uigetfile succeeds, it will then read the file.
        %   if DefaultName==[], get any file, else get a file with the same
        %   filename as DefaultName
        function f=Get(filter,DialogTitle,DefaultName)
            [filename, pathname]=uigetfile(filter, DialogTitle, DefaultName);
            if filename ==0  % fail to get a file
                f=file();
            elseif isempty(DefaultName) % if no default file name, get one
                f=file(pathname,filename);
            elseif strcmp(filename, DefaultName)==0   % get the wrong file
                fprintf(2,'\nSelect the procedure file named: %s.\n',...
                            DefaultName);
                f=file();
            else                
                f=file(pathname,filename);
            end
        end
    end
end

