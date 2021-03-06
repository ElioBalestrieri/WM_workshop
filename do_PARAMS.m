function P = do_PARAMS(SUBJ_name, str_call)
% define parameters for experiments
%
% created by Elio Balestrieri for didactic purpose at WWU
% started on 18-Mar-2019

% general
P.subjID = SUBJ_name; % empty previous
P.outsave = [SUBJ_name '_' str_call '_' datestr(now, 30)]; % provide a timestamp so that the name of the file will always be different, avoiding unwanted overwriting
P.expidentifier = str_call;
P.n_rep_cond = 4; % number of repetition per condition
P.textsize = 25;


% background & other colors (in RGB values)
P.colors.BCK = [128 128 128];
P.colors.TXT = [10 10 10];
P.colors.FIX = P.colors.TXT;
P.oneva = 52;

switch str_call
    
    case 'DMS'
        
        % define load conditions
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
        
    case 'sternberg'
        
        % define load conditions
        P.exp.load_conds = [1 3 6];
        
        % stimulus durations -in seconds
        P.exp.digit_onscreen = 1.2;
        P.exp.wait_for_probe = 2;
        P.exp.warning_sig = .2;
        
        % stimuli font
        P.exp.fontname = 'Courier New';
        
        % preallocate conditions
        P = local_preallocate_conds(P);
        
        % preallocate digits 
        P = local_preallocate_digits(P);
        
        % warning color fixation
        P.colors.WARN = [0 200 0];
        
        % reset textsize to have bigger stimuli
        P.textsize = 40;


      
end


% inter trial interval -common to all exps- in seconds
P.exp.ITI = 1;
P.exp.FIX = 1;

end



%% ######################### LOCAL FUNCTIONS ##############################
% local functions are a fast way to split any task in subcomponent. This
% process has two advantages: on the one hand improves computing
% performance; on the other, it improves readability of code, facilitating
% debugging. Just try to use them as much as possible.

% GENERAL FUNCTION
function P = local_preallocate_conds(P)
% preallocation here is meant to pre-assign the experimental conditions 
% before the experiment starts. In this way at every trial the right
% parameters (number of items, color of items, and so on, will be easily
% determined
%

% The function is assuming that the condition to be preallocated will generally be the same
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

% The positions of the squares are defined by taking N angles and N
% eccentricities and randomly sampling them.
put_angle = linspace(0,2*pi,P.exp.load_conds(end)); % define angles
im_vect = exp(1i*put_angle); % use complex numbers
eccentricity = linspace(P.oneva, 6*P.oneva, P.exp.load_conds(end));

% predefine colors
% the definition of colors is now lazily done by creating all possible
% combinations of 3 RGB values. Take into account that other parameters
% should be considered, like: how much the colors are similar among each
% other? Do they share the same luminance, and so on and so forth.
P.exp.colpalette = CombVec([0 128 255], [0 128 255], [0 128 255]);
P.exp.colpalette(:,sum(P.exp.colpalette==128)==3) = []; % null grey

% preallocate nans
% by "preallocation" is meant the pre-assigning a variable with
% pre-defefined dimension before starting a loop which will update at any
% iteration the entries of the matrix. This process hugely speeds up
% computation, and even if it is trivial with such small matrices (~30
% values), it is a good practice in data handling. Keep in mind when you
% see that your scipt takes too long ;)
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

% sternberg-specific
function P = local_preallocate_digits(P)

P.cell_digit_stims = cell(P.tot_trl, 2); % first column: vector of digits; second column: probe stimuli (scalar)
source_digit = 1:9;

for iTrial = 1:P.tot_trl
    
    digit_vect = randsample(source_digit, P.exp.pre_conds(iTrial,1));

    P.cell_digit_stims{iTrial, 1} = digit_vect;

    if P.exp.pre_conds(iTrial, 2) == 2

        P.cell_digit_stims{iTrial, 2} = randsample(digit_vect, 1);
        
    else
        
        to_be_sorted = source_digit(not(ismember(source_digit, digit_vect)));
        P.cell_digit_stims{iTrial, 2} = randsample(to_be_sorted, 1);

    end
end


end
