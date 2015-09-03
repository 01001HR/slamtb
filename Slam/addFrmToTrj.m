function [Lmk,Trj,Frm,Fac] = addFrmToTrj(Sen,Lmk,Trj,Frm,Fac)

% ADDFRMTOTRJ Add frame to trajectory
%   [Trj,Frm,Fac] = ADDFRMTOTRJ(Trj,Frm,Fac) Adds a frame to the trajectory
%   Trj. It does so by advancing the HEAD pointer in the trajectory Trj,
%   and clearing sensitive data in the frame pointed by the new HEAD.
%
%   The trajectory is a circular array, so when all positions are full,
%   adding a new frame overwrites the oldest one. In such case, all factors
%   linking to the discarded frame are cleared.
%
%   The added frame is empty, and only its ID is created, distinct to all
%   other IDs.

% Advance HEAD
Trj.head = mod(Trj.head, Trj.maxLength) + 1;

% Update TAIL
if Trj.length < Trj.maxLength

    % Trj is not yet full. Just lengthen.
    Trj.length = Trj.length + 1;

else
    % Trj is full. Tail frame will be overwritten !!
    
    % Reanchor landmarks anchored on the tail
    [Lmk,Trj,Frm,Fac] = moveAnchorsFromTailFrm(Sen,Lmk,Trj,Frm,Fac);
    
    % Remove tail frame and cleanup graph
    [Lmk,Trj,Frm,Fac] = removeTailFrm(Lmk,Trj,Frm,Fac);
        
    % Advance TAIL
    Trj.tail = mod(Trj.tail, Trj.maxLength) + 1;    
    
end

% Complete the new frame with no factors
Frm(Trj.head).used    = true;
Frm(Trj.head).id      = newId('Frm'); % Frame unique ID
Frm(Trj.head).factors = [];

% Query and Block positions in Map
r = newRange(Frm(Trj.head).state.dsize);
blockRange(r);
Frm(Trj.head).state.r = r;


end

function [Lmk,Trj,Frm,Fac] = removeTailFrm(Lmk,Trj,Frm,Fac)

% REMOVETAILFRM Remove tail frame from trajectory.
%
%   [Lmk,Trj,Frm,Fac] = REMOVETAILFRM(Lmk,Trj,Frm,Fac) removes the tail
%   frame from  Trj and cleans up all the information in Lmk(:), Frm(:,:),
%   Fac(:) that has been affected.
%
%   The motionh factor linking this frams to the next one is converted to
%   an absolute factor.

global Map

% Delete factors from factors lists in Frm and Lmk
factors = Frm(Trj.tail).factors;
for fac = factors
    
    if strcmp(Fac(fac).type, 'motion') 
        % Convert motion factor to absolute factor
%         fprintf('Converting Fac ''%d''.\n', fac)
        
        newTail = Fac(fac).frames(2);
        [Frm(newTail),Fac(fac)] = makeAbsFactorFromMotionFactor(Frm(newTail),Fac(fac));
    
    else
        [Fac(fac),Frm,Lmk] = deleteFactor(Fac(fac),Frm,Lmk);    
    end
    
end

%     [Fac(factors).used] = deal(false);
%     [Fac(factors).frames] = deal([]);
%     [Fac(factors).lmk] = deal([]);

% Clean discarded tail frame
Frm(Trj.tail).used = false;
Frm(Trj.tail).factors = [];

% Unblock positions in Map
Map.used(Frm(Trj.tail).state.r)    = false;


end

function [Lmk,Trj,Frms,Facs] = moveAnchorsFromTailFrm(Sen,Lmk,Trj,Frms,Facs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

factors = Frms(Trj.tail).factors;
for fac = factors
    if strcmp(Facs(fac).type, 'measurement') 
        switch Lmk(Facs(fac).lmk).type
            case 'idpPnt'
                if Lmk(Facs(fac).lmk).par.anchorfrm == Trj.tail
                    [Lmk(Facs(fac).lmk),Frms,Facs] = reanchorIdpLmk(Sen,Lmk(Facs(fac).lmk),Frms,Facs);
                end
            case 'papPnt'
                if Lmk(Facs(fac).lmk).par.mainfrm == Trj.tail
                    reanchorPapPntMainAnchor();
                elseif Lmk(Facs(fac).lmk).par.assofrm == Trj.tail
                    reanchorPapPntAssoAnchor();
                end
                
        end
    end
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

