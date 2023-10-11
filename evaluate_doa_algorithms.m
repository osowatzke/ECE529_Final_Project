% Spacing between array elements in terms of lambda
element_spacing = 0.5;

% Source angle in degrees
source_angle = [-40, 10, 50];

% Frequency of each source
source_freq = [pi/3, pi/5, pi/7].';

% Number of array elements
num_elements = 10;

% Number of Correlation samples
num_samples = 100;

% SNR of each source
% Does not match paper
SNR_dB = 30*ones(1,3);

% Look angle in degrees
look_angle = (-90:1:90);

% Craete linear array object
linear_array = uniform_linear_array(...
    'num_samples',      num_samples,...
    'num_elements',     num_elements,...
    'element_spacing',  element_spacing,...
    'source_angle',     source_angle,...
    'source_freq',      source_freq,...
    'source_snr',       SNR_dB);

% Create beamforming direction of arrival estimator
beamforming_estimator = beamforming_doa_estimator(...
    'element_spacing',  element_spacing,...
    'look_angle',       look_angle);

% Create capon direction of arrival estimator
capon_estimator = capon_doa_estimator(...
    'element_spacing',  element_spacing,...
    'look_angle',       look_angle);

% Create music direction of arrival estimator
music_estimator = music_doa_estimator(...
    'num_sources',      length(source_angle),...
    'element_spacing',  element_spacing,...
    'look_angle',       look_angle);

% Create improved music direction of arrival estimator
improved_music_estimator = improved_music_doa_estimator(...
    'num_sources',      length(source_angle),...
    'element_spacing',  element_spacing,...
    'look_angle',       look_angle);

% Create root music direction of arrival estimator
root_music_estimator = root_music_doa_estimator(...
    'num_sources',      length(source_angle),...
    'element_spacing',  element_spacing);

% Create espirit direction of arrival estimator
espirit_estimator = espirit_doa_estimator(...
    'num_sources',      length(source_angle),...
    'element_spacing',  element_spacing);

% Create receive data for linear array
rx_data = linear_array.create_rx_data();

% Create beamforming spatial spectrum
beamforming_spatial_spectrum = beamforming_estimator.create_spatial_spectrum(rx_data);

% Create capon spatial spectrum
capon_spatial_spectrum = capon_estimator.create_spatial_spectrum(rx_data);

% Create music spatial spectrum
music_spatial_spectrum = music_estimator.create_spatial_spectrum(rx_data);

% Create improved music spatial spectrum
improved_music_spatial_spectrum = improved_music_estimator.create_spatial_spectrum(rx_data);

% Create root music angle estimates
root_music_source_angles = root_music_estimator.compute_source_angles(rx_data);

% Create espirit music angle estimates
espirit_source_angles = espirit_estimator.compute_source_angles(rx_data);

% Create figure
figure(1)
clf;
hold on;

% plot beamforming spatial spectrum
y = 10*log10(abs(beamforming_spatial_spectrum));
plot(look_angle,y - max(y),'LineWidth',1.5);

% plot capon spatial spectrum
y = 10*log10(abs(capon_spatial_spectrum));
plot(look_angle,y - max(y),'LineWidth',1.5);

% plot music spatial spectrum
y = 10*log10(abs(music_spatial_spectrum));
plot(look_angle,y - max(y),'LineWidth',1.5);

% plot improved music spatial pectrum
y = 10*log10(abs(improved_music_spatial_spectrum));%max(abs(P)));
plot(look_angle,y - max(y),'LineWidth',1.5);

% plot root music angle estimates
colorOrder = get(gca,'ColorOrder');
colorOrderIndex = get(gca,'ColorOrderIndex');
plotColor = colorOrder(colorOrderIndex,:);
line((root_music_source_angles.').*ones(2,1), repmat(ylim.',1,length(root_music_source_angles)),...
    'Color',plotColor,'LineWidth',1.5);
set(gca,'ColorOrderIndex',colorOrderIndex+1);

% plot espirit angle estimates
colorOrder = get(gca,'ColorOrder');
colorOrderIndex = get(gca,'ColorOrderIndex');
plotColor = colorOrder(colorOrderIndex,:);
line((espirit_source_angles.').*ones(2,1), repmat(ylim.',1,length(espirit_source_angles)),...
    'Color',plotColor,'LineWidth',1.5);
set(gca,'ColorOrderIndex',colorOrderIndex+1);
xlim([look_angle(1) look_angle(end)]);
grid on;
box on;


% Create legend
legend([{'Beamforming','Capon','Music','Improved Music','Root Music'},...
    repmat({''},1,length(root_music_source_angles)-1),{'ESPRIT'},...
    repmat({''},1,length(root_music_source_angles)-1)]);

% label axes
xlabel('Angle (deg)');
ylabel('Spatial Spectrum (dB)');
title('Spatial Spectrum for Different Direction of Arrival Algorithms');