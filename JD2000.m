function [DAY]=JD2000(JEAR,MONTH,KDAY,JHR,MI,SEC)
%  ������2000��1��1.5��0ʱ0��0�������������
%
% ����  �����ʱ��,  ����:
%      JYEAR=���, 4λ����;   MONTH=�·�,  2λ����   KDAY=����,  2λ����;  JHR=ʱ,  2 λ��;
%      MI=��,  2λ����  ; SEC=��  ʵ��
% ���:����ʱ�̵���2000.0�Ļ���
JJ=fix((14-MONTH)/12);
L=JEAR-JJ-1900*fix((JEAR/1900))+100*fix((2000/(JEAR+1951)));
DAY=KDAY-36496+fix((1461*L)/4)+fix((367*(MONTH-2+JJ*12))/12);
DAY=DAY+((JHR*60+MI)*60+SEC)/86400-0.5;