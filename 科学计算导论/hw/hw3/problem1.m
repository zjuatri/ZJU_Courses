theta = 0:0.01:2*pi;
e = 0.967276;
rho = (17.9*(1-e^2))./(1-e.*cos(theta));
polar(theta,rho);
