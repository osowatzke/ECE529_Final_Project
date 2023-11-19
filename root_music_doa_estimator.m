classdef root_music_doa_estimator < doa_estimator
    
    % Public class methods
    methods

        % Function creates the spatial spectrum using beamforming
        function theta = compute_source_angles(self, rx_data)

            % Function estimates the auto-correlation matrix
            Rxx = self.compute_corr(rx_data);

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
                cl(i) = sum(diag(C(1:(end-i+1),i:end)));
            end
            cl = flip([conj(flip(cl(2:end))); cl]);

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
            theta = 180/pi*asin(1/(2*pi*self.element_spacing)*angle(zi));
        end
    end
end