% data_prep_and_visualization_20160203.m
% Arvid Lundervold (c) 2016
% cf. Figure ./Figs/Data_to_classes_20151209_pptx.pdf in manus
% Uses data produced by the R-script 'code2/data_prep_20160203.R'

% Modified from D_20151110_analysis_20151211.m
% using fn1 = '../data/Dnomiss_20151110.csv';
% (modified from D_20150525_analysis.m, D_20150813_analysis.m)
% Require data from: astri_wave1_inattention_cond_infer_trees_18_20151110.Rmd
% clear all, close all hidden, data_prep_and_visualization_20160203

MATREAD = 0;
OLD_ANALYSES = 0;
NEW_ANALYSES = 1;
SUMMARY = 0;
FITENSEMBLE = 0;

% import matplotlib.pyplot as plt
% plt.savefig()

%% Read the data

fn1 = '../data2/inattention_nomiss_snap_is_012_20160203.csv';
% fn1 = '../data/Dnomiss_20151110.csv';
% fn2 = '../data/D_20151110.csv';
% fn3 = '../data/dd_20151110.csv';

T1 = readtable(fn1);
T2 = readtable(fn2);
T3 = readtable(fn3);

%% Inspect table data in T

T1.Properties.Description =['../data/Dnomiss_20151110.csv ; ', 'Derived from: astri_wave1_inattention_cond_infer_trees_18_20151110.Rmd'];
T = T1(:, {'gender', 'grade','snap1','snap2','snap3','snap4','snap5','snap6','snap7','snap8','snap9','ave'});
T.Properties.VariableNames = {'gender', 'grade','snap1','snap2','snap3','snap4','snap5','snap6','snap7','snap8','snap9','ave'};
T.Properties.VariableDescriptions =  {'0=Girl/1=Boy'  'Grade'  'SNAP1 question'  'SNAP2' 'SNAP3' 'SNAP4' 'SNAP5' 'SNAP6' 'SNAP7' 'SNAP8' 'SNAP9' 'Mean academic achievement'};
T.Properties.VariableUnits =  {'0/1'  '2/3/4'  'score 0/1/2'  '0/1/2' '0/1/2' '0/1/2' '0/1/2' '0/1/2' '0/1/2' '0/1/2' '0/1/2' 'real number in [0, 6]'};
TT = T;

% Some properties
h = height(T);
w = width(T);
fprintf('\n ==> Properties of table T of height %d and width %d:\n\n', h, w);
disp(T.Properties)

% Display the first five rows of table T
fprintf('\n ==> First five rows of table T:\n\n');
disp(T(1:5,:))


%% Make a matrix A of the numeric gender, grade, ave, and SNAP variables

tq_list = {'snap1','snap2','snap3','snap4','snap5','snap6','snap7','snap8','snap9'};
A = T{:,tq_list};
A = [T{:, {'gender','grade','ave'}}, A]; % pre-insert the variable 'gender', 'grade' and 'ave'
Avars = {'gender','grade','ave', 'snap1','snap2','snap3','snap4','snap5','snap6','snap7','snap8','snap9'};
l = length(Avars);

% Display the first ten rows of matrix A
fprintf('\n ==> First ten rows of matrix A:\n\n');
for i=1:length(Avars)-1
    fprintf('\t%s', char(Avars(i)));
end
fprintf('\t%s\n', char(Avars(i+1)));
disp(A(1:10,:))


%% Discretized at three levels, with data-driven cutpoints (equifreqent levels)

bins = 3;
y = quantile(T.ave,[0:bins]/bins);
[N,EDGES,BIN] = histcounts(T.ave,y);
cuts = sprintf('1:[%.3f, %.3f) 2:[%.3f,%.3f) 3:[%.3f,%.3f]', EDGES(1), EDGES(2), EDGES(2), EDGES(3), EDGES(3), EDGES(4));
T.ave_cat = BIN;   % categorical(BIN,'Ordinal',true);
descr = sprintf('%s - 1:low, 2:medium; 3:high average mark', cuts);
fprintf('\n ==> Discretization of acadmic achievements (i.e. T.ave_cat): %s\n', cuts);
T.Properties.VariableDescriptions{'ave_cat'} = descr;


