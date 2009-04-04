function [Rob,Sen,Lmk,Obs,Tim] = createSlamStructures(Robot,Sensor,Landmark,Time)

% CREATESLAMSTRUCTURES  Initialize SLAM data structures from user data.
global Map

% Create robots and controls
Rob = createRobots(Robot);

% Create sensors
Sen = createSensors(Sensor);

% Install sensors in robots
[Rob,Sen] = installSensors(Rob,Sen);

% Create Landmarks and non-observables
Lmk = createLandmarks(Landmark);

% Create Map - empty
Map = createMap(Rob,Sen,Lmk);

% Initialize robots and sensors in Map
Rob = initRobots(Rob);
Sen = initSensors(Sen);

% Create Observations (matrix: [ line=sensor , colums=landmark ])
Obs = createObservations(Sen,Lmk);

% Create time variables
Tim = createTime(Time);
