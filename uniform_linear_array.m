% Author: O. Sowatzke
%
% Updated: 09/27/2023
%
% Subject: Class generates receive data for a uniform linear array
%
classdef uniform_linear_array < key_value_constructor

    properties

        % Num of samples to generate
        num_samples;

        % Number of elements in the uniform linear array
        num_elements;

        % Element spacing in the uniform linear array
        % expreseed in terms of lambda
        element_spacing;

        % Angle of each source from boresight in degrees
        source_angle;

        % Frequency of each source signal (rad)
        source_freq;

        % SNR of each source signal in dB
        source_snr;
    end

    methods
        
        % Function creates receive data for a uniform linear array
        function rx_data = create_rx_data(self)

            % Ensure input frequency is of correct dimensions
            % (num_sources x 1)
            w = self.source_freq(:);

            % Create array of sample indices (1 x num_samples)
            n = 0:(self.num_samples-1);
            
            % Create complex exponentials signals for each source.
            % Result is num_sources x num_samples.
            source_signals = exp(1i*w.*n);

            % Ensure source SNR is of correct dimensions
            % (num_sources x 1)
            snr = self.source_snr(:);

            % Determine the scaling of each signal to get the desired SNR
            % (Assumes noise with unit power)
            source_scaling = 10.^(snr/20);

            % Scale each source signal to achieve desired SNR
            source_signals = source_scaling.*source_signals;
            
            % Assign element spacing to well known variable
            % to keep notation clean
            d = self.element_spacing;

            % Create array of element indices (num_elements x 1)
            n = (0:(self.num_elements-1)).';

            % Convert source angle to correct dimensions (1 x num_sources)
            theta = self.source_angle(:).';

            % Convert source angle from degrees to radians
            theta = pi*theta/180;

            % Determine the phase shift of each source on each of the
            % uniform linear array elements. (num_elements x num_sources)
            source_phase_shift = exp(1i*2*pi*n.*d*sin(theta));

            % For each array element, the received signal is the sum of all
            % the signal returns on that element. If we perform matrix
            % multiplication of the source_phase_shift and source_signals
            % we not only apply a phase shift but also sum each of the
            % signal returns. The resulting matrix will be
            % (num_elements x num_samples)
            source_signals = source_phase_shift*source_signals;

            % Generate complex noise of the same size as the signal
            % Noise has unit power
            noise_signals = 1/sqrt(2)*complex(randn(size(source_signals)),...
                randn(size(source_signals)));

            % The receive signal will be the sum of noise and signal
            rx_data = source_signals + noise_signals;
        end
    end
end