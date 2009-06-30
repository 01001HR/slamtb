function [sv,vis] = visibleSegment(s,d,imSize,mrg,lmin)

% VISIBLESEGMENT  Visible segment.
%   VISIBLESEGMENT(S,D,IMSIZE) returns the segment portion of segment S
%   that is visible in the image defined by IMSIZE. D is a vector of depths
%   of the two segment's endpoints.
%
%   VISIBLESEGMENT(...,MRG) restricts the image size to be smaller in MRG
%   pixels at its four borders. The default is MRG = 0 pix.
%
%   VISIBLESEGMENT(...,LMIN) sets all segments shorter than LMIN pixels to
%   be invisible. The default is LMIN = 1 pix.
%
%   [SV,VIS] = VISIBLESEGMENT(...) returns the visible segment SV and a
%   flag of visibility. In case of non visibility, the flag is set to false
%   and the output segment is SV = [0;0;0;0].
%
%   The function works for segment matrices S = [S1 S2 ... Sn] and D = [D1
%   D2 ... Dn], giving a segments matrix SV and a visibility vector VIS.

% input options and defaults
if nargin < 5
    lmin = 1;
    if nargin < 4
        mrg = 0;
    end
end

% init output arrays
n   = size(s,2);
sv  = zeros(4,n);
vis = false(1,n);

% loop all segments
for i = 1:n
    a = s(1:2,i); % endpoints
    b = s(3:4,i);
    ad = d(1,i);  % depths
    bd = d(2,i);

    if ad<0 && bd<0 % both depths negative -> not visible
        sv(:,i) = zeros(4,1);
        vis(i) = false;

    else

        u = normvec(b-a); % uncorrected direction
        if ad<0           % endpoint A is behind the camera
            a = b + 1e8*u;
        elseif bd<0       % endpoint B is behind the camera
            b = a - 1e8*u;
        end

        % trim segment at image borders, with margin
        ss = trimSegment([a;b],imSize,mrg);

        % check visibility and assign output
        if numel(ss) == 0 % null vector -> not visible
            sv(:,i) = zeros(4,1);
            vis(i) = false;
        elseif segLength(ss) < lmin % too short -> not visible
            sv(:,i) = zeros(4,1);
            vis(i) = false;
        else
            sv(:,i) = ss; % visible
            vis(i) = true;
        end
    end
end
