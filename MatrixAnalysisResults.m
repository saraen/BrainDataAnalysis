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
        
    end
    
    methods
    end
    
end

