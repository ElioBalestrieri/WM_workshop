function P = WM_exp(P)
% runs demo WM experiments
%
% created by Elio Balestrieri for didactic purpose at WWU
% started on 18-Mar-2019

% start PTB
P = local_start_PTB(P);

% welcome screen
Screen('FillRect', P.ptb.win, P.colors.BCK)
Screen('TextSize', P.ptb.win, P.textsize);
DrawFormattedText(P.ptb.win, 'Welcome!\n\nPress any button to sart',...
        'center', 'center', P.colors.TXT);
Screen('Flip', P.ptb.win);
    
KbStrokeWait;

% main experimental loop
while P.this_trl <= P.tot_trl
    
    switch P.expidentifier
        
        case 'DMS'
            
            P = local_do_trial_DMS(P);
            
    end
    
    P.this_trl = P.this_trl +1;

end

% save output from experiment
save(P.outsave, 'P')

end


%% ####################### LOCAL FUNCTIONS ###############################

% general
function P = local_start_PTB(P)

debugRect = [0 0 1920 540];

PsychDefaultSetup(1)
P.ptb.screens = Screen('Screens');
P.ptb.onScreen = max(P.ptb.screens);
[P.ptb.win, P.ptb.winRect] = PsychImaging('OpenWindow', ...
                P.ptb.onScreen, P.colors.BCK);
            
[P.ptb.PixSize.X, P.ptb.PixSize.Y] = Screen('WindowSize', P.ptb.onScreen);
[P.ptb.cntr.X, P.ptb.cntr.Y] = RectCenter(P.ptb.winRect);

% hide cursor
HideCursor(P.ptb.win)

% get keycodes
KbName('UnifyKeyNames');
P.keys.y = KbName('y');
P.keys.m = KbName('m');
P.keys.ESC = KbName('ESCAPE');

end

% DMS
function P = local_do_trial_DMS(P)

P.ptb.cntr.X, P.ptb.cntr.Y
xy_cntr_squares = squeeze(P.exp.square_pos(P.this_trl, :, :))';
this_squaPos = round([xy_cntr_squares(1,:)+P.ptb.cntr.X-P.square_edge/2;...
                      xy_cntr_squares(2,:)+P.ptb.cntr.Y-P.square_edge/2;...
                      xy_cntr_squares(1,:)+P.ptb.cntr.X+P.square_edge/2;...
                      xy_cntr_squares(2,:)+P.ptb.cntr.Y+P.square_edge/2]);

this_squaPos = this_squaPos(:,1:P.exp.pre_conds(P.this_trl,1));
this_squaCol = squeeze(P.exp.square_cols(P.this_trl, ...
    1:P.exp.pre_conds(P.this_trl,1), :))';

if P.exp.pre_conds(P.this_trl, 2)==2
    this_testCol = this_squaCol;
else
    this_testCol = this_squaCol;
    this_testCol(:, end) = squeeze(P.exp.square_cols(P.this_trl,...
        P.exp.pre_conds(P.this_trl,1)+1, :))';

end

% show fixation
Screen('FillRect', P.ptb.win, P.colors.BCK)
Screen('TextSize', P.ptb.win, P.textsize)
DrawFormattedText(P.ptb.win, '+','center', 'center', P.colors.FIX);
Screen('Flip', P.ptb.win);
WaitSecs(P.exp.FIX);

% show stimuli
Screen('FillRect', P.ptb.win, P.colors.BCK)
Screen('TextSize', P.ptb.win, P.textsize)
DrawFormattedText(P.ptb.win, '+','center', 'center', P.colors.FIX);
Screen('FillRect', P.ptb.win, this_squaCol, this_squaPos);
Screen('Flip', P.ptb.win);
WaitSecs(P.exp.square_onscreen);

% show blank window ISI
Screen('FillRect', P.ptb.win, P.colors.BCK)
Screen('TextSize', P.ptb.win, P.textsize)
DrawFormattedText(P.ptb.win, '+','center', 'center', P.colors.FIX);
Screen('Flip', P.ptb.win);
WaitSecs(P.exp.ISI);

% show test array
no_response = true;
base = GetSecs;
while no_response

    Screen('FillRect', P.ptb.win, P.colors.BCK);
    Screen('TextSize', P.ptb.win, P.textsize);
    DrawFormattedText(P.ptb.win, '?','center', 'center', P.colors.FIX);
    Screen('FillRect', P.ptb.win, this_testCol, this_squaPos);
    Screen('Flip', P.ptb.win);

    [keyDown, kt, kc] = KbCheck;

    if find(kc) == P.keys.y 

        P.data(P.this_trl, 3) = 1;
        P.data(P.this_trl, 5) = kt-base;
        P.data(P.this_trl,4) = P.data(P.this_trl,2)==P.data(P.this_trl, 3);

    elseif find(kc) == P.keys.m

        P.data(P.this_trl, 3) = 2;
        P.data(P.this_trl, 5) = kt-base;
        P.data(P.this_trl,4) = P.data(P.this_trl,2)==P.data(P.this_trl, 3);

    elseif find(kc) == P.keys.ESC
        % aborting experiment
        P.this_trl = P.tot_trl;
    
    else

        keyDown = 0;

    end

    if keyDown
        no_response = false;
    end

end
end

