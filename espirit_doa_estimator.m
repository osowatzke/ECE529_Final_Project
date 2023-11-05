classdef espirit_doa_estimator < key_value_constructor

    properties

        % Element spacing in the uniform linear array
        % expressed in terms of lambda
        element_spacing;

        % Number of sources
        num_sources;
    end

    methods

        % Function creates the spatial spectrum using beamforming
        function theta = compute_source_angles(self, rx_data)

            % compute the number of received samples
            num_samples = size(rx_data,2);

            % Function estimates the auto-correlation matrix
            Rxx = 1/num_samples*(rx_data*rx_data');

            % Compute the eigenvectors of the matrix
            [Es,~] = eig(Rxx);

            % Extract signal eigenvectors
            Es = Es(:,(end-self.num_sources+1):end);

            % Decompose E into Es1 and Es2
            Es1 = Es(1:(end-1),:);
            Es2 = Es(2:end,:);

            % Decompose the matrix product of Es1 and Es2
            [V,~,~] = svd([Es1'; Es2']*[Es1, Es2]);

            % Decompose Matrix matrix into V12 and V22
            N = size(V,1);
            V12 = V(1:N/2,(end-N/2+1):end);
            V22 = V((end-N/2+1):end,(end-N/2+1):end);

            % Get the eigenvalues of psi
            psi = -V12*(V22^-1);
            phi = eig(psi);

            % Angle estiamte
            theta = 180/pi*asin(angle(phi)/(2*pi*self.element_spacing));
        end
    end
end