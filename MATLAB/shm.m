function [period,sol] = shm(omega,theta0,thetad0,grph) 
% Finds the period of a nonlinear pendulum given the length of the pendulum
% arm and initial conditions. All angles in radians.

%Setting initial conditions
if nargin==0
    error('Must omega and initial conditions')
end
if nargin==1
   theta0 = pi/2;
   thetad0=0;
   grph='a';
end
if nargin==2
    thetad0 = 0;
    grph='a';
end
if nargin==3
    grph='a';
end
%g=9.81;

%omega = sqrt(g/R);
T= 2*pi/omega;
% number of oscillations to graph
N = 1;


tspan = linspace(0,N*T,500); 
%Linearly spaced tspan is important.
%If just two elements are supplied in tspan, ode45 returns a non-uniform array
%A non-uniform array in time cannot be used to find the average energies

%opts = odeset('events',@events,'refine',6); %Here for future event finder
opts = odeset('refine',6);
r0 = [theta0 thetad0];
[t,w] = ode45(@proj,tspan,r0,opts,omega);
% Mass is assumed equal to 1
% KE =0.5*theta^2, PE = 0.5*omega^2*thetad^2
E0 = 0.5*(thetad0^2) + 0.5*(omega^2)*(theta0^2);
KEn =  0.5*(w(:,2).^2);
PEn = 0.5*(omega^2)*(w(:,1).^2);
%En = KEn + PEn;
Delta = (KEn+PEn-E0)/E0;
sol = [t,w];
ind= find(w(:,2).*circshift(w(:,2), [-1 0]) <= 0);
ind = chop(ind,4);
period= 2*mean(diff(t(ind)));


if grph=='a'
    plot(t,Delta,'k-')
    title('\Delta_n')
    xlabel('t')
    ylabel( '\Delta_n')
end

if grph=='bc' 
    plot(t,w(:,1),'k-',t,w(:,2),'b-',t,mean(KEn)*ones(size(t,1),1),'r-',t,mean(PEn)*ones(size(t,1),1),'g--');
    legend('$\theta$','$\dot{\theta}$','Kinetic Energy','Potential Energy','Interpreter','latex')
    title('$\theta$,$\dot{\theta}$ ','Interpreter','latex')
    xlabel('t')
    ylabel('$\theta$,$\dot{\theta}$ and Energies','Interpreter','latex')
end

if grph=='d'
    plot(w(:,1),w(:,2),'ob-')
    xlabel('\theta')
    ylabel('$\dot{\theta}$','Interpreter','latex')
end
end
%-------------------------------------------
%
function rdot = proj(t,r,omega)
    rdot = [r(2); -omega*omega*(r(1))];
end
