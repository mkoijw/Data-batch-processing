function [DAY]=JD2000(JEAR,MONTH,KDAY,JHR,MI,SEC)
%  计算自2000年1月1.5日0时0分0秒起算的儒略日
%
% 输入  计算的时刻,  其中:
%      JYEAR=年分, 4位整数;   MONTH=月分,  2位整数   KDAY=日期,  2位整数;  JHR=时,  2 位整;
%      MI=分,  2位整数  ; SEC=秒  实数
% 输出:计算时刻的自2000.0的积日
JJ=fix((14-MONTH)/12);
L=JEAR-JJ-1900*fix((JEAR/1900))+100*fix((2000/(JEAR+1951)));
DAY=KDAY-36496+fix((1461*L)/4)+fix((367*(MONTH-2+JJ*12))/12);
DAY=DAY+((JHR*60+MI)*60+SEC)/86400-0.5;