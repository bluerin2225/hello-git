% S-Function化モデル作成ツール
% 事前準備：
%   本スクリプトを任意の場所に格納し、MATLABでその場所のパスを設定する。
% 使用方法：
%   1) S-Function化情報を記入したsfunc_info.xlsxを用意する。
%   2) 1)で用意したファイルをS-Function化対象の関数を含んだCファイルが
%      格納されたフォルダに格納する。
%   3) 2)のフォルダへ移動する。
%   4) コマンド「sfunc_gen」を実行する。
% 出力ファイル：
%   TBD
% 参考：
%   https://jp.mathworks.com/help/simulink/sfg/example-of-a-basic-c-mex-s-function.html
function sfunc_gen()
    curr = pwd;
    sFuncInfoFilePath = fullfile(curr, 'sfunc_info.xlsx');
    sFuncInfo = load_sfunc_info(sFuncInfoFilePath);
end

function sFuncInfo = load_sfunc_info(sFuncInfoFilePath)
    sFuncInfo.SFunctionName = '';
    sFuncInfo.SourceFilePath = '';
    sFuncInfo.NumOfInports = 0;
    sFuncInfo.Inports = [];
    sFuncInfo.NumOfOutports = 0;
    sFuncInfo.Outports = [];

    [~, ~, raw] = xlsread(sFuncInfoFilePath);
    rowNum = height(raw);
    
    for row=1:rowNum
        name = raw{row, 1};
        val = raw{row, 2};
        
        switch name
            case 'SFunctionName'                
                sFuncInfo.SFunctionName = val;
                
            case 'SourceFilePath'
                sFuncInfo.SourceFilePath = val;

            case 'NumOfInports'
                sFuncInfo.NumOfInports = val;

            case 'Inport'
                sFuncInfo.Inports = [sFuncInfo.Inports; val];

            case 'NumOfOutports'
                sFuncInfo.NumOfOutports = val;

            case 'Outport'
                sFuncInfo.Outports = [sFuncInfo.Outports; val];

            otherwise
                fprintf('[WARNING] Unexpected name %s is found.\n', name);
        end
    end
    
    if ~iscell(sFuncInfo.Inports)
        sFuncInfo.Inports = {sFuncInfo.Inports};
    end
    
    if ~iscell(sFuncInfo.Outports)
        sFuncInfo.Outports = {sFuncInfo.Outports};
    end
end
