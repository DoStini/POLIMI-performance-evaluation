samples = csvread("Trace2.csv");
s = size(samples);
N = s(1);

fprintf("Calculating moments\n");

sample_mean = 1 / N * sum(samples); % first moment
second_moment = 1 / N * sum(samples .^ 2);
third_moment = 1 / N * sum(samples .^ 3);

variance = 1 / N * sum((samples - sample_mean) .^ 2); % second central moment 

cv = sqrt(variance) / sample_mean;


fprintf("Sample mean: %f\n", sample_mean);
fprintf("Second moment: %f\n", second_moment);
fprintf("Third moment: %f\n", third_moment);

syms a b real;

eqn1 = sample_mean == (a + b) / 2;
eqn2 = variance == (b - a) ^ 2 / 12;

sol = solve([eqn1, eqn2], [a,b]);

sol_a = sol.a(2);
sol_b = sol.a(1);

syms uniform_dist(x);

uniform_dist(x) = piecewise(x <= sol_a, 0, x <= sol_b, (x-sol_a)/(sol_b-sol_a), 1);

fprintf("\nUniform dist properties:\n");
fprintf("a: %f\n", sol_a);
fprintf("b: %f\n", sol_b);

% EXPONENTIAL

lambda = 1 / sample_mean;


syms exponential_dist(x);

exponential_dist(x) = 1 - exp(-lambda * x);


fprintf("\nExponential dist properties:\n");
fprintf("lambda: %f\n", lambda);

% ERLANG

erl_k = 1 / (cv * cv);
erl_lambda = erl_k / sample_mean;

syms erlang(x);

erlang(x) = 1;

for n = 0:round(erl_k) - 1
    erlang(x) = erlang(x) - 1 / factorial(n) * exp(-erl_lambda * x) * (erl_lambda * x) ^ n;
end

fprintf("\nErlang dist properties:\n");
fprintf("k: %f\n", erl_k);
fprintf("lambda: %f\n", erl_lambda);

% Weibull

syms w_lambda w_k;

eqn1 = sample_mean == w_lambda * gamma(1 + 1/w_k);
eqn2 = variance == w_lambda ^ 2 * (gamma(1 + 2/w_k) - gamma(1 + 1/w_k) ^ 2);

sol = solve([eqn1, eqn2], [w_lambda, w_k]);

weibull_lambda = sol.w_lambda;
weibull_k = sol.w_k;

syms weibull_distribution(x) x;

weibull_distribution(x) = 1 - exp(-(x / weibull_lambda)^weibull_k);

fprintf("\nWeighbul dist properties:\n");
fprintf("k: %f\n", weibull_k);
fprintf("lambda: %f\n", weibull_lambda);

% PARETO

syms p_alpha p_m;

eqn1 = sample_mean == p_alpha * p_m / (p_alpha - 1);
eqn2 = variance == p_alpha * p_m ^ 2 / ((p_alpha - 1)^2 * (p_alpha - 2));

sol = solve([eqn1, eqn2], [p_alpha, p_m]);

pareto_alpha = double(sol.p_alpha(1));
pareto_m = double(sol.p_m(1));

syms pareto_distribution(x);

pareto_distribution(x) = piecewise(x < pareto_m, 0, 1 - (pareto_m / x) ^ pareto_alpha);


fprintf("\nPareto dist properties:\n");
fprintf("alpha: %f\n", pareto_alpha);
fprintf("m: %f\n", pareto_m);

% HYPER


hyper_params = mle(samples, 'pdf', @(samples, l1, l2, p1)HyperExp_pdf(samples, [l1, l2, p1]), 'Start', [0.8 / sample_mean, 1.2 / sample_mean, 0.4]);

syms hyper_distribution(x); 

p1 = hyper_params(3);
H_l1 = hyper_params(1);
H_l2 = hyper_params(2);

hyper_distribution(x) = 1 - p1 * exp(-H_l1 * x) - (1- p1) * exp(-H_l2 * x);


fprintf("\nHyper dist properties:\n");
fprintf("P1: %f\n", p1);
fprintf("lambda 1: %f\n", H_l1);
fprintf("lambda 2: %f\n", H_l2);

% HYPO

hypo_params = mle(samples, 'pdf', @(samples, l1, l2)HypoExp_pdf(samples, [l1, l2]), 'Start', [1 / (sample_mean * 0.3), 1 / (sample_mean * 0.7)]);
h_l1 = hypo_params(1);
h_l2 = hypo_params(2);

syms hypo_distribution(x);

hypo_distribution(x) = 1 - h_l2 * exp(-h_l1 * x) / (h_l2 - h_l1) + h_l1 * exp(-h_l2 * x) / (h_l2 - h_l1);



fprintf("\nHypo dist properties:\n");
fprintf("lambda 1: %f\n", h_l1);
fprintf("lambda 2: %f\n", h_l2);


% FINAL COMPARISION

parts = (1:N).' / N;
cdf = sort(samples);

figure(3);
hold on;

fplot(hyper_distribution, [0 100], 'Color', '#873e23');
fplot(hypo_distribution, [0 100], 'Color', '#41403e');
fplot(exponential_dist, [0 100], 'b');
fplot(pareto_distribution, [0 100], 'm');
fplot(erlang, [0, 100], 'y'); % Plot the Erlang CDF
fplot(weibull_distribution, [0 100], 'g');
plot(cdf, parts, 'r--'); % Plot the sample CDF
xlabel('x');
ylabel('CDF');
title('Plotted distributions and Sample CDF');
legend('Hyperexponential CDF', 'Hypoexponential CDF', 'Exponential CDF', 'Pareto CDF', 'Erlang CDF', 'Weighbul Distribution', 'Sample CDF');
grid on;
hold off;