%% Make a matrix B of the numeric gender, grade, ave, and SNAP variables

B = T{:,tq_list};
B = [T{:, {'gender','grade','ave_cat'}}, B]; % pre-insert the variable 'gender', 'grade' and 'ave'
Bvars = {'gender','grade','ave_cat', 'snap1','snap2','snap3','snap4','snap5','snap6','snap7','snap8','snap9'};

l = length(Avars);

% Display the first ten rows of matrix b
fprintf('\n ==> First ten rows of matrix B:\n\n');
for i=1:length(Bvars)-1
    fprintf('%s\t', char(Bvars(i)));
end
fprintf('%s\n', char(Bvars(i+1)));
disp(B(1:10,:))


%% Make a new table Tcat with categoricak variables

Tcat = T;
Tcat.gender = categorical(T.gender);
Tcat.grade = categorical(T.grade,'Ordinal',true);
for i=1:9
    cmd = sprintf('Tcat.snap%d = categorical(T.snap%d);', i, i);
    eval(cmd);
end


%% Make a subsets of A representing average achievement and SNAP in girls and boys, respectiveley

ave_girls = A(A(:,1)== 0,3);
ave_boys =  A(A(:,1)== 1,3);

snap_girls = A(A(:,1)== 0,4:12);
snap_boys = A(A(:,1)== 1,4:12);

snap = A(:,4:12);
Gender = A(:,1);
Grade = A(:,2);
Ave = A(:,3);
Ave_cat = B(:,3);

save '../data2/Dnomiss_A_B_Gender_Grade_SNAP_20160203.mat' fn1 T1 T A Avars B Bvars Gender Grade Ave Ave_cat ave_girls ave_boys snap snap_girls snap_boys


%% New analyses

