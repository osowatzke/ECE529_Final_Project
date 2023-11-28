classdef doa_estimation < key_value_constructor

    % Public class properties
    properties

        % Random number generate seed
        seed = 529;
        
        % Figure number for spatial spectrum
        fig_num = 1;

        % Number of samples to generate
        num_samples = 100;

        % Number of elements in the uniform linear array
        num_elements = 10;

        % Element spacing in the uniform linear array
        % expressed in terms of lambda
        element_spacing = 0.5;

        % Angle of each source from boresight in degrees
        source_angle = [-40, 10, 50];

        % Frequency of each source signal (rad)
        source_freq = [pi/3, pi/5, pi/7];

        % SNR of each source signal in dB
        source_snr = 20*log10(100/3)*ones(1,3);

        % Look angles for spatial spectrums in degrees
        look_angle = -90:1:90;
    end
    
    % Protected class properties
    properties(Access=protected)

        % ULA object
        linear_array;

        % Beamforming DOA estimator
        beamforming_estimator;

        % Capon DOA estimator
        capon_estimator;

        % MUSIC DOA estimator
        music_estimator;

        % Improved MUSIC DOA estimator
        improved_music_estimator;

        % Root MUSIC DOA estimator
        root_music_estimator;

        % ESPRIT DOA esimator
        esprit_estimator;

        % Received ULA data
        rx_data;

        % Beamforming Spatial Spectrum
        beamforming_spatial_spectrum;

        % Capon Spatial Spectrum
        capon_spatial_spectrum;

        % MUSIC Spatial Spectrum
        music_spatial_spectrum;

        % Improved MUSIC Spatial Spectrum
        improved_music_spatial_spectrum;

        % Root MUSIC source angles
        root_music_source_angles;

        % ESPRIT source angles
        esprit_source_angles;
    end

    % Public class methods
    methods

        % Function creates ULA data, runs it through the DOA algorithms,
        % and plots the resulting spatial spectrums.
        function run(self)

            % Seed the random number generator
            rng(self.seed);

            % Validate source configuration
            self.validate_source_config();

            % Initialize DOA objects
            self.initialize_doa_objects();

            % Create received ULA data
            self.create_rx_data();

            % Run Direction of Arrival Algorithms
            self.run_doa_algorithms();

            % Plot Spatial Spectrum
            self.plot_spatial_spectrum();
        end
    end

    % Protected class methods
    methods(Access=protected)

        % Function validates source configuration
        function validate_source_config(self)
           
            % Ensure source angle is a vector
            if ~isvector(self.source_angle)
                error('Source Angle must be a vector.')
            end

            % Ensure source frequency is a vector
            if ~isvector(self.source_freq)
                error('Source Frequency must be a vector.');
            end

            % Ensure source snr is a vector
            if ~isvector(self.source_snr)
                error('Source SNR must be a vector.');
            end

            % Ensure there is configuration for each source
            if (length(self.source_angle) ~= length(self.source_freq)) || ...
                (length(self.source_angle) ~= length(self.source_snr))

                error(['Source Angle, Source Frequency, and Source SNR'...
                    ' must be vectors of the same length.']);
            end
        end

        % Function computes the number of sources
        function y = num_sources(self)
            y = length(self.source_angle);
        end

        % Function initializes direction of arrival objects
        function initialize_doa_objects(self)
            
            % Initialize ULA object
            self.linear_array = uniform_linear_array(...
                'num_samples',      self.num_samples,...
                'num_elements',     self.num_elements,...
                'element_spacing',  self.element_spacing,...
                'source_angle',     self.source_angle,...
                'source_freq',      self.source_freq,...
                'source_snr',       self.source_snr);

            % Initialize beamforming DOA estimator
            self.beamforming_estimator = beamforming_doa_estimator(...
                'element_spacing',  self.element_spacing,...
                'look_angle',       self.look_angle);

            % Initialize Capon DOA estimator
            self.capon_estimator = capon_doa_estimator(...
                'element_spacing',  self.element_spacing,...
                'look_angle',       self.look_angle);

            % Initialize MUSIC DOA estimator
            self.music_estimator = music_doa_estimator(...
                'num_sources',      self.num_sources,...
                'element_spacing',  self.element_spacing,...
                'look_angle',       self.look_angle);

            % Initialize Improved MUSIC DOA estimator
            self.improved_music_estimator = improved_music_doa_estimator(...
                'num_sources',      self.num_sources,...
                'element_spacing',  self.element_spacing,...
                'look_angle',       self.look_angle);

            % Create Root MUSIC DOA estimator
            self.root_music_estimator = root_music_doa_estimator(...
                'num_sources',      self.num_sources,...
                'element_spacing',  self.element_spacing);

            % Create ESPRIT DOA estimator
            self.esprit_estimator = espirit_doa_estimator(...
                'num_sources',      self.num_sources,...
                'element_spacing',  self.element_spacing);
        end

        % Function creates received ULA data
        function create_rx_data(self)

            % Create ULA Data
            self.rx_data = self.linear_array.create_rx_data();
        end

        % Function runs DOA algorithms
        function run_doa_algorithms(self)

            % Create beamforming spatial spectrum
            self.beamforming_spatial_spectrum = ...
                self.beamforming_estimator.create_spatial_spectrum(self.rx_data);

            % Create capon spatial spectrum
            self.capon_spatial_spectrum = ...
                self.capon_estimator.create_spatial_spectrum(self.rx_data);
            
            % Create music spatial spectrum
            self.music_spatial_spectrum = ...
                self.music_estimator.create_spatial_spectrum(self.rx_data);
            
            % Create improved music spatial spectrum
            self.improved_music_spatial_spectrum = ...
                self.improved_music_estimator.create_spatial_spectrum(self.rx_data);
            
            % Create root music angle estimates
            self.root_music_source_angles = ...
                self.root_music_estimator.compute_source_angles(self.rx_data);
            
            % Create espirit music angle estimates
            self.esprit_source_angles = ...
                self.esprit_estimator.compute_source_angles(self.rx_data);
        end

        % Function plots the spatial spectrum
        function plot_spatial_spectrum(self)

            % Create and clear figure
            figure(self.fig_num);
            clf;

            % Overlay spatial spectrum plots
            hold on;

            % Plot beamforming spatial spectrum
            spatial_spectrum = self.beamforming_spatial_spectrum;
            spatial_spectrum_norm = spatial_spectrum/max(abs(spatial_spectrum));
            plot(self.look_angle,10*log10(abs(spatial_spectrum_norm)),'LineWidth',1.5);
            
            % Plot capon spatial spectrum
            spatial_spectrum = self.capon_spatial_spectrum;
            spatial_spectrum_norm = spatial_spectrum/max(abs(spatial_spectrum));
            plot(self.look_angle,10*log10(abs(spatial_spectrum_norm)),'LineWidth',1.5);
            
            % Plot MUSIC spatial spectrum
            spatial_spectrum = self.music_spatial_spectrum;
            spatial_spectrum_norm = spatial_spectrum/max(abs(spatial_spectrum));
            plot(self.look_angle,10*log10(abs(spatial_spectrum_norm)),'LineWidth',1.5);
            
            % Plot Improved MUSIC spatial pectrum
            spatial_spectrum = self.improved_music_spatial_spectrum;
            spatial_spectrum_norm = spatial_spectrum/max(abs(spatial_spectrum));
            plot(self.look_angle,10*log10(abs(spatial_spectrum_norm)),'LineWidth',1.5);

            % plot root music angle estimates
            colorOrder = get(gca,'ColorOrder');
            colorOrderIndex = get(gca,'ColorOrderIndex');
            plotColor = colorOrder(colorOrderIndex,:);
            line((self.root_music_source_angles.').*ones(2,1),...
                repmat(ylim.',1,length(self.root_music_source_angles)),...
                'Color',plotColor,'LineWidth',1.5);
            set(gca,'ColorOrderIndex',colorOrderIndex+1);
            
            % plot espirit angle estimates
            colorOrder = get(gca,'ColorOrder');
            colorOrderIndex = get(gca,'ColorOrderIndex');
            plotColor = colorOrder(colorOrderIndex,:);
            line((self.esprit_source_angles.').*ones(2,1),...
                repmat(ylim.',1,length(self.esprit_source_angles)),...
                'Color',plotColor,'LineWidth',1.5);
            set(gca,'ColorOrderIndex',colorOrderIndex+1);

            % Set plot bounds
            xlim([self.look_angle(1) self.look_angle(end)]);

            % Turn on grid and box
            grid on;
            box on;
            
            % Create legend
            legend([{'Beamforming','Capon','Music','Improved Music','Root Music'},...
                repmat({''},1,self.num_sources-1),{'ESPRIT'},...
                repmat({''},1,self.num_sources-1)]);
            
            % label axes
            xlabel('Angle (deg)');
            ylabel('Spatial Spectrum (dB)');
            title('Spatial Spectrum for Different Direction of Arrival Algorithms');
        end
    end
end