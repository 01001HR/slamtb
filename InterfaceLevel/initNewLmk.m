function [Lmk,Obs] = initNewLmk(Rob, Sen, Raw, Lmk, Obs, Opt)

%INITNEWLMK  Initialise one landmark.
%   [LMK, OBS] = INITNEWLMK(ROB, SEN, RAW, LMK, OBS) returns the new
%   set of landmarks.
%
%   This "new set" contains the "old set" plus new elements. These new
%   elements are extracted from the recent observations (RAW), from the
%   current state estimated (ROB for robot and SEN for the sensor).
%
%   Finally, we can have a mean and a variance-covariance estimation for
%   the new landmark state.
%


global Map

% TODO: reorganize the function to better place the SWITCH statements.
switch Sen.type

    % camera pinHole
    case {'pinHole'}

        % test if there is space in Lmk for a new lmk
        usedLmks = [Lmk.used];
        idps     = strcmp({Lmk.type},'idpPnt');
        freeIdps = idps & ~usedLmks;

        if any(freeIdps)

            % index to first free Idp lmk
            lmk = find(freeIdps,1);

            switch Raw.type
                case {'simu'}
                    [y, R, newId] = simDetectFeature([Lmk(usedLmks).id],Raw.data,Sen.par.pixCov);

                case {'real'}
                    %to do
                    %[y,R,newId] = detectFeature([Lmk(usedLmks).id],Raw.data,Sen.par);
            end

            if ~isempty(y)  % a feature was detected

                % fill Obs struct before continuing
                Obs(lmk).sen      = Sen.sen;
                Obs(lmk).lmk      = lmk;
                Obs(lmk).sid      = Sen.id;
                Obs(lmk).lid      = newId;
                Obs(lmk).stype    = Sen.type;
                Obs(lmk).ltype    = Lmk.type;
                Obs(lmk).meas.y   = y;
                Obs(lmk).meas.R   = R;
                Obs(lmk).exp.e    = y;
                Obs(lmk).exp.E    = R;
                Obs(lmk).exp.um   = det(R);  % uncertainty measure
                Obs(lmk).app.curr = newId;
                Obs(lmk).app.pred = newId;
                Obs(lmk).vis      = true;
                Obs(lmk).measured = true;
                Obs(lmk).matched  = true;
                Obs(lmk).updated  = true;

                %----------------inside the switch -----------------
                % INIT LMK
                [l, L_rf, L_sf, L_sk, L_sd, L_pix, L_n] = ...
                    retroProjIdpPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    y, ...
                    Lmk(lmk).nom.n) ;
                % non-measurable covariance
                L_n;
                N = Lmk(lmk).nom.N ;
                %-----------------------------------


                % Group all map Jacobians and ranges
                if Sen.frameInMap % if the sensor frame is in the state
                    mr  = [Rob.frame.r;Sen.frame.r];
                    L_m = [L_rf L_sf] ;
                else
                    mr  = Rob.frame.r;
                    L_m = L_rf ;
                end

                % co- and cross-variance of map variables (robot and eventually sensor)
                P_MM = Map.P(mr,mr) ;
                P_MX = Map.P(mr,(Map.used)) ;

                % landmark co- and cross-variance
                P_LL  = ...
                    L_m   * P_MM * L_m'   + ...  % by map   cov
                    L_pix * R    * L_pix' + ...  % by pixel cov
                    L_n   * N    * L_n' ;        % by nom   cov
                P_LX = L_m*P_MX ;

                % add to Map and get lmk range in Map
                Lmk(lmk).state.r = addToMap(l,P_LL,P_LX);

                % Fill Lmk structure before exit
                Lmk(lmk).lmk     = lmk;
                Lmk(lmk).id      = newId;
                Lmk(lmk).used    = true;
                Lmk(lmk).sig     = newId;
            end
        end
    otherwise
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an initialisation of landmark with ''',Sen.type,''' sensor ''',Sen.name,'''.']);
end
