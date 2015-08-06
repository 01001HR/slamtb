function [Rob, Frm] = rob2frm(Rob, Frm)

% Creates a frame Frm from information in Rob.

global Map

Frm.rob = Rob.rob;
Frm.used = true;
% Frm.state.r % This is fixed by Frm structure.
Frm.state.x = Rob.state.x;
Frm.state.size = Rob.state.size;
% Frm.manifold.r % This is fixed by Frm structure.
Frm.manifold.x = Rob.manifold.x;
Frm.manifold.size = Rob.manifold.size;
Frm.manifold.active = true;

% Copy data to Map storage
Map.x(Frm.state.r) = Frm.state.x;
% Manifolds are zero until soving:
Map.m(Frm.manifold.r) = 0; 

% Sync rob ranges to those in Frm
Rob.state.r = Frm.state.r;
Rob.manifold.r = Frm.manifold.r;



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

