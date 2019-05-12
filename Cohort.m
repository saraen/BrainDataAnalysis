classdef Cohort < handle
    %Cohort
    
    properties
        patients
        healthControls
    end
    
    methods
        
        % Constuctor
        function obj = Cohort
            obj.patients = [];
            obj.healthControls = [];
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
        
        function analizePersonsVector(obj, personsVector)
            for i = 1:length(personsVector)
                personsVector(i).analize();
            end
        end
        
    end
    
end

