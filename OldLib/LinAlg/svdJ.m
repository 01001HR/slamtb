function [U,D,V,Da,Ua,Va] = svdJ(A)

% SVDJ  Singular value decomposition with Jacobians
%   [U,S,V] = SVDJ(A)  performs the singular value decomposition of
%   matrix A with reduced matrix size. If A is M-by-N, then U is M-by-N, S
%   is N-by-N and V is N-by-N. It is the same as [U,S,V] = SVD(A,0).
%
%   [U,S,V,Sa] = SVDJ(A) returns the Jacobian of the singular values wrt A.
%   It is a 3-tensor,
%
%       Sa(j,i,k) = d(s(k))/d(A(i,j)) ,     with s(k) = S(k,k).
%
%   [U,S,V,Sa,Ua,Va] = SVDJ(A) returns also the Jacobians of U and V wrt A.
%   They are 4-tensors,
%
%       Ua(j,i,k,l) = d(U(k,l))/d(A(i,j)) , and
%       Va(j,i,k,l) = d(V(k,l))/d(A(i,j)) .
%
%   Notice in Sa, Ua, and Va, the reversed order of indices _i_ and _j_,
%   indicating the transposition of the Jacobians wrt the input matrix
%   elements A(i,j).
%
%   The algorithm follows PAPADOPOULO-00, "Estimating the Jacobian of the
%   Singular Value Decomposition: theory and Applications", Tech. Rep.
%   INRIA, 2000.
%
%   A Matlab cell at the end of the file allows testing the Jacobians
%   against those computed with numerical methods.
%
%   IMPORTANT NOTE: The result of Ua is wrong for any reason.
%
%   See also SVD.

% (c) 2008 Joan Sola @ LAAS-CNRS
% Modified on 15/09/2008 by Theodore Papadopoulo @ sophia inria fr

% The comments are linked to equation numbers in PAPADOPOULO-00.

% Take SVD with reduced matrix sizes, (1)
[U,D,V] = svd(A);

if nargout > 3 % Jacobians

    M = size(A,1);
    N = size(A,2);

    MN = min(M,N);

    for i = 1:M
        for j = 1:N
            for k = 1:min(M,N)

                % Singular values derivatives, (7)
                Da(j,i,k) = U(i,k)*V(j,k);

            end
        end
    end

    if nargout > 4 % Jac. also for rotation matrices

        d = diag(D);

        [Ua,Ou] = deal(zeros(N,M,M,M));
        [Va,Ov] = deal(zeros(N,M,N,N));

        for i = 1:M
            for j = 1:N
                for k = 1:MN
                    for l = k+1:MN % Ou and Ov are antisymmetric

                        % Linear system, (8)
                        b = [U(i,k)*V(j,l);
                            -U(i,l)*V(j,k)];
                        C = [d(l) d(k);
                            +d(k) d(l)];

                        % Solution for given i, j, k, l
                        % (only non-degenerated cases)
                        x = pinv(C)*b;

                        Ou(j,i,k,l) =  x(1);
                        Ou(j,i,l,k) = -x(1); % Ou is antisymmetric

                        Ov(j,i,k,l) =  x(2);
                        Ov(j,i,l,k) = -x(2); % Ov is antisymmetric
                    end
                end

                if M>N
                    for k = N+1:M
                        for l = 1:N
                            x = U(i,k)*V(j,l)/d(l);
                            Ou(j,i,k,l) =  x;
                            Ou(j,i,l,k) = -x;
                        end
                    end
                end

                if M<N
                    for k = 1:M
                        for l = M+1:N
                            x = U(i,k)*V(j,l)/d(k);
                            Ov(j,i,k,l) =  x;
                            Ov(j,i,l,k) = -x;
                        end
                    end
                end

                % Singular vector derivatives, (9)
                Ua(j,i,:,:) =  U*squeeze(Ou(j,i,:,:));
                Va(j,i,:,:) = -V*squeeze(Ov(j,i,:,:));

            end
        end

    end

end

return


%% Numeric Jacobian
dx = 1e-6;
M = 4;
N = 2;
A = randn(M,N);

%
[U,D,V,Da,Ua,Va] = svdJ(A);
%
% [U,D,V,Da] = svdJ(A);
%
clear Ua1 Da1 Va1
for i = 1:M
    for j = 1:N
        A1           = A;
        A1(i,j)      = A1(i,j)+dx;
        [U1,D1,V1]   = svd(A1);
        Ua1(j,i,:,:) = (U1-U)/dx;
        Da1(j,i,:)   = diag(D1-D)/dx;
        Va1(j,i,:,:) = (V1-V)/dx;
    end
end

max(max(max(Da-Da1)))
max(max(max(max(Ua-Ua1))))
max(max(max(max(Va-Va1))))

