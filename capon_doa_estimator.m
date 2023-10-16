classdef capon_doa_estimator < key_value_constructor

    properties

        % Element spacing in the uniform linear array
        % expreseed in terms of lambda
        element_spacing;

        % Look angle in degrees 
        look_angle;
    end

    methods

        % Function creates the spatial spectrum using beamforming
        function P = create_spatial_spectrum(self, rx_data)

            % compute the number of elements in uniform linear array
            num_elements = size(rx_data,1);

            % compute the number of received samples
            num_samples = size(rx_data,2);

            % Function estimates the auto-correlation matrix
            Rxx = 1/num_samples*(rx_data*rx_data');

            % Convert the look angle to radians
            look_angle_rad = (self.look_angle(:).')*pi/180;

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
                P(i) = 1/(A(:,i)'*Rxx_inv*A(:,i));
            end
        end
    end
end