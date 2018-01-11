data = gpr_ghoshal();
file_name = data.fileName;
diel_1 = mean(data.dielectric.dielectric_1);
diel_2 = mean(data.dielectric.dielectric_2);
diel_3 = mean(data.dielectric.dielectric_3);

signal_1 = mean(data.signalQuality.signalQuality_1);
signal_2 = mean(data.signalQuality.signalQuality_2);
signal_3 = mean(data.signalQuality.signalQuality_3);

summary = struct('file_name', file_name, 'avg_dielectric_1', diel_1, ...
    'avg_dielectric_2', diel_2,'avg_dielectric_3', diel_3,...
    'avg_signal_quality_1', signal_1,'avg_signal_quality_2', signal_2,...
    'avg_signal_quality_3', signal_3)