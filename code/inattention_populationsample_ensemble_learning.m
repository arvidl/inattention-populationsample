% inattention_populationsample_ensemble_learning.m
% In: /Users/arvid/GitHub/inattention-populationsample/code

fn1 = '../data/inattention_nomiss_2397x12.csv';
fn2 = '../datainattention_nomiss_2397x12_snap_is_0_1_2_outcome_is_0_1_2.csv';
fn3 = '../data/inattention_nomiss_2397x12_snap_is_0_1_2_outcome_is_L_M_H.csv';
fn4 = '../data/inattention_nomiss_2397x12_snap_is_N_S_C_outcome_is_L_M_H.csv';


% E = readtable(fn2);
D = readtable(fn4);

summary(D)

tc = fitctree(D, 'averBinned');

view(tc, 'Mode','graph')