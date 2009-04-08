function Lmk = createLandmarks(Landmark)

% CREATELANDMARKS  Create Lmk() structure array.
%   Lmk = CREATELANDMARKS(Landmark) creates the structure array Lmk() to be
%   used as SLAM data. The input Landmark{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Landmark{}
%   per each landmark type considered. See userData.m for details.

lmk = 0; % lmk index in Lmk()

for lmkClass = 1:numel(Landmark)

    numLmk = 0; % lmk # in a given class

    while numLmk < Landmark{lmkClass}.maxNbr

        numLmk = numLmk + 1; 
        lmk    = lmk + 1;
        
        Li = Landmark{lmkClass};
        
        Lo.lmk  = lmk;
        Lo.id   = 0;
        Lo.type = Li.type;
        Lo.used = false;

        % state
        Lo.state.x = [];        
        Lo.state.P = [];
        switch Li.type
            case {'eucPnt'}
                Lo.state.size = 3;
            case {'homPnt'}
                Lo.state.size = 4;
            case {'idpPnt','plkLin'}
                Lo.state.size = 6;
        end
        Lo.state.r = [];

        % Non observable priors
        if isfield(Li,'nonObsMean')
            Lo.nom.n = Li.nonObsMean;
            Lo.nom.N = diag(Li.nonObsStd.^2);
        else
            Lo.nom.n = [];
            Lo.nom.N = [];
        end

        % other parameters
        Lo.par = [];

        Lo.sig = [];

        Lo.nsearch = 0;
        Lo.nmatch  = 0;
        Lo.ninlier = 0;

        Lmk(lmk) = Lo;
        
    end
    
end

