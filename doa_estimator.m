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

        % Number of sources method
        num_sources_method = 'AIC';
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

        % Function determines the number of sources if not specified
        function num_sources = get_num_sources(self, lambda, K)

            % If the eigenvalues are passed as diagonal matrix
            if size(lambda,1) > 1 && size(lambda,2) > 1
                lambda = diag(lambda);
            end

            % Sort the eigenvalues in descending order
            lambda = sort(lambda,'descend');

            % If number of sources is unspecified,
            % compute the number of sources
            if isempty(self.num_sources)

                % Use AIC to estimate the number of sources
                if strcmpi(self.num_sources_method,'AIC')
                    num_sources = aic_num_sources(lambda, K);


                % Use MDL to estimate the number of sources
                else
                    num_sources = mdl_num_sources(lambda, K);
                end

            % Use a user-provided number of sources
            else
                num_sources = self.num_sources;
            end
        end
    end
end