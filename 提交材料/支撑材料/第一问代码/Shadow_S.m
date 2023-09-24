%计算两块板子间的遮挡
function S = Shadow_S(ST,D,H,P_b,P_f)

Width = 6;
Long  = 6;

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


S_ot(1)=-1*P_b(1)/sqrt(P_b(1)^2+P_b(2)^2+(H-P_b(3))^2);     %S_ot太阳光线反射到塔
S_ot(2)=-1*P_b(2)/sqrt(P_b(1)^2+P_b(2)^2+(H-P_b(3))^2);
S_ot(3)=(H-P_b(3))/sqrt(P_b(1)^2+P_b(2)^2+(H-P_b(3))^2);
                
S_na(1)=(S_ot(1)-S_is(1))/sqrt((S_ot(1)-S_is(1))^2+(S_ot(2)-S_is(2))^2+(S_ot(3)-S_is(3))^2);  %镜面法向
S_na(2)=(S_ot(2)-S_is(2))/sqrt((S_ot(1)-S_is(1))^2+(S_ot(2)-S_is(2))^2+(S_ot(3)-S_is(3))^2);
S_na(3)=(S_ot(3)-S_is(3))/sqrt((S_ot(1)-S_is(1))^2+(S_ot(2)-S_is(2))^2+(S_ot(3)-S_is(3))^2);

pitch=180/pi*atan(S_na(3)/sqrt(S_na(1)^2+S_na(2)^2));   %角度
%yaw 北偏东沿顺时针方向为正
if(S_na(1)>=0)
    yaw=180/pi*acos(S_na(2)/sqrt(S_na(1)^2+S_na(2)^2));
elseif(S_na(1)<0)
    yaw=360-180/pi*acos(S_na(2)/sqrt(S_na(1)^2+S_na(2)^2));
end 

yaw_r = -(yaw - 180)/180*pi;
pitch_r = (0.5*pi -  pitch/180*pi);

%旋转矩阵无误
Rz = [cos(yaw_r) sin(yaw_r) 0 ;  -sin(yaw_r) cos(yaw_r) 0 ; 0 0 1];
Rx = [1 0 0; 0 cos(pitch_r) sin(pitch_r) ; 0 -sin(pitch_r) cos(pitch_r)];
R = Rx*Rz;

%反射遮挡
if( S_ot(1) == 0 )
    M1 = [ S_na(1) S_na(2) S_na(3) ; S_ot(2) -S_ot(1) 0 ;  0  S_ot(3) -S_ot(2) ];
    H1 = [ S_na(1)*P_b(1)+S_na(2)*P_b(2)+S_na(3)*P_b(3) ; S_ot(2)*P_f(1)-S_ot(1)*P_f(2) ; S_ot(3)*P_f(2)-S_ot(2)*P_f(3)];
else
    M1 = [ S_na(1) S_na(2) S_na(3) ; S_ot(2) -S_ot(1) 0 ; S_ot(3)  0  -S_ot(1) ];
    H1 = [ S_na(1)*P_b(1)+S_na(2)*P_b(2)+S_na(3)*P_b(3) ; S_ot(2)*P_f(1)-S_ot(1)*P_f(2) ; S_ot(3)*P_f(1)-S_ot(1)*P_f(3)];
end
P_pro1 = M1\H1;
Vec_mirr1 = P_pro1 - P_b';
P_mirr1 = R*Vec_mirr1;  
%入射遮挡
if( S_is(1) == 0 )
    M2 = [ S_na(1) S_na(2) S_na(3) ; S_is(2) -S_is(1) 0 ;  0  S_is(3) -S_is(2) ];
    H2 = [ S_na(1)*P_b(1)+S_na(2)*P_b(2)+S_na(3)*P_b(3) ; S_is(2)*P_f(1)-S_is(1)*P_f(2) ; S_is(3)*P_f(2)-S_is(2)*P_f(3)];
else
    M2 = [ S_na(1) S_na(2) S_na(3) ; S_is(2) -S_is(1) 0 ; S_is(3)  0  -S_is(1) ];
    H2 = [ S_na(1)*P_b(1)+S_na(2)*P_b(2)+S_na(3)*P_b(3) ; S_is(2)*P_f(1)-S_is(1)*P_f(2) ; S_is(3)*P_f(1)-S_is(1)*P_f(3)];
end
P_pro2 = M2\H2;
Vec_mirr2 = P_pro2 - P_b';
P_mirr2 = R*Vec_mirr2;   

if( P_mirr1(1) > -Width && P_mirr1(2) > -Long && P_mirr1(1) < Width && P_mirr1(2) < Long)
    del_vec = P_f' - P_pro1;
    if( del_vec(1)*S_ot(1) >= 0 && del_vec(2)*S_ot(2) >= 0 )
         %反射光线被挡
        S1 = (abs( P_mirr1(1) ) - Width)*(abs( P_mirr1(2) ) - Long);
    else
        S1 = 0;
    end
else
     S1 = 0;
end

if( P_mirr2(1) > -Width && P_mirr2(2) > -Long && P_mirr2(1) < Width && P_mirr2(2) < Long)
    del_vec = -P_f' + P_pro2;
    if( del_vec(1)*S_is(1) >= 0 && del_vec(2)*S_is(2) >= 0 )
   %入射光线被挡
        S2 = (abs( P_mirr2(1) ) - Width)*(abs( P_mirr2(2) ) - Long);
    else 
        S2 = 0;
    end
else
   S2 = 0;
end
    
    if( S1 > S2 )
        S = S1;
    else
        S = S2;
    end
end

