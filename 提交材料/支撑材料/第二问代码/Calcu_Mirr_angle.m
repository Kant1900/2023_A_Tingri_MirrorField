%A1   纬度   
%H   塔高
%A2   赤纬角
%w    时角
%As  太阳高度角
%Rs    太阳方位角
%H  塔高
%P    镜子的中心点坐标  (1*3的向量)
% H=80;
% P=[1.250 ,11.664 ,4];
% ST=13;
% D=1;
%Cos_eff    余弦效率
%At_eff     大气透射率
%Trunc_eff

function [pitch,yaw,Cos_eff,At_eff,Int_eff]=Calcu_Mirr_angle(ST,D,H,P,l1,l2)
Dhr=sqrt(P(1)^2+P(2)^2+(H-P(3))^2);
At_eff=0.99321-0.0001176*Dhr+1.97*10^(-8)*Dhr^2;

A1=39.4*pi/180;
w=pi/12*(ST-12);
A2=asin(sin(2*pi*D/365)*sin(2*pi*23.45/360));
As=asin(cos(A2)*cos(A1)*cos(w)+sin(A2)*sin(A1));

CRs=(sin(A2)-sin(As)*sin(A1))/(cos(As)*cos(A1));
SRs=-1*sin(w)*cos(A2)/cos(As);

xit=1*cos(As)*SRs;
yit=cos(As)*CRs;
zit=sin(As);
xi=xit/sqrt(xit^2+yit^2+zit^2);
yi=yit/sqrt(xit^2+yit^2+zit^2);
zi=zit/sqrt(xit^2+yit^2+zit^2);
S_is=[-1*xi,-1*yi,-1*zi];     %S_is太阳光线的入射向量


S_ot(1)=-1*P(1)/sqrt(P(1)^2+P(2)^2+(H-P(3))^2);     %S_ot太阳光线折射到塔
S_ot(2)=-1*P(2)/sqrt(P(1)^2+P(2)^2+(H-P(3))^2);
S_ot(3)=(H-P(3))/sqrt(P(1)^2+P(2)^2+(H-P(3))^2);
                
S_na(1)=(S_ot(1)-S_is(1))/sqrt((S_ot(1)-S_is(1))^2+(S_ot(2)-S_is(2))^2+(S_ot(3)-S_is(3))^2);  %镜面法向
S_na(2)=(S_ot(2)-S_is(2))/sqrt((S_ot(1)-S_is(1))^2+(S_ot(2)-S_is(2))^2+(S_ot(3)-S_is(3))^2);
S_na(3)=(S_ot(3)-S_is(3))/sqrt((S_ot(1)-S_is(1))^2+(S_ot(2)-S_is(2))^2+(S_ot(3)-S_is(3))^2);

Cos_eff=S_ot(1)*S_na(1)+S_ot(2)*S_na(2)+S_ot(3)*S_na(3);

% if (S_na(2)>=0)
%     pitch=180/pi*atan(S_na(3)/sqrt(S_na(1)^2+S_na(2)^2));   %角度
% elseif(S_na(2)<0)
%     pitch=180-180/pi*atan(S_na(3)/sqrt(S_na(1)^2+S_na(2)^2));
% end

pitch=180/pi*atan(S_na(3)/sqrt(S_na(1)^2+S_na(2)^2));   %角度

%yaw 北偏东沿顺时针方向为正
if(S_na(1)>0)
    yaw=180/pi*acos(S_na(2)/sqrt(S_na(1)^2+S_na(2)^2));

elseif(S_na(1)<0)
    yaw=360-180/pi*acos(S_na(2)/sqrt(S_na(1)^2+S_na(2)^2));
end 

o=acos(S_ot(1)*S_na(1)+S_ot(2)*S_na(2)+S_ot(3)*S_na(3));

% h_x=3*sin(pi/2-o)/sin(pi/2+o-pitch*pi/180);  %淘汰掉的算法
% Int_eff=(8-h_x)/4;
% if (Int_eff>1)
%     Int_eff=1;
% end
% if ((h_x-4)<=0)
%     Int_eff=1;
% else
%     Int_eff=4/h_x;
% end

Int_eff=A_trunc(o,P(1),P(2),l1,l2);
