% Excelの終了はユーザーに任せる
function xopen()
    wbs = [];
    wb = [];
    
    getLastSelectedFolderPath();
    %filePath = fullfile(pwd, 'test.xlsx');

    persistent lastSelectedFolderPath;  %選択したファイルのパス保持
    %lastSelectedFolderPath = 'C:\Users\tomonori\Downloads\';

    filterExt = '*.xl*;*.xlsx;*.xlsm';
    %filterName = 'Excel ファイル (*.xls,*.xlsx,*.xlsm)';
    
    if ~isempty(lastSelectedFolderPath) && exist(lastSelectedFolderPath, 'dir')
        [fileName, lastSelectedFolderPath] = uigetfile([lastSelectedFolderPath, filterExt]);
    else
        [fileName, lastSelectedFolderPath] = uigetfile(filterExt);
    end
    
    if isequal(fileName, 0)
        return;
    end

    filePath = fullfile(lastSelectedFolderPath, fileName);
    disp(['User selected ', filePath]);

    return; %debug
    
    try
        excelApp = actxserver('Excel.Application');
        excelApp.Visible = 1;
    catch me
        disp(getReport(me));
        return;
    end
    
    try
        wbs = excelApp.Workbooks;
        wb = wbs.Open(filePath);
    catch me
        disp(getReport(me));
    end

    releaseComObj(wbs);
    releaseComObj(wb);
    releaseComObj(excelApp);
end

function releaseComObj(obj)
    try
        if ~isempty(obj)
            obj.release();
        end
    catch me
        % 万一、上のobj.release()で例外が発生した場合に、
        % 後続のreleaseComObj()の呼び出しが行われなくなるのを防ぐため、
        % 例外はここで握りつぶす。
        disp(getReport(me));
    end
end

function getLastSelectedFolderPath()
    [scriptFolderPath, ~, ~] = fileparts(mfilename('fullpath'));
    settingFolderPath = fullfile(scriptFolderPath, 'settings');
    lastSelectedFolderFilePath = fullfile(settingFolderPath, 'LastSelectedFolderPath.txt');
    lastSelectedFolderPath = '';
    
    if ~exist(settingFolderPath, 'dir')
        mkdir(settingFolderPath);
    end
    
    if exist(lastSelectedFolderFilePath, 'file')
        lines = readLines(filePath);
        if ~isempty(lines)
            lastSelectedFolderPath = lines{1};
        end
    else
        writeLines(lastSelectedFolderFilePath, []);
    end
end

function lines = readLines(filePath)
    lines = [];
    
    try
        fid = fopen(filePath);
        assert(fid >= 3, '[ERROR] Failed to open %s. (fid=%d)\n', filePath, fid);
    catch me
        fprintf('[ERROR] Failed to read %s: \n%s\n', filePath, getReport(me));
    end
    
    try
        while ~feof(fid)
            line = fgetl(fid);
            lines = [lines; strtrim(line)];
        end
    catch me
        fprintf('[ERROR] Error occurred while reading from %s\n%s\n', filePath, getReport(me));
    end
    
    fclose(fid);
    
    if ~iscell(lines)
        lines = {lines};
    end
end

% linesが空の場合でも中身は空でファイルを作成する。
function writeLines(filePath, lines)
    try
        fid = fopen(filePath, 'wt');
        assert(fid >= 3, '[ERROR] Failed to open %s. (fid=%d)\n', filePath, fid);
    catch me
        fprintf('[ERROR] Failed to read %s: \n%s\n', filePath, getReport(me));
    end
    
    try
        n = length(lines);
        for i=1:n
            fprintf(fid, '%s\n', lines{i});
        end
    catch me
        fprintf('[ERROR] Error occurred while writing to %s\n%s\n', filePath, getReport(me));
    end
    
    fclose(fid);
end
