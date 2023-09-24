% x0=0;
% y0=0;
% l=8;
% d=5;
function [points] = get_points_zuimi(l,d,h,x0,y0)
m=floor(700/(l+d)/sqrt(3));
n=round(700/(l+d));
k=1;
for i=-m:m
    yij(k)=(l+d)/2*sqrt(3)*i;
    k=k+1;
end
y_num=k-1;



k=1;
for i=1:n
    xij1(k)=(l+d)*i-350;
    xij(k)=(l+d)/2*(2*i-1)-350;
    k=k+1;
end
x_num=k-1;


a=1;
for i=1:y_num
 for j=1:x_num
 if((xij(j)^2+yij(i)^2)<=350^2)&&(((xij(j)-x0)^2+((yij(i)-y0)^2))>10000)
    if mod(i,2)==1
     points(a,1)=xij1(j)-x0;
    else
     points(a,1)=xij(j)-x0;
    end
     points(a,2)=yij(i)-y0;
     points(a,3)=h;
     a=a+1;
 end
 end
end

% scatter (points(:,1),points(:,2));
% axis equal

