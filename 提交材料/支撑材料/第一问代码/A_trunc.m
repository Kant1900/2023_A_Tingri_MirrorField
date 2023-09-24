

function [efficiency] = A_trunc(w,X,Y,L_h,L_w)%w：入射角

                                                     %X 横坐标 
                                                     %Y 纵坐标
                                                     %L_h：定日镜高度
                                                     %L_w：定日镜宽度
                                                     %单位mrad 
d=sqrt(X^2+Y^2);                                                    %d：反射距离
 error_sun = 0.00251; %太阳形状误差标准差
 error_bq = 0.00188; %光束质量误差标准差
 error_track = 0.00063; %跟踪误差标准差
 heat_w = 7;%集热器宽度
 heat_h = 8;%集热器高度
 
%error_tot 吸热器表面聚光光斑的总标准差  
%error_ast 像散误差标准差

error_ast = sqrt((L_h*L_w*((cos(w))^2+1))/2)/4/d;
% error_ast=0
% error_tot=0.003
error_tot = sqrt(d^2*(error_sun^2+error_bq^2+error_track^2+error_ast^2));
ratio_front=1/(2*3.1415926*error_tot^2) ; %效率中前面的系数

f=@(x,y) exp((-x.^2-y.^2)/error_tot.^2/2);%积分函数
ratio_behind=dblquad(f,-0.5*heat_h,0.5*heat_h,-0.5*heat_w,0.5*heat_w,1);
efficiency = ratio_front*ratio_behind;
end
