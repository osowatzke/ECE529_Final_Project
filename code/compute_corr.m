% Author: O. Sowatzke
%
% Updated: 12/03/2023
%
% Subject: Function computes a correlation matrix using samples of the
% received signal
function Rxx = compute_corr(rx_data)
    
    % compute the number of received samples
    num_samples = size(rx_data,2);

    % Function estimates the spatial auto-correlation matrix
    Rxx = 1/num_samples*(rx_data*rx_data');
end