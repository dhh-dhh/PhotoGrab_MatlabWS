function drawcircle(c,r)
hold on;
theta=0:pi/100:2*pi;

x=c(1,1)+r*cos(theta); y=c(1,2)+r*sin(theta);

rho=r*sin(theta);

% figure(1)

plot(x,y,'-')

hold on; axis equal
% % 
% fill(x,y,'c')

% figure(2)
% 
% h=polar(theta,rho);
% 
% set(h,'LineWidth',2)