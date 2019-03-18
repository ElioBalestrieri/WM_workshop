function P = do_PLOT(P)
% bin memory accuracy performance on memory load

dat = P.data;

load_cond = unique(dat(:,1))';

figure
acc = 0; perf_vect = nan(numel(load_cond),1);
for iCond = load_cond
    
    acc = acc+1;
    this_lgcl = dat(:,1) == iCond;
    perf_this = nanmean(dat(this_lgcl, 4));
    perf_vect(acc) = perf_this;

end
    
bar(load_cond, perf_vect)
title([P.expidentifier ' performance'])

end

