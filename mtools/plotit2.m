problem = 103;
base    = 'C:\Users\Alexander\Documents\BA\mojito\mtools\results\run-103-27.01.2021-9190a223';
objsfil = 'C:\Users\Alexander\Documents\BA\mojito\mtools\plot-settings\objectives-103';
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

fancyFmt = 1;

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
    fig4.Position(3:4) = [1024 768];
    font_size = 11; %10 is default
    font_weight = 'bold'; %'normal' or 'bold'
    
    %h = plotmatrix(objective_X','o');
    %set(h, 'MarkerSize','3');
    
    %linetypes = 'ox+*sdv^<>phox+';
    num_objs = size(objective_X, 1);
    subplot_i = 0;
        
    for row_i = 1:num_objs
        for col_j = 1:num_objs
            subplot_i = subplot_i + 1;
            h = subplot(num_objs, num_objs, subplot_i);
            if row_i == col_j
                hist(objective_X(row_i,:), 20);
                yExponent = getAxExponent(objective_X(row_i,:));
                xExponent = getAxExponent(objective_X(col_j,:));
            else
                pl = plot(objective_X(col_j,:), objective_X(row_i,:), 'k+', 'MarkerSize', 5);
                ax = ancestor(pl, 'axes');
                
                goalInfoIdx = find(ismember({s.name}, objective_vars{row_i}));
                if (size(goalInfoIdx, 2) > 0)
                    hline = refline(ax, [0 s(goalInfoIdx).min]);
                    hline.Color = 'r';
                    hline = refline(ax, [0 s(goalInfoIdx).max]);
                    hline.Color = 'r';
                    hline = refline(ax, [0 s(goalInfoIdx).goal]);
                    hline.Color = 'g';
                end
                if fancyFmt
                    yExponent = formatAxisTicks(ax, objective_X(row_i,:), true);
                    xExponent = formatAxisTicks(ax, objective_X(col_j,:), false);
                else
                    yExponent = getAxExponent(objective_X(row_i,:));
                    xExponent = getAxExponent(objective_X(col_j,:));
                end
            end
            
            %set y-label and y-tick marks (on 1st column, with exceptions)
            if (col_j == 1 && row_i == 1)
                axisLabel(objective_vars{row_i}, yExponent, true, font_size, font_weight)
                set(h, 'YTickLabel', '');
            elseif (col_j == num_objs && row_i == 1)
                set(h, 'YAxisLocation', 'right');
            elseif (col_j == 1)
                axisLabel(objective_vars{row_i}, yExponent, true, font_size, font_weight)
                %annotation('textbox',[0 0.1 0.1 0.1],'interpreter','latex','String','$\times 10^{-12}$', 'FitBoxToText','on', 'EdgeColor', 'none');
            else
                set(h, 'YTickLabel', '');
            end
                        
            %set x-label and x-tick marks
            if (row_i == num_objs && col_j == num_objs)
                axisLabel(objective_vars{col_j}, xExponent, false, font_size, font_weight);
                set(h, 'XTickLabel', '');
            elseif (row_i == 1 && col_j == num_objs)
                set(h, 'XAxisLocation', 'top');
            elseif (row_i == num_objs)
                axisLabel(objective_vars{col_j}, xExponent, false, font_size, font_weight);
            else
                set(h, 'XTickLabel', '');
            end
            
            set(h, 'FontSize', [font_size], 'FontWeight', font_weight);
            %set(h, 'OuterPosition', outer_position);
            pos = get(h, 'Position');
            dw = 0.01;
            dh = 0.01;
            newpos = [pos(1)-dw, pos(2)-dh, pos(3)+dw*2, pos(4)+dh*2];
            set(h, 'Position', newpos);
        end
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

function axExponent = getAxExponent(data)
    axMin = min(data);
    axExponent = floor(log10(abs(axMin)));
end

function axExponent = formatAxisTicks(ax, data, isY)
     axMin = min(data);
     axMax =  max(data);
     axTicks = linspace(axMin, axMax, 5);
     %axTicklabels = num2cell((axTicks./(10.^floor(log10(axTicks)))));
     axExponent = floor(log10(abs(axMin)));
     axFactor = 10^axExponent;
     axMagnitude = (axMax - axMin);
     axMagnitudeScaled = axMagnitude/axFactor;
     axNumMagnitudeDecades = floor(log10(1/axMagnitudeScaled));
     axTickLabelsScaled = axTicks./axFactor;
     %'%0.1f'
     extraDigits = 1;
     while extraDigits < 10
        numDigits = max(axNumMagnitudeDecades + extraDigits, 0);
        axFormatStr = sprintf('%%0.%df', numDigits);
        axTicklabels = cellfun(@(s)sprintf(axFormatStr, round(s, numDigits)), num2cell(axTickLabelsScaled),'UniformOutput',false);
        if (length(axTicklabels) - length(unique(axTicklabels)) > 0)
             extraDigits = extraDigits + 1;
        else
             break
        end
     end
     
     if (isY)
     ax.YTickLabelMode = 'manual';
     ax.YTickMode = 'manual';
     ax.YTick = axTicks;
     ax.YTickLabel = axTicklabels;
     ax.YLimMode = 'manual';
     ax.YLim = [(axMin - axMagnitude*0.05) (axMax + axMagnitude*0.05)];
     else
        ax.XTickLabelMode = 'manual';
        ax.XTickLabelRotation = 90;
        ax.XTickMode = 'manual';
        ax.XTick = axTicks;
        ax.XTickLabel = axTicklabels;
        ax.XLimMode = 'manual';
        ax.XLim = [(axMin - axMagnitude*0.05) (axMax + axMagnitude*0.05)];
     end
end