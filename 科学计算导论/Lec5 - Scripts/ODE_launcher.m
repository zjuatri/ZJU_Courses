% ODE launcher

clear; clc; close all

[t,x] = ode45(@ode_to_solve,[0 10],[2]);
semilogy(t,x)