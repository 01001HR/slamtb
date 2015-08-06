function Fac = makeMotionFactor(Frm_old, Frm_new, Fac, factorRob)


Fac.used = true; % Factor is being used ?
%     Fac.fac = fac; % index in Fac array
Fac.id = newId; % Factor unique ID

Fac.type = 'motion'; % {'motion','measurement','absolute'}
%     Fac.sen = []; % sen index
%     Fac.lmk = []; % lmk index
%     Fac.id1 = []; % id of block 1
%     Fac.id2 = []; % id of block 2

% Project into manifold, 7DoF --> 6DoF
[e, E_x] = qpose2epose(factorRob.state.x);
E = E_x * factorRob.state.P * E_x';

% Measurement is the straight data
Fac.meas.y = e;
Fac.meas.R = E;
Fac.meas.W = E^-1; % measurement information matrix

% Expectation has zero covariance -- and info in not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(E)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z = zeros(size(e)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z = Fac.meas.R; % error cov matrix
Fac.err.W = Fac.meas.W; % error information matrix

% Jacobians are zero at this stage. Just make size correct.
Fac.err.E_node1 = zeros(6,factorRob.state.size); % Jac. of error wrt. node 1
Fac.err.E_node2 = zeros(6,factorRob.state.size); % Jac. of error wrt. node 2

% Cross link factor with frames
% Fac.frmId = [Frm_old.id Frm_new.id]; % frame ids
Fac.frm = [Frm_old.frm Frm_new.frm];

% Append factor ID to factors list.
Frm_old.factorIds = [Frm_old.factorIds Fac.id]; 
Frm_new.factorIds = [Frm_new.factorIds Fac.id]; 
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

