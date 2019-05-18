classdef Cohort < handle
    %Cohort
    
    properties
        patients
        healthControls
        
        FApatientsResults
        FAhealthControlsResults
        
        SCpatientsResults
        SChealthControlsResults
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
        end
        
        function showPlots(obj)
            %Strength
            strengthsLinePlot(obj, 'FAMatrix');
            strengthsLinePlot(obj, 'SCMatrix');
            strengthsBoxPlot(obj, 'FAMatrix');
            strengthsBoxPlot(obj, 'SCMatrix');
            
            %Degrees
%             degreesLinePlot(obj, 'FAMatrix');
%             degreesLinePlot(obj, 'SCMatrix');
%             degreesBoxPlot(obj, 'FAMatrix');
%             degreesBoxPlot(obj, 'SCMatrix');
        end
        
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
            plot(hv_mean_by_node, 'k-o', 'MarkerFaceColor', 'k', 'MarkerSize', 4,'LineWidth', 2);
            title(plotTitle);
            hold on;
            plot(ms_mean_by_node, 'b-o', 'MarkerFaceColor', 'b', 'MarkerSize', 4, 'LineWidth', 2);
            legend('hv', 'ms');
            ylabel('Mean strength');
            xlabel('Nodes');
            
            % Plot the hub limits
            plot(hubLimitHealthControls*ones(80), 'k', 'LineWidth', 2);
            plot(hubLimitPatients*ones(80), 'b', 'LineWidth', 2);
 
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
        
        function evaluateCohort(obj)
            evaluateFAMatrix(obj)
            evaluateSCMatrix(obj)
        end
        
        function evaluateFAMatrix(obj)
            evaluateStrengthsFAMatrix(obj);
            evaluateDegreesFAMatrix(obj);
        end
        
        function evaluateSCMatrix(obj)
            evaluateStrengthsSCMatrix(obj);
            evaluateDegreesSCMatrix(obj);
        end
        
        
        function evaluateStrengthsFAMatrix(obj)
            % First evaluate the strength in the PATIENTS group
            for i = 1:length(obj.patients)
                patientsStrengths(i,:) = obj.patients(i).FAMatrix.strengths;
            end
            obj.FApatientsResults.strengthMean = mean2(patientsStrengths);
            obj.FApatientsResults.strengthSd = std2(patientsStrengths);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsStrengths(i,:) = obj.healthControls(i).FAMatrix.strengths;
            end
            obj.FAhealthControlsResults.strengthMean = mean2(healthControlsStrengths);
            obj.FAhealthControlsResults.strengthSd = std2(healthControlsStrengths);
            
            % Perform the t-test
            [obj.FApatientsResults.strengthTtest, obj.FApatientsResults.strengthPvalue] = ttest2( mean(healthControlsStrengths, 2), mean(patientsStrengths,2));
            [obj.FAhealthControlsResults.strengthTtest, obj.FAhealthControlsResults.strengthPvalue] = ttest2( mean(healthControlsStrengths, 2), mean(patientsStrengths,2));
        end
        
        function evaluateStrengthsSCMatrix(obj)
            % First evaluate the strength in the patients group
            for i = 1:length(obj.patients)
                patientsStrengths(i,:) = obj.patients(i).SCMatrix.strengths;
            end
            obj.SCpatientsResults.strengthMean = mean2(patientsStrengths);
            obj.SCpatientsResults.strengthSd = std2(patientsStrengths);
            
            % Then evaluate the health controls group
            for i = 1:length(obj.healthControls)
                healthControlsStrengths(i,:) = obj.healthControls(i).SCMatrix.strengths;
            end
            obj.SChealthControlsResults.strengthMean = mean2(healthControlsStrengths);
            obj.SChealthControlsResults.strengthSd = std2(healthControlsStrengths);
            
            % Perform the t-test
            [obj.SCpatientsResults.strengthTtest, obj.SCpatientsResults.strengthPvalue] = ttest2( mean(healthControlsStrengths, 2), mean(patientsStrengths,2));
            [obj.SChealthControlsResults.strengthTtest, obj.SChealthControlsResults.strengthPvalue] = ttest2( mean(healthControlsStrengths, 2), mean(patientsStrengths,2));
        end
        
        function evaluateDegreesFAMatrix(obj)
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsDegrees(i,:) = obj.patients(i).FAMatrix.degrees;
            end
            obj.FApatientsResults.degreesMean = mean2(patientsDegrees);
            obj.FApatientsResults.degreesSd = std2(patientsDegrees);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsDegrees(i,:) = obj.healthControls(i).FAMatrix.degrees;
            end
            obj.FAhealthControlsResults.degreesMean = mean2(healthControlsDegrees);
            obj.FAhealthControlsResults.degreesSd = std2(healthControlsDegrees);
            
            % Perform the t-test
            [obj.FApatientsResults.degreesTtest, obj.FApatientsResults.degreesPvalue] = ttest2( mean(healthControlsDegrees, 2), mean(patientsDegrees,2));
            [obj.FAhealthControlsResults.degreesTtest, obj.FAhealthControlsResults.degreesPvalue] = ttest2( mean(healthControlsDegrees, 2), mean(patientsDegrees,2));
        end
        
        function evaluateDegreesSCMatrix(obj)
            % First evaluate the PATIENTS group
            for i = 1:length(obj.patients)
                patientsDegrees(i,:) = obj.patients(i).SCMatrix.degrees;
            end
            obj.SCpatientsResults.degreesMean = mean2(patientsDegrees);
            obj.SCpatientsResults.degreesSd = std2(patientsDegrees);
            
            % Then evaluate the HEALTH CONTROLS group
            for i = 1:length(obj.healthControls)
                healthControlsDegrees(i,:) = obj.healthControls(i).SCMatrix.strengths;
            end
            obj.SChealthControlsResults.degreesMean = mean2(healthControlsDegrees);
            obj.SChealthControlsResults.degreesSd = std2(healthControlsDegrees);
            
            % Perform the t-test
            [obj.SCpatientsResults.degreesTtest, obj.SCpatientsResults.degreesPvalue] = ttest2( mean(healthControlsDegrees, 2), mean(patientsDegrees,2));
            [obj.SChealthControlsResults.degreesTtest, obj.SChealthControlsResults.degreesPvalue] = ttest2( mean(healthControlsDegrees, 2), mean(patientsDegrees,2));

        end
        
    end
    
end

