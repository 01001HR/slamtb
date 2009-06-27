function [p0,P0_l] = lineOrigin(L)

n = L(1:3);
v = L(4:6);

if nargout == 1

    f = cross(v,n);
    g = dot(v,v);

    p0 = f/g;

else % Jac
    % numerator
    [f,F_v,F_n] = crossJ(v,n);
    % denominator
    g    = dot(v,v);
    G_v  = 2*v';

    % 3D point
    p0   = f/g;
    P0_f = 1/g;  % = eye(3)/g
    P0_g = -f/g^2;

    % Jacobians wrt n and v
    P0_n = P0_f*F_n;
    P0_v = P0_f*F_v + P0_g*G_v;

    % full Jacobian
    P0_l = [P0_n P0_v];
end

return

%%

syms nx ny nz vx vy vz real
L = [nx;ny;nz;vx;vy;vz];
[p0,P0_l] = lineOrigin(L);

simplify(P0_l - jacobian(p0,L))
