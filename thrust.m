% ----
% „—Í—š—ð
% @param t: Œ»ÝŽž[sec] (1x1)
% @param Tend: ”RÄI—¹Žž[sec] (1x1)
% @param FT: „—Í[N] (1x1)
% @return ft: „—Í[N] (1x1)
% ----
function ft = thrust(t, Tends, FT)
	ft = 0.0;
	if t < Tends
		ft = FT;
	end
end