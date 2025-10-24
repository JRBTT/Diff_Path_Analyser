% Module: readFile
% Author: Jason Buntting
% Function: Reads and returns .xls data
% Date: 24/10/25

function data = readFile(fileName)
    
    % chceck if it is a file
    if ~isfile(fileName)
        error('File not found: %s', fileName)
    end
    
    % check if it is an excel file
    [~,~,ext] = fileparts;
    validExts = {'.xls', '.xlsx', '.xlsm'};
    if ~ismember(lower(ext), validExts)
        error('File must be an Excel file (.xls, .xlsx, or .xlsm).');
    end

    % check sheet
    [~, sheets] = xlsfinfo(filename);
    if isempty(sheets)
        error('No readable sheets found in %s.', filename);
    end

    % Default: read the first sheet
    sheetName = sheets{1};

    try
        % Read Excel data
        data = readtable(filename, 'Sheet', sheetName);
    catch ME
        error('⚠️ Failed to read sheet "%s": %s', sheetName, ME.message);  
    end

    % Check and fix invalid headers
    data.Properties.VariableNames = matlab.lang.makeValidName( ...
        data.Properties.VariableNames);
    
    % Print summary for user awareness
    fprintf('✅ Read %d rows from sheet "%s" in %s\n', ... 
        height(data), sheetName, filename);

end