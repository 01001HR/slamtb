function Rob = initRobots(Rob)

% INITROBOTS Initialize robots in Map.
%   Rob = INITROBOTS(Rob) initializes all robots in Rob() in the global map
%   Map. It does so by:
%       getting a range of free states for the robot
%       assigning it to the appropriate fields of Rob
%       setting Rob's mean and cov. matrices in Map
%       setting all Map.used positions in the range to true

% (c) 2009 Joan Sola @ LAAS-CNRS


for rob = 1:numel(Rob)

    fr = addToMap(Rob(rob).frame.x,Rob(rob).frame.P); % frame range in Map
    Rob(rob).frame.r = fr;
    
    vr = addToMap(Rob(rob).vel.x,Rob(rob).vel.P);     % velocity range
    Rob(rob).vel.r   = vr;
    
    Rob(rob).state.r = [fr;vr];   % robot's state range

end
