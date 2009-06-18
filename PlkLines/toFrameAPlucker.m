function [Lf,Lf_f,Lf_l] = toFrameAPlucker(F,L)

% TOFRAMEAPLUCKER  Anchored Plucker toFrame transform.
%   TOFRAMEAPLUCKER(F,L) transforms the anchored Plucker line L from the
%   global frame to the frame F.
%
%   The anchored Plucker line is defined by L = [x; n; v], where
%       x  : is the anchor, a 3-point
%       n  : is the 3-normal to the plane containing the line and the anchor
%       v  : is a director 3-vector of the line
%
%   [Lf,Lf_f,Lf_l] = TOFRAMEAPLUCKER(F,L) returns the Jacobians wrt F and
%   L.

% (c) 2008 Joan Sola @ LAAS-CNRS

x = L(1:3);
n = L(4:6);
v = L(7:9);

t = F(1:3);
q = F(4:7);

if nargout == 1
    
    R = q2R(q);
    xf = R'*x - R'*t;
    nf = R'*n;
    vf = R'*v;
    Lf = [xf;nf;vf];
    
else
    
    [xf,Xf_f,Xf_x] = toFrame(F,x);
    [nf,Nf_q,Nf_n] = Rtp(q,n);
    [vf,Vf_q,Vf_v] = Rtp(q,v);
    Z33 = zeros(3);
    
    Lf = [xf;nf;vf];
    
    Lf_f = [...
        Xf_f
        Z33 Nf_q
        Z33 Vf_q];
    
    Lf_l = [...
        Xf_x Z33  Z33
        Z33  Nf_n Z33
        Z33  Z33  Vf_v];
    
end

return

%% jac

syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 real

F = [t1;t2;t3;a;b;c;d];
L = [x1;x2;x3;n1;n2;n3;v1;v2;v3];

[Lf,Lf_f,Lf_l] = toFrameAPlucker(F,L);

simplify(Lf   - toFrameAPlucker(F,L))
simplify(Lf_f - jacobian(Lf,F))
simplify(Lf_l - jacobian(Lf,L))
