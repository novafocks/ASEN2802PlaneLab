
clc
clear
close all

wo=10;
w1=5;
L=10;
N=4;
x=0:L./N:L;
%%Rectangle Vals
%Force vals at halfway between each discretization

Rect.force=[wo.*L./N,wo.*L./N,wo.*L./N,wo.*L./N];
Rect.xvals=[L./8,3.*L./8,5.*L./8,7.*L./8];
%Wiffle tree vals in order a,b,c,d,e,f
Rect.wiffle=[L./N,L./N,L./8,L./8,L./8,L./8];
Rect.Feq=wo.*L;
%%Trapezoid Values
wx=(((w1-wo).*x./L)+wo).*L./N;
for i=1:N
Trap.force(i)=(wx(i)+wx(i+1)).*L./(2.*N);
end
for i=1:N
trapTriXval(i)=2.5./3+2.5.*(i-1);
end
trapRectXval=Rect.xvals;
%Weight for each x val is dependent on force under each area

for i=1:N
    WeightedAveTrap(i)=((Trap.force(i)-wx(i+1).*L./N).*trapTriXval(i)+(wx(i+1).*trapRectXval(i).*L./N))./Trap.force(i);
end
Trap.xvals=WeightedAveTrap;
Trap.wiffle=wiffleTreeVals(Trap.force,Trap.xvals);
Trap.Feq=(wo+w1).*L./2;
%%Triangle Values

wxTri=(((0-wo).*x./L)+wo).*L./N;

for i=1:N
    Tri.force(i)=(wxTri(i)+wxTri(i+1)).*L./(2.*N);
end

for i=1:N
TriTriXval(i)=2.5./3+2.5.*(i-1);
end
TriRectXval=Rect.xvals;
%Weight for each x val is dependent on force under each area

for i=1:N
    WeightedAveTri(i)=((Tri.force(i)-2.5.*wxTri(i+1)).*TriTriXval(i)+(wxTri(i+1)).*(2.5).*TriRectXval(i))./Tri.force(i);
end
Tri.xvals=WeightedAveTri;
Tri.wiffle=wiffleTreeVals(Tri.force,Tri.xvals);
Tri.Feq=wo.*L./2;


function [wiffle]=wiffleTreeVals(Force,Xvals)
F12=Force(1)+Force(2);
F13=Force(3)+Force(4);
A=[0,0,-Force(1),Force(2),0,0;0,0,0,0,-Force(3),Force(4);-F12,F13,0,0,0,0;0,0,1,1,0,0;1,1,1,0,-1,0;1,1,1,0,0,1];
invA=inv(A);
B=[0;0;0;Xvals(2)-Xvals(1);Xvals(3)-Xvals(1);Xvals(4)-Xvals(1)];
wiffle=invA*B;
end


