function [MapFig,SenFig] = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...
    SimRob, SimSen, SimLmk,...
    FigOpt)

% CREATEGRAPHICSSTRUCTURES Create figures and graphics handles structures.
%   [MAPFIG,SENFIG] = CREATEGRAPHICSSTRUCTURES ...
%       (ROB,SEN,LMK,OBS,SIMROB,SIMSEN,SIMLMK,MAPFIGURE,SENFIGURES) creates
%   a 3D figure MapFig and one figure for each sensor in Sen(). It returns
%   a structure MAPFIG with handles to objects in the map figure, and a
%   structure array SENFIG with handles to graphics objects in each sensor
%   figure. To do so, its need information from the following sources:
%
%       ROB:      Structure array of robots.
%       SEN:      Structure array of sensors.
%       LMK:      Structure array of landmarks.
%       OBS:      Structure array of observations.
%       SIMROB:   Structure array of simulated robots.
%       SIMSEN:   Structure array of simulated sensors.
%       SIMLMK:   Structure array of simulated landmarks.
%       FIGOPT:   User-defined structure with options for figures
%
%   See also CREATEMAPFIG, CREATESENFIG, USERDATA, SLAMTB, and
%   consult slamToolbox.pdf in the root directory.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


% Init map figure
MapFig = createMapFig(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,FigOpt);

% Init sensor's measurement space figures
SenFig = createSenFig(Sen,Obs,SimLmk,FigOpt);










