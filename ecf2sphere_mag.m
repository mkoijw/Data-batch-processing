function [Bx,By,Bz,H,D,I,F] = ecf2sphere_mag(X,Y,Z,Nmax,g,h)
%% 
%程序说明
%功能：该函数实现了地固直角坐标系(X Y Z)向地固球坐标系的转换,并计算地固球坐标系下的七个磁场矢量分量
%参考：该程序改编自ecf2wgs_mag.m
%补充：对磁场矢量的计算，WMM2015_Report（wmm_magnetic.m）中，输入为WGS84下的坐标，然后转换为地
%          固球坐标，在地固球坐标下计算得到磁场矢量后，再旋转到WGS84下。本程序中，输入的坐标为地固直角坐标，
%          由地固直角坐标直接转换成地固球坐标，之后计算得到地固球坐标系下的磁场矢量
% 输入：地固系下的某点坐标值（X,Y,Z），单位km，Nmax为阶数
% 输出：地固球坐标系下磁场强度分量值[Bx,By,Bz,H,D,I,F]，单位nT，rad

%% 
%给定相关参数
N=Nmax;%阶数
a=6371.2; % 地磁参考半径，单位km

%% 
%--------------------由地固直角坐标求地固球坐标
L=atan2(Y,X); % 经度，单位rad        
r=sqrt(X^2+Y^2+Z^2);%地心距，单位km
lat_prime=asin(Z/r);%地心纬度，单位rad
lat_co=pi/2-lat_prime;% 地固坐标系下的地心余纬，单位rad


%% 
%-----------------由地固球坐标计算磁场强度分量值
[p,dp]=simit_l(lat_co,Nmax);%调用函数计算勒让德多项式p和多项式对余纬的导数
   dV_lat_co=0;
   dV_lon=0;
   dV_r=0;%在地固球坐标系下的三轴分量，分别为北向、东向、垂直向下，单位nT
  %对于勒让德多项式，i表示阶数n,j-1表示次数m,具体参考函数simit_l 、
  %对于地磁场模型，i表示阶数n,j-1表示次数m,具体参考txt文件WMM2015.txt及计算h和g的程序
  %根本原因在于，n从1开始，m从0开始，MATLAB的角标只能从1开始
  %对于g,h,p,dp来说，i和j依然对应于相应的角标，这里需要对应于矩阵中相应的数，与j与m是不是同一个值无关
 for i=1:N%参考地磁场模型的级数公式
    for j=1:i+1%i表示阶数n,j表示次数m,其中m=j-1，具体参考函数simit_l
       dV_lat_co=dV_lat_co+(a/r)^(i+2)*(g(i,j)*cos((j-1)*L)+h(i,j)*sin((j-1)*L))*dp(i,j);
       dV_lon=dV_lon+(a/r)^(i+2)*(g(i,j)*sin((j-1)*L)-h(i,j)*cos((j-1)*L))*(j-1)*p(i,j)/sin(lat_co);
       dV_r=dV_r-(i+1)*(a/r)^(i+2)*(g(i,j)*cos((j-1)*L)+h(i,j)*sin((j-1)*L))*p(i,j);
    end 
 end
    X_prime=dV_lat_co;
    Y_prime=dV_lon;
    Z_prime=dV_r;%在地固球坐标系下的三轴分量，分别为北向、东向、垂直向下，单位nT

%%
%计算地固球坐标系下的七个磁场矢量分量
    Bx=X_prime;
    By=Y_prime;
    Bz=Z_prime;%在地固球坐标系下的三轴分量，分别为北向、东向、地心，单位nT  
    
    H=sqrt(Bx^2+By^2);                    % 水平分量 H，单位nT
    D=atan2(By,Bx)*180/pi;                % 磁偏角 D 范围为(-pi,pi)
    I=atan(Bz/H)*180/pi;                  % 磁倾角 I 范围为（-pi/2,pi/2)
    F=sqrt(Bx^2+By^2+Bz^2);               % 总磁场强度 F，单位nT
  %见WMM2015_Report 
