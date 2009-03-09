function SenFig = drawSenFig(SenFig, Obs, Sen, Lmk)

% DRAWSENFIG (SENFIG, OBS, SEN, LMK)  (re)draw the sensors figures.
% return the SENFIG


% visible = {'off','on'};
% posOffset = [0;0];


for sen = 1:size(Obs,1)     %numel(Sen)

    %     for lmk = 1:size(Obs,2) %numel(Lmk)

    % Sensor type:
    % ------------
    switch Sen(sen).type

        % camera pinhole
        % --------------
        case {'pinHole'}

            % process only visible landmarks

            % first erase lmks that were drawn but are no longer visible
            vis   = [Obs(sen,:).vis];
            drawn = (strcmp((get(SenFig(sen).ellipse,'vis')),'on'))';
            erase = drawn & ~vis;

            set(SenFig(sen).measure(erase),'vis','off');
            set(SenFig(sen).ellipse(erase),'vis','off');
            set(SenFig(sen).label(erase),  'vis','off');

            % now draw only visible landmarks
            for lmk = find(vis)

                % Landmark type:
                % --------------
                switch Lmk(lmk).type

                    % idp
                    % ---
                    case {'idpPnt'}

                        colors = ['m' 'r']; % magenta/red
                        drawObsPoint(SenFig(sen), Obs(sen,lmk), colors);

                        % euclidian
                        % ---------
                    case {'eucPnt'}

                        colors = ['b' 'c']; % magenta/red
                        drawObsPoint(SenFig(sen), Obs(sen,lmk), colors);


                        % ADD HERE FOR NEW LANDMARK
                        % case {'newLandmark'}
                        % do something


                        % unknown
                        % -------
                    otherwise
                        % Print an error and exit
                        error(['Unknown sensor type. Cannot display landmark type ''',Lmk(lmk).type,''' with ''',Sen(sen).type,''' sensor ''',Sen(sen).name,'''.']);
                end % and of the "switch" on sensor type



                %                 else % Lmk is not visible : draw blank
            end



            % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
            % case {'newSensor'}
            % do something


            % unknown
            % -------
        otherwise
            error(['The sensor type is unknows, cannot display the sensor ',Sen(sen).name,' with type=',Sen(sen).type,'!']);
    end


    %     end

end
