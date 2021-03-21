% 目的:ファイル処理での例外に対して確実にファイルクローズするコードのテンプレートを作りたい。
% 理由:毎度例外処理を検討するのは面倒。テンプレートを作ることで素早く品質の高いコードを作りたい。
% 前提：
% 1. fopenの第一引数は開くファイルの名前とする。
%    -> fopenは'all'やファイル識別子も引数として受け取れるが、今まで使用する機会が無かったこともあり、
%       それらを使用した場合の例外処理は検討対象外とする。
%
% 考慮が必要なこと：
% 1. fopen内で例外発生。
%    -> 引数が対応していない型だと例外が発生する。
%       対応している型は文字行ベクトルまたはstringスカラー。
%       1つの要素しかない string配列を"stringスカラー"と呼ぶ。
% 2. fopenの戻り値が無効なファイル識別子。
%    -> 3 以上の整数が有効なファイル識別子。
%       ファイル識別子 0、1 および 2はそれぞれ、標準入力、標準出力 (画面) および標準エラー用に予約されている。
%       fopen でファイルを開けない場合、ファイル識別子は-1が返される。
%
% 参考URL:
% https://jp.mathworks.com/help/matlab/ref/fopen.html
% https://jp.mathworks.com/help/matlab/ref/string.html
function file_open_exception_handling()
    filePath = fullfile(pwd, 'test_file.txt');
    fprintf('[INFO] テスト用ファイルのパス：%s\n', filePath);

    disp('[INFO] テスト前にテスト用ファイルを削除する。');

    if exist(filePath, 'file')
        delete(filePath);
    end
    
    disp('[TEST] 存在しないファイルをオープンする。');

    try
        fid = fopen(filePath);
        fprintf('fid = %d\n', fid);
        % 何もしないでクローズ
        fclose(fid);
    catch me
        disp(getReport(me));
    end

    disp('[INFO] テスト用ファイルを作成する。');
    
    fid = fopen(filePath, 'w');
    fclose(fid);

    disp('[TEST] 存在するファイルをオープンする。');

    try
        fid = fopen(filePath);
        fprintf('fid = %d\n', fid);
        % 何もしないでクローズ
        fclose(fid);
    catch me
        disp(getReport(me));
    end

    disp('[INFO] ここから例外処理検討用。');

    disp('1. fopen内で例外発生。');
    disp('   -> 第一引数としてcellを渡す。');
    
    filePath = {filePath};

    try
        fid = fopen(filePath);
        
        % ファイル処理

        % 正常系のファイルクローズ
        fclose(fid);
        
    catch me
        %if exist('fid', 'var') && fid >= 3
            % 異常系のファイルクローズ
            % fopenで例外発生した場合はfidが存在しない。
            % 
            fclose(fid);
        %end
    end
    
    try
        clear fid;
        fid = fopen(filePath);
        fprintf('fid = %d\n', fid);
        % 何もしないでクローズ
        fclose(fid);
    catch me
        fprintf('fidが存在するかどうか: %d\n', exist('fid', 'var'));
        disp(getReport(me));
    end
    
    % オープンで一旦区切る
    try
        [fid, msg] = fopen(filePath);
        % 直接fidを判断していない。msgが偶然emptyになる可能性があったりして。
        assert(isempty(msg), msg);
    catch me
        rethrow(me);
        % ファイルが存在しない場合、下記エラーとなり、エラーの内容がショボい。
        % 念のため表示してもよいかもしれない。
        % エラー: test (行 15)
        % No such file or directory
    end
  
    try
        % ファイル処理
    catch me
        fclose(fid);
    end
 
        
end

function ret = raiseError()
    error('Error has been raised!!!');
end
