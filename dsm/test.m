% 目的：DSMの使われ方を調査する
% 要VARIANT切替
% 対象モデル内のすべてのDSMを列挙する
% 対象モデル内のすべてのDSR/DSWの使用箇所、使用順序、接続されているSubsystemを抽出する




cmds = {'diary(''t2.txt'')', 'elist gcs', 'diary(''off'')', 'quit'};
simOut = sim('untitled','debug',cmds);
