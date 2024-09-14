clear
close
clc
mainDir = 'E:\EPofGM\SwarmData\Sat_A';
saveData_filename = ['E:\EPofGM\Data_batch_processing\data\' ...
                     'test20240827.csv'];
startDate = '20240827';
endDate = '20240827';

[cdfPaths, sp3Paths] = getFilePathsWithinDateRange(mainDir, startDate, endDate);
total_data = [];
for i = 1:length(cdfPaths)
    data = dataprocess(sp3Paths{i}, cdfPaths{i});
    total_data = [total_data;data];
end
writematrix(total_data,saveData_filename);