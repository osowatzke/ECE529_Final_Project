classdef improved_music_doa_estimator < high_resolution_doa_estimator

    % Public class methods
    methods

        % Function creates the spatial spectrum using beamforming
        function P = create_spatial_spectrum(self, rx_data)

            % Function estimates the auto-correlation matrix
            Rxx = compute_corr(rx_data);

            % compute the number of elements in uniform linear array
            num_elements = size(rx_data,1);

            % compute the number of received samples
            num_samples = size(rx_data,2);

            % Compute the transormation matrix
            J = flip(eye(num_elements));

            % transform the receive data
            Y = J*conj(rx_data);

            % Function estimates the auto-correlation matrix of the
            % transformed data
            Ryy = compute_corr(Y);

            % Compute a new auto-correlation matrix
            R = Rxx + Ryy;

            % Compute the eigenvalues of the matrix
            [V,D] = eig(R);

            % Use the user-provided number of sources
            % or estimate with AIC or MDL
            num_sources = self.get_num_sources(D,num_samples);

            % noise subspace eigenvector matrix
            En = V(:,1:(end-num_sources));

            % Convert the look angle to radians
            look_angle_rad = (self.look_angle(:).')*pi/180;

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
        end
    end
end