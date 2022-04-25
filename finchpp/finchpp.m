function y_init = finchpp(A0, c)
    % graph FINCH initialization
    [esti_y, esti_num_clust] = FINCH(A0, [], 0);
    idx = find(esti_num_clust == c, 1);
    if ~isempty(idx)
        y_init = esti_y(:, idx);
        y_init = ind2vec(y_init')';
    elseif any(esti_num_clust > c)
        refine_starter = find(esti_num_clust > c, 1, 'last');
        y_init = req_numclust(esti_y(:, refine_starter), A0, c);
        y_init = ind2vec(y_init')';
        disp('FINCH refine');
    else
        disp('FINCH failed to find cluster');
        y_init = [];
    end
end
