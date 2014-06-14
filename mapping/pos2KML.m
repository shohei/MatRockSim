% ----
% ECEF座標系における機体の位置、射点の位置からGoogle Earthに読み込めるように
% KMLファイル形式に変換し、outputフォルダに出力する。
% @param filename 出力するファイル名(string)
% @param u, e, n ECEF座標系での機体の位置Up-East-Northの順番[m]
% @param xr, yr, zr ECEF座標系での射点の位置Up-East-Northの順番[m]
% @return str KMLファイルの中身を出力
% ----
% Future Work
% TimeStampタグとPointタグを使ってPlacemarkアイコンをアニメーションさせる。
% パラシュート解散時などイベント事に色を変える。
% ----
function str = pos2KML( filename, u, e, n, xr, yr, zr )

fileaddress = strcat('output/',filename,'.kml');
[fid, msg] = fopen(fileaddress, 'w');

string1 = ['<?xml version="1.0" encoding="UTF-8"?>\n'...
	'<kml xmlns="http://www.opengis.net/kml/2.2"> <Document>\n'...
	'\t<name>Flight Paths</name>\n'...
	'\t<description>Rocket Flight Paths.</description>\n'...
	'\t<Style id="yellowLineGreenPoly">\n'...
	'\t<LineStyle>\n'...
	'\t\t<color>7f00ffff</color>\n'...
	'\t\t<width>4</width>\n'...
	'\t</LineStyle>\n'...
	'\t<PolyStyle>\n'...
	'\t\t<color>7f00ff00</color>\n'...
	'\t</PolyStyle>\n'...
	'\t</Style>\n'...
	'\t<Placemark>\n'...
	'\t\t<name>Absolute Extruded</name>\n'...
	'\t\t<description>Transparent green wall with yellow outlines</description>\n'...
	'\t\t<styleUrl>#yellowLineGreenPoly</styleUrl>\n'...
	'\t\t<LineString>\n'...
	'\t\t\t<extrude>1</extrude>\n'...
	'\t\t\t<tessellate>1</tessellate>\n'...
	'\t\t\t<altitudeMode>absolute</altitudeMode>\n'...
	'\t\t\t<coordinates>\n'];

% ---- 座標生成 ----
[ecef_x, ecef_y, ecef_z] = launch2ecef(u, e, n, xr, yr, zr);
[phi, lambda, h] = ecef2blh(ecef_x, ecef_y, ecef_z);
string2 = '';
for i = 1:length(phi)
	% KMLのcoordinatesタグは経度、緯度、高度の順番
	string = sprintf('\t\t\t%.6f,%.6f,%.2f', lambda(i), phi(i), h(i));
	string2 = strcat(string2, string, '\n');
end
% ---- 座標生成終了 ----

string3 = ['\t\t\t</coordinates>\n'...
	'\t</LineString> </Placemark>\n'...
	'</Document> </kml>'];

% ---- ファイル出力 ----
fprintf(fid, string1);
fprintf(fid, string2);
fprintf(fid, string3);
fclose(fid);
% ---- 関数出力 ----
str = strcat(string1, string2, string3);