%% WORKING MEMORY TEST BATTERY
%
% created by Elio Balestrieri for didactic purpose at WWU
% started on 18-Mar-2019

clear all
close all
clc

% remind to add ptb path now otherwise some functions (CombVec) won't work
% on windows
% addpath(genpath('/home/ebalestr/toolboxes/Psychtoolbox-3-Psychtoolbox-3-9b2e154/Psychtoolbox')) % add ptb -unnecessary in LAB -?-

%% Get subject name
% .. and test to be performed

SUBJ_name = input('Please insert subject name: ', 's');

prompt_exp = ['\nWhich experiment would you like to run?\n', ...
    '\n[S] --> Sternberg Task',...
    '\n[D] --> Delayed-Match-to-Sample (DMS) task'...
    '\n[Q] --> Exit'...
    '\n\n'...
    '?'];%,

cell_possile_answ = {'s', 'd'};
str_exp = {'sternberg', 'DMS'};

%% Let the subject choose -recursively- the experiment
you_dont_give_an_appropriate_answer = true;
while you_dont_give_an_appropriate_answer
    
    WHICH_exp = input(prompt_exp,'s');
    lgcl_cell = ismember(cell_possile_answ, lower(WHICH_exp));
    
    % 
    if any(lgcl_cell)
        
        str_call = str_exp{lgcl_cell};
        
        % Get parameters
        P = do_PARAMS(SUBJ_name, str_call);
        
        % Start experiment
        P = WM_exp(P);
        
        sca; close all; clc;
        
        % Plot results
        do_PLOT(P)
        
    elseif strcmpi(WHICH_exp, 'q')
        
        fprintf('\nThanks for participating!\n')
        return
        
    end
      

    
end




        
    
    
