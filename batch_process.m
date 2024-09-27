clear
close
clc
mainDir = 'E:\EPofGM\SwarmData\Sat_A';
saveData_filename = ['E:\EPofGM\Data_batch_processing\data\' ...
                     'predPosTrain20240825.csv'];
startDate = '20240825';
endDate = '20240825';
%%
DAY_t0=JD2000(2020,1,1,0,0,0);
DAY_t=JD2000(2024,8,25,0,0,0); 
DAY_decimal=(DAY_t-DAY_t0)/365;
[n,m,gvali,hvali,gsvi,hsvi]=textread('WMM2020.txt','%f %f %f %f %f %f');%
g=zeros(12,13);
h=zeros(12,13);
for x=1:length(n)
      g(n(x),m(x)+1) = gvali(x)+gsvi(x)*DAY_decimal;
      h(n(x),m(x)+1) = hvali(x)+hsvi(x)*DAY_decimal;
end
%%
[cdfPaths, sp3Paths] = getFilePathsWithinDateRange(mainDir, startDate, endDate);
total_data = [];
for i = 1:length(cdfPaths)
    data = dataprocess1(sp3Paths{i}, cdfPaths{i},g,h);
    total_data = [total_data;data];
end
writematrix(total_data,saveData_filename);