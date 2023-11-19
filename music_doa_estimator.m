classdef music_doa_estimator < doa_estimator

    % Public class methods
    methods

        % Function creates the spatial spectrum using beamforming
        function [P, theta] = create_spatial_spectrum(self, rx_data)

            % Function estimates the auto-correlation matrix
            Rxx = self.compute_corr(rx_data);

            % Compute the eigenvalues of the matrix
            [V,D] = eig(Rxx);

            % Estimate the number of sources
            num_samples = size(rx_data,2);
            num_sources_est = aic_estimate_num_sources(diag(D),num_samples);

            if self.num_sources ~= num_sources_est
                warning('Number of sources incorrectly estimated')
                keyboard;
            end

            % noise subspace eigenvector matrix
            En = V(:,1:(end-self.num_sources));

            % Convert the look angle to radians
            look_angle_rad = (self.look_angle(:).')*pi/180;

            % compute the number of elements in uniform linear array
            num_elements = size(rx_data,1);

            % Create a (num_elements x num_angles) matrix for steering the
            % beam to each of the look angles
            A = exp(1i*2*pi*self.element_spacing...
                *sin(look_angle_rad).*(0:(num_elements-1)).');

            % Create an empty array for the spatial spectrum output
            P = zeros(length(look_angle_rad),1);

            % Compute the spatial spectrum output for each look angle
            for i = 1:length(look_angle_rad)
                P(i) = 1/(A(:,i)'*(En*En')*A(:,i));
            end

            % Estimate source angles from spatial spectrum
            theta = self.estimate_doa(P);
        end
    end
end