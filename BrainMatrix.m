classdef BrainMatrix < handle
    %BrainMatrix this class stores a brain matrix and its graph properties
    
    properties
        matrix
        
        % graph properties
        strengths
        degrees
        betweenness
        efficiencyGlobal
        clusteringCoef
        density
        shortestPath        
        modularity
        
    end
    
    methods
        % Constuctor
        function obj = BrainMatrix ( matrix )
            obj.matrix = matrix;
        end
        
        function analize(obj)   
%             obj.strengths        = strengths_und_sign(obj.matrix);
%             obj.degrees          = degrees_und(obj.matrix);
%             obj.betweenness      = betweenness_wei(weight_conversion(obj.matrix, 'lengths'));
%             obj.efficiencyGlobal = efficiency_wei(obj.matrix);            
            obj.clusteringCoef = clustering_coef_wu_sign(obj.matrix);
            
%             obj.density        = density_und(obj.matrix);
%             obj.shortestPath   = distance_wei(obj.matrix);
%             obj.modularity     = modularity_und(obj.matrix);
            
        end
    end
    
end

