classdef clog < handle 
    % CLOG - This is a minimalistic common logger based on log4j and glog.
    % 
    % Description:
    %       It is designed to be fast and very easy to use.  
    % Initial design is to work in matlab environment.
    % Later, planning for other programming languages as well.
    % Please contact me (info below) with any questions or suggestions!
    % 
    %
    % Author: 
    %       Prasanta Singh <singh.prasanta@gmail.com> https://github.com/pksingh/clog
    %
    % Modified version of 'log4m' which can be found here:
    %       https://in.mathworks.com/matlabcentral/fileexchange/37701-log4m-a-powerful-and-simple-logger-for-matlab
    % Modified version of 'log4matlab' which can be found here:
    %       http://www.mathworks.com/matlabcentral/fileexchange/33532-log4matlab
    
    properties (Constant)
        ALL = 0;
        TRACE = 1;
        DEBUG = 2;
        INFO = 3;
        WARN = 4;
        ERROR = 5;
        FATAL = 6;
        OFF = 7;
        NONE = 7;
    end
        
    properties(Access = protected)
        logger;
    end
    
    properties(SetAccess = protected)
        logLevel = clog.INFO; %Default Log Level
        fileLogLevel = clog.ALL; %Default File Log Level
        fullpath = 'clog.log';  %Default File              
    end
 
%% Public Static Methods Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    methods (Static)
        function obj = getLogger( logPath )          
            % FileLogger
            if(nargin == 0)
                logPath = 'clog.log';
            elseif(nargin > 1)
                error('Only one parameter is used for log file.');
            end
            
            persistent logger;
            if isempty(logger) || ~isvalid(logger)
                if ( nargin > 0 )
                    logger = clog( logPath );
                else
                    logger = clog( );
                end
            end
            obj = logger;
        end
        
    end
    
    
%% Public Methods Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods       

        function setFilename(self,logPath)
            [fid,message] = fopen(logPath, 'a');
            
            if(fid < 0)
                error(['Verify logfile path: ' message]);
            end
            fclose(fid);
            
            self.fullpath = logPath;
        end

        function setFileLogLevel(self,logLevel)
            self.fileLogLevel = logLevel;
        end

        function setLogLevel(self,logLevel)
            self.logLevel = logLevel;
        end
        

%% The public Logging methods %%
        function log(self, varargin)
            lvlStr = 'LOG';
            fprintf('%s:%s\n', lvlStr, self.getMessage(varargin{:}));
        end
        
        function trace(self, varargin)
            self.verboseLog(self.TRACE, varargin{:});
        end

        function debug(self, varargin)
            self.verboseLog(self.DEBUG, varargin{:});
        end
        
        function info(self, varargin)
            self.verboseLog(self.INFO, varargin{:});
        end
        
        function warn(self, varargin)
            self.verboseLog(self.WARN, varargin{:});
        end

        function error(self, varargin)
            self.verboseLog(self.ERROR, varargin{:});
        end
        
        function fatal(self, varargin)
            self.verboseLog(self.FATAL, varargin{:});
        end      
        
    end

%% Private Methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        function self = clog( logpath )
            if(nargin > 0)
                path = logpath;
                self.setFilename(path);
            end
        end

%% VerboseLog %%       
        function verboseLog(self,level,message,varargin)           
            
            % set up our level string
            switch level
                case{self.TRACE}
                    lvlStr = 'TRACE';
                case{self.DEBUG}
                    lvlStr = 'DEBUG';
                case{self.INFO}
                    lvlStr = 'INFO';
                case{self.WARN}
                    lvlStr = 'WARN';
                case{self.ERROR}
                    lvlStr = 'ERROR';
                case{self.FATAL}
                    lvlStr = 'FATAL';
                otherwise
                    lvlStr = 'UNKNOWN';
            end
            
            % Write to Console based on log level
            if( self.logLevel <= level )
                fprintf('%s:%s\n', lvlStr, self.getMessage(message, varargin{:}));
            end
            
            % Skip writing to file, if file log level is too high
            if(self.fileLogLevel > level)
                return;
            end 
            
            % Append new log to log file
            try
                fid = fopen(self.fullpath,'a');
                fprintf(fid,'%s %s: %s\n' ...                    
                    , datestr(now,'yyyy-mm-dd HH:MM:SS,FFF') ...
                    , lvlStr ...
                    , self.getMessage(message, varargin{:}));
                fclose(fid);
            catch ME
                display(ME);
            end 
        end
        
%% GetMessage %%       
        function message = getMessage(~, message, varargin)

            if nargin > 2
                message = sprintf(message, varargin{:});
            end

            [rows, ~] = size(message);
            if rows > 1
                message = sprintf(' %s', evalc('disp(message)'));
            end
        end

    end
    
end
