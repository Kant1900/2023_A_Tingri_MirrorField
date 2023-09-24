
k=1;
for i=0:7
    for j=1:5
        P(k,1)=50*j*cos(i*pi/4);
        P(k,2)=50*j*sin(i*pi/4);
        k=k+1;
    end
end

