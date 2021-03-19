% Step 1
%dataset1 = synthLoadMultipleStates(103, 'C:\Users\Alexander\Documents\BA\mojito\mtools\mojito-tests');

% Step 2
figure
hold on
synthPlotGenerationMetrics2D(dataset1{105},'voutpp1-2','toutzc1-2','rx')
%synthPlotGenerationMetrics2DMovie(dataset1, 'voutpp1', 'toutzc1', 'rx');