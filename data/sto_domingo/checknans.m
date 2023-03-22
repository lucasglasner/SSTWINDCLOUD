function mvar = checknans(var,mask,eps)
    nT = sum(mask);
    n = sum(~(isnan(var(mask))));
    if(n > nT*eps)
        mvar = nanmean(var(mask));
    else
        mvar = nan;
    end
    
end