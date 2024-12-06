clear;
clc;
close all;

L=10;
x=0:.1:L;
E=10^7; %PSI
I=.000072;
U=1./(E.*I);
Wo=.37
W1=.18
%W1=
%%Rectangular
%Deflection Equation

Rect.Vx=U.*((Wo.*(x.^4)./24)-L.*Wo.*(x.^3)./6+Wo.*(L.^2).*(x.^2)./4);
Rect.MaxV=max(Rect.Vx);

%Moment Equation

Rect.Mx=(.5).*Wo.*(x.^2)-Wo.*L.*x+Wo.*(L.^2)-(.5).*Wo.*(L.^2);
Rect.MaxMx=max(Rect.Mx);

%Shear Stress equation
Rect.ShearStress=-Wo.*x+Wo.*L;
Rect.Strain=Rect.ShearStress./E;

figure(1)
subplot(2,2,1)
plot(x,Rect.Vx)
title('Deflection versus X')
xlabel('x position (in)')
ylabel('Deflection value (in)')
subplot(2,2,2)
plot(x,Rect.Mx)
title('Bending Moment versus X')
xlabel('x position (in)')
ylabel('Bending Moment value (lb*in)')
subplot(2,2,3)
plot(x,Rect.ShearStress)
title('Bending Shear Stress versus X')
xlabel('x position (in)')
ylabel('Bending Shear Stress value (lb*in)')
subplot(2,2,4)
plot(x,Rect.Strain)
title('Bending Strain versus X')
xlabel('x position (in)')
ylabel('Bending Strain value')
%%Trapeziodal
%Deflection Equation

%Vx.Trap=

%Moment Equation

Trap.Mx=(W1-Wo).*(x.^3)./(6.*L)+Wo.*(x.^2)./2-L.*(W1+Wo).*x./2+(2.*W1+Wo).*(L.^2)./6;

Trap.Vx=U.*((W1-Wo).*(x.^5)./(120.*L)+Wo.*(x.^4)./24-L.*(W1+Wo).*(x.^3)./12+(2.*W1+Wo).*(L.^2).*(x.^2)./12);

Trap.ShearStress=-(W1-Wo).*(x.^2)./(2.*L)-Wo.*x+L.*(W1+Wo)./2;

Trap.Strain=Trap.ShearStress./(E);

figure(2)
subplot(2,2,1)
plot(x,Trap.Vx)
title('Deflection versus X')
xlabel('x position (in)')
ylabel('Deflection value (in)')
subplot(2,2,2)
plot(x,Trap.Mx)
title('Bending Moment versus X')
xlabel('x position (in)')
ylabel('Bending Moment value (lb*in)')
subplot(2,2,3)
plot(x,Trap.ShearStress)
title('Bending Shear Stress versus X')
xlabel('x position (in)')
ylabel('Bending Shear Stress value (lb*in)')

subplot(2,2,4)
plot(x,Trap.Strain)
title('Bending Strain versus X')
xlabel('x position (in)')
ylabel('Bending Strain value')

%%Triangular
%Deflection Equation

Tri.Vx=U.*(-Wo.*(x.^5)./(120.*L)+Wo.*(x.^4)./24-Wo.*L.*(x.^3)./12+Wo.*(L.^2).*(x.^2)./12)

%Moment Equation
%Trap.Mx=(W1-Wo).*(x.^3)./(6.*L)+Wo.*(x.^2)./2-L.*(W1+Wo).*x./2+(2.*W1+Wo).*(L.^2)./6;
Tri.Mx=-Wo.*(x.^3)./(6.*L)+Wo.*(x.^2)./2-Wo.*L.*x./2+Wo.*(L.^2)./6;  %-Wo.*x.*(x.^2-3.*L.*x+3.*L.^2)./(6.*L)+(Wo.*L.^2)./6;

Tri.ShearStress=Wo.*(x.^2)./(2.*L)-Wo.*x+Wo.*L./2;

Tri.Strain=Tri.ShearStress./E;


figure(3)
subplot(2,2,1)
plot(x,Tri.Vx)
title('Deflection versus X')
xlabel('x position (in)')
ylabel('Deflection value (in)')
subplot(2,2,2)
plot(x,Tri.Mx)
title('Bending Moment versus X')
xlabel('x position (in)')
ylabel('Bending Moment value (lb*in)')
subplot(2,2,3)
plot(x,Tri.ShearStress)
title('Bending Shear Stress versus X')
xlabel('x position (in)')
ylabel('Bending Shear Stress value (lb*in)')

subplot(2,2,4)
plot(x,Tri.Strain)
title('Bending Strain versus X')
xlabel('x position (in)')
ylabel('Bending Strain value')