if NEW_ANALYSES == 1
    
    n_girls = length(ave_girls);
    mean_ave_girls = mean(ave_girls);
    std_ave_girls = std(ave_girls);
    med_ave_girls = median(ave_girls);
    n_boys = length(ave_boys);
    mean_ave_boys = mean(ave_boys);
    std_ave_boys = std(ave_boys); 
    med_ave_boys = median(ave_boys);
        
    fprintf('\n ==> Mean acadmic achievements GIRLS (n=%d): mean = %.3f (SD = %.3f), median = %.3f\n', ...
        n_girls, mean_ave_girls, std_ave_girls, med_ave_girls);
    
    fprintf('\n ==> Mean acadmic achievements BOYS (n=%d): mean = %.3f (SD = %.3f), median = %.3f\n', ...
        n_boys, mean_ave_boys, std_ave_boys, med_ave_boys);
    
    
    % Histogram plots
    
    fg1 = figure(1);
    % h1 = histogram(ave_girls, 'FaceColor', [1, 0, 0], 'FaceAlpha', 0.6, 'BinWidth', 0.1); % ,'BinLimits', [0, 6]);
    h1 = histogram(ave_girls, 'FaceColor', [1, 0, 0], 'FaceAlpha', 0.6, 'BinMethod', 'scott');
    hold on
    % h2 = histogram(ave_boys, 'FaceColor', [0, 0, 1], 'FaceAlpha', 0.6, 'BinWidth', 0.1); % ,'BinLimits', [0, 6]);
    h2 = histogram(ave_boys, 'FaceColor', [0, 0, 1], 'FaceAlpha', 0.6, 'BinMethod', 'scott');
    hold off
    xlabel('Average marks [0, 6]')
    legend('GIRLS', 'BOYS','Location', 'NorthEast')
    set(gcf, 'Color', 'White', 'Unit', 'Normalized', 'Position', [0.0452 0.1295 0.6381 0.7790]) ;
    title(sprintf('Academic achievement: GIRLS (n=%d) and BOYS (n=%d)', n_girls, n_boys), 'FontSize', 16);
    % orient landscape
    % print('-dpdf', '-bestfit', 'FIG_academic_achievement_girls_boys')
    % cmd = sprintf('!open FIG_academic_achievement_girls_boys.pdf');
    print('FIG_academic_achievement_girls_boys_20160203', '-depsc')
    cmd = sprintf('!open FIG_academic_achievement_girls_boys_20160203.eps');
    % eval(cmd);

    % cmd = sprintf('h{i} = histogram(K(:,%d), ''BinLimits'', [0, nbins(%d)], ''BinWidth'', 1.0,''FaceColor'', [0, 0, 0], ''FaceAlpha'', 0.6);', i, i);
    % eval(cmd);
    % suptitle(sprintf('Academic achievement: GIRLS (n=%d) and BOYS (n=%d)', n_girls, n_boys));
 
    snap_vars = {'snap1','snap2','snap3','snap4','snap5','snap6','snap7','snap8','snap9'};
    table_snap_girls = array2table(snap_girls, 'VariableNames', snap_vars);
    table_snap_boys = array2table(snap_boys, 'VariableNames', snap_vars);
    
    fprintf('\n ==> SNAP Girls and Boys tabulate:\n\n');
    for i=1:9
        cmd = sprintf('tg%d = tabulate(snap_girls(:,%d));', i, i);
        eval(cmd);
        cmd = sprintf('tb%d = tabulate(snap_boys(:,%d));', i, i);
        eval(cmd);
    end
    
    fprintf('\\begin{tabular}{l|rrr|rrr|rrr|rrr|rrr|rrr|rrr|rrr|rrr}\n')
    fprintf('\t&  \\multicolumn{3}{c|}{SNAP1}\t & \t \\multicolumn{3}{c|}{SNAP2}\t & \t \\multicolumn{3}{c|}{SNAP3}\t & \t \\multicolumn{3}{c|}{SNAP4}\t & \t \\multicolumn{3}{c|}{SNAP5}\t & \t \\multicolumn{3}{c|}{SNAP6}\t & \t \\multicolumn{3}{c|}{SNAP7}\t & \t \\multicolumn{3}{c|}{SNAP8}\t & \t \\multicolumn{3}{c|}{SNAP9}\\\\ \n');
    fprintf('Sex \t & 0 & 1 & 2\t&  0 & 1 & 2\t& 0 & 1 & 2\t& 0 & 1 & 2\t& 0 & 1 & 2\t& 0 & 1 & 2\t& 0 & 1 & 2\t& 0 & 1 & 2\t& 0 & 1 & 2\\\\ \n');
    fprintf('GIRLS\t'); 
    for i=1:8
        cmd = sprintf('fprintf(''& %%.1f & %%.1f & %%.1f\\t'', tg%d(1,3), tg%d(2,3), tg%d(3,3));', i, i, i);
        eval(cmd)
    end
    cmd = sprintf('fprintf(''& %%.1f & %%.1f & %%.1f'', tg%d(1,3), tg%d(2,3), tg%d(3,3));', i+1, i+1, i+1);
    eval(cmd)
    fprintf('\\\\ \n');
    
    fprintf('BOYS\t');
    for i=1:8
        cmd = sprintf('fprintf(''& %%.1f & %%.1f & %%.1f\\t'', tb%d(1,3), tb%d(2,3), tb%d(3,3));', i, i, i);
        eval(cmd)
    end
    cmd = sprintf('fprintf(''& %%.1f & %%.1f & %%.1f'', tb%d(1,3), tb%d(2,3), tb%d(3,3));', i+1, i+1, i+1);
    eval(cmd)
    fprintf('\\\\ \n');
    fprintf('\\end{tabular}\n')
    
    % Make a methodological figure     
    ss = snap(:,1);
    sss = repmat(ss, 1, 100);
    for i=2:9
        ss = snap(:,i);
        ssss = repmat(ss, 1, 100);
        sss = [sss, ssss];
    end
    
    % Create figure
    fg2 = figure(2);
    colormap('gray(3)');
    set(fg2, 'Color', 'White', 'Unit', 'Normalized', 'Position', [0.0256 0.1162 0.1786 0.7790]) ;
    
    % Create axes
    axes1 = axes('Parent',fg2);
    hold(axes1,'on');
    
    % Create image
    im = image(sss,'Parent',axes1,'CDataMapping','scaled');
    
    box(axes1,'on');
    axis(axes1,'tight');
    axis(axes1,'ij');
    % Set the remaining axes properties
    set(axes1,'CLim',[0 2],'DataAspectRatio',[1 1 1],'Layer','top','XTick',...
        [50 150 250 350 450 550 650 750 850 900.5],'XTickLabel',...
        {'1','2','3','4','5','6','7','8','9',''});
    % Create colorbar
    colorbar('peer',axes1,'southoutside','Ticks',[0 1 2]);
    %orient portrait
    print('FIG_snap_data_matrix_20160203', '-depsc');
    
    
    % Average marks
    tt = Ave(:,1);
    ttt = repmat(tt, 1, 100);
    
    % Create figure
    fg3 = figure(3);
    colormap('gray(256)');
    set(fg3, 'Color', 'White', 'Unit', 'Normalized', 'Position', [0.0256 0.1162 0.0500 0.7790]) ;
    
    % Create axes
    axes1 = axes('Parent',fg3);
    hold(axes1,'on');
    
    % Create image
    im = image(ttt,'Parent',axes1,'CDataMapping','scaled');
    
    box(axes1,'on');
    axis(axes1,'tight');
    axis(axes1,'ij');
    % Set the remaining axes properties
    set(axes1,'CLim',[0 6],'DataAspectRatio',[1 1 1],'Layer','top','XTick',...
        [50 150 250 350 450 550 650 750 850 900.5],'XTickLabel',...
        {'','','','','','','','','',''});
    % Create colorbar
    colorbar('peer',axes1,'southoutside','Ticks',[0 3 6]);
    %colorbar('peer',axes1,'southoutside');
    %orient portrait
    print('FIG_ave_data_matrix', '-depsc');
    
    
    % Average marks (categorized)
    uu = Ave_cat(:,1);
    uuu = repmat(uu, 1, 100);
    
    % Create figure
    fg4 = figure(4);
    colormap('gray(3)');
    set(fg4, 'Color', 'White', 'Unit', 'Normalized', 'Position', [0.0256 0.1162 0.0500 0.7790]) ;
    
    % Create axes
    axes1 = axes('Parent',fg4);
    hold(axes1,'on');
    
    % Create image
    im = image(uuu,'Parent',axes1,'CDataMapping','scaled');
    
    box(axes1,'on');
    axis(axes1,'tight');
    axis(axes1,'ij');
    % Set the remaining axes properties
    set(axes1,'CLim',[1 3],'DataAspectRatio',[1 1 1],'Layer','top','XTick',...
        [50 150 250 350 450 550 650 750 850 900.5],'XTickLabel',...
        {'','','','','','','','','',''});
    % Create colorbar
    % colorbar('peer',axes1,'southoutside','Ticks',[0 1 2]);
    colorbar('peer',axes1,'southoutside');
    %orient portrait
    print('FIG_ave_cat_data_matrix', '-depsc');
    
    
    
%     im = imagesc(sss, [0 2]), axis image, colormap(gray(3))
%     colorbar('southoutside')
%     title('SNAP 1, SNAP 2, SNAP 3, SNAP 4, SNAP 5, SNAP 6, SNAP 7, SNAP 8, SNAP 9');
%     
    % [P1,ANOVATAB1,STATS1] = kruskalwallis(snap(:,1), Gender)
    
    % Two-sample F test for equal variances.
    [H1,P1,CI1,STATS1] = vartest2(ave_girls,ave_boys)

    % Two-sample t-test with pooled or unpooled variance estimate.
    [H2,P2,CI2,STATS2] = ttest2(ave_girls,ave_boys, 'vartype', 'unequal')
    
end


