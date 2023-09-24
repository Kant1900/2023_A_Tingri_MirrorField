%Posi           每个镜面的位置
l1=8;            %长
l2=7;          %宽
d=6;           %间距
h=4;             %高度
%P 是吸收塔坐标点的遍历

j=2;    %选择一天中的时间点
k=3;    %选择月份
Efieid_day_ave_persize=zeros(1,size(P,1));   %单位面积平均输出功率
Efieid=zeros(1,size(P,1));     %定日场输出热功率 装着一天五个时刻的

for kk1 =1:size(P,1) 
    x0=P(kk1,1);
    y0=P(kk1,2);
    
%   kk1=1;      %单次运行时候使用
%   x0=35;
%   y0=-35;

%     x0=28.7;
%     y0=-21.1;

%    Posi=get_points(l2,d,h,x0,y0);              %按环数生成坐标
    Posi=get_points_zuimi(l2,d,h,x0,y0);      %按最密堆积生成坐标
    num=size(Posi,1);

    H=80;                    %塔高
    ST=[9,10.5,12.01,13.5,15];
    D=[307,335,0,31,61,93,123,154,185,215,246,276];
    H_alti=3;        %海拔高度  单位km
    G0=1.366;     %太阳常数 kW/m^2  
    Efieid_day_ave=zeros(1,12);

    Si=l1*l2;        %每块镜子的面积
    effi_sum=zeros(1,5);             %总的效率（五个连乘）
   
    Ref_eff =0.92;          %镜面反射效率
    
    Cos_eff_ave=zeros(1,5); %存着一天各次的余弦效率
    At_effi_ave=zeros(1,5); %存着一天各次的透射率
    Cos_eff_day_ave=zeros(1,12);  %存着每月21号的余弦效率
    At_effi_day_ave=zeros(1,12);  %存着每月21号的折射率
    
    Sb_effi_ave=zeros(1,5);
    Trunc_eff_ave=zeros(1,5);          %存着一天各次的透射率   
    Trunc_eff=zeros(1,num);            %截断效率
    effi_sumi=zeros(1,num);
    pitchi=zeros(1,num);    %pitch角度
    yawi=zeros(1,num);      %yaw角度
    Cos_effi=zeros(1,num);  %余弦效率
    At_effi=zeros(1,num);   %大气透射率
    Sb_effi=zeros(1,num);               %遮挡效率


    A1=39.4*pi/180;
    w=pi/12*(ST(j)-12);
    A2=asin(sin(2*pi*D(k)/365)*sin(2*pi*23.45/360));
    As=asin(cos(A2)*cos(A1)*cos(w)+sin(A2)*sin(A1));
    
    a=0.4237-0.00821*(6-H_alti)^2;
    b=0.5055+0.00595*(6.5-H_alti)^2;
    c=0.2711+0.01858*(2.5-H_alti)^2;
    DNI=G0*(a+b*exp(-1*(c)/sin(As)))*1000;    %法向直接辐射照度计算
    
    
    for i=1:num
        [pitchi(i),yawi(i),Cos_effi(i),At_effi(i),Trunc_eff(i)]=Calcu_Mirr_angle(ST(j),D(k),H,Posi(i,:),l1,l2);
    
        k1 = 1;    %计算遮挡效率
        S = zeros(1 , 20);
        for j1 = 1:num
            if( i == j1 )
                continue;
            end
            if( distance(Posi(j1,:),[0,0]) > distance(Posi(i,:),[0,0]) )
                continue;
            end
            if( distance( Posi(j1,:) , Posi(i,:) ) <= 30 )
               %计算遮挡面积
               S(k1) = Shadow_S(ST(j) , D(k) , H , Posi(i,:) , Posi(j1,:),l2,l1);
               k1 = k1 + 1;
            end
        end
        S_total(i) = max(S)/(l1*l2);       %被挡住的面积
        Sb_effi(i)=1-S_total(i);
        if(Sb_effi(i)<=0)
            Sb_effi(i)=0;
        end
        effi_sumi(i)=Cos_effi(i)*At_effi(i)*Trunc_eff(i)*Ref_eff*Sb_effi(i);
    end 
    Cos_eff_ave(j)=mean(Cos_effi);        %镜场某时刻余弦效率均值（因为面积相同，就直接均值了） 
    At_effi_ave(j)=mean(At_effi);
    effi_sum(j)=mean(effi_sumi);
    Sb_effi_ave(j)=mean(Sb_effi);
    
    Efieid(kk1)=effi_sum(j)*Si*DNI*num;              %总功率

    Efieid_day_ave_persize(kk1)=Efieid(kk1)/Si/num;   %平均功率

end

%+++++++++++++++++++++++++++++++++++绘图++++++++++++++++++++++++++++++++++++++++++++++++++
% 光学效率镜场图像

figure();
sz=15;
scatter (Posi(:,1),Posi(:,2),sz,effi_sumi,'filled');
axis equal
c = colorbar;
c.Label.String = '光学效率';
title('镜场光学效率     3月21日 10:30', 'FontSize', 8);
xlabel('X', 'FontSize', 10);
ylabel('Y', 'FontSize', 10);

%遮挡效率图像
figure();
sz=15;
scatter (Posi(:,1),Posi(:,2),sz,Sb_effi,'filled');
axis equal
c = colorbar;
c.Label.String = '遮挡效率';
title('镜场遮挡效率     3月21日 10:30', 'FontSize', 8);
xlabel('X', 'FontSize', 10);
ylabel('Y', 'FontSize', 10);

%截断效率的图像
figure();
sz=15;
scatter (Posi(:,1),Posi(:,2),sz,Trunc_eff,'filled');
axis equal
c = colorbar;
c.Label.String = '截断效率';
title('镜场截断效率     3月21日 10:30', 'FontSize', 8);
xlabel('X', 'FontSize', 10);
ylabel('Y', 'FontSize', 10);

%余弦效率的图像

figure();
sz=15;
scatter (Posi(:,1),Posi(:,2),sz,Cos_effi,'filled');
axis equal
c = colorbar;
c.Label.String = '余弦效率';
title('镜场余弦效率     3月21日 10:30', 'FontSize', 8);
xlabel('X', 'FontSize', 10);
ylabel('Y', 'FontSize', 10);
