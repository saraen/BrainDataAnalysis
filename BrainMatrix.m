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
        shortestPathLength
        edgesInShortestPath
        characteristicPathLength
        
    end
    
    methods
        % Constuctor
        function obj = BrainMatrix ( matrix )
            obj.matrix = matrix;
            
            % Replace all the negative values with zeros
            obj.matrix(obj.matrix<0) = 0;            
        end
        
        function analize(obj)
            obj.strengths        = strengths_und(obj.matrix);
            obj.degrees          = degrees_und(obj.matrix);
            obj.betweenness      = betweenness_wei(weight_conversion(obj.matrix, 'lengths'));
            obj.efficiencyGlobal = efficiency_wei(obj.matrix);
            obj.clusteringCoef   = clustering_coef_wu(weight_conversion(obj.matrix, 'normalize'));
            [obj.shortestPathLength, obj.edgesInShortestPath]   = distance_wei(weight_conversion(obj.matrix, 'lengths'));
            obj.characteristicPathLength = mean2(obj.shortestPathLength); %The average shortest path length is the characteristic path length of the network
        end
    end
    
end

