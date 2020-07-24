function [g1, gamma] = forward_GK_parameters(g,a)

angles = linspace(0,pi,20000);
u = cos(angles);

K = 1/pi * a * g * (1-g^2)^(2*a)/((1 + g)^(2*a) - (1 - g)^(2*a));

pGK = K*(1 + g^2 - 2*g*u).^(-(a + 1));

%     g1 = -2 * pi * trapz(u, u.*pGK);

L = ((1+g)^(2*a)+(1-g)^(2*a))/((1+g)^(2*a) - (1-g)^(2*a));
g1 = (2*g*a*L - (1 + g^2))/(2*g*(a-1));

g2 = 2*pi*trapz(angles, pGK.*sin(angles).*(1/2 * (3*(cos(angles)).^2 - 1)));

gamma = (1 - g2)/(1 - g1);