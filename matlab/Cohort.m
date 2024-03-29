classdef Cohort < handle
    %Cohort
    
    properties
        patients
        healthControls
        
        FApatientsResults
        FAhealthControlsResults
        
        SCpatientsResults
        SChealthControlsResults
        
        pValueLimit
    end
    
    methods
        
        % Constuctor
        function obj = Cohort
            obj.patients       = [];
            obj.healthControls = [];
            
            obj.FApatientsResults       = MatrixAnalysisResults();
            obj.FAhealthControlsResults = MatrixAnalysisResults();
            
            obj.SCpatientsResults       = MatrixAnalysisResults();
            obj.SChealthControlsResults = MatrixAnalysisResults();
            
            obj.pValueLimit = 0.01;
        end
        
        function loadCohortMembersFromFile(obj, descriptionFileName)
            descriptionTable = readtable(descriptionFileName);
            descriptionTableRows = size(descriptionTable, 1);
            
            hvFaDirName = 'CONN_UOC\FA\HV\';
            hvScDirName = 'CONN_UOC\SC\HV\';
            
            msFaDirName = 'CONN_UOC\FA\MS\';
            msScDirName = 'CONN_UOC\SC\MS\';
            
            for row = 1:descriptionTableRows
                id = char(descriptionTable{row,'ID'});
                person  = Person;
                
                if descriptionTable{row,'group'} == 0
                    % This person is a health control
                    % First read the FA matrix
                    file = dir(strcat(hvFaDirName,'*', id, '*.csv'));
                    person.FAMatrix = load(file.name);
                    
                    % Then read the SC matrix
                    file = dir(strcat(hvScDirName,'*', id, '*.csv'));
                    person.SCMatrix = load(file.name);
                    
                    %Finally add it to the correspondent vector
                    obj.healthControls = [obj.healthControls, person];
                    
                    
                else
                    % This person is a patient
                    % First read the FA matrix
                    file = dir(strcat(msFaDirName,'*', id, '*.csv'));
                    person.FAMatrix = load(file.name);
                    
                    % Then read the SC matrix
                    file = dir(strcat(msScDirName,'*', id, '*.csv'));
                    person.SCMatrix = load(file.name);
                    
                    %Finally add it to the correspondent vector
                    obj.patients = [obj.patients, person];
                    
                end
            end
        end
        
        function analizeCohort(obj)
            obj.analizePersonsVector(obj.patients);
            obj.analizePersonsVector(obj.healthControls);
        end
        
        function analizePersonsVector(~, personsVector)
            for i = 1:length(personsVector)
                personsVector(i).analize();
            end
        end
        
        function showAnalysisResults(obj)
            
            disp('====================');
            
            disp('STRENGHT - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.strengthMean), ' (', num2str(obj.FApatientsResults.strengthSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.strengthMean), ' (', num2str(obj.FAhealthControlsResults.strengthSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.strengthPvalue)]);
            
            disp('--------------------');
            disp('STRENGHT - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.strengthMean), ' (', num2str(obj.SCpatientsResults.strengthSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.strengthMean), ' (', num2str(obj.SChealthControlsResults.strengthSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.strengthPvalue)]);
            
            disp('====================');
            
            disp('DEGREES - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.degreesMean), ' (', num2str(obj.FApatientsResults.degreesSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.degreesMean), ' (', num2str(obj.FAhealthControlsResults.degreesSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.degreesPvalue)]);
            
            disp('--------------------');
            disp('DEGREES - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.degreesMean), ' (', num2str(obj.SCpatientsResults.degreesSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.degreesMean), ' (', num2str(obj.SChealthControlsResults.degreesSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.degreesPvalue)]);
            
            disp('====================');
            
            disp('BETWEENNESS CENTRALITY - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.betweennessMean), ' (', num2str(obj.FApatientsResults.betweennessSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.betweennessMean), ' (', num2str(obj.FAhealthControlsResults.betweennessSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.betweennessPvalue)]);
            
            disp('--------------------');
            disp('BETWEENNESS CENTRALITY - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.betweennessMean), ' (', num2str(obj.SCpatientsResults.betweennessSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.betweennessMean), ' (', num2str(obj.SChealthControlsResults.betweennessSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.betweennessPvalue)]);
            
            disp('====================');
            
            disp('GLOBAL EFFICIENCY - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.efficiencyGlobalMean), ' (', num2str(obj.FApatientsResults.efficiencyGlobalSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.efficiencyGlobalMean), ' (', num2str(obj.FAhealthControlsResults.efficiencyGlobalSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.efficiencyGlobalPvalue)]);
            
            disp('--------------------');
            disp('GLOBAL EFFICIENCY - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.efficiencyGlobalMean), ' (', num2str(obj.SCpatientsResults.efficiencyGlobalSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.efficiencyGlobalMean), ' (', num2str(obj.SChealthControlsResults.efficiencyGlobalSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.efficiencyGlobalPvalue)]);
            
            disp('====================');
            
            disp('LOCAL EFFICIENCY - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.efficiencyLocalMean), ' (', num2str(obj.FApatientsResults.efficiencyLocalSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.efficiencyLocalMean), ' (', num2str(obj.FAhealthControlsResults.efficiencyLocalSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.efficiencyLocalPvalue)]);
            
            disp('--------------------');
            disp('LOCAL EFFICIENCY - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.efficiencyLocalMean), ' (', num2str(obj.SCpatientsResults.efficiencyLocalSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.efficiencyLocalMean), ' (', num2str(obj.SChealthControlsResults.efficiencyLocalSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.efficiencyLocalPvalue)]);
            
            disp('====================');
            
            disp('CLUSTERING COEFFICIENT - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.clusteringCoefMean), ' (', num2str(obj.FApatientsResults.clusteringCoefSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.clusteringCoefMean), ' (', num2str(obj.FAhealthControlsResults.clusteringCoefSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.clusteringCoefPvalue)]);
            
            disp('--------------------');
            disp('CLUSTERING COEFFICIENT - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.clusteringCoefMean), ' (', num2str(obj.SCpatientsResults.clusteringCoefSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.clusteringCoefMean), ' (', num2str(obj.SChealthControlsResults.clusteringCoefSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.clusteringCoefPvalue)]);
            
            disp('====================');
            
            disp('SHORTEST PATH LENGTH - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.shortestPathLengthMean), ' (', num2str(obj.FApatientsResults.shortestPathLengthSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.shortestPathLengthMean), ' (', num2str(obj.FAhealthControlsResults.shortestPathLengthSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.shortestPathLengthPvalue)]);
            
            disp('--------------------');
            disp('SHORTEST PATH LENGTH - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.shortestPathLengthMean), ' (', num2str(obj.SCpatientsResults.shortestPathLengthSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.shortestPathLengthMean), ' (', num2str(obj.SChealthControlsResults.shortestPathLengthSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.shortestPathLengthPvalue)]);
            
            disp('====================');
            
            disp('NUMBER OF EDGES IN SHORTEST PATH - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.edgesInShortestPathMean), ' (', num2str(obj.FApatientsResults.edgesInShortestPathSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.edgesInShortestPathMean), ' (', num2str(obj.FAhealthControlsResults.edgesInShortestPathSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.edgesInShortestPathPvalue)]);
            
            disp('--------------------');
            disp('NUMBER OF EDGES IN SHORTEST PATH - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.edgesInShortestPathMean), ' (', num2str(obj.SCpatientsResults.edgesInShortestPathSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.edgesInShortestPathMean), ' (', num2str(obj.SChealthControlsResults.edgesInShortestPathSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.edgesInShortestPathPvalue)]);
            
            disp('====================');
            
            disp('CHARACTERISTIC PATH LENGTH - FA MATRIX');
            disp(['MS: ', num2str(obj.FApatientsResults.characteristicPathLengthMean), ' (', num2str(obj.FApatientsResults.characteristicPathLengthSd), ')']);
            disp(['HV: ', num2str(obj.FAhealthControlsResults.characteristicPathLengthMean), ' (', num2str(obj.FAhealthControlsResults.characteristicPathLengthSd), ')']);
            disp(['p-value: ', num2str(obj.FAhealthControlsResults.characteristicPathLengthPvalue)]);
            
            disp('--------------------');
            disp('CHARACTERISTIC PATH LENGTH - SC MATRIX');
            disp(['MS: ', num2str(obj.SCpatientsResults.characteristicPathLengthMean), ' (', num2str(obj.SCpatientsResults.characteristicPathLengthSd), ')']);
            disp(['HV: ', num2str(obj.SChealthControlsResults.characteristicPathLengthMean), ' (', num2str(obj.SChealthControlsResults.characteristicPathLengthSd), ')']);
            disp(['p-value: ', num2str(obj.SChealthControlsResults.characteristicPathLengthPvalue)]);
            
        end
        
        function evaluateCohort(obj)
            evaluateFAMatrix(obj)
            evaluateSCMatrix(obj)
        end
        
        function evaluateFAMatrix(obj)
            evaluateStrengths(obj, 'FAMatrix');
            evaluateDegrees(obj, 'FAMatrix');
            evaluateBetweenness(obj, 'FAMatrix');
            evaluateGlobalEfficiency(obj, 'FAMatrix');
            evaluateLocalEfficiency(obj, 'FAMatrix');
            evaluateClusteringCoef(obj, 'FAMatrix');
            evaluateShortestPath(obj, 'FAMatrix');
        end
        
        function evaluateSCMatrix(obj)
            evaluateStrengths(obj, 'SCMatrix');
            evaluateDegrees(obj, 'SCMatrix');
            evaluateBetweenness(obj, 'SCMatrix');
            evaluateGlobalEfficiency(obj, 'SCMatrix');
            evaluateLocalEfficiency(obj, 'SCMatrix');
            evaluateClusteringCoef(obj, 'SCMatrix');
            evaluateShortestPath(obj, 'SCMatrix');
        end
        
        
        function showPlots(obj)
            %Strength
            strengthsLinePlot(obj, 'FAMatrix');
            strengthsLinePlot(obj, 'SCMatrix');
            strengthsBoxPlot(obj, 'FAMatrix');
            strengthsBoxPlot(obj, 'SCMatrix');
            
            %Degrees
            degreesLinePlot(obj, 'FAMatrix');
            degreesLinePlot(obj, 'SCMatrix');
            degreesBoxPlot(obj, 'FAMatrix');
            degreesBoxPlot(obj, 'SCMatrix');
            
            %Betweenness centrality
            betweennessLinePlot(obj, 'FAMatrix');
            betweennessLinePlot(obj, 'SCMatrix');
            betweennessBoxPlot(obj, 'FAMatrix');
            betweennessBoxPlot(obj, 'SCMatrix');
            
            %Global efficiency
            globalEfficiencyBoxPlot(obj, 'FAMatrix');
            globalEfficiencyBoxPlot(obj, 'SCMatrix');
            
            %Clustering coefficient
            clusteringCoefLinePlot(obj, 'FAMatrix');
            clusteringCoefLinePlot(obj, 'SCMatrix');
            clusteringCoefBoxPlot(obj, 'FAMatrix');
            clusteringCoefBoxPlot(obj, 'SCMatrix');
            
            %Shortest Path Length
            shortestPathLinePlot(obj, 'FAMatrix');
            shortestPathLinePlot(obj, 'SCMatrix');
            shortestPathBoxPlot(obj, 'FAMatrix');
            shortestPathBoxPlot(obj, 'SCMatrix');
            
            %Number of edges in the shortest path
            edgesInShortestPathLinePlot(obj, 'FAMatrix');
            edgesInShortestPathLinePlot(obj, 'SCMatrix');
            edgesInShortestPathBoxPlot(obj, 'FAMatrix');
            edgesInShortestPathBoxPlot(obj, 'SCMatrix');
            
            %Characteristic path length
            characteristicPathLengthBoxPlot(obj, 'FAMatrix');
            characteristicPathLengthBoxPlot(obj, 'SCMatrix');
            
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %
        %                 PLOTS FUNCTIONS
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % This function shows a line plot of the mean values of the
        % strengths of each node for each population
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function strengthsLinePlot(obj, matrixType)
            % If a node has a strength higher than the average and 1
            % standard deviation of its group of participants, it is
            % considered a hub node. This value will be called hubLimit
            hubLimitPatients = 0;
            hubLimitHealthControls = 0;
            
            % First we need to combine all strength vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsStrengths(i,:) = obj.patients(i).FAMatrix.strengths;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsStrengths(i,:) = obj.healthControls(i).FAMatrix.strengths;
                end
                hubLimitPatients = obj.FApatientsResults.strengthMean + obj.FApatientsResults.strengthSd;
                hubLimitHealthControls = obj.FAhealthControlsResults.strengthMean + obj.FAhealthControlsResults.strengthSd;
                
                plotTitle = 'Strength-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsStrengths(i,:) = obj.patients(i).SCMatrix.strengths;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsStrengths(i,:) = obj.healthControls(i).SCMatrix.strengths;
                end
                hubLimitPatients = obj.SCpatientsResults.strengthMean + obj.SCpatientsResults.strengthSd;
                hubLimitHealthControls = obj.SChealthControlsResults.strengthMean + obj.SChealthControlsResults.strengthSd;
                
                plotTitle = 'Strength-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the strength
            % matrices. This is the mean strength value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsStrengths);
            hv_mean_by_node = mean(healthControlsStrengths);
            
            % Now we plot the values
            figure
            plot(hv_mean_by_node, '-o', 'color', [0.6350 0.0780 0.1840], 'MarkerFaceColor', [0.6350 0.0780 0.1840], 'MarkerSize', 4,'LineWidth', 2);            
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, '--o', 'color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerSize', 4,'LineWidth', 2);            
            legend('hv', 'ms');
            ylabel('Mean strength');
            xlabel('Nodes');
            
            % Plot the hub limits
            plot(hubLimitHealthControls*ones(80), 'color', [0.6350 0.0780 0.1840], 'LineWidth', 2);
            plot(hubLimitPatients*ones(80), 'color', [0.4660 0.6740 0.1880], 'LineWidth', 2);
            
            hold off
        end
        
        % This function plots the strength boxplot of both groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function strengthsBoxPlot(obj, matrixType)
            % First we need to combine all strength vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsStrengths(i,:) = obj.patients(i).FAMatrix.strengths;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsStrengths(i,:) = obj.healthControls(i).FAMatrix.strengths;
                end
                
                plotTitle = 'Strength-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsStrengths(i,:) = obj.patients(i).SCMatrix.strengths;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsStrengths(i,:) = obj.healthControls(i).SCMatrix.strengths;
                end
                
                plotTitle = 'Strength-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the strength
            % matrices. This is the mean strength value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsStrengths);
            hv_mean_by_node = mean(healthControlsStrengths);
            
            % Now we combine both groups of data into a matrix
            X(:,1) = hv_mean_by_node;
            X(:,2) = ms_mean_by_node;
            
            %Plot the values
            figure
            boxplot(X, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        % This function shows a line plot of the mean values of the
        % degrees of each node for each population
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function degreesLinePlot(obj, matrixType)
            
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsDegrees(i,:) = obj.patients(i).FAMatrix.degrees;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsDegrees(i,:) = obj.healthControls(i).FAMatrix.degrees;
                end
                plotTitle = 'Degrees-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsDegrees(i,:) = obj.patients(i).SCMatrix.degrees;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsDegrees(i,:) = obj.healthControls(i).SCMatrix.degrees;
                end
                plotTitle = 'Degrees-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the degrees
            % matrices. This is the mean degree value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsDegrees);
            hv_mean_by_node = mean(healthControlsDegrees);
            
            % Now we plot the values
            figure
            plot(hv_mean_by_node, '-o', 'color', [0.6350 0.0780 0.1840], 'MarkerFaceColor',  [0.6350 0.0780 0.1840], 'MarkerSize', 4,'LineWidth', 2);
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, '--o', 'color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerSize', 4, 'LineWidth', 2);
            legend('hv', 'ms');
            ylabel('Mean degree');
            xlabel('Nodes');
            
            hold off
        end
        
        % This function plots the degree boxplot of both groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function degreesBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsDegrees(i,:) = obj.patients(i).FAMatrix.degrees;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsDegrees(i,:) = obj.healthControls(i).FAMatrix.degrees;
                end
                
                plotTitle = 'Degrees-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsDegrees(i,:) = obj.patients(i).SCMatrix.degrees;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsDegrees(i,:) = obj.healthControls(i).SCMatrix.degrees;
                end
                
                plotTitle = 'Degrees-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the degrees
            % matrices. This is the mean degree value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsDegrees);
            hv_mean_by_node = mean(healthControlsDegrees);
            
            % Now we combine both groups of data into a matrix
            X(:,1) = hv_mean_by_node;
            X(:,2) = ms_mean_by_node;
            
            %Plot the values
            figure
            boxplot(X, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        % This function shows a line plot of the mean values of the
        % betweenness centrality of each node for each population
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function betweennessLinePlot(obj, matrixType)
            
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsBetweenness(i,:) = obj.patients(i).FAMatrix.betweenness;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsBetweenness(i,:) = obj.healthControls(i).FAMatrix.betweenness;
                end
                plotTitle = 'Betweenness centrality-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsBetweenness(i,:) = obj.patients(i).SCMatrix.betweenness;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsBetweenness(i,:) = obj.healthControls(i).SCMatrix.betweenness;
                end
                plotTitle = 'Betweenness centrality-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the betweenness
            % matrices. This is the mean betweenness value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsBetweenness);
            hv_mean_by_node = mean(healthControlsBetweenness);
            
            % Now we plot the values
            figure
            plot(hv_mean_by_node, '-o', 'color', [0.6350 0.0780 0.1840], 'MarkerFaceColor',  [0.6350 0.0780 0.1840], 'MarkerSize', 4,'LineWidth', 2);
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, '--o', 'color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerSize', 4, 'LineWidth', 2);
            legend('hv', 'ms');
            ylabel('Mean betweenness centrality');
            xlabel('Nodes');
            
            hold off
        end
        
        % This function plots the betweenness centrality boxplot of both
        % groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function betweennessBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsBetweenness(i,:) = obj.patients(i).FAMatrix.betweenness;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsBetweenness(i,:) = obj.healthControls(i).FAMatrix.betweenness;
                end
                
                plotTitle = 'Betweenness centrality-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsBetweenness(i,:) = obj.patients(i).SCMatrix.betweenness;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsBetweenness(i,:) = obj.healthControls(i).SCMatrix.betweenness;
                end
                
                plotTitle = 'Betweenness centrality-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the degrees
            % matrices. This is the mean degree value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsBetweenness);
            hv_mean_by_node = mean(healthControlsBetweenness);
            
            % Now we combine both groups of data into a matrix
            X(:,1) = hv_mean_by_node;
            X(:,2) = ms_mean_by_node;
            
            %Plot the values
            figure
            boxplot(X, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        
        % This function plots the global efficiency boxplot of both
        % groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function globalEfficiencyBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsEfficiency(i,:) = obj.patients(i).FAMatrix.efficiencyGlobal;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsEfficiency(i,:) = obj.healthControls(i).FAMatrix.efficiencyGlobal;
                end
                
                plotTitle = 'Global efficiency-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsEfficiency(i,:) = obj.patients(i).SCMatrix.efficiencyGlobal;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsEfficiency(i,:) = obj.healthControls(i).SCMatrix.efficiencyGlobal;
                end
                
                plotTitle = 'Global efficiency-SC Matrix';
                
            end
            
            %Plot the values
            group = [    ones(size(healthControlsEfficiency));
                2 * ones(size(patientsEfficiency))];
            figure
            boxplot([healthControlsEfficiency; patientsEfficiency],group, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        % This function shows a line plot of the mean values of the
        % clustering coefficient of each node for each population
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function clusteringCoefLinePlot(obj, matrixType)
            
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsClusteringCoef(i,:) = obj.patients(i).FAMatrix.clusteringCoef;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsClusteringCoef(i,:) = obj.healthControls(i).FAMatrix.clusteringCoef;
                end
                plotTitle = 'Clustering coefficient-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsClusteringCoef(i,:) = obj.patients(i).SCMatrix.clusteringCoef;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsClusteringCoef(i,:) = obj.healthControls(i).SCMatrix.clusteringCoef;
                end
                plotTitle = 'Clustering coefficient-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the clustering coef
            % matrices. This is the mean betweenness value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsClusteringCoef);
            hv_mean_by_node = mean(healthControlsClusteringCoef);
            
            % Now we plot the values
            figure
            plot(hv_mean_by_node, '-o', 'color', [0.6350 0.0780 0.1840], 'MarkerFaceColor',  [0.6350 0.0780 0.1840], 'MarkerSize', 4,'LineWidth', 2);
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, '--o', 'color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerSize', 4, 'LineWidth', 2);
            legend('hv', 'ms');
            ylabel('Mean clustering coefficient');
            xlabel('Nodes');
            
            hold off
        end
        
        % This function plots the Clustering coef boxplot of both
        % groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function clusteringCoefBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsClusteringCoef(i,:) = obj.patients(i).FAMatrix.clusteringCoef;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsClusteringCoef(i,:) = obj.healthControls(i).FAMatrix.clusteringCoef;
                end
                
                plotTitle = 'Clustering coefficient-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsClusteringCoef(i,:) = obj.patients(i).SCMatrix.clusteringCoef;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsClusteringCoef(i,:) = obj.healthControls(i).SCMatrix.clusteringCoef;
                end
                
                plotTitle = 'Clustering coefficient-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the clustering coef
            % matrices. This is the mean clustering coef value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsClusteringCoef);
            hv_mean_by_node = mean(healthControlsClusteringCoef);
            
            % Now we combine both groups of data into a matrix
            X(:,1) = hv_mean_by_node;
            X(:,2) = ms_mean_by_node;
            
            %Plot the values
            figure
            boxplot(X, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        % This function shows a line plot of the mean values of the
        % shortest path length of each node for each population
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function shortestPathLinePlot(obj, matrixType)
            
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsShortestPathLength(i,:) = mean(obj.patients(i).FAMatrix.shortestPathLength);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsShortestPathLength(i,:) = mean(obj.healthControls(i).FAMatrix.shortestPathLength);
                end
                plotTitle = 'Shortest path length-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsShortestPathLength(i,:) = mean(obj.patients(i).SCMatrix.shortestPathLength);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsShortestPathLength(i,:) = mean(obj.healthControls(i).SCMatrix.shortestPathLength);
                end
                plotTitle = 'Shortest path length-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the clustering coef
            % matrices. This is the mean betweenness value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsShortestPathLength);
            hv_mean_by_node = mean(healthControlsShortestPathLength);
            
            % Now we plot the values
            figure
            plot(hv_mean_by_node, '-o', 'color', [0.6350 0.0780 0.1840], 'MarkerFaceColor',  [0.6350 0.0780 0.1840], 'MarkerSize', 4,'LineWidth', 2);
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, '--o', 'color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerSize', 4, 'LineWidth', 2);
            legend('hv', 'ms');
            ylabel('Mean shortest path length');
            xlabel('Nodes');
            
            hold off
        end
        
        % This function plots the shortest path length boxplot of both
        % groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function shortestPathBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsShortestPathLength(i,:) = mean(obj.patients(i).FAMatrix.shortestPathLength);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsShortestPathLength(i,:) = mean(obj.healthControls(i).FAMatrix.shortestPathLength);
                end
                
                plotTitle = 'Shortest path length-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsShortestPathLength(i,:) = mean(obj.patients(i).SCMatrix.shortestPathLength);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsShortestPathLength(i,:) = mean(obj.healthControls(i).SCMatrix.shortestPathLength);
                end
                
                plotTitle = 'Shortest path length-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the clustering coef
            % matrices. This is the mean clustering coef value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsShortestPathLength);
            hv_mean_by_node = mean(healthControlsShortestPathLength);
            
            % Now we combine both groups of data into a matrix
            X(:,1) = hv_mean_by_node;
            X(:,2) = ms_mean_by_node;
            
            %Plot the values
            figure
            boxplot(X, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        % This function shows a line plot of the mean number of edges in
        % the shortest paths of each node for each population
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function edgesInShortestPathLinePlot(obj, matrixType)
            
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsEdgesInShortestPath(i,:) = mean(obj.patients(i).FAMatrix.edgesInShortestPath);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsEdgesInShortestPath(i,:) = mean(obj.healthControls(i).FAMatrix.edgesInShortestPath);
                end
                plotTitle = 'Number of edges in the shortest path-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsEdgesInShortestPath(i,:) = mean(obj.patients(i).SCMatrix.edgesInShortestPath);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsEdgesInShortestPath(i,:) = mean(obj.healthControls(i).SCMatrix.edgesInShortestPath);
                end
                plotTitle = 'Number of edges in the shortest path-SC Matrix';
                
            end
            
            
            ms_mean_by_node = mean(patientsEdgesInShortestPath);
            hv_mean_by_node = mean(healthControlsEdgesInShortestPath);
            
            % Now we plot the values
            figure
            plot(hv_mean_by_node, '-o', 'color', [0.6350 0.0780 0.1840], 'MarkerFaceColor',  [0.6350 0.0780 0.1840], 'MarkerSize', 4,'LineWidth', 2);
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, '--o', 'color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerSize', 4, 'LineWidth', 2);
            legend('hv', 'ms');
            ylabel('Mean number of edges in the shortest path');
            xlabel('Nodes');
            
            hold off
        end
        
        % This function plots the number of edges in the shortest path boxplot of both
        % groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function edgesInShortestPathBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsEdgesInShortestPath(i,:) = mean(obj.patients(i).FAMatrix.edgesInShortestPath);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsEdgesInShortestPath(i,:) = mean(obj.healthControls(i).FAMatrix.edgesInShortestPath);
                end
                
                plotTitle = 'Number of edges in the shortest path-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsEdgesInShortestPath(i,:) = mean(obj.patients(i).SCMatrix.edgesInShortestPath);
                end
                for i = 1:length(obj.healthControls)
                    healthControlsEdgesInShortestPath(i,:) = mean(obj.healthControls(i).SCMatrix.edgesInShortestPath);
                end
                
                plotTitle = 'Number of edges in the shortest path-SC Matrix';
                
            end
            
            % Then we obtain the mean value of each column of the clustering coef
            % matrices. This is the mean clustering coef value of each brain node
            % across each population
            ms_mean_by_node = mean(patientsEdgesInShortestPath);
            hv_mean_by_node = mean(healthControlsEdgesInShortestPath);
            
            % Now we combine both groups of data into a matrix
            X(:,1) = hv_mean_by_node;
            X(:,2) = ms_mean_by_node;
            
            %Plot the values
            figure
            boxplot(X, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        
        % This function plots the characteristic path length boxplot of both
        % groups
        %
        % @param matrixType must be either 'FAMatrix' or 'SCMatrix'
        function characteristicPathLengthBoxPlot(obj, matrixType)
            % First we need to combine all degrees vectors into a matrix
            if strcmp(matrixType, 'FAMatrix') == true
                for i = 1:length(obj.patients)
                    patientsCharacteristicPathLength(i,:) = obj.patients(i).FAMatrix.characteristicPathLength;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsCharacteristicPathLength(i,:) = obj.healthControls(i).FAMatrix.characteristicPathLength;
                end
                
                plotTitle = 'Characteristic Path Length-FA Matrix';
                
            elseif strcmp(matrixType, 'SCMatrix')
                for i = 1:length(obj.patients)
                    patientsCharacteristicPathLength(i,:) = obj.patients(i).SCMatrix.characteristicPathLength;
                end
                for i = 1:length(obj.healthControls)
                    healthControlsCharacteristicPathLength(i,:) = obj.healthControls(i).SCMatrix.characteristicPathLength;
                end
                
                plotTitle = 'Characteristic Path Length-SC Matrix';
                
            end
            
            %Plot the values
            group = [    ones(size(healthControlsCharacteristicPathLength));
                2 * ones(size(patientsCharacteristicPathLength))];
            figure
            boxplot([healthControlsCharacteristicPathLength; patientsCharacteristicPathLength],group, 'Color', 'k', 'Labels',{'HV','MS'})
            title(plotTitle)
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %
        %                 EVALUATE PROPERTIES FUNCTIONS
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function evaluateStrengths(obj, matrixType)
            patientsValues       = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsValues = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            
            % First evaluate the strength in the PATIENTS group
            for i = 1:length(obj.patients)
                patientsValues(i,:) = obj.patients(i).getBrainMatrix(matrixType).strengths;
            end
            obj.getPatientsResults(matrixType).strengthMean = mean2(patientsValues);
            obj.getPatientsResults(matrixType).strengthSd   = std2(patientsValues);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsValues(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).strengths;
            end
            obj.getHealthControlsResults(matrixType).strengthMean = mean2(healthControlsValues);
            obj.getHealthControlsResults(matrixType).strengthSd   = std2(healthControlsValues);
            
            ms_mean_by_node = mean(patientsValues);
            hv_mean_by_node = mean(healthControlsValues);
            
            % Perform the t-test
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).strengthTtest        = h;
            obj.getPatientsResults(matrixType).strengthPvalue       = p;
            
            obj.getHealthControlsResults(matrixType).strengthTtest  = h;
            obj.getHealthControlsResults(matrixType).strengthPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['STRENGTHS-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsValues, healthControlsValues);
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            else
                % If not, add it to the node by node comparison significant
                % nodes
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' Strength in both groups']);
                obj.addSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            end
        end
        
        
        function evaluateDegrees(obj, matrixType)
            patientsValues       = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsValues = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsValues(i,:) = obj.patients(i).getBrainMatrix(matrixType).degrees;
            end
            obj.getPatientsResults(matrixType).degreesMean = mean2(patientsValues);
            obj.getPatientsResults(matrixType).degreesSd   = std2(patientsValues);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsValues(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).degrees;
            end
            obj.getHealthControlsResults(matrixType).degreesMean = mean2(healthControlsValues);
            obj.getHealthControlsResults(matrixType).degreesSd   = std2(healthControlsValues);
            
            ms_mean_by_node = mean(patientsValues);
            hv_mean_by_node = mean(healthControlsValues);
            
            % Perform the t-test
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).degreesTtest        = h;
            obj.getPatientsResults(matrixType).degreesPvalue       = p;
            
            obj.getHealthControlsResults(matrixType).degreesTtest  = h;
            obj.getHealthControlsResults(matrixType).degreesPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['DEGREES-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsValues, healthControlsValues);
            % Add them to the node by node comparison significant nodes
            obj.addSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            else
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' Degrees in both groups']);                
            end
            
        end
        
        
        function evaluateBetweenness(obj, matrixType)
            patientsValues       = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsValues = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsValues(i,:) = obj.patients(i).getBrainMatrix(matrixType).betweenness;
            end
            obj.getPatientsResults(matrixType).betweennessMean = mean2(patientsValues);
            obj.getPatientsResults(matrixType).betweennessSd   = std2(patientsValues);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsValues(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).betweenness;
            end
            obj.getHealthControlsResults(matrixType).betweennessMean = mean2(healthControlsValues);
            obj.getHealthControlsResults(matrixType).betweennessSd   = std2(healthControlsValues);
            
            ms_mean_by_node = mean(patientsValues);
            hv_mean_by_node = mean(healthControlsValues);
            
            % Perform the t-test
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).betweennessTtest        = h;
            obj.getPatientsResults(matrixType).betweennessPvalue       = p;
            
            obj.getHealthControlsResults(matrixType).betweennessTtest  = h;
            obj.getHealthControlsResults(matrixType).betweennessPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['BETWEENNESS-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsValues, healthControlsValues);
            % Add them to the node by node comparison significant nodes
            obj.addSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);            
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            else                
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' Betweenness in both groups']);
            end
            
        end
        
        function evaluateGlobalEfficiency(obj, matrixType)
            % Each person has one single global efficiency value, that is
            % why there will be a one dimensional vector for each group of
            % persons
            patientsValues       = zeros(length(obj.patients), 1);
            healthControlsValues = zeros(length(obj.healthControls), 1);
            
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsValues(i,:) = obj.patients(i).getBrainMatrix(matrixType).efficiencyGlobal;
            end
            obj.getPatientsResults(matrixType).efficiencyGlobalMean = mean2(patientsValues);
            obj.getPatientsResults(matrixType).efficiencyGlobalSd   = std2(patientsValues);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsValues(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).efficiencyGlobal;
            end
            obj.getHealthControlsResults(matrixType).efficiencyGlobalMean = mean2(healthControlsValues);
            obj.getHealthControlsResults(matrixType).efficiencyGlobalSd   = std2(healthControlsValues);
            
            % Perform the t-test
            [h, p] = ttest2( healthControlsValues, patientsValues);
            
            obj.getPatientsResults(matrixType).efficiencyGlobalTtest        = h;
            obj.getPatientsResults(matrixType).efficiencyGlobalPvalue       = p;
            
            obj.getHealthControlsResults(matrixType).efficiencyGlobalTtest  = h;
            obj.getHealthControlsResults(matrixType).efficiencyGlobalPvalue = p;
            
            if(p < obj.pValueLimit)
                %If p is significative, add the values to both significant matrix
                obj.addSignificantValues(matrixType, 1, patientsValues, healthControlsValues);
                obj.addGlobalSignificantValues(matrixType, 1, patientsValues, healthControlsValues);
            else
                disp(['There is no significative difference in the mean values of the ', matrixType, ' Global Efficiency in both groups']);
            end
        end
        
        function evaluateLocalEfficiency(obj, matrixType)
            patientsValues       = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsValues = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsValues(i,:) = obj.patients(i).getBrainMatrix(matrixType).efficiencyLocal;
            end
            obj.getPatientsResults(matrixType).efficiencyLocalMean = mean2(patientsValues);
            obj.getPatientsResults(matrixType).efficiencyLocalSd   = std2(patientsValues);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsValues(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).efficiencyLocal;
            end
            obj.getHealthControlsResults(matrixType).efficiencyLocalMean = mean2(healthControlsValues);
            obj.getHealthControlsResults(matrixType).efficiencyLocalSd   = std2(healthControlsValues);
            
            ms_mean_by_node = mean(patientsValues);
            hv_mean_by_node = mean(healthControlsValues);
            
            % Perform the t-test
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).efficiencyLocalTtest        = h;
            obj.getPatientsResults(matrixType).efficiencyLocalPvalue       = p;
            
            obj.getHealthControlsResults(matrixType).efficiencyLocalTtest  = h;
            obj.getHealthControlsResults(matrixType).efficiencyLocalPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['LOCAL EFFICIENCY-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsValues, healthControlsValues);
            % Add them to the node by node comparison significant nodes
            obj.addSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);            
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            else
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' Local Efficiency in both groups']);
            end
        end
        
        
        function evaluateClusteringCoef(obj, matrixType)
            patientsValues       = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsValues = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsValues(i,:) = obj.patients(i).getBrainMatrix(matrixType).clusteringCoef;
            end
            obj.getPatientsResults(matrixType).clusteringCoefMean = mean2(patientsValues);
            obj.getPatientsResults(matrixType).clusteringCoefSd   = std2(patientsValues);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsValues(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).clusteringCoef;
            end
            obj.getHealthControlsResults(matrixType).clusteringCoefMean = mean2(healthControlsValues);
            obj.getHealthControlsResults(matrixType).clusteringCoefSd   = std2(healthControlsValues);
            
            ms_mean_by_node = mean(patientsValues);
            hv_mean_by_node = mean(healthControlsValues);
            
            % Perform the t-test
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).clusteringCoefTtest        = h;
            obj.getPatientsResults(matrixType).clusteringCoefPvalue       = p;
            
            obj.getHealthControlsResults(matrixType).clusteringCoefTtest  = h;
            obj.getHealthControlsResults(matrixType).clusteringCoefPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['CLUSTERING COEFFICIENT-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsValues, healthControlsValues);
            % Add them to the node by node comparison significant nodes
            obj.addSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);            
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsValues, healthControlsValues);
            else
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' Clustering coefficient in both groups']);
            end
        end
        
        function evaluateShortestPath(obj, matrixType)
            patientsShortestPath              = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            patientsEdgesInShortestPath       = zeros(length(obj.patients), size(obj.patients(1).getBrainMatrix(matrixType).matrix, 2));
            patientsCharacteristicPathLength  = zeros(length(obj.patients), 1);
            
            healthControlsShortestPath              = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsEdgesInShortestPath       = zeros(length(obj.healthControls), size(obj.healthControls(1).getBrainMatrix(matrixType).matrix, 2));
            healthControlsCharacteristicPathLength  = zeros(length(obj.healthControls), 1);
            
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                %The rows of this matrix corresponds to each patient in the
                %group, and the columns, to the average path length of each
                %node to the rest of the nodes
                patientsShortestPath(i,:)             = mean(obj.patients(i).getBrainMatrix(matrixType).shortestPathLength);
                patientsEdgesInShortestPath(i,:)      = mean(obj.patients(i).getBrainMatrix(matrixType).edgesInShortestPath);
                patientsCharacteristicPathLength(i,:) = obj.patients(i).getBrainMatrix(matrixType).characteristicPathLength;
                
            end
            
            obj.getPatientsResults(matrixType).shortestPathLengthMean = mean2(patientsShortestPath);
            obj.getPatientsResults(matrixType).shortestPathLengthSd   = std2(patientsShortestPath);
            
            obj.getPatientsResults(matrixType).edgesInShortestPathMean = mean2(patientsEdgesInShortestPath);
            obj.getPatientsResults(matrixType).edgesInShortestPathSd   = std2(patientsEdgesInShortestPath);
            
            obj.getPatientsResults(matrixType).characteristicPathLengthMean = mean2(patientsCharacteristicPathLength);
            obj.getPatientsResults(matrixType).characteristicPathLengthSd   = std2(patientsCharacteristicPathLength);
            
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsShortestPath(i,:)             = mean(obj.healthControls(i).getBrainMatrix(matrixType).shortestPathLength);
                healthControlsEdgesInShortestPath(i,:)      = mean(obj.healthControls(i).getBrainMatrix(matrixType).edgesInShortestPath);
                healthControlsCharacteristicPathLength(i,:) = obj.healthControls(i).getBrainMatrix(matrixType).characteristicPathLength;
                
            end
            obj.getHealthControlsResults(matrixType).shortestPathLengthMean = mean2(healthControlsShortestPath);
            obj.getHealthControlsResults(matrixType).shortestPathLengthSd   = std2(healthControlsShortestPath);
            
            obj.getHealthControlsResults(matrixType).edgesInShortestPathMean = mean2(healthControlsEdgesInShortestPath);
            obj.getHealthControlsResults(matrixType).edgesInShortestPathSd   = std2(healthControlsEdgesInShortestPath);
            
            obj.getHealthControlsResults(matrixType).characteristicPathLengthMean = mean2(healthControlsCharacteristicPathLength);
            obj.getHealthControlsResults(matrixType).characteristicPathLengthSd   = std2(healthControlsCharacteristicPathLength);
            
            % Perform the t-test
            
            % Shortest Path
            ms_mean_by_node = mean(patientsShortestPath);
            hv_mean_by_node = mean(healthControlsShortestPath);
            
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).shortestPathLengthTtest  = h;
            obj.getPatientsResults(matrixType).shortestPathLengthPvalue = p;
            
            obj.getHealthControlsResults(matrixType).shortestPathLengthTtest  = h;
            obj.getHealthControlsResults(matrixType).shortestPathLengthPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['SHORTEST PATH-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsShortestPath, healthControlsShortestPath);
            % Add them to the node by node comparison significant nodes
            obj.addSignificantValues(matrixType, nodeIndex, patientsShortestPath, healthControlsShortestPath);            
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsShortestPath, healthControlsShortestPath);
            else
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' Shortest path in both groups']);
            end
            
            
            % Number of edges in the shortest Path
            ms_mean_by_node = mean(patientsEdgesInShortestPath);
            hv_mean_by_node = mean(healthControlsEdgesInShortestPath);
            
            [h, p] = ttest2( hv_mean_by_node, ms_mean_by_node);
            
            obj.getPatientsResults(matrixType).edgesInShortestPathTtest  = h;
            obj.getPatientsResults(matrixType).edgesInShortestPathPvalue = p;
            
            obj.getHealthControlsResults(matrixType).edgesInShortestPathTtest  = h;
            obj.getHealthControlsResults(matrixType).edgesInShortestPathPvalue = p;
            
            % SIGNIFICANT VALUES
            disp('--------------');
            disp(['NUMBER OF EDGES IN SHORTEST PATH-', matrixType]);
            nodeIndex = obj.getSignificantNodesIndex(patientsEdgesInShortestPath, healthControlsEdgesInShortestPath);
            % Add them to the node by node comparison significant nodes
            obj.addSignificantValues(matrixType, nodeIndex, patientsEdgesInShortestPath, healthControlsEdgesInShortestPath);                        
            
            if(p < obj.pValueLimit)
                % If the gloabl p is significant, add the nodes to the global
                % significant values matrix
                obj.addGlobalSignificantValues(matrixType, nodeIndex, patientsEdgesInShortestPath, healthControlsEdgesInShortestPath);
            else
                disp(['There is no global significative difference in the mean values of the ', matrixType, ' number of edges in the shortest path in both groups']);
            end
            
            
            % Characteristic path length
            [h, p] = ttest2( healthControlsCharacteristicPathLength, patientsCharacteristicPathLength);
            
            obj.getPatientsResults(matrixType).characteristicPathLengthTtest  = h;
            obj.getPatientsResults(matrixType).characteristicPathLengthPvalue = p;
            
            obj.getHealthControlsResults(matrixType).characteristicPathLengthTtest  = h;
            obj.getHealthControlsResults(matrixType).characteristicPathLengthPvalue = p;
            
            if(p < obj.pValueLimit)
                %If p is significative, add the values to both significant matrix
                obj.addSignificantValues(matrixType, 1, patientsCharacteristicPathLength, healthControlsCharacteristicPathLength);
                obj.addGlobalSignificantValues(matrixType, 1, patientsCharacteristicPathLength, healthControlsCharacteristicPathLength);
            else
                disp(['There is no significative difference in the mean values of the ', matrixType, ' characteristic path length in both groups']);
            end
        end
        
        
        function patientsMatrixAnalysisResults = getPatientsResults (obj, matrixType)
            if strcmp(matrixType, 'FAMatrix') == true
                patientsMatrixAnalysisResults = obj.FApatientsResults;
            elseif strcmp(matrixType, 'SCMatrix') == true
                patientsMatrixAnalysisResults = obj.SCpatientsResults;
            end
        end
        
        function healthControlsMatrixAnalysisResults = getHealthControlsResults (obj, matrixType)
            if strcmp(matrixType, 'FAMatrix') == true
                healthControlsMatrixAnalysisResults = obj.FAhealthControlsResults;
            elseif strcmp(matrixType, 'SCMatrix') == true
                healthControlsMatrixAnalysisResults = obj.SChealthControlsResults;
            end
        end
        
        function [nodeIndex] = getSignificantNodesIndex(obj, patientsValueMatrix, hvValueMatrix)
            nodeIndex = [];
            [~, p] = ttest2( patientsValueMatrix, hvValueMatrix);
            for i = 1:length(p)
                if p(i) < obj.pValueLimit
                    nodeIndex = [nodeIndex i];
                end
            end
            if ~isempty(nodeIndex)
                disp (['Los nodos con p<0.01 son: ', num2str(nodeIndex)]);
            else
                disp('There is no significative difference in the mean values of both groups');
            end
        end
        
        %Add the correspondent significant values to the matrix
        function addSignificantValues(obj, matrixType, nodeIndex, patientsValues, hvValues)
            if ~isempty(nodeIndex)
                
                oldPatientsValues = obj.getPatientsResults(matrixType).significantValuesMatrix;
                newPatientsValues = [oldPatientsValues patientsValues(:, nodeIndex)];
                obj.getPatientsResults(matrixType).significantValuesMatrix = newPatientsValues;
                
                oldHvValues = obj.getHealthControlsResults(matrixType).significantValuesMatrix;
                newHvValues = [oldHvValues hvValues(:, nodeIndex)];
                obj.getHealthControlsResults(matrixType).significantValuesMatrix = newHvValues;
            end
        end
        
        
        %Add the correspondent significant values to the matrix
        function addGlobalSignificantValues(obj, matrixType, nodeIndex, patientsValues, hvValues)
            if ~isempty(nodeIndex)
                
                oldPatientsValues = obj.getPatientsResults(matrixType).globalSignificantValuesMatrix;
                newPatientsValues = [oldPatientsValues patientsValues(:, nodeIndex)];
                obj.getPatientsResults(matrixType).globalSignificantValuesMatrix = newPatientsValues;
                
                oldHvValues = obj.getHealthControlsResults(matrixType).globalSignificantValuesMatrix;
                newHvValues = [oldHvValues hvValues(:, nodeIndex)];
                obj.getHealthControlsResults(matrixType).globalSignificantValuesMatrix = newHvValues;
            end
        end
        
        % This function returns the common features matrix concatenating
        % the significant values from SC and FA matrixes
        function [featuresMatrix]  = getFeaturesMatrixCommon(obj)
            
            %PATIENTS
            %First, concatenate the significant values from FA and SC
            faPatientsValues = obj.getPatientsResults('FAMatrix').significantValuesMatrix;
            scPatientsValues = obj.getPatientsResults('SCMatrix').significantValuesMatrix;
            patientsValues = [faPatientsValues scPatientsValues];
            
            %Then add a column to specify the class to which each row
            %belongs - in this case ms
            classes = cell(size(patientsValues, 1), 1);
            classes(:) = {'ms'};
            patientsValues = [num2cell(patientsValues) classes];
            
            %HEALTHY VOLUNTEERS
            %First, concatenate the significant values from FA and SC
            faHvValues = obj.getHealthControlsResults('FAMatrix').significantValuesMatrix;
            scHvValues = obj.getHealthControlsResults('SCMatrix').significantValuesMatrix;
            healthControlsValues = [faHvValues scHvValues];
            
            %Then add a column to specify the class to which each row
            %belongs - in this case hv
            classes = cell(size(healthControlsValues, 1), 1);
            classes(:) = {'hv'};
            healthControlsValues = [num2cell(healthControlsValues) classes];
            
            %Finally, store both groups in the same matrix
            featuresMatrix = [patientsValues; healthControlsValues];
            
        end
        
        function [featuresMatrix]  = getFeaturesMatrix(obj, matrixType)
            
            %PATIENTS
            %First get the significant values of the nodes
            patientsValues = obj.getPatientsResults(matrixType).significantValuesMatrix;
            
            %Then add a column to specify the class to which each row
            %belongs - in this case ms
            classes = cell(size(patientsValues, 1), 1);
            classes(:) = {'ms'};
            patientsValues = [num2cell(patientsValues) classes];
            
            %HEALTHY VOLUNTEERS
            %First get the significant values of the nodes
            healthControlsValues = obj.getHealthControlsResults(matrixType).significantValuesMatrix;
            
            %Then add a column to specify the class to which each row
            %belongs - in this case hv
            classes = cell(size(healthControlsValues, 1), 1);
            classes(:) = {'hv'};
            healthControlsValues = [num2cell(healthControlsValues) classes];
            
            %Finally, store both groups in the same matrix
            featuresMatrix = [patientsValues; healthControlsValues];
            
        end
        
        function [featuresMatrix]  = getGlobalSignificantFeaturesMatrix(obj, matrixType)
            
            %PATIENTS
            %First get the significant values of the nodes
            patientsValues = obj.getPatientsResults(matrixType).globalSignificantValuesMatrix;
            
            %Then add a column to specify the class to which each row
            %belongs - in this case ms
            classes = cell(size(patientsValues, 1), 1);
            classes(:) = {'ms'};
            patientsValues = [num2cell(patientsValues) classes];
            
            %HEALTHY VOLUNTEERS
            %First get the significant values of the nodes
            healthControlsValues = obj.getHealthControlsResults(matrixType).globalSignificantValuesMatrix;
            
            %Then add a column to specify the class to which each row
            %belongs - in this case hv
            classes = cell(size(healthControlsValues, 1), 1);
            classes(:) = {'hv'};
            healthControlsValues = [num2cell(healthControlsValues) classes];
            
            %Finally, store both groups in the same matrix
            featuresMatrix = [patientsValues; healthControlsValues];
            
        end
        
    end
    
end

