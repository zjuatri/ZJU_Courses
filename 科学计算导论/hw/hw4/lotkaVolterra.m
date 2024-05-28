function state = lotkaVolterra (initial_state, alpha, beta, gamma, delta, dt, ntimesteps)
state = zeros(2,ntimesteps);
state(:,1) = initial_state;
for i = 2:ntimesteps
    dx_dt = state(1,i-1)*(alpha - beta * state(2,i-1));
    dy_dt = - state(2,i-1)*(gamma - delta * state(1,i-1));
    state(1,i) = state(1,i-1) + dx_dt * dt;
    state(2,i) = state(2,i-1) + dy_dt * dt;
end

t = linspace(0,dt,ntimesteps);
x = state(1,:);
y = state(2,:);

fig = figure;
plot(t,x);
hold on

plot(t,y);
legend('prey','predator')
set(gcf, 'Position', [500,500,700, 350]); % modify the size of figure
movegui(fig,"center");

end