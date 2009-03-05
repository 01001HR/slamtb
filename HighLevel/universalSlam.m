% SLAM wireframe - a universal SLAM algorithm


%   (c) 2009 Joan Sola @ LAAS-CNRS

% clear workspace and declare globals
clear
global Map

%% I. Specify user-defined options - EDIT USER DATA FILE userData.m
userData;

%% II. Initialize data structures from user data
% Create robots and controls
Rob = createRobots(Robot);
% Con = createControls(Robot);

% Create sensors
Sen = createSensors(Sensor);

% Install sensors in robots
[Rob,Sen] = installSensors(Rob,Sen);

% Create Landmarks and non-observables
Lmk = createLandmarks(Landmark);
% Nob = createNonObservables(Landmark);

% Create Map - empty
Map = createMap(Rob,Sen,Lmk);

% Initialize robots and sensors in Map
Rob = initRobots(Rob);
Sen = initSensors(Sen);

% Create Observations (matrix: [ line=sensor , colums=landmark ])
Obs = createObservations(Sen,Lmk);

% Create world
Wrd = createWorld(World);

% Create source and/or destination files and paths

%% III. Initialize graphics objects
% Init map figure
MapFig = createMapFig(Rob,Sen,Lmk,Wrd,MapFigure);

% Init sensor's measurement space figures
SenFig = createSenFig(Sen,Obs,SensorFigure);

% Init data logging plots

%% IV. Temporal loop
firstFrame = 1 ;
lastFrame = 10 ;
for currentFrame = firstFrame : lastFrame
    
    % 1. SIMULATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Simulate robots
    for rob = 1:numel(Rob)

        % Simulate sensor observations
        for sens = Rob(rob).sensors

            % Observe landmarks
                
        end % end process sensors
        
        % Robot motion
        %Rob(rob) = motion(Rob(rob),Control(rob),dt,noise);
        
    end % end process robots
    
    
    % 2. ESTIMATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Process robots
    for rob = 1:numel(Rob)

        % Process sensor observations
        for sens = Rob(rob).sensors

            % Observe knowm landmark
            %obsKnownLmks;
                
            % Initialize new landmarks
            %initNewLmks;
            
        end % end process sensors
        
        % Robot motion
            % [DEBUG]
            Control = [] ;
            Control(rob).v = [1,0,0]' ; % vx, vy, vz
            dt = 1 ; % seconds
            % [/DEBUG]
            Rob(rob) = motion(Rob(rob),Control(rob),dt);
        
    end % end process robots

    % 3. VISUALIZATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create test Obs
    Obs(1,1) = testObs(Obs(1,1)); 
    
    % Figure of the Map:
    MapFig = drawMapFig(MapFig, Lmk, Rob, Sen) ;
    
    % Figures for each sensors
    SenFig = drawSenFig(SenFig, Obs, Sen, Lmk) ;
    
    
    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%% V. Post-processing
