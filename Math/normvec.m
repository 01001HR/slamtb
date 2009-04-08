function [vn,VN_v] = normvec(v,jacMethod)

% NORMVEC Normalize vector.
%   NORMVEC(V) is the unit length vector in the same direction and sense as
%   V. It is equal to V/norm(V).
%
%   [NV,NV_v] = NORMVEC(V) returns the Jacobian of the normed vector wrt V.
%
%   [NV,NV_v] = NORMVEC(V,method) , with method ~= 0, uses a scalar diagonal
%   matrix as Jacobian, meaning that the vector has been just scaled to
%   length one by a scalar factor.

% (c) 2008 Joan Sola @ LAAS-CNRS

n2 = dot(v,v);
n  = sqrt(n2);

vn = v/n;

if nargout > 1
    s = numel(v);

    if nargin > 1 && jacMethod ~= 0  % use scalar method (approx)
        VN_v = eye(s)/n;
        
    else                             % use full vector method (exact)
        n3  = n*n2;       
        VN_v = (n2*eye(s) - v*v')/n3;
        
    end

end

return

%%
syms v1 v2 v3 v4 v5 real
v = [v1;v2;v3;v4;v5];
[vn,VN_v] = normvec(v);

simplify(VN_v - jacobian(vn,v))
