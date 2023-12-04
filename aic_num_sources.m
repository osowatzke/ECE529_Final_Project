% Author: O. Sowatzke
%
% Updated: 12/05/2023
%
% Subject: Function computes the number of sources using the AIC algorithm
%
function num_sources = aic_num_sources(lambda, K)

    % Number of eigenvalues
    M = length(lambda);

    % Create empty array for each eigenvalue
    arg = zeros(M,1);

    % Loop for each eigenvalue
    for n = 0:(length(arg)-1)
        arg(n+1) = -2*log((prod(lambda((n+1):end).^(1/(M-n)))/((1/(M-n))*sum(lambda((n+1):end)))).^((M-n)*K)) + ...
            2*n*(2*M - n);
    end

    % Find the minimum value
    [~, num_sources] = min(arg);

    % Update to account for one-based indexing
    num_sources = num_sources - 1;
end