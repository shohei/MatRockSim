# Todo
- パラシュートのシミュレーションの改善（風が全く関係ない）
-  パラシュートのシミュレーション時間刻みが大きい？
-  推力をEngファイルから読み込めるようにする


# MatRockSim

Matlab Rocket Flight Simulator

6自由度のロケットフライトシミュレーター。水平座標系での飛翔をシミュレーション。

## 実行
Matlab/OctaveでMatRockSimフォルダ内で下記コマンドで実行。

    MatRockSim


## パラメータ設定
- params.mファイルの中身を変更
- aerodynamics/cd_Rocket.mファイルを変更することによって抗力係数の変更

## Future Works
- 推力データの読み込み
- 慣性モーメントの時間変化。（推力とXdotなどの連携）
- 圧力中心の遷移(Barrowman method??, マッハ数依存の空力モーメント係数 ??)
- 上空の風の変化に対応
- GPSシミュレータやGoogle Earthに読み込み可能にデータダンプ