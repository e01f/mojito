problem = 103;
base    = 'C:\Users\Alexander\Documents\BA\mojito\mtools\results\run-103-07.06.2012-a3feb71c-single';
objsfil = 'C:\Users\Alexander\Documents\BA\mojito\mtools\plot-settings\objectives-103';
objsfilhists = 'C:\Users\Alexander\Documents\BA\mojito\mtools\plot-settings\objectives-103-hists';
run('C:\Users\Alexander\Documents\BA\mojito\mtools\plot-settings\objectives_103.m');
mtoolsd = 'C:\Users\Alexander\Documents\BA\mojito\mtools';
python  = '"C:/Program Files/Python37/python.exe"';
m_path  = 'C:/Users/Alexander/Documents/BA/mojito';
state_file = 'state_gen0160.db';

wd = cd;
cd(m_path);
cmd = [python ' ./summarize_db.py ' num2str(problem) ' ' base '/' state_file ' None temp_metrics temp_points'];
if exist([m_path '/temp_metrics.val'], 'file') == 2
    if questdlg('temp_metrics/temp_points file exists, recreate?', 'summarize_db.py: rerun?', 'Yes', 'No', 'No') == "Yes"
        system(cmd);
    end
else
    system(cmd);
end
cd(wd);