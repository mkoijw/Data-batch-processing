function data = dataprocess(MODA_SC_1B_filename, MAGA_LR_1B_filename)
cd('E:\EPofGM\Data_batch_processing\code')
infilePath = 'E:\EPofGM\Global_geomagnetic_model\WMM2020\WMM2020_Windows\WMM2020_Windows\bin\input.txt';
outfilePath = 'E:\EPofGM\Global_geomagnetic_model\WMM2020\WMM2020_Windows\WMM2020_Windows\bin\output.txt';

%% 从sp3文件提取位置 ITRF km
[Pos, ~] = sp32Pos(MODA_SC_1B_filename);
%% 将位置转为WMM_file.exe输入格式
fileID = fopen(infilePath, 'w');
date = '2024.8';
altitude_type = 'E';
lla_data = itrf2lla(Pos);
for i = 1:size(lla_data, 1)
    altitude = lla_data(i, 3);
    latitude = lla_data(i, 1);
    longitude = lla_data(i, 2);
    % 生成字符串并写入文件
    fprintf(fileID, '%s %s M%f %f %f\n', date, altitude_type, altitude, latitude, longitude);
end
fclose(fileID);
%% 运行WMM_file.exe
% 更改当前目录
cd('E:\EPofGM\Global_geomagnetic_model\WMM2020\WMM2020_Windows\WMM2020_Windows\bin');

% 执行命令
[status, cmdout] = system('WMM_file f input.txt output.txt');

% 检查命令是否成功执行
if status == 0
    disp('命令成功执行');
    disp(cmdout); % 显示命令输出
else
    disp('命令执行失败');
    disp(cmdout); % 显示错误信息
end
cd('E:\EPofGM\Data_batch_processing\code');
%% 提取WMM2020模型输出
% 读取表格数据
WMM2020_data = readtable(outfilePath, 'VariableNamingRule', 'preserve');
WMM2020_B_NEC = WMM2020_data(:,11:13);
WMM2020_B_NEC = table2array(WMM2020_B_NEC);
%% 从cdf文件提取B NEC nT
B_NEC_cell = cdf2B_NEC(MAGA_LR_1B_filename);
B_NEC = horzcat(B_NEC_cell{:})';
%% 组合位置,磁矢量，WMM磁矢量，WMM_error
% WMM_error = B_NEC(19:86400,:) - WMM2020_B_NEC(1:86382,:);
% %Pos是0 0 18开始 B_NEC是0 0 0开始
% trainData = [Pos(1:86382,:),B_NEC(19:86400,:),WMM2020_B_NEC(1:86382,:),WMM_error];
WMM_error = B_NEC - WMM2020_B_NEC;
data = [Pos, B_NEC, WMM2020_B_NEC, WMM_error];
