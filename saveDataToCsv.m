function saveDataToCsv( featuresMatrix, hasHeaders, fileName)
%SAVE_DATA_TO_CSV This function stores data in a csv file
% 
% Inputs: 
%   featuresMatrix =  cell matrix containing the values of each feature,
%                     and the last column is the observation class
% 
%   hasHeaders     = 1 if the featuresMatrix has headers 
%                    0 if it doesnt. In this case, the columns will be renamed
%                      to 'ColumnN', being N the column number.
%                
%   fileName       = the name of the file without the extension (.csv) 
%   


% Create column names if the featuresMatrix doesn't have
if( hasHeaders == 0 )
    columnNames = cell(1, size(healthControlsValues, 2));
    for i = 1: length(columnNames)
        columnNames{i} = ['Column', num2str(i)];
    end
    featuresMatrix = [columnNames; featuresMatrix];
end

% Convert cell to a table and use first row as variable names
table = cell2table(featuresMatrix(2:end,:),'VariableNames', featuresMatrix(1,:));
 
% Write the table to a CSV file
fileName = [fileName, '.csv'];
writetable(table, fileName);

end

