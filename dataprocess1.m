function data = dataprocess1(MODA_SC_1B_filename, MAGA_LR_1B_filename,g,h)
cd('E:\EPofGM\Data_batch_processing\code')
infilePath = 'E:\EPofGM\Global_geomagnetic_model\WMM2020\WMM2020_Windows\WMM2020_Windows\bin\input.txt';
outfilePath = 'E:\EPofGM\Global_geomagnetic_model\WMM2020\WMM2020_Windows\WMM2020_Windows\bin\output.txt';
%% 读预测位置和速度
predPosfile = 'E:\EPofGM\Data_batch_processing\data\predPos20240825.txt';
[x_p,y_p,z_p,vx_p,vy_p,vz_p]=textread(predPosfile,'%f %f %f %f %f %f');
Pos_p = [x_p,y_p,z_p];
V_p = [vx_p,vy_p,vz_p];
%% 从sp3文件提取位置 ITRF km
[Pos, ~] = sp32Pos(MODA_SC_1B_filename);
%% 从cdf文件提取B NEC nT
B_NEC_cell = cdf2B_NEC(MAGA_LR_1B_filename);
B_NEC = horzcat(B_NEC_cell{:})';
%%
Br_model=zeros(86400,3);
%%
for i=1:86400
    [Bx_model,By_model,Bz_model,~,~,~,~] = ecf2sphere_mag(Pos(i,1),Pos(i,2), Pos(i,3),12,g,h);
    Br_model(i,:)=[Bx_model,By_model,Bz_model];
end
detaB_model=(B_NEC-Br_model);%3 X 86400,swarm卫星的实际位置处的模型误差

%% 估计位置 B_NEC 真实位置 模型误差
data = [Pos_p, B_NEC, Pos, detaB_model];
data = data(6401:86400,:);
