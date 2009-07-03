function [d,D_l,D_p] = lp2d(l,p)

% LP2D  Line-point signed distance, in 2D.
%   LP2D(HM,P) is the orthogonal signed distance from point P to the 2-D
%   homogeneous line HM. The point P can be either an Euclidean 2-vector or
%   a projective (homogeneous) 3-vector.
%
%   [d,D_hm,D_p) = LP2D(...) returns the Jacobians wrt HM and P.

if numel(p) == 2
    [p,P_p] = euc2hmg(p);
else
    P_p = 1;
end

n   = l(1:2);
nn2 = dot(n,n);
nn  = sqrt(nn2);
nn3 = nn2*nn;
ltp = l'*p;

d   = ltp/p(3)/nn;

if nargout > 1 % jac
    
    [u,v,w] = split(p);
    [a,b,c] = split(l);
    
    D_l = [ u/w/nn-ltp/w/nn3*a, v/w/nn-ltp/w/nn3*b,  1/nn];
    D_p = [ a/w/nn, b/w/nn, c/w/nn-ltp/w^2/nn]*P_p;

end

return

%% jac

syms a b c u v w real
l = [a;b;c];

%% Euclidean build
p = [u;v];
d = lp2d(l,p)

D_l = jacobian(d,l)
D_p = jacobian(d,p)

%% Euclidean test
p = [u;v];
[d,D_l,D_p] = lp2d(l,p)

D_l - jacobian(d,l)
D_p - jacobian(d,p)

%% Homog build
p = [u;v;w];
d = lp2d(l,p)

D_l = jacobian(d,l)
D_p = jacobian(d,p)

%% Homog test
p = [u;v;w];
[d,D_l,D_p] = lp2d(l,p)

simplify(D_l - jacobian(d,l))
simplify(D_p - jacobian(d,p))
