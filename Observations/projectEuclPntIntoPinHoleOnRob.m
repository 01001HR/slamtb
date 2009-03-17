function [u,s,U_r,U_s,U_k,U_d,U_l]=projectEuclPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

% PROJECTEUCLPNTINTOPINHOLEONROB Project euclidean point into Pin-hole
% camera model on robot

if nargout <= 2 % only pixel

    lr  = toFrame(Rf,l);
    ls = toFrame(Sf,lr);

    [u,s]=pinHole(ls,Spk,Spd);



else % Jacobians




    [lr, LR_r, LR_l]  = toFrame(Rf,l);
    [ls, LS_s, LS_lr] = toFrame(Sf,lr);

    [u,s,U_ls,U_k,U_d]=pinHole(ls,Spk,Spd);

    U_r  = U_ls*LS_lr*LR_r;
    U_s  = U_ls*LS_s;
    U_lr = U_ls*LS_lr;
    U_l  = U_lr*LR_l;

end
return

%% test Jacobians - WARNING! IT TAKES AGES TO COMPUTE !!
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av d2 d4 d6 lx ly lz real

Rf.x=[rx;ry;rz;ra;rb;rc;rd];
Sf.x=[sx;sy;sz;sa;sb;sc;sd] ;

Rf = updateFrame(Rf);
Sf = updateFrame(Sf);
Spk = [u0;v0;au;av];
Spd = [d2;d4;d6];
l = [lx;ly;lz];

[u,s,U_r,U_s,U_k,U_d,U_l]=projectEuclPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l);


simplify(U_r - jacobian(u,Rf.x))
simplify(U_s - jacobian(u,Sf.x))
simplify(U_k - jacobian(u,Spk))
simplify(U_d - jacobian(u,Spd))
simplify(U_l - jacobian(u,l))













