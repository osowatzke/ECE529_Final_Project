classdef capon_doa_estimator < doa_estimator

    % Public class methods
    methods

        % Function creates the spatial spectrum using beamforming
        function P = create_spatial_spectrum(self, rx_data)

            % Function estimates the auto-correlation matrix
            Rxx = self.compute_corr(rx_data);

            % Convert the look angle to radians
            look_angle_rad = (self.look_angle(:).')*pi/180;

            % compute the number of elements in uniform linear array
            num_elements = size(rx_data,1);

            % Create a (num_elements x num_angles) matrix for steering the
            % beam to each of the look angles
            A = exp(1i*2*pi*self.element_spacing...
                *sin(look_angle_rad).*(0:(num_elements-1)).');

            % Invert the Rxx matrix
            Rxx_inv = inv(Rxx);

            % Create an empty array for the spatial spectrum output
            P = zeros(length(look_angle_rad),1);

            % Compute the spatial spectrum output for each look angle
            for i = 1:length(look_angle_rad)
                P(i) = 1/(A(:,i)'*Rxx_inv*A(:,i)); %#ok
            end
        end
    end
end