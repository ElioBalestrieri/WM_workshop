function P = do_PARAMS(SUBJ_name, str_call)
% define parameters for experiments
%
% created by Elio Balestrieri for didactic purpose at WWU
% started on 18-Mar-2019

% general
P.subjID = SUBJ_name; % empty previous
P.outsave = [SUBJ_name '_' str_call '_' datestr(now, 30)];
P.expidentifier = str_call;
P.n_rep_cond = 4; % number of repetition per condition
P.textsize = 25;


% background & other colors
P.colors.BCK = [128 128 128];
P.colors.TXT = [10 10 10];
P.colors.FIX = P.colors.TXT;
P.oneva = 52;

switch str_call
    
    case 'DMS'
        
        P.exp.load_conds = [3 4 9];
        
        % stimulus durations -in seconds
        P.exp.square_onscreen = .5;
        P.exp.ISI = 1.5;
        
        % stimuli dimensions -in pixels
        P.square_edge = 30;
                
        % preallocate conditions
        P = local_preallocate_conds(P);
        
        % define squares positions
        P = local_preallocate_squarepos(P);
        
        
        
end


% inter trial interval -common to all exps- in seconds
P.exp.ITI = 1;
P.exp.FIX = 1;

end



%% ######################### LOCAL FUNCTIONS ##############################

% GENERAL FUNCTIONS
function P = local_preallocate_conds(P)
% assuming that the condition to be preallocated will generally be the same
% regardless of the experiment to be performed: some memory load, and an
% equal distribution of trials conforming with the memory items or not

module_trls = CombVec(P.exp.load_conds, [1 2]);
trl_mat = repmat(module_trls, 1,P.n_rep_cond);
P.exp.pre_conds = datasample(trl_mat,size(trl_mat, 2),2, 'Replace', false)';

% then add some parameters in the root of P, like trial number and so on
P.this_trl = 1;
P.tot_trl = size(P.exp.pre_conds,1);

% finally preallocate data structure
% cols ord: 1-load condition; 2- congruency condition; 3- subj resp; 4-
% accuracy, 5- RT

P.data = nan(P.tot_trl, 5);
P.data(:,1:2) = P.exp.pre_conds;

end

% DMS-specific
function P = local_preallocate_squarepos(P)
% preallocate square position and colors

put_angle = linspace(0,2*pi,P.exp.load_conds(end)); 
im_vect = exp(1i*put_angle);
eccentricity = linspace(P.oneva, 6*P.oneva, P.exp.load_conds(end));

% predefine colors
P.exp.colpalette = CombVec([0 128 255], [0 128 255], [0 128 255]);
P.exp.colpalette(:,sum(P.exp.colpalette==128)==3) = []; % null grey

% preallocate nans
P.exp.square_pos = nan(P.tot_trl, P.exp.load_conds(end), 2);
P.exp.square_cols = nan(P.tot_trl, P.exp.load_conds(end)+1, 3);

for iTrial = 1:P.tot_trl
    
    subset.angles = randsample(im_vect, P.exp.load_conds(end));
    subset.ecc = randsample(eccentricity, P.exp.load_conds(end));
    subset.fin = subset.angles.*subset.ecc;
    
    % define xy pos in the matrix
    P.exp.square_pos(iTrial, :, 1) = round(real(subset.fin));
    P.exp.square_pos(iTrial, :, 2) = round(imag(subset.fin));
    
    % define colors
    P.exp.square_cols(iTrial, :, :) = ...
        datasample(P.exp.colpalette, P.exp.load_conds(end)+1, 2, ...
        'Replace', false)'; % one more than necessary, to facilitate shift between "correct" and "incorrect" decision
    
    
end

end

