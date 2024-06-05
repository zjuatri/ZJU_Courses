function vxOpt = goldCornhole(g,c,x0,y0,vxa,vxb,vy,tstep,dis,tol)
phi = (sqrt(5)-1)/2;
vx1 = vxb-phi*(vxb-vxa);
vx2 = vxa+phi*(vxb-vxa);
vxOpt = goldsecsearch(vxa,vx1,vx2,vxb);

    function vx = goldsecsearch(vxa,vx1,vx2,vxb)
        if(f((vx1+vx2)/2)<tol)
            vx = (vx1+vx2)/2;
        else
            if(f(vx1)<f(vx2))
                vxb = vx2;
                vx2 = vx1;
                vx1 = vxb-phi*(vxb-vxa);
                vx = goldsecsearch(vxa,vx1,vx2,vxb);
            else
                vxa = vx1;
                vx1 = vx2;
                vx2 = vxa+phi*(vxb-vxa);
                vx = goldsecsearch(vxa,vx1,vx2,vxb);
            end
        end
    end

    function out = f(vx0)
        out=abs(projectileSim(g,c,x0,y0,vx0,vy,tstep)-dis);
    end
end

function disX = projectileSim(g,c,x0,y0,vx0,vy0,tstep)
t = 0;
x=[x0];
y=[y0];
vx=[vx0];
vy=[vy0];

while y(end)>=0
    ax = -c*vx(end)*sqrt(vx(end)^2 + vy(end)^2);
    ay = -g-c*vy(end)*sqrt(vx(end)^2 + vy(end)^2);
    vx(end+1) = vx(end) + ax*tstep;
    vy(end+1) = vy(end) + ay*tstep;
    x(end+1) = x(end) + vx(end)*tstep;
    y(end+1) = y(end) + vy(end)*tstep;
    t = t + tstep;
    if y(end)==0
        disX = x(end);
        break
    elseif y(end)<0
        tend = y(end-1)/ vy(end-1);
        disX = x(end-1)+ vx(end-1)*tend;
        break
    end
end
end


