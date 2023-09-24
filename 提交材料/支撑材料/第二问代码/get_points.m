
function [points] = get_points(l,d,h,x0,y0)
% l=6;   %l是边长（先按装正方形考虑）
% d=5;   %间距大于5
% h=4;   %镜面高度
%n 环数
%Ri 每一环的半径 
%Ai 每环步进角度 
%mi 每一环的镜子数目
%points  各个点
n=ceil((250+sqrt(x0^2+y0^2))/(l+d));

for i=1:n
    Ri(i)=100+(l+d)/2*(2*i-1);
    Ai(i)=2*asin((l+d)/(2*Ri(i)));
    mi(i)=ceil(2*pi/Ai(i));

end 
xij=zeros(n,mi(n));
yij=zeros(n,mi(n));
yawij=zeros(n,mi(n));
k=1;
for i=1:n
    for j=1:mi(i)
        yawij(i,j)=(j-1)*Ai(i);
        xij(i,j)=Ri(i)*cos(yawij(i,j));
        yij(i,j)=Ri(i)*sin(yawij(i,j));
        if(yawij(i,j)>0)
            if((xij(i,j)+x0)^2+(yij(i,j)+y0)^2<=(350+l+d)^2)
            points(k,1)=xij(i,j);
            points(k,2)=yij(i,j);
            points(k,3)=h;
            k=k+1;
        end
    end
end

% figure();
% scatter (points(:,1),points(:,2));
% axis equal

end
