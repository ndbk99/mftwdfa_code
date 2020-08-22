classdef DataSet
    
    
    properties
        
        user_id             % nametag of user - for handling different filesystems
        data_name           % nametag of data set
        normed              % whether or not to normalize the fluctuation function by interpolation resolution
        
        filepath_in         % full filepath of raw data text file containing climate data
        data_subfolder      % location of subfolder of "data" in which to store MFTWDFA results from this DataSet
        figs_subfolder      % location of subfolder of "figs" in which to store figures generated from this DataSet
        figs_compare        % place to save figures that compare across datasets   
        
        varnames            % column names for reading in data (needs to be cell array of char arrays, i.e. 'Xvarname' not "Xvarname")
        cutoff              % index of line to start reading from in data file
        t_scale             % time scale in data file
        
        folder_out          % location of folder within "results" to hold this data set's output
        
        bounds_lhs          % log-t bounds for left-hand fluct func slope segment
        bounds_rhs          % log-t bounds for right-hand fluct func slope segment
        
        data_res            % data set's optimal/intrinsic resolution
        
        X                   % array of X data
        Y                   % array of Y data
        
        
    end
    
    
    
    methods
        
        
        
        %%% DATASET CLASS CONSTRUCTOR
        
        function obj = DataSet(uid, dn, nm)
            
            if nargin == 2
                nm = 0;
            end
            
            % Assign user ID and dataset name
            obj.user_id = uid;
            obj.data_name = dn;
            obj.normed = nm;

            % Load in data set's parameters
            [obj.filepath_in, obj.data_subfolder, obj.figs_subfolder, obj.figs_compare, obj.varnames, obj.cutoff, obj.t_scale, obj.bounds_lhs, obj.bounds_rhs] = obj.set_params();
            
            % Load in the raw data 
            [obj.X,obj.Y] = obj.load_data();
            
            % Calculate the appropriate data resolution for the dataset
            obj.data_res = opt_res(obj);
            
        end
        
        
        
        %%% LOAD IN RAW DATASET
        
        function [X,Y] = load_data(obj)
            
            % Unpack X and Y variable column names
            Xvarname = obj.varnames{1};
            Yvarname = obj.varnames{2};

            % Read in data from file as table, trim any top part of the data needed
            A = readtable(obj.filepath_in);
            A = A(obj.cutoff:end,:);
            
            % create age and temp arrays from table & plot
            X = cell2mat(table2cell(A(:,{Xvarname})));
            Y = cell2mat(table2cell(A(:,{Yvarname})));
            
            % create X and Y arrays in order of age and with correct sign (time goes negative)
            X = flip(X) * -1 * obj.t_scale;
            Y = flip(Y);
            
        end
               
        
    end
    
    
end