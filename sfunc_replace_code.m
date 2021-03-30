function sfunc_replace_code(templateFilePath, srcFilePath, conversionPairs)
assert(ischar(templateFilePath));
assert(ischar(srcFilePath));
assert(iscell(conversionPairs));

if exist(srcFilePath, 'file')
    delete(srcFilePath);
end

fidR = fopen(templateFilePath);
assert(fidR >= 3, '[ERROR] File open error: %s', templateFilePath);
cleanupObjR = onCleanup(@() fclose(fidR));

fidW = fopen(srcFilePath, 'wt');
assert(fidW >= 3, '[ERROR] File open error: %s', srcFilePath);
cleanupObjW = onCleanup(@() fclose(fidW));

while ~feof(fidR)
    line = fgetl(fidR);
    newLine = replace_sfunc_info(line, conversionPairs);
    fprintf(fidW, '%s\n', newLine);
end
end

function line = replace_sfunc_info(line, conversionPairs)
pairNum = height(conversionPairs);

for i=1:pairNum
    oldText = conversionPairs{i, 1};
    newText = conversionPairs{i, 2};
    line = strrep(line, oldText, newText);
end
end
