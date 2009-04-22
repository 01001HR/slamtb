% USERDATA  User data for universal SLAM.
%   Edit this script to enter the information you need for SLAM. Variable
%   names and comments should make this file easy to understand. Follow
%   these guidelines:
%
%   * Specify site and estimation details for the current run.
%   * Specify sampling time and start and end frames.
%   * Use as many robots and sensors as you wish.
%   * Assign sensors to robots via Sensor{i}.robot.
%   * Use field Sensor{i}.d for radial distortion parameters if desired.
%   * Define one instance of each landmark type you wish to use. Use the
%   field Landmark{i}.naxNbr to specify the maximum number of such
%   landmarks that the SLAM map must support.
%
%   See further comments within the file for more detailed information.
%
%   NOTE: You can have multiple copies of this file with different names to
%   store different simulation conditions. Just modify the call in SLAMTB
%   to point to the particular 'USERDATA' file you want.
%
%   See also SLAMTB, EULERANGLES.

%   (c) 2009 Joan Sola @ LAAS-CNRS


% Time variables 
%   - sampling time, first and last frames
Time = struct(...
    'dt',                   .1,...          % sampling time, seconds
    'firstFrame',           1,...           % first frame #
    'lastFrame',            600);            % last frame #

% Simulated world
%   - Simulation landmark sets, playground dimensions
World = struct(...
    'xMin',                 -10,...         % playground limits
    'xMax',                 10,...
    'yMin',                 -10,...
    'yMax',                 10,...
    'zMin',                 -10,...
    'zMax',                 10,...
    'points',               thickCloister(-6,6,-6,6,1,5));  % 3d point landmarks

% Robot things with their controls
%   - each robot's type and initial configuration, and controls.
%   - motion models (add new model strings if you need more):
%       'constVel'    6D Constant velocity model
%       'odometry'    6D Odometry model
%   - See EULERANGLES for orientations specifications.
Robot{1} = struct(...                     % ODOMETRY EXAMPLE
    'id',                   1,...           % robot identifier
    'name',                 'Dala',...      % robot name
    'type',                 'atrv',...      % type of robot
    'motion',               'odometry',...  % motion model
    'position',             [0;-5;0],...     % robot position in map
    'orientationDegrees',   [0;0;0],...     % orientation, in degrees, roll pitch yaw.
    'positionStd',          [0;0;0],...     % position error, std
    'orientationStd',       [0;0;0],...     % orient. error, std, in degrees
    'dx',                   [.1;0;0],...     % position increment
    'daDegrees',            [0;0;1.14],...     % angle increment, degrees
    'dxStd',                [0.01;0.01;0.01],...  % odo linear error std
    'daStd',                [0.2;0.2;0.2]);      % odo ang error std, degrees

% Robot{2} = struct(...                     % ODOMETRY EXAMPLE
%     'id',                   2,...           % robot identifier
%     'name',                 'Dala',...      % robot name
%     'type',                 'atrv',...      % type of robot
%     'motion',               'odometry',...  % motion model
%     'position',             [3;-4;0],...     % robot position in map
%     'orientationDegrees',   [0;0;37],...     % orientation, in degrees, roll pitch yaw.
%     'positionStd',          [0;0;0],...     % position error, std
%     'orientationStd',       [0;0;0],...     % orient. error, std, in degrees
%     'dx',                   [.15;0;0],...     % position increment
%     'daDegrees',            [0;0;1.7],...     % angle increment, degrees
%     'dxStd',                [0.01;0.01;0.01],...  % odo linear error std
%     'daStd',                [0.1;0.1;0.1]);      % odo ang error std, degrees

% Robot{3} = struct(...                     % CONSTANT VELOCITY EXAMPLE
%     'id',                   3,...           % robot identifier
%     'name',                 'Dala',...      % robot name
%     'type',                 'atrv',...      % type of robot
%     'motion',               'constVel',...  % motion model
%     'position',             [1;0;0],...     % robot position in map
%     'orientationDegrees',   [0;0;45],...    % orientation, in degrees, roll pitch yaw.
%     'positionStd',          [0;0;0],...     % position error, std
%     'orientationStd',       [0;0;0],...     % orient. error, std, degrees
%     'velocity',             [1;0;0],...     % lin. velocity
%     'angularVelDegrees',    [0;0;10],...    % ang. velocity, in degrees
%     'velStd',               [0;0;0],...     % lin. vel. error, std
%     'angVelStd',            [0;0;0],...     % ang. vel. error, std, degrees
%     'dv',                   [1;0;0],...     % veolcity increment
%     'dwDegrees',            [0;0;0],...     % ang. vel. increment, degrees
%     'dvStd',                [0;0;0],...     % vel perturbation std
%     'dwStd',                [0;0;1]);       % ang vel pert. std, degrees


