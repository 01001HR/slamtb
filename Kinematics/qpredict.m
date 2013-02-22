function [q1,Q1_q,Q1_w] = qpredict(q,w,dt,met)

% QPREDICT Time update function for quaternions.
%   Qu = QPREDICT(Q,DV) is the updated quaternion Q after a rotation in body
%   frame expressed by the three angles in DV (roll, pitch, yaw).
%
%   Qu = QPREDICT(Q,W,DT) assumes a rotation speed W and a sampling time DT.
%   It is equivalent to the previous case with DV = W*DT.
%
%   [Qu,QU_q,QU_w] = QPREDICT(Q,W,DT) returns Jacobians wrt Q and W.
%
%   [...] = QPREDICT(...,MET) allows the specification of the method to
%   update the quaternion:
%       'tustin' uses Qu = Q + .5*DT*W2OMEGA(W)*Q
%       'exact'  uses Qu = QPROD(Q,V2Q(W*DT))
%   The Jacobians are always computed according to the 'tustin' method.
%   'tustin' is the default method.
%
%   See also QPROD, W2OMEGA, Q2PI, V2Q, QUATERNION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch nargin
    case 2
        dt = 1;
        met = 'tustin';
    case 3
        if isa(dt,'char')
            met = dt;
            dt = 1;
        else
            met = 'tustin';
        end
end


switch lower(met)
    case 'tustin'
        W  = w2omega(w);
        q1 = q + .5*dt*W*q; % Tustin integration - fits with Jacobians
    case 'exact'
        q1 = qProd(q,v2q(w*dt)); % True value - Jacobians based on tustin form
    otherwise
        error('Unknown quaternion predict method. Use ''tustin'' or ''exact''')
end

if nargout > 1  % Jacobians always use Tustin method
    W    = w2omega(w);
    Q1_q = eye(4) + 0.5*dt*W;
    Q1_w = 0.5*dt*q2Pi(q);
end










