function state = LorenzAttractor (initial_state, dt, ntimesteps, SIGMA, RHO, BETA)
% LorenzAttractor simulate the behavior of a Lorenz atttractor;

state = zeros(3,ntimesteps);
state(:,1) = initial_state;

for i = 2:ntimesteps
    
    x = state(1,i-1);
    y = state(2,i-1);
    z = state(3,i-1);
    
    dx_dt = SIGMA*(y-x);
    dy_dt = x*(RHO - z) - y;
    dz_dt = x*y - BETA*z;
    
    state(:,i) = state(:,i-1) + dt*[dx_dt; dy_dt; dz_dt];
end