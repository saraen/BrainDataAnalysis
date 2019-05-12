classdef BrainMatrix < handle
    %BrainMatrix this class stores a brain matrix and its graph properties
    
    properties
        matrix
        
        % graph properties
        betweeness
        clusteringCoef
        density
        shortestPath
        efficiency
        modularity
        richClub
        strengths
        transitivity
    end
    
    methods
        % Constuctor
        function obj = BrainMatrix ( matrix ) 
            obj.matrix = matrix;
        end
    end
    
end

