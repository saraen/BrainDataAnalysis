classdef MatrixAnalysisResults < handle
   
    %MatrixAnalysisResults This class contains de results of the analysis
    % of one population with the same matrix type (FA or SC)
    
    properties
        %Strength
        strengthMean   = 0
        strengthSd     = 0
        strengthTtest  = 0
        strengthPvalue = 0  
        
        %Degrees
        degreesMean   = 0
        degreesSd     = 0
        degreesTtest  = 0
        degreesPvalue = 0 
        
        %Betweenness centrality
        betweennessMean   = 0
        betweennessSd     = 0
        betweennessTtest  = 0
        betweennessPvalue = 0
        
        %Global efficiency
        efficiencyGlobalMean   = 0
        efficiencyGlobalSd     = 0
        efficiencyGlobalTtest  = 0
        efficiencyGlobalPvalue = 0
        
        %Local efficiency
        efficiencyLocalMean   = 0
        efficiencyLocalSd     = 0
        efficiencyLocalTtest  = 0
        efficiencyLocalPvalue = 0
        
        %Clustering coefficient
        clusteringCoefMean   = 0
        clusteringCoefSd     = 0
        clusteringCoefTtest  = 0
        clusteringCoefPvalue = 0
        
        %Shortest path length
        shortestPathLengthMean   = 0
        shortestPathLengthSd     = 0
        shortestPathLengthTtest  = 0
        shortestPathLengthPvalue = 0
        
        %Number of edges in the shortest path
        edgesInShortestPathMean   = 0
        edgesInShortestPathSd     = 0
        edgesInShortestPathTtest  = 0
        edgesInShortestPathPvalue = 0
        
        %Characteristic Path length
        characteristicPathLengthMean   = 0
        characteristicPathLengthSd     = 0
        characteristicPathLengthTtest  = 0
        characteristicPathLengthPvalue = 0

        % Matrix that contain the values that are significantly different
        % in each group
        significantValuesMatrix = []        
    end
    
    methods
    end
    
end

