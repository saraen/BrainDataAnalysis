classdef BrainMatrix < handle
    %BrainMatrix this class stores a brain matrix and its graph properties
    
    properties
        matrix
    end
    
    methods
        % Constuctor
        function obj = BrainMatrix ( matrix ) 
            obj.matrix = matrix;
        end
    end
    
end

