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
    end
 
%% Public Static Methods Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    methods (Static)
        function obj = getLogger( ~ )           
            persistent logger;
            if isempty(logger) || ~isvalid(logger)
                logger = clog( );
            end
            obj = logger;
        end
        
    end
    
    
%% Public Methods Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods       

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
