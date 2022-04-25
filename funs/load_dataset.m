function [X, y, name] = load_dataset(dataset_id)
    switch dataset_id
        case 1
            data = load('Mpeg7_uni');
            X = data.X;
            y = data.Y;
            name = 'MPEG-7';
        case 2
            data = load('nus-wide');
            X = data.X;
            y = data.Y;
            name = 'NUS-WIDE';
        case 3
            data = load('reutersidf10k_bal');
            X = data.X;
            y = data.Y;
            name = 'REUTERS-10k';
        case 4
            [X, y] = load_hdf5('USPS.h5');
            name = 'USPS';
        otherwise
            error('Unknown dataset')
    end
    [y, idx] = sort(y);
    X = X(idx, :);
end

function [X, y] = load_hdf5(name)
    X = h5read(name, '/data');
    n = size(X, 4);

    X = reshape(X, [], n)';
    X = im2double(X);
    X = rescale(X);

    y = h5read(name, '/labels');
    y = double(y);
end
