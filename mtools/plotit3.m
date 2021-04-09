problem = 103;
base    = 'C:\Users\Alexander\Documents\BA\mojito\mtools\results\run-103-27.01.2021-9190a223';
objsfil = 'C:\Users\Alexander\Documents\BA\mojito\mtools\plot-settings\objectives-103-hists';
run('C:\Users\Alexander\Documents\BA\mojito\mtools\plot-settings\objectives_103.m');
mtoolsd = 'C:\Users\Alexander\Documents\BA\mojito\mtools';
python  = '"C:/Program Files/Python37/python.exe"';
m_path  = 'C:/Users/Alexander/Documents/BA/mojito';
state_file = 'state_gen0105.db';

% Step 1
%dataset1 = synthLoadMultipleStates(103, testdat);

% hdr file will contain
% IND_ID,GENETIC_AGE,FEASIBLE,maxpwr,avgpwr,voutdc,voutav1,voutav2,voutav3,voutav4,voutpp1,voutpp2,voutpp3,voutpp4,toutzc1,toutzc2,toutzc3,toutzc4,maxpwr-2,avgpwr-2,voutdc-2,voutav1-2,voutav2-2,voutav3-2,voutav4-2,voutpp1-2,voutpp2-2,voutpp3-2,voutpp4-2,toutzc1-2,toutzc2-2,toutzc3-2,toutzc4-2,metric_functio


% Step 2
%figure
%hold on
%synthPlotGenerationMetrics3D(dataset1{105},'voutpp3', 'voutav3','toutzc3','rx')
%synthPlotGenerationMetrics2DMovie(dataset1, 'voutav3', 'toutzc3', 'r.');

% Step 3
wd = cd;
cd(m_path);
cmd = [python ' ./summarize_db.py ' num2str(problem) ' ' base '/' state_file ' None temp_metrics temp_points'];
system(cmd);
cd(wd);

%(not used, so turned off)
%[scaled, unscaled] = synthImportPoints([base '_points']);  
%all_unscaled_vars = unscaled.header; % {var index}
%all_unscaled_X = unscaled.data'; % [var index][sample index]

%'objective_X' has _only_ metric_value data for objectives; not ind_ID etc
objectives = synthImportObjectives(objsfil, [m_path '\temp_metrics']);
objective_vars = objectives.header; % {objective index}
objective_X = objectives.data'; % [objective index][sample index]
for i = 1:length(objective_vars)
    objective_vars{i} = strrep(objective_vars{i}, '_', ' ');
end

%'notposs_X' has _only_ metric value data for objectives; not ind_ID etc
%notposs = synthImportMetrics([base '_notposs']);
%notposs_X = notposs.data'; % [objective index][sample index]

objective_X01 = objective_X; %like objective_X, but range is [0,1] per row
for var_i = 1:size(objective_X,1)
    mn = min(objective_X(var_i, :));
    mx = max(objective_X(var_i, :));
    objective_X01(var_i,:) = (objective_X(var_i,:) - mn) / (mx - mn);
end

%maybe do 2d scatterplot grid
%objective_X = objectives.data'; % [objective index][sample index]
if 1
    fig4 = figure(4);
    fig4.Position(1:2) = [400 0];
    fig4.Position(3:4) = [1800 768];
    font_size = 11; %10 is default
    font_weight = 'bold'; %'normal' or 'bold'
    
    %h = plotmatrix(objective_X','o');
    %set(h, 'MarkerSize','3');
    
    %linetypes = 'ox+*sdv^<>phox+';
    num_objs = size(objective_X, 1);
    subplot_i = 0;
        
    for row_i = 1:num_objs
        subplot_i = subplot_i + 1;
        h = subplot(2, num_objs/2, subplot_i);
        goalInfoIdx = find(ismember({s.name}, objective_vars{row_i}));
        if (size(goalInfoIdx, 2) > 0)
            edges = linspace(s(goalInfoIdx).min, s(goalInfoIdx).max, 100);
            hg = histogram(objective_X(row_i,:), 'BinEdges', edges);
        else
            hg = histogram(objective_X(row_i,:), 20);
        end
        ax = ancestor(hg, 'axes');
        if (size(goalInfoIdx, 2) > 0)
            ax.XLimMode = 'manual';
            axMagnitude = (s(goalInfoIdx).max - s(goalInfoIdx).min);
            ax.XLim = [(s(goalInfoIdx).min - axMagnitude*0.05) (s(goalInfoIdx).max + axMagnitude*0.05)];
            hLine = line(ax, [s(goalInfoIdx).min, s(goalInfoIdx).min], ylim);
            hLine.Color = 'r';
            hLine = line(ax, [s(goalInfoIdx).max, s(goalInfoIdx).max], ylim);
            hLine.Color = 'r';
            hLine = line(ax, [s(goalInfoIdx).goal, s(goalInfoIdx).goal], ylim);
            hLine.Color = 'g';
        end
        axisLabel(objective_vars{row_i}, 0, false, font_size, font_weight);
   
        set(h, 'FontSize', [font_size], 'FontWeight', font_weight);
        pos = get(h, 'Position');
        xOffs = 0.00;
        yOffs = 0.00;
        dw = 0.005;
        dh = 0.02;
        newpos = [pos(1)-xOffs-dw, pos(2)-yOffs-dh, pos(3)+dw*2, pos(4)+dh*2];
        set(h, 'Position', newpos);
    end
end

function axisLabel(axLbl, axExponent, isY, font_size, font_weight)
    if ~(axExponent == 0)
        axLbl = [axLbl ' x 10^{' num2str(axExponent) '}'];
    end
    if isY
        ylabel(axLbl, 'FontSize', [font_size], 'FontWeight', font_weight);
    else
        xlabel(axLbl, 'FontSize', [font_size], 'FontWeight', font_weight);
    end
end