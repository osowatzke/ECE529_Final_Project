% Author: O. Sowatzke
%
% Updated: 11/18/2023
%
% Subject: Base class for direction of arrival estimator
%
classdef doa_estimator < key_value_constructor

    % Public class properties
    properties

        % Element spacing in the uniform linear array
        % expreseed in terms of lambda
        element_spacing;

        % Look angle in degrees 
        look_angle;

        % Number of sources
        num_sources;
    end

    % Protected class methods
    methods(Access=protected)

        % Function estimates the spatial auto-correlation matrix using
        % samples of the received signal
        function Rxx = compute_corr(~, rx_data)
            
            % compute the number of received samples
            num_samples = size(rx_data,2);

            % Function estimates the spatial auto-correlation matrix
            Rxx = 1/num_samples*(rx_data*rx_data');
        end

        % Function estimates directions of arrival from an input spatial
        % spectrum. It sorts local maximums of the spatial spectrum and
        % outputs the angles corrsponding to largest local maximums
        function source_angles = estimate_doa(self, P)

            % Find the index of local maxima
            I = (abs(P) > [abs(P(2:end)); 0]) | ...
                (abs(P) > [0; P(1:(end-1))]);

            % Compute the look angles corresponding to each local maxima
            max_angles = self.look_angle(I);

            % Sort the local maxima
            [~, J] = sort(abs(P(I)));

            % Return the location of each source
            source_angles = max_angles(J(1:self.num_sources));
        end
    end
end