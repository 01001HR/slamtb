function Lmk = updateEndPoints(Rob,Sen,Lmk,Obs)

% 3D landmark, IDL is Inverse Depth Line
idl     = Lmk.state.x;      % This is the inverse depth line vector
[p1,p2] = idl2pp(idl);      % 3D support points
L = ppLine2pvLine([p1;p2]); % this is a point-vector line

% measured segment
s  = Obs.meas.y; % This is the measured segment, a 4-vector [x1;y1;x2;y2].
u1 = s(1:2);     % this is one endpoint
u2 = s(3:4);     % this is the other endpoint

% optical ray
x0 = fromFrame(Rob.frame,Sen.frame.t);  % this is optical centre in world frame
R  = Rob.frame.R*Sen.frame.R;      % Rob and Sen rotations, composed
v1 = R*invPinHole(u1,1,Sen.par.k); % the first vector
v2 = R*invPinHole(u2,1,Sen.par.k); % the second vector

% point-vector forms of optical rays
R1 = [x0;v1]; % optical ray of first observed endpoint
R2 = [x0;v2]; % optical ray of second observed endpoint

% intersections
[T1,P11] = intersectPvLines(L,R1); % line with optical ray 1
[T2,P21] = intersectPvLines(L,R2); % line with optical ray 2

t1 = T1(1); % only abcissa in landmark line is of interest
t2 = T2(1); % only abcissa in landmark line is of interest

% put always the smallest abscissa first:
if t1>t2
    t = [t2;t1]; % t is now a vector with the 2 abscissas
else
    t = [t1;t2];
end

% here we should see if the new abscissas make the segment longer or not.
% This is already programmed somewhere in Jafar. I leave it like t_new = t:
t_new = t;

% finally we assign to the landmark object.
Lmk.par.endpoints.abscissas = t_new;
Lmk.par.endpoints.p1 = P11;
Lmk.par.endpoints.p2 = P21;

return

%% test - previous
slamrc
% run slamtb and stop after creating SLAM structures
Rob=Rob(1); Rob.frame.x = [0;0;0;1;0;0;0]; Rob.frame = updateFrame(Rob.frame);
Sen=Sen(1); Sen.frame.x = [0;0;0;.5;-.5;.5;-.5]; Sen.frame = updateFrame(Sen.frame);
Lmk=Lmk(1);
Obs=Obs(1,1);

%% test 1
% lmk
p0 = [1;1;1];
p1 = [10;5;1];
p2 = [10;-5;1];
Lmk.state.x = ppp2idl(p0,p1,p2);

% obs
e1 = projEucPntIntoPinHoleOnRob(Rob.frame,Sen.frame,Sen.par.k,Sen.par.d,p1) + randn(2,1);
e2 = projEucPntIntoPinHoleOnRob(Rob.frame,Sen.frame,Sen.par.k,Sen.par.d,p2) + randn(2,1);
Obs.meas.y = [e1;e2];

% abscissas
Lmk = updateEndPoints(Rob,Sen,Lmk,Obs);

% print
Lmk.par.endpoints.abscissas
Lmk.par.endpoints.p1
Lmk.par.endpoints.p2

