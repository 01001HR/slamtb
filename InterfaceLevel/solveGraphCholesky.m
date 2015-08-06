function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac)

% SOLVEGRAPHCHOLESKY Solves the SLAM graph using Cholesky decomposition.
%
%   See courseSLAM.pdf in the documentation for details about the Cholesky
%   decomposition, graph-SLAM algorithm.

% Copyright 2015-    Joan Sola @ IRI-UPC-CSIC.

global Map

% Control of iterations and exit conditions
res_old     = 1e10;
target_dres = 1e-2;
target_res  = 1e-6;
n_iter      = 30;

% Map range
mr = find(Map.used);

for it = 1:n_iter
    
    fprintf('----------------\nIteration: %d; \n',it)

    
    % Compute Jacobians for projection onto the manifold
    [Frm,Lmk] = computeStateJacobians(Frm,Lmk);
    
    % Build Hessian and rhs vector
    Fac = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac);
    
    % Column permutation
    p = colamd(Map.H(mr,mr))';
    
    % Permutated map range
    pr = mr(p);
    
    % Decomposition
    [Map.R, ill] = chol(Map.H(pr,pr));
    
    if ~ill

        % Solve for dx
        y = -Map.R'\Map.b(pr); % solve for y
        dx(p,1) = Map.R\y;     % solve for dx and reorder
        Map.x(mr) = dx;
        
        % Update nominal states
        [Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm);
        
        % Check resulting errors
        [res, err_max] = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac);
        dres = res - res_old; 
        res_old = res;
        
        fprintf('Residual: %.2e; variation: %.2e \n', res, dres)
        
    else
        error('Ill-conditioned Hessian')
    end
    
    if ( ( -dres <= target_dres ) || (err_max <= target_res) ) %&& ( abs(derr) < target_derr) )
        break;
    end
    
end

% fprintf('it: %2d / nfac: %3d / err: %.2e\n', it, sum([Fac.used]), err)

end

function [Frm,Lmk] = computeStateJacobians(Frm,Lmk)

% COMPUTESTATEJACOBIANS Compute Jacobians for projection onto the manifold.

Frm = frmJacobians(Frm);
Lmk = lmkJacobians(Lmk);
end

function [Fac] = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac)

% BUILDPROBLEM Build least squares problem's matrix H and vector b

global Map

% Reset Hessian and rhs vector
mr = find(Map.used);
Map.H(mr,mr) = 0;
Map.b(mr)    = 0;

% Iterate all factors
facs = find([Fac.used]);
for fac = facs
    
    % Extract some pointers
    rob = Fac(fac).rob;
    sen = Fac(fac).sen;
    lmk = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, info mat, and Jacobians
    [Fac(fac), e, W, J1, J2, r1, r2] = computeError(Rob(rob),Sen(sen),Lmk(lmk),Obs(sen,lmk),Frm(frames),Fac(fac));

    % Compute sparse Hessian blocks
    H_11 = J1' * W * J1;
    H_12 = J1' * W * J2;
    H_22 = J2' * W * J2;
    
    % Compute rhs vector blocks
    b1 = J1' * W * e;
    b2 = J2' * W * e;
    
    % Update H and b
    Map.H(r1,r1) = Map.H(r1,r1) + H_11;
    Map.H(r1,r2) = Map.H(r1,r2) + H_12;
    Map.H(r2,r1) = Map.H(r2,r1) + H_12';
    Map.H(r2,r2) = Map.H(r2,r2) + H_22;
    
    Map.b(r1,1) = Map.b(r1,1) + b1;
    Map.b(r2,1) = Map.b(r2,1) + b2;

%     fprintf('Factor: %3d; ''%s'' ; error: %e \n', fac, Fac(fac).type(1:4), norm(e))

end

end

function [Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm)

% UPDATESTATES Update Frm and Lmk states based on computed error.

global Map

for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        Frm(rob,frm) = updateKeyFrm(Frm(rob,frm));
    end
%     Rob(rob) = frm2rob(Rob(rob), Frm(rob,Trj.head));
end
for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'eucPnt'
            % Trivial composition -- no manifold stuff
            Lmk(lmk).state.x = Lmk(lmk).state.x + Map.x(Lmk(lmk).state.r);
        otherwise
            error('??? Unknown landmark type ''%s'' or Update not implemented.',Lmk.type)
    end
end

% Reset error state
Map.x(Map.used) = 0;

end

function [res, err_max] = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac)

res = 0;
err_max = 0;

for fac = [Fac([Fac.used]).fac]
    
    rob = Fac(fac).rob;
    sen = Fac(fac).sen;
    lmk = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, and info mat
    [Fac(fac), e, W] = computeError(Rob(rob),Sen(sen),Lmk(lmk),Obs(sen,lmk),Frm(frames),Fac(fac));

    err_maha = e' * W * e;
    
    if err_maha > err_max
        err_max = err_maha;
    end
    
    res = res + err_maha;
    
end

end


% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

