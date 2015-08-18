function Lmk = updateLmk(Lmk,Sen,Frms)

global Map

% Get state error from Map
dl = Map.x(Lmk.state.r);

% IMPORTANT: for anchored landmarks the frames should be already updated.
switch Lmk.type
    case 'eucPnt'
        % Trivial composition -- no manifold stuff
        Lmk.state.x = Lmk.state.x + dl;
    case 'idpPnt'
        % get some pointers
        rob = Lmk.par.anchorrob;
        sen = Lmk.par.anchorsen;
        frm = Lmk.par.anchorfrm;
        anchorpose = composeFrames(updateFrame(Frms(rob,frm).state),Sen(sen).frame);
        
        Lmk.state.x(1:3) = anchorpose.x(1:3);
        Lmk.state.x(4:6) = Lmk.state.x(4:6) + dl;
        if Lmk.state.x(end) < 0
            Lmk.state.x(end) = 0.001; % Fix lmk
        end
    case 'papPnt'
        % only update if in complete form
        [~, ~, ~, ~, completeForm] = splitPap( Lmk.state.x );
        if completeForm
            % get some pointers
            % FIXME: This may not work for multirobot (using the same sensor!)
            mainanchorpose = composeFrames(updateFrame(Frms(Lmk.par.mainfrm).state),Sen.frame);
            assoanchorpose = composeFrames(updateFrame(Frms(Lmk.par.assofrm).state),Sen.frame);

            Lmk.state.x(1:3) = mainanchorpose.t;
            Lmk.state.x(4:6) = assoanchorpose.t;
            Lmk.state.x(7:9) = Lmk.state.x(7:9) + dl;
            
            if Lmk.state.x(end) < 0
                Lmk.state.x(end) = 0.001; % Fix lmk
            end
        end

    case 'hmgPnt'
        Lmk.state.x = composeHmgPnt(Lmk.state.x, dl);
    otherwise
        error('??? Unknown landmark or update not yet implemented landmark type ''%s''.',Lmk.type)
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

