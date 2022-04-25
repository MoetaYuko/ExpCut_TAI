function [Y, obj] = expcut(A, Y, lambda, n_iter, early_stop)
% expcut  Balanced Graph Cut with Exponential Inter-Cluster Compactness
%   [Y, obj] = expcut(A, Y, lambda, n_iter, early_stop)
%   A: n*n affinity matrix.
%   Y: n*c initial label indicator matrix.
%
%   D. Wu, F. Nie, J. Lu, R. Wang and X. Li, "Balanced Graph Cut with
%   Exponential Inter-Cluster Compactness," in IEEE Transactions on Artificial
%   Intelligence, doi: 10.1109/TAI.2021.3123126.
%
%   Please contact Danyang Wu <danyangwu41x@mail.nwpu.edu.cn> if you have any
%   questions.
%
%   SPDX-FileCopyrightText: 2020-2022 Jitao Lu <dianlujitao@gmail.com>
%   SPDX-License-Identifier: MIT
    arguments
        A
        Y
        lambda = 1
        n_iter = 50
        early_stop = true
    end
    n = size(Y, 1);
    Y = full(Y);

    A = A - diag(diag(A));
    A = (A + A') / 2;
    D = diag(sum(A));
    L = D - A;

    % y_l^T \times L \times y_l
    links = diag(Y' * L * Y);

    pow_all = exp(lambda / n * sum(Y))';

    m_vec = vec2ind(Y');

    exp_lambda = exp(lambda / n);

    for iter = 1:n_iter
        obj(iter) = sum(links ./ pow_all);
        if early_stop && iter > 2 && abs((obj(iter) - obj(iter - 1)) / obj(iter - 1)) < 1e-10
            break;
        end

        for i = 1:n
            m = m_vec(i);

            Y_L = Y' * L(:, i);

            links_new = links + 2 * Y_L + L(i, i);
            links_new(m) = links(m);

            pow_new = pow_all * exp_lambda;
            pow_new(m) = pow_all(m);

            links_0 = links;
            links_0(m) = links(m) - 2 * Y_L(m) + L(i, i);

            pow_0 = pow_all;
            pow_0(m) = pow_all(m) / exp_lambda;

            delta = links_new ./ pow_new - links_0 ./ pow_0;

            [~, p] = min(delta);
            if p ~= m
                links(m) = links_0(m);
                pow_all(m) = pow_0(m);
                links(p) = links_new(p);
                pow_all(p) = pow_new(p);

                Y(i, p) = 1;
                Y(i, m) = 0;
                m_vec(i) = p;
            end
        end
    end

    Y = vec2ind(Y')';
end
