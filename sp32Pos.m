function [Pos, V] = sp32Pos(MODA_SC_1B_filename)
% 打开 SP3 文件
fid = fopen(MODA_SC_1B_filename, 'r');

% 初始化变量
pl47_data = zeros(86400,3);
i = 0;
j = 0;
% 逐行读取文件
while ~feof(fid)
    line = fgetl(fid);
    % 查找 PL47 行
    if startsWith(line, 'PL47')
        % 提取 PL47 行的数据
        i = i + 1;
        data = str2num(line(5:end)); % 读取 PL47 行的数据
        if length(data) >= 3
            pl47_data(i,:) = [data(1), data(2), data(3)];
        end
    end
    % 查找 VL47 行
    if startsWith(line, 'VL47')
        % 提取 VL47 行的数据
        j = j + 1;
        data = str2num(line(5:end))/10000; % 读取 VL47 行的数据
        if length(data) >= 3
            vl47_data(j,:) = [data(1), data(2), data(3)];
        end
    end
end

% 关闭文件
fclose(fid);
Pos = pl47_data;
V = vl47_data;

