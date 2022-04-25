addpath("funs");
addpath("data");
addpath("finchpp");

data_index = 1;

[X, y, dataset_name] = load_dataset(data_index);
c = length(unique(y));

A0 = selftuning(X, 5);
A0 = full(A0);
y_init = finchpp(A0, c);

mu = [290, 225, 165, 90.5];

tic;
[la, obj] = expcut(A0, y_init, mu(data_index));
toc
results = ClusteringMeasure_new(y, la);

disp(['Clustering results on ', dataset_name, ' dataset:']);
disp(results);
