function [ Lmk, Frms, Facs ] = papTestAnchorOnFrm( Rob, Sen, Lmk, Obs , Frms, Facs, Opt, currFrmIdx, currFacIdx )
%PAPTESTANCHORONFRM Reanchor pap pnt on frame if it is a better anchor
%   [ LMK, FRMS, FACS ] = PAPTESTANCHORONFRM( ROB, SEN, LMK, OBS , FRMS,
%   FACS, CURRFRMIDX, CURRFACIDX ) test if the frame FRMS(CURRFRMIDX) is a
%   better anchor than the current main and associated anchor frames, and
%   perform a reanchoring if needed. Note we consider here that the a
%   projection factor to the current frame was already added to the graph.
% 
%   The test is based on the parallax angle values computed using the frame
%   estimates and the observations from these frames. We do not reanchor if
%   the current parallax is above a MAXPARTHRESHOLD. The reanchoring
%   procedure is composed of the following steps:
%      1. update FACS.FRAMES of projection factors to this landmark;
%      2. update LMK.ANCHORFAC
%      3. update pointers on LMK.PAR
%      4. update LMK.STATE.X

%   Copyright 2015 Ellon Paiva @ LAAS-CNRS.

% Only continue if the current factor is not one of the factors linking
% only to anchor frames
if Lmk.par.mainfac == currFacIdx || Lmk.par.assofac == currFacIdx
    return
end
 
% If we have good anchors (aka lmk is fixed to anchors) we do nothing.
if Lmk.fixedAnchors
    return
end

% Get main, associated and current camera frames
[ maincamframe, assocamframe ] = papLmkCamAnchorFrames( Lmk, Sen, Frms );
currcamframe = composeFrames(updateFrame(Frms(currFrmIdx).state),Sen.frame);

% Get parallax angle between main anchor frame and current frame, and
% between associated anchor frame and current frame
papmaincurr = measurements2pap(maincamframe, Lmk.par.mainmeas, ...
                               currcamframe, Facs(currFacIdx).meas.y, ...
                               Sen.par.k, Sen.par.c);
papassocurr = measurements2pap(assocamframe, Lmk.par.assomeas, ...
                               currcamframe, Facs(currFacIdx).meas.y, ...
                               Sen.par.k, Sen.par.c);
% papmaincurr = pap2newanchors(Lmk.state.x,maincamframe.t,currcamframe.t);
% papassocurr = pap2newanchors(Lmk.state.x,assocamframe.t,currcamframe.t);

% Based on the new parallax angles, test if the current frame is a better
% anchor than the current anchors
[~, bestParIdx] = max([Lmk.state.x(9) papmaincurr(9) papassocurr(9)]);
switch bestParIdx
    case 1 % Parallax main-asso is better
        % do nothing. We suppose a factor to the current frame was already
        % added.
        
    case 2 % Parallax main-current is better, perform the reanchoring.
        % Before reanchoring, check the distance between the new anchors.
        % If its bigger than a threshold, we do not reanchor, and mark the
        % lmk current anchors as fixed. This is a workaround when
        % simulating landmarks, to avoid anchors that are too far from each
        % other, and which relative uncertainty would be big. 
        if abs(Frms(Lmk.par.mainfrm).id - Frms(currFrmIdx).id) > Opt.init.papPnt.maxAncDistKf
             Lmk.fixedAnchors = true;
             return;
        end
        
        % If we get here, proceed with reanchoring...
        
        % Set the current frame as the associated anchor frame
        [ Lmk, Frms, Facs ] = papChangeAssoAnchorToFrm( Lmk, Frms, Facs, currFrmIdx, currFacIdx );
        
        % Update lmk state
        Lmk.state.x = papmaincurr;
        
        % Set fixedAnchors flag if parallax is good enough
        if Lmk.state.x(9) >= Opt.init.papPnt.noReanchorTh
            Lmk.fixedAnchors = true;
        end
        
        % Mark the landmark to be reseted if it is not new (used by GTSAM)
        if ~Lmk.new
            Lmk.reset = true;
        end
        
    case 3 % Parallax asso-current is better, perform the reanchoring
        % As in the 'case 2' above, before reanchoring, check the distance
        % between the new anchors, bur here the new main-asso anchors
        % frames are the associated and the newest frame.
        if abs(Frms(Lmk.par.assofrm).id - Frms(currFrmIdx).id) > Opt.init.papPnt.maxAncDistKf
             Lmk.fixedAnchors = true;
             return;
        end
        
        % If we get here, proceed with reanchoring...
        
        % First swap main and associated anchors
        [ Lmk, Frms, Facs ] = papSwapMainAssoAnchors( Lmk, Frms, Facs );
        % Then change the current associated anchor (in fact, the main
        % anchor after the swap) to the current frame
        [ Lmk, Frms, Facs ] = papChangeAssoAnchorToFrm( Lmk, Frms, Facs, currFrmIdx, currFacIdx );

        % Update lmk state
        Lmk.state.x = papassocurr;
        
        % Set fixedAnchors flag if parallax is good enough
        if Lmk.state.x(9) >= Opt.init.papPnt.noReanchorTh
            Lmk.fixedAnchors = true;
        end
        
        % Mark the landmark to be reseted if it is not new (used by GTSAM)
        if ~Lmk.new
            Lmk.reset = true;
        end
        

end

end

