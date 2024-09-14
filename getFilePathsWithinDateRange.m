function [cdfList, sp3List] = getFilePathsWithinDateRange(mainDir, startDate, endDate)
% mainDir: 主目录路径，如 'E:\EPofGM\SwarmData\Sat_A'
% startDate, endDate: 指定的日期区间，格式为 'yyyymmdd'，例如 '20240825'

% 初始化两个文件列表
cdfList = {};
sp3List = {};

% 将输入的日期转为数字便于比较
startDateNum = datenum(startDate, 'yyyymmdd');
endDateNum = datenum(endDate, 'yyyymmdd');

% 获取主目录下的所有文件夹
folderList = dir(mainDir);

% 遍历所有文件夹
for i = 1:length(folderList)
    folderName = folderList(i).name;
    
    % 确保当前项是文件夹，且文件夹名为有效的日期格式
    if folderList(i).isdir && length(folderName) == 8 && all(isstrprop(folderName, 'digit'))
        folderDateNum = datenum(folderName, 'yyyymmdd');
        
        % 检查文件夹日期是否在指定的范围内
        if folderDateNum >= startDateNum && folderDateNum <= endDateNum
            % 获取该文件夹中的文件
            folderPath = fullfile(mainDir, folderName);
            filesInFolder = dir(folderPath);
            
            % 遍历文件夹中的所有文件
            for j = 1:length(filesInFolder)
                fileName = filesInFolder(j).name;
                % 排除 '.' 和 '..'
                if ~filesInFolder(j).isdir
                    % 获取文件扩展名
                    [~, ~, ext] = fileparts(fileName);
                    % 将文件路径按类型存入对应列表
                    if strcmpi(ext, '.cdf')
                        cdfList{end+1} = fullfile(folderPath, fileName);
                    elseif strcmpi(ext, '.sp3')
                        sp3List{end+1} = fullfile(folderPath, fileName);
                    end
                end
            end
        end
    end
end
end
