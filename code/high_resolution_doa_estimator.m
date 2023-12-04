% Author: O. Sowatzke
%
% Update: 12/05/2023
%
% Subject: Base class for high-resolution direction of arrival estimator
%
classdef high_resolution_doa_estimator < doa_estimator
    
    % Public class properties
    properties

        % Number of sources
        num_sources;

        % Number of sources method
        num_sources_method = 'AIC';
    end

    % Protected class methods
    methods(Access=protected)
        
        % Function determines the number of sources if not specified
        function num_sources = get_num_sources(self, lambda, K)

            % Handle the eigenvalues being passed in as diagonal matrix
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
