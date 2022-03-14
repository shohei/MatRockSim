% ----
% 推力履歴
% @param t: 現在時刻[sec] (1x1)
% @param thrust_data: 推力データ 推力配列 (.engファイルより読み込み）
% @param thrust_t: 推力データ 時刻配列 (.engファイルより読み込み）
% @return ft: 推力[N] (1x1)
% ----
function ft = thrust(t, thrust_data, thrust_t)
	ft = 0.0;
    Tends = thrust_t(end);
	if t < Tends
		ft = interp1(thrust_t, thrust_data, t);
	end
end
