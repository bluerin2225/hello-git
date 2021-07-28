function sortedSubsystemList = sortSubsystemByPosition(subsystemList)

    % サブシステムの数分のIndexを作成する。
    indexList = initIndexList(subsystemList);

    % ソート用データをソートする。
    indexList = sortIndexList(indexList);

    % ソートされたインデックスのリストでサブシステムをソートする。
    sortedSubsystemList = sortSubsystemList(subsystemList, indexList);
end

% ソート用データの初期化。Indexには先頭から順に1、2、...と要素の位置の数値が格納される。
function indexList = initIndexList(subsystemList)
indexList = [];
n = length(subsystemList);
for i=1:n
    data = [];
    data.Index = i;
    [data.Left, data.Top, ~, ~] = get_param(subsystemList{i}, 'Position');
    indexList = [indexList data];
end
end

% ソート用データをソートする。
function indexList = sortIndexList(indexList)
    indexNum = length(indexList);

    % ブロック線図内のサブシステムの位置でソートする。
    % 左上⇒右下の順となるようにソートする。
    for i=1:indexNum
        for j=indexNum:-1:i+1
            data1 = indexList(j-1);
            data2 = indexList(j);
            
            if data1.Top > data2.Top
                % data1の方がブロック線図の下の位置にあるのでdata2と入れ替える
                indexList(j-1) = data2;
                indexList(j) = data1;
            elseif data1.Top == data2.Top
                % 同じTop位置にある場合はLeft位置で左にある方を先に持ってくる
                if data1.Left > data2.Left
                    indexList(j-1) = data2;
                    indexList(j) = data1;
                end
            end
        end
    end
end

% ソートされたインデックスのリストでサブシステムをソートする。
function sortedSubsystemList = sortSubsystemList(subsystemList, indexList)
    sortedSubsystemList = [];
    n = length(indexList);
    for i=1:n
        data = indexList(i);
        sortedSubsystemList{i} = subsystemList{data.Index};
    end
end
