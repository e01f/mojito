% 	voutpp1 ?[0,0.5], möglichst klein
%	voutpp2 ?[0,0.5], möglichst klein
%	voutpp3 ?[0,0.5], möglichst klein
%	voutpp4 ?[0,0.5], möglichst klein
%	toutzc1 ?[0.9/f_Test,1.1/f_Test], möglichst genau 1/f_Test
%	toutzc2 ?[1.4/f_Test,1.6/f_Test], möglichst genau 1.5/f_Test
%	toutzc3 ?[1.9/f_Test,2.1/f_Test], möglichst genau 2/f_Test
%	toutzc4 ?[2.4/f_Test,2.6/f_Test], möglichst genau 2.5/f_Test
%   toutzc1d, -0.1, 0.1
%   toutzc2d, -0.1, 0.1
%   toutzc3d, -0.1, 0.1
%   toutzc4d, -0.1, 0.1

s(1).name = 'voutpp1';
s(1).min = 0;
s(1).max = 0.5;
s(1).goal = 0;
s(2).name = 'voutpp2';
s(2).min = 0;
s(2).max = 0.5;
s(2).goal = 0;
s(3).name = 'voutpp3';
s(3).min = 0;
s(3).max = 0.5;
s(3).goal = 0;
s(4).name = 'voutpp4';
s(4).min = 0;
s(4).max = 0.5;
s(4).goal = 0;

f_Test = 1000;

s(5).name = 'toutzc1';
s(5).min = 0.9/f_Test;
s(5).max = 1.1/f_Test;
s(5).goal = 1/f_Test;
s(6).name = 'toutzc2';
s(6).min = 1.4/f_Test;
s(6).max = 1.6/f_Test;
s(6).goal = 1.5/f_Test;
s(7).name = 'toutzc3';
s(7).min = 1.9/f_Test;
s(7).max = 2.1/f_Test;
s(7).goal = 2/f_Test;
s(8).name = 'toutzc4';
s(8).min = 2.4/f_Test;
s(8).max = 2.6/f_Test;
s(8).goal = 2.5/f_Test;

f_Test2 = 89;

s(9).name = 'toutzc1-2';
s(9).min = 0.9/f_Test2;
s(9).max = 1.1/f_Test2;
s(9).goal = 1/f_Test2;
s(10).name = 'toutzc2-2';
s(10).min = 1.4/f_Test2;
s(10).max = 1.6/f_Test2;
s(10).goal = 1.5/f_Test2;
s(11).name = 'toutzc3-2';
s(11).min = 1.9/f_Test2;
s(11).max = 2.1/f_Test2;
s(11).goal = 2/f_Test2;
s(12).name = 'toutzc4-2';
s(12).min = 2.4/f_Test2;
s(12).max = 2.6/f_Test2;
s(12).goal = 2.5/f_Test2;

s(13).name = 'toutzc1d';
s(13).min = -0.1;
s(13).max = 0.1;
s(13).goal = 0.0;
s(14).name = 'toutzc2d';
s(14).min = -0.1;
s(14).max = 0.1;
s(14).goal = 0.0;
s(15).name = 'toutzc3d';
s(15).min = -0.1;
s(15).max = 0.1;
s(15).goal = 0.0;
s(16).name = 'toutzc4d';
s(16).min = -0.1;
s(16).max = 0.1;
s(16).goal = 0.0;
