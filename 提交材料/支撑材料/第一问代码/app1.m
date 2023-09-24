                 %Posi      每个镜面的位置
num=1745;
H=80;                    %塔高
ST=[9,10.5,12.01,13.5,15];
D=[307,335,0,31,61,93,123,154,185,215,246,276];
H_alti=3;        %海拔高度  单位km
G0=1.366;     %太阳常数 kW/m^2 
Efieidi=zeros(1,num);  %每个镜子的功率
Efieid=zeros(1,5);     %定日场输出热功率 装着一天五个时刻的
Efieid_day_ave=zeros(1,12);
Efieid_day_ave_persize=zeros(1,12);
Si=36;        %每块镜子的面积
effi_sum_ave=zeros(1,5);             %总的效率（五个连乘）
effi_sumi=zeros(1,num);
effi_sum_day_ave=zeros(1,12);
pitchi=zeros(1,num);    %pitch角度
yawi=zeros(1,num);      %yaw角度
Cos_effi=zeros(1,num);  %余弦效率
Ref_eff =0.92;          %镜面反射效率
At_effi=zeros(1,num);   %大气透射率
Cos_eff_ave=zeros(1,5); %存着一天各次的余弦效率
At_effi_ave=zeros(1,5); %存着一天各次的透射率
Cos_eff_day_ave=zeros(1,12);  %存着每月21号的余弦效率
At_effi_day_ave=zeros(1,12);  %存着每月21号的折射率
Sb_effi=zeros(1,num);               %遮挡效率
Sb_effi_ave=zeros(1,5);
Sb_effi_day_ave=zeros(1,12);
Trunc_eff=zeros(1,num);            %截断效率
Trunc_eff_ave=zeros(1,5);          %存着一天各次的透射率
Trunc_eff_day_ave=zeros(1,12);
for k=1:12

    for j=1:5
        A1=39.4*pi/180;
        w=pi/12*(ST(j)-12);
        A2=asin(sin(2*pi*D(k)/365)*sin(2*pi*23.45/360));
        As=asin(cos(A2)*cos(A1)*cos(w)+sin(A2)*sin(A1));
        
        a=0.4237-0.00821*(6-H_alti)^2;
        b=0.5055+0.00595*(6.5-H_alti)^2;
        c=0.2711+0.01858*(2.5-H_alti)^2;
        DNI=G0*(a+b*exp(-1*(c)/sin(As)))*1000;    %法向直接辐射照度计算
        for i=1:num
            [pitchi(i),yawi(i),Cos_effi(i),At_effi(i),Trunc_eff(i)]=Calcu_Mirr_angle(ST(j),D(k),H,Posi(i,:));
        
            k1 = 1;    %计算遮挡效率
            S = zeros(1 , 20);
            for j1 = 1:num
                if( i == j1 )
                    continue;
                end
                if( distance( Posi(j1,:) , Posi(i,:) ) <= 30 )
                   %计算遮挡面积
                   S(k1) = Shadow_S(ST(j) , D(k) , H , Posi(i,:) , Posi(j1,:));
                   k1 = k1 + 1;
                end
            end
            S_total(i) = max(S)/36;       %被挡住的面积
            Sb_effi(i)=1-S_total(i);
            
            effi_sumi(i)=Cos_effi(i)*At_effi(i)*Trunc_eff(i)*Ref_eff*Sb_effi(i);
            Efieidi(i)=effi_sumi(i)*Si*DNI*num; 
        end 
        Cos_eff_ave(j)=mean(Cos_effi);        %镜场某时刻余弦效率均值（因为面积相同，就直接均值了） 
        At_effi_ave(j)=mean(At_effi);
        Trunc_eff_ave(j)=mean(Trunc_eff);
        Sb_effi_ave(j)=mean(Sb_effi);
        Efieid(j)=mean(Efieidi);

        effi_sum_ave(j)=mean(effi_sumi);
        

    end
    effi_sum_day_ave(k)=mean(effi_sum_ave);
    Efieid_day_ave(k)=mean(Efieid);
    Cos_eff_day_ave(k)=mean(Cos_eff_ave);
    At_effi_day_ave(k)=mean(At_effi_ave);
    Trunc_eff_day_ave(k)=mean(Trunc_eff_ave);
    Sb_effi_day_ave(k)=mean(Sb_effi_ave);
end

Efieid_day_ave_persize=Efieid_day_ave/(Si*num);
%++++++++++++++++++++++++++++++++++++画图 pitch和yaw+++++++++++++++++++
% sz=25;
% scatter (Posi(:,1),Posi(:,2),sz,yawi,'filled');
% axis equal
% % s.SizeData = 100;
% colorbar
% 
% figure();
% sz=25;
% scatter (Posi(:,1),Posi(:,2),sz,pitchi,'filled');
% axis equal
% % s.SizeData = 100;
% colorbar

%++++++++++++++++++++++++++++++++++画图大气透射率+++++++++++++++++++++++++++++

% figure();
% sz=25;
% scatter (Posi(:,1),Posi(:,2),sz,At_effi,'filled');
% axis equal
% % s.SizeData = 100;
% colorbar


