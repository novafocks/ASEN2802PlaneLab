clc
clear
close all



wo=10;
w1=5;
L=10;
N=4;
x=[L./8,3.*L./8,5.*L./8,7.*L./8]

for i=1:3
    if i==1
        [ForceRect,XvalRect,FeqRect]=discretizeLoad(wo,w1,N,L,x,i);
    elseif i==2
        [ForceTrap,XvalTrap,FeqTrap]=discretizeLoad(wo,w1,N,L,x,i);
    else
        [ForceTri,XvalTri,FeqTri]=discretizeLoad(wo,w1,N,L,x,i);
    end
end

function [Force,Xval,Feq]=discretizeLoad(wo,w1,N,L,x,i)

if i==1
    Wave=wo;
    deltax=L/N;
    for j=1:N
        Force(j)=Wave.*deltax;
        Xval(j)=x(j);
    end
    Feq=Wave.*L;
elseif i==2
    xnew=[0,2.5,5,7.5,10]
    Wx=((w1-wo).*xnew./L)+wo;
    for j=1:N
        Force(j)=(Wx(j)+Wx(j+1)).*L./(2.*N);
        Xval(j)=(2.*Wx(j)+Wx(j+1)).*(L./N)./(3.*(Wx(j)+Wx(j+1)))+2.5.*(j-1);
    end
    Feq=(wo+w1).*L./2;
else
    xnew=[0,2.5,5,7.5,10]
    Wx=-wo.*xnew./L+wo
    for j=1:N
        Force(j)=(Wx(j)+Wx(j+1)).*L./8;
        Xval(j)=(2.*Wx(j)+Wx(j+1)).*(L./N)./(3.*(Wx(j)+Wx(j+1)))+2.5.*(j-1);
    end
    Feq=wo.*L./2;
end
end


