deg_arr = 0:30:360;
rad_arr = deg_arr/360*2*pi;
sin_arr = sin(rad_arr);
cos_arr = cos(rad_arr);
matrix = [deg_arr' sin_arr' cos_arr'];
disp(matrix);