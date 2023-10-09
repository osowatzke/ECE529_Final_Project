classdef root_music_doa_estimator < key_value_constructor

    properties

        % Element spacing in the uniform linear array
        % expressed in terms of lambda
        element_spacing;

        % Number of sources
        num_sources;
    end

    methods

        % Function creates the spatial spectrum using beamforming
        function theta = compute_roots(self, rx_data)

            % compute the number of received samples
            num_samples = size(rx_data,2);

            % Function estimates the auto-correlation matrix
            Rxx = 1/num_samples*(rx_data*rx_data');

            % Compute the eigenvalues of the matrix
            [V,~] = eig(Rxx);

            % noise subspace eigenvector matrix
            En = V(:,1:(end-self.num_sources));

            % Compute C
            C = En*En';

            % Compute cl
            M = size(C,1);
            cl = zeros(M,1);
            for i = 1:M
                cl(i) = sum(diag(C(i:end,1:(end-i+1))));
            end
            cl = [conj(flip(cl(2:end))); cl];

            % Find the roots of cl
            zi = roots(cl);

            % Find the roots less than 1
            zi = zi(abs(zi) < 1);

            % Find the roots closest to 1
            [~, idx] = sort(abs(1 - abs(zi)));
            zi = zi(idx);

            % Find the roots corresponding to the number of sources
            zi = zi(1:self.num_sources);

            % Find the angles of each source
            theta = -180/pi*asin(1/(2*pi*self.element_spacing)*angle(zi));
        end
    end
end