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
        
        function analize(obj)           
            obj.betweeness     = betweenness_wei(obj.matrix);
            obj.clusteringCoef = clustering_coef_wu_sign(obj.matrix);
            obj.density        = density_und(obj.matrix);
            obj.shortestPath   = distance_wei(obj.matrix);
            obj.efficiency     = efficiency_wei(obj.matrix);
            obj.modularity     = modularity_und(obj.matrix);
            obj.richClub       = rich_club_wu(obj.matrix);
            obj.strengths      = strengths_und_sign(obj.matrix);
        end
    end
    
end

