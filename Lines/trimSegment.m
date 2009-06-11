function e = trimSegment(s,imSize)

% TRIMSEGMENT  Trim segment at image borders
%   TRIMSEGMENT(S,IMSIZE) trims the segment S at the image borders
%   specified by IMSIZE. S is a 4-vector containing the two segment's
%   endpoints. IMSIZE is a 2-vector with the image dimensions in pixels,
%   IMSIZE = [HSIZE,VSIZE]. The output segment has the same orientation as
%   the input one.
%
%   See also TRIMLINE, PINHOLESEGMENT.

%   (c) 2008 Joan Sola @ LAAS-CNRS

% input segment's endpoints
a = s(1:2);
b = s(3:4);

% image witdh and height
[w,h] = split(imSize);

insq = inSquare([a b],[0 w 0 h]);

if all(insq) % both endpoints are in the image

    e = s; % return the segment unchanged

else % at least one endpoint is out of the image

    H = pp2hm(a,b); % homogeneous line
    L = [1; 0; 0];  % left image border
    R = [1; 0;-w];  % right
    T = [0; 1; 0];  % top
    B = [0; 1;-h];  % bottom

    % intersections of infinite line with infinite borders
    HL = hh2p(H,L,1);
    HR = hh2p(H,R,1);
    HT = hh2p(H,T,1);
    HB = hh2p(H,B,1);

    % bring to image borders
    i = 1;
    if inInterval(HL(2),[0,h])
        e(i:i+1,1) = HL;
        i = 3;
    end
    if inInterval(HR(2),[0,h])
        e(i:i+1,1) = HR;
        i = 3;
    end
    if inInterval(HT(1),[0,w])
        e(i:i+1,1) = HT;
        i = 3;
    end
    if inInterval(HB(1),[0,w])
        e(i:i+1,1) = HB;
    end

    if insq(1) % endpoint a is in the image

        p = e(1:2);
        q = e(3:4);

        u = b - a;
        v = p - a;
        if any(u./v > 0)
            e(1:2) = a;
            e(3:4) = p;
        else
            e(1:2) = a;
            e(3:4) = q;
        end

    elseif insq(2) % endpoint b is in the image

        p = e(1:2);
        q = e(3:4);

        u = a - b;
        v = p - b;
        if any(u./v > 0)
            e(1:2) = p;
            e(3:4) = b;
        else
            e(1:2) = q;
            e(3:4) = b;
        end

    else % no endpoint is inside the image

        if i == 1 % no intersection with image borders
            % Segment is not visible
            e = [];

        else
            p = e(1:2);
            q = e(3:4);

            if i==3 && any((p-a)./(b-p) > 0)  % segment is visible
                % check orientations

                u = b - a;
                v = q - p;
                if any(u./v < 0)
                    e = e([3 4 1 2]); % match orientations
                end
            else % segment is not visible
                e = [];
            end
        end

    end
end

return

%% test
imsize = [10 10];
s{1}  = [1 2 3 4]';
s{2}  = [-1 2 3 4]';
s{3}  = [1 -2 3 4]';
s{4}  = [1 2 -3 4]';
s{5}  = [1 2 3 -4]';
s{6}  = [1 2 3 11]';
s{7}  = [1 2 11 4]';
s{8}  = [1 11 3 4]';
s{9}  = [11 2 3 4]';
s{10} = [-1 -2 13 14]';
s{11} = [13 14 -1 -2]';

for i=1:numel(s)
    s{i}'
    (trimSegment(s{i},imsize))'
end