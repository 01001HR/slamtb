function cos=squat2cos(quat)

% COS = SQUAT2COS(QUAT) Converts symbolic quaternion to direction cosines matrix - body to earth
%
% where:    QUAT is a 4x1 column unity vector representing the quaternion
%           Re = COS * Rb converts body referenced vector Rb into
%                           earth referenced vector Re

warning('This function is being deprecated. Use q2R instead.')
    
a=quat(1);
b=quat(2);
c=quat(3);
d=quat(4);

a2=a^2;
ab=2*a*b;
ac=2*a*c;
ad=2*a*d;
b2=b^2;
bc=2*b*c;
bd=2*b*d;
c2=c^2;
cd=2*c*d;
d2=d^2;

cos=[a2+b2-c2-d2    bc-ad          bd+ac
     bc+ad          a2-b2+c2-d2    cd-ab
     bd-ac          cd+ab          a2-b2-c2+d2];
