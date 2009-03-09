function drawObsPoint(SenFig, Obs, colors)

% DRAWOBSPOINT(SENFIG, OBS, COLORS)  (re)draw a landmark on the pinHole sensor figure.
%
% COLORS is the colors witch apply to the point figure. ex:
%    colors = ['m' 'r']; % magenta/red or
%    colors = ['b' 'c']; % blue/cyan
% OBS is the observation of the couple (landmark/sensor).
%


posOffset = [0;0];

% get the lmk id
lmk = Obs.lid;


% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(lmk),...
        'xdata', y(1),...
        'ydata', y(2),...
        'color', colors(1),...
        'vis',   'on');
else
    set(SenFig.measure(lmk),...
        'vis',   'off');
end

% the ellipse
[X,Y] = cov2elli(Obs.exp.e, Obs.exp.E, 3, 10) ;
set(SenFig.ellipse(lmk),...
    'xdata', X,...
    'ydata', Y,...
    'color', colors(1+Obs.updated),...
    'vis',   'on');

% the label
pos = Obs.exp.e + posOffset;
set(SenFig.label(lmk),...
    'position', pos,...
    'vis',      'on');




