clear
close
clc
MODA_SC_1B_filename = 'E:\EPofGM\SwarmData\Sat_A\20150522\SW_OPER_MODA_SC_1B_20150522T000000_20150522T235959_0502.sp3';
MAGA_LR_1B_filename = 'E:\EPofGM\SwarmData\Sat_A\20150522\SW_OPER_MAGA_LR_1B_20150522T000000_20150522T235959_0602_MDR_MAG_LR.cdf';
saveData_filename = ['E:\ai_software\SWARM simulation_ecef\' ...
                     'swarm 20150522'];
time = linspace(1,86400,86400)';
%% 从sp3文件提取位置 ITRF km
[Pos, V] = sp32Pos(MODA_SC_1B_filename);
%% 从cdf文件提取B NEC nT
B_NEC_cell = cdf2B_NEC(MAGA_LR_1B_filename);
B_NEC = horzcat(B_NEC_cell{:})';
%% 组合数据
data = [time B_NEC Pos V]; 
writematrix(data, saveData_filename, 'Delimiter', '	');

