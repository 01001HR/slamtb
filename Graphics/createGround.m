function handle = createGround(SimLmk,ax,color)

% CREATEGROUND  Create ground graphics.
%   CREATEGROUND(SimLmk, AX, CLR) creates a horizontal 'surface' of given
%   color CLR in the axes AX. The limits are specified in SimLmk.
%
%   GH = CREATEGROUND(...) returns a handle to the 'surface' object.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 2
    ax = gca;
end

[x,y] = meshgrid(SimLmk.lims.xMin:2:SimLmk.lims.xMax,SimLmk.lims.yMin:2:SimLmk.lims.yMax);
z = zeros(size(x));
handle = surface(...
    'parent',     ax,...
    'XData',      x,...
    'YData',      y,...
    'ZData',      z,...
    'FaceColor',  'none',...
    'EdgeColor',  color,...
    'Marker',     'none');









