function r = addToMap(x, P_LL, P_LX, r)

% ADDTOMAP  Add Gaussian to Map.
%   ADDTOMAP(L,P_LL) adds the Gaussian N(L,P_LL) to the global EKF-map Map,
%   at positions that are empty, and returns the range of positions where
%   it has been added. ADDTOMAP adds mean L in Map.x and covariances P_LL
%   in the block-diagonal of Map.P. 
%
%   For example, in the case of a map which has all used states contiguous,
%   the new state and covariance are appended at the end of the existing
%   one:
%
%           | x |        | P     0   |
%       x = |   |    P = |           |
%           | L |        | 0    P_LL |
%
%
%   Map is a global structure, containing:
%       .used   a vector of logicals indicating used positions 
%       .x      the state vector 
%       .P      the covariances matrix 
%       .size   the Map's maximum size, numel(Map.x)
%
%   ADDTOMAP(L,P_LL,P_LX) accepts the cross variance matrix between L and the
%   currently used states in Map.x, so that the covariance is augmented
%   with
%
%           |   P     P_LX' |
%       P = |               |
%           | P_LX    P_LL  |
%   
%   ADDTOMAP(L,P_LL,P_LX,R) or ADDTOMAP(x,P_LL,[],R) permits indicating the
%   range R as input.
%
%   See also NEWRANGE, USEDRANGE.
%
%   (c) 2009 Joan Sola @ LAAS-CNRS.

global Map

% parse inputs
if nargin == 2
    P_LX = [] ;
end
if nargin <= 3
    r = newRange(numel(x));
end

% add to map
Map.x(r)    = x;
Map.P(r,r)  = P_LL;
if(size(P_LX)~=0)
    mr = usedRange();
    Map.P(r,mr) =  P_LX ;
    Map.P(mr,r) =  P_LX' ;
end ;

Map.used(r) = true;

