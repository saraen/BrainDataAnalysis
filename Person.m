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
    end
    
end

