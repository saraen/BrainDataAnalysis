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
            
        end
        
        function evaluateCohort(obj)
            evaluateFAMatrix(obj)
            evaluateSCMatrix(obj)
        end
        
        function evaluateFAMatrix(obj)
            evaluateStrengthsFAMatrix(obj);
        end
        
        function evaluateSCMatrix(obj)
            evaluateStrengthsSCMatrix(obj);
            
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
        
        
    end
    
end

