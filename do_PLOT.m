function do_PLOT(P)
% bin memory accuracy performance on memory load

dat = P.data;

load_cond = unique(dat(:,1))';

figure
acc = 0; [acc_vect, RT_vect] = deal(nan(numel(load_cond),1));
for iCond = load_cond
    
    acc = acc+1;
    this_lgcl = dat(:,1) == iCond;
    
    acc_vect(acc) = nanmean(dat(this_lgcl, 4));
   
    RT_vect(acc) = nanmean(dat(this_lgcl, 5));

end

subplot(1,2,1)
bar(load_cond, acc_vect)
title([P.expidentifier ' -Accuracy'])
xlabel('Memory load')
ylabel('Accuracy')

subplot(1,2,2)
bar(load_cond, RT_vect)
title([P.expidentifier ' -Reaction Times'])
xlabel('Memory load')
ylabel('RT')

end

