classdef Person < handle
    %Person: This class implements patients and healthy controls
    
    properties
        FAMatrix 
        SCMatrix 
    end
    
    methods
        function set.FAMatrix(obj, value)
            obj.FAMatrix = BrainMatrix(value);
        end
        
        function set.SCMatrix(obj, value)
            obj.SCMatrix = BrainMatrix(value);
        end
        
        function analize(obj)
            obj.FAMatrix.analize();
            obj.SCMatrix.analize();
        end
        
        function [matrix] = getBrainMatrix(obj, matrixType)
            if strcmp(matrixType, 'FAMatrix') == true
                matrix = obj.FAMatrix;
            elseif strcmp(matrixType, 'SCMatrix') == true
                matrix = obj.SCMatrix;
            end
        end
    end
    
end

