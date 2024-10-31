
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

%%Trapezoid Values

Trap.force=(((w1-wo).*x./L)+wo).*L./N;
for i=1:N
trapTriXval(i)=2.5./3+2.5.*(i-1);
end
trapRectXval=Rect.xvals;
%Weight for each x val is dependent on force under each area

for i=1:N
    WeightedAveTrap(i)=((Trap.force(i)-2.5.*w1).*trapTriXval(i)+w1.*(2.5).*trapRectXval(i))./Trap.force(i);
end
Trap.xvals=WeightedAveTrap;
Trap.wiffle=wiffleTreeVals(Trap.force,Trap.xvals);

%%Triangle Values

Tri.force=(((0-wo).*x./L)+wo).*L./N;
for i=1:N
TriTriXval(i)=2.5./3+2.5.*(i-1);
end
TriRectXval=Rect.xvals;
%Weight for each x val is dependent on force under each area

for i=1:N
    WeightedAveTri(i)=((Tri.force(i)-2.5.*w1).*TriTriXval(i)+w1.*(2.5).*TriRectXval(i))./Tri.force(i);
end
Tri.xvals=WeightedAveTri;
Tri.wiffle=wiffleTreeVals(Tri.force,Tri.xvals);



function [wiffle]=wiffleTreeVals(Force,Xvals)
F12=Force(1)+Force(2);
F13=Force(3)+Force(4);
A=[0,0,-Force(1),Force(2),0,0;0,0,0,0,-Force(3),Force(4);-F12,F13,0,0,0,0;1,1,0,-1,0,1;0,0,1,1,0,0;0,0,0,0,1,1];
invA=inv(A);
B=[0;0;0;Xvals(4)-Xvals(2);Xvals(4)-Xvals(3);Xvals(4)-Xvals(3)];
wiffle=invA*B;
end


