function [l, L_rf, L_sf, L_sk, L_hm, L_beta] = ...
    retroProjPlkLinFromPinHoleOnRob(Rf, Sf, Sk, hm, beta)

% RETROPROJPLKLINFROMPINHOLEONROB Retro-project Plucker line from pinhole on robot.
%
%   L = RETROPROJPLKLINFROMPINHOLEONROB(RF, SF, SK, HM, beta) gives the
%   retroprojected Plucker line L in World Frame from an observed
%   homogeneous line HM. RF and SF are Robot and Sensor Frames, SK is the
%   camera calibration parameters vector, HM is the detected homogeneous 2D
%   line and BETA is the non-measurable prior. L is a 6-vector :
%     L = [nx ny nz vx vy vz]'
%   with the 6 Plucker coordinates of a line in 3D space.
%
%   [L, L_rf, L_sf, L_k, L_hm, L_n] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, HM and N.
%
%   See also INVPINHOLEIDP, FROMFRAMEIDP.

% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

% L in Sensor Frame
[ls, LS_sk, LS_hm, LS_beta] = invPinHolePlucker(Sk,hm,beta) ;

% L in world frame
[lr, LR_sf, LR_ls] = fromFramePlucker(Sf, ls) ;
[l,  L_rf,  L_lr]  = fromFramePlucker(Rf, lr) ;

% chain rule for Jacobians
L_sf = L_lr*LR_sf ;
L_ls = L_lr*LR_ls ;
L_sk = L_ls*LS_sk ;
L_hm = L_ls*LS_hm ;
L_beta = L_ls*LS_beta ;

return

%% test
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av h1 h2 h3 b1 b2 real

Rf.x = [rx;ry;rz;ra;rb;rc;rd];
Sf.x = [sx;sy;sz;sa;sb;sc;sd] ;

Rf   = updateFrame(Rf);
Sf   = updateFrame(Sf);
Sk   = [u0;v0;au;av];
hm   = [h1 h2 h3]';
beta = [b1 b2]';

%% test jacobian
[l,L_r,L_s,L_k,L_hm,L_beta] = retroProjPlkLinFromPinHoleOnRob(Rf,Sf,Sk,hm,beta)

%% down here tha Jac test - WARNING! IT TAKES AGES TO COMPUTE !!
simplify(L_r - jacobian(l,Rf.x))
simplify(L_s - jacobian(l,Sf.x))
% simplify(L_k - jacobian(l,Sk))
% simplify(L_hm - jacobian(l,hm))

%% numerical test
Rf.x = epose2qpose([0 0 0 deg2rad([0 0 0])]');
Sf.x = epose2qpose([0 0 0 deg2rad([90 0 90])]');
Rf   = updateFrame(Rf);
Sf   = updateFrame(Sf);
Sk   = [100 100 100 100]';
hm   = [1 0 0]';
beta = [1 0]';

[l,L_r,L_s,L_k,L_hm,L_beta] = retroProjPlkLinFromPinHoleOnRob(Rf,Sf,Sk,hm,beta)
