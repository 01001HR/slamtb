
function Ld = idp2pLinValue(idp, IDP)

%  IDP2PLINTEST  Return the linearity of a re-parametrization IDP->P.
%    LD = IDP2PLINTEST() returns the linearity coefficient as defined in
%    expression (15) in civeraTRO08 "Inverse Depth Parameterization
%    for Monocular SLAM"
%
%
%    See also IDP2P.
%


% explode idp:
py  = idp(4:5);
m   = py2vec(py);
rho = idp(6);

% and idp variance:
RHO = IDP(6,6);

sigma_rho = sqrt(RHO);
sigma_d   = sigma_rho/rho^2; % depth sigma

% We follow expression (15) in civeraTRO08 "Inverse Depth Parameterization
% for Monocular SLAM":

xi  = idp2p(idp);
%rwc = fromFrame(Rob,Cam.t); % current camera center
% hw        = xi-rwc;  % idp point to camera center
% sigma_rho = sqrt(RHO);
% sigma_d   = sigma_rho/rho^2; % depth sigma  
% d1        = norm(hw);
% cos_a     = m'*hw/d1;
% 
% Ld = 4*sigma_d/d1*abs(cos_a);

Ld = 10000;


end


%%%%%%%%%%%%% IMPLEMENTATION IN OLD LIB %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TODO remove me !
%%%%%%%%%%%%%%%%%%%

% ir = loc2range(Idp.loc);
% 
% % explode idp:
% idp = Map.X(ir);
% py  = idp(4:5);
% m   = py2vec(py);
% rho = idp(6);
% 
% % and idp variance:
% IDP = Map.P(ir,ir);
% RHO = IDP(6,6);
% 
% % We follow expression (15) in civeraTRO08 "Inverse Depth Parameterization
% % for Monocular SLAM":
% 
% xi  = idp2p(idp);
% rwc = fromFrame(Rob,Cam.t); % current camera center
% 
% hw        = xi-rwc;  % idp point to camera center
% sigma_rho = sqrt(RHO);
% sigma_d   = sigma_rho/rho^2; % depth sigma  
% d1        = norm(hw);
% cos_a     = m'*hw/d1;
% 
% Ld = 4*sigma_d/d1*abs(cos_a);

