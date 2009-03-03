function occupateMap(loc)

% OCCUPATEMAP  Occupate one map location
%   OCCUPATEMAP(LOC) updates global Map vectors Map.free
%   and Map.used in the location LOC and resizes Map.n
%   and Map.m if necessary

global Map WDIM

Map.free(loc) = 0;   % update map free space
Map.used(loc) = loc; % update map used space

if max(loc) > Map.n
    Map.n = loc;
    Map.m = loc2state(loc)+WDIM-1;
end
