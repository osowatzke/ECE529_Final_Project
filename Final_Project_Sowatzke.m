%% Case 1
% Evaluating the effects of ULA size
% Perform DOA estimation with 4 antenna elements
o = doa_estimation(...
    'fig_num',      1,...
    'num_elements', 4);
o.run();

% Perform DOA estimation with 27 antenna elements
o = doa_estimation(...
    'fig_num',      2,...
    'num_elements', 27);
o.run();

%% Case 2
% Evaluating the effects of the number of correlation samples
% Perform DOA estimation with 5 correlation samples
o = doa_estimation(...
    'fig_num',      3,...
    'num_samples',  5);
o.run();

% Perform DOA estimation with 100 correlation samples
o = doa_estimation(...
    'fig_num',      4,...
    'num_samples',  100);
o.run();

%% Case 3
% Evaluating the effects of the SNR
% Perform DOA estimation with -10dB SNR for each source signal
o = doa_estimation(...
    'fig_num',      5,...
    'source_snr',   -10*ones(1,3));
o.run();

% Perform DOA estimation with 30dB SNR for each source signal
o = doa_estimation(...
    'fig_num',      6,...
    'source_snr',   30*ones(1,3));
o.run();

%% Case 4
% Closely spaced source signals
o = doa_estimation(...
    'fig_num',      6,...
    'source_angle', [0 10 15]);
o.run();

%% Case 5
% Correlated source signals
o = doa_estimation(...
    'fig_num',      7,...
    'source_freq',  [pi/3 pi/3 pi/7]);
o.run();
