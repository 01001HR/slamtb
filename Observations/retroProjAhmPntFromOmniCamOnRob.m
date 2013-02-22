function [ahm, AHM_rf, AHM_sf, AHM_sk, AHM_sc, AHM_u, AHM_rho] = ...
    retroProjAhmPntFromOmniCamOnRob(Rf, Sf, Sk, Sc, u, n)

% RETROPROJAHMPNTFROMOMNICAMONROB Retro-project ahm from omnicam on robot.
%
%   AHM = RETROPROJAHMPNTINTOOMNICAMONROB(RF, SF, SK, SC, U, N) gives the
%   retroprojected AHM in World Frame from an observed pixel U. RF and SF
%   are Robot and Sensor Frames, Sk and Sc are camera calibration and
%   distortion correction parameters. U is the pixel coordinate and N is
%   the non-observable inverse depth. AHM is a 7-vector :
%     AHM = [X Y Z U V W IDepth]'
%
%   [AHM, AHM_rf, AHM_sf, AHM_k, AHM_c, AHM_u, AHM_n] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, U and N.
%
%   See also FROMFRAMEAHM.
%

%   Copyright 2012 Grigory Abuladze @ ASL-vision
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

  % AHM in Sensor Frame
  [ahms, AHMS_u, AHMS_rho, AHMS_sk, AHMS_sc] = invOmniCamAhm(u, n, Sk, Sc) ;

  [ahmr, AHMR_sf, AHMR_ahms] = fromFrameAhm(Sf,ahms);
  [ahm , AHM_rf , AHM_ahmr]  = fromFrameAhm(Rf,ahmr);

  AHM_ahms = AHM_ahmr*AHMR_ahms;
  AHM_sk   = AHM_ahms*AHMS_sk ;
  AHM_sf   = AHM_ahmr*AHMR_sf;

  AHM_sc  = AHM_ahms*AHMS_sc ;

  AHM_u   = AHM_ahms*AHMS_u ;
  AHM_rho = AHM_ahms*AHMS_rho ;

end