% Sensor things 
%   - each sensor's type and parameters, noise, non-measurable prior.
%   - Sensor types (add new type strings if you need more):
%       'pinHole'   Pin-hole camera
%   - See EULERANGLES for orientations specifications.
Sensor{1} = struct(...
    'id',                   1,...           % sensor identifier
    'name',                 'Micropix',...  % sensor name
    'type',                 'pinHole',...   % type of sensor
    'robot',                1,...           % robot where it is mounted
    'position',             [0;0.15;.6],...    % position in robot
    'orientationDegrees',   [-90;0;-90],...   % orientation in robot, roll pitch yaw
    'positionStd',          [0;0;0],...     % position error std
    'orientationStd',       [0;0;0],...     % orient. error std
    'imageSize',            [480;360],...   % image size
    'pixErrorStd',          1.0,...         % pixel error std
    'intrinsic',            [240;180;240;240],... % intrinsic params
    'distortion',           [],...          % distortion params
    'frameInMap',           false);         % add sensor frame in slam map?

% Sensor{2} = struct(...
%     'id',                   2,...           % sensor identifier
%     'name',                 'Micropix',...      % sensor name
%     'type',                 'pinHole',...   % type of sensor
%     'robot',                1,...           % robot where it is mounted
%     'position',             [0;-0.15;.6],...     % position in robot
%     'orientationDegrees',   [-90;0;-90],...      % orientation in robot, roll pitch yaw
%     'positionStd',          [0;0;0],...     % position error std
%     'orientationStd',       [1.5;1.5;1.5],...     % orient. error std
%     'imageSize',            [640;480],...   % image size
%     'pixErrorStd',          1.0,...         % pixel error std
%     'intrinsic',            [320;240;500;500],...   % intrinsic params
%     'distortion',           [],...          % distortion params
%     'frameInMap',           true );         % add sensor frame in slam map?



% Estimation options 
%   - reprojection, active search, etc
Opt = struct(...
    'map',                  struct(...      % options for the map
        'num3dLmks',        75),...        % number of 3d landmarks
    'correct',              struct(...      % options for lmk correction
        'reprojectLmks',    true,...       % reproject lmks after active search?
        'warpMethod',       'jacobian',...  % patch warping method
        'nUpdates',         10,...           % max simultaneus updates
        'MD2th',            9,...           % Threshold on Mahalanobis distance
        'linTestTh',        0.1),...        % threshold on IDP linearity test
    'init',                 struct(...      % Options for initialization
        'idpPnt',           struct(...      % opt. for IDP init
            'nonObsMean',   0.01,...        % mean of non obs. for initialization
            'nonObsStd',    1)));           % std of non obs for initialization
        
% Simulation options
%   - random
SimOpt = struct(...                    
    'random',               struct(...      % random generator options
        'active',           false,...       % use true random generator?
        'fixedSeed',        1,...           % random seed for non-random runs
        'seed',             0));            % actual seed



% Figure options  
%   - view, projection, video, ellipses.
%   - figure projections - mapProj:
%       'persp'     Perspective
%       'ortho'     Orthographic
%   - 3D figure views - mapView - see MAPOBSERVER.
%       [a,e,f]     Custom azimuth/elevation/FOV vector. Distance automatic
%       [a,e,f,d]   custom az/el/fov/distance vector.
%   - 3D figure predefined views (edit mapObserver.m to create/edit views):
%       'top'       Top view
%       'side'      Side view
%       'view'      Generic view
%       'normal'    Normal view
%   - objects colors - two options for color specification:
%       'rgbcmykw'  1-char predifined Matlab colors
%       [r g b]     RGB color vector. [0 0 0] is black, [1 1 1] is white.
FigOpt = struct(...
    'renderer',         'zbuffer',...    % renderer
    'ellipses',          true,...        % show 3d ellipsoids?
    'mapProj',          'persp',...      % projection of the 3d figure
    'mapView',           [0 90 40 20],...% viewpoint of the 3d figure
    'colors',            struct(...      % Colors:
        'border',        .8*[1 1 1],...  %   [r g b]      
        'axes',          [0 0 0],...     % with:
        'backgnd',       .6*[1 1 1],...  %   [0 0 0] black
        'raw',           .2*[1 1 1],...  %   [1 1 1] white
        'simu',          'g',...         %   or 'r', 'b', etc.
        'est',           'b',...
        'label',         'y'),...
    'figSize',           struct(...
        'map',           [320 240],...   % map figure size
        'sen',           [320 240],...   % sensor figure size
    'video',             struct(...      % video options
        'createVideo',       false)));     % create video sequence?


% Experiment options 
%   - site name, series gathered, estimation run number 
ExpOpt = struct(...
    'site',                 'sitename',...  % Name of the site
    'dataRun',              1,...           % Run # on this site
    'estimateRun',          1,...           % slam run for data and site
    'lmkTypes',             'idp',...       % types of landmarks used
    'sensingType',          'mono',...      % sensing mode
    'mappingType',          'single');      % mapping mode


