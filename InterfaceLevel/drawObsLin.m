function drawObsLin(SenFig, Obs, colors, imSize)

% DRAWOBSLIN  Redraw a line landmark on the pinHole sensor figure.
%   DRAWOBSLIN(SENFIG, OBS, COLORS)  (re)draw a line landmark on the
%   pinHole sensor figure.
%
%   COLORS is the colors to apply to the point figure. ex:
%    colors = ['m' 'r']; % magenta/red or
%    colors = ['b' 'c']; % blue/cyan
%   OBS is the observation of the couple (landmark/sensor).
%


posOffset = 8;

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(Obs.lmk),...
        'xdata', [y(1);y(3)],...
        'ydata', [y(2);y(4)],...
        'color', colors(2,:),...
        'vis',   'on');
else
    set(SenFig.measure(Obs.lmk),...
        'vis',   'off');
end

% the mean
s = trimHmgLin(Obs.exp.e, imSize);
if ~isempty(s)
    X = s([1 3]);
    Y = s([2 4]);
    set(SenFig.mean(Obs.lmk),...
        'xdata', X,...
        'ydata', Y,...
        'color', colors(1,:),...
        'vis',   'on');
else
    set(SenFig.mean(Obs.lmk),'vis','off');
end

% the ellipses - 
% TODO: need to solve what we show as expectation
% [X,Y] = cov2elli(Obs.exp.e, Obs.exp.E+Obs.meas.R, 3, 10) ;
% set(SenFig.ellipse(Obs.lmk),...
%     'xdata', X,...
%     'ydata', Y,...
%     'color', colors(1+Obs.updated,:),...
%     'vis',   'on');

% the label
c = (Obs.meas.y(1:2)+Obs.meas.y(3:4))*0.5; % segment's center
v = (Obs.meas.y(1:2)-Obs.meas.y(3:4));     % segment's vector
n = normvec([-v(2);v(1)]);                 % segment's normal vector
pos = c + n*posOffset;
set(SenFig.label(Obs.lmk),...
    'position', pos,...
    'string',   num2str(Obs.lid),...
    'vis',      'on');

