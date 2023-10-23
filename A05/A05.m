seed = 521191478;
a = 1664525;
c = 1013904223;
m = 2 ^ 32;

N = 10000;

samples = zeros(N,1);

samples(1) = seed;

for x = 2:N
    samples(x) = mod(a * samples(x - 1) + c, m);
end

uniform = samples / m;

figure(1);
plot(sort(uniform), [1:N] / N);


% Exponential

exponential = -log(uniform) / 0.1;

t = [0:250] / 10;
figure(2);
plot(sort(exponential), [1:N]/N, t, 1 - exp(-0.1 * t));
xlim([0 25]);


% Pareto

pareto_m = 5; pareto_a = 1.5;

pareto = pareto_m ./ nthroot(uniform, pareto_a);

pareto_t = [50:250] / 10;

figure(3);
plot(sort(pareto), [1:N] / N, pareto_t, 1 - (pareto_m ./ pareto_t) .^ pareto_a);
xlim([0 25]);



% Erlang

N_erlang = 2500;

erlang_k = 4; erlang_l = 0.4;

exponential_gen = -log(uniform(1:N_erlang)) / erlang_l;

erlang = ones(2500, 1);

for i = 0:erlang_k - 1
    erlang = erlang .* uniform(1 + N_erlang * i:N_erlang * (i + 1));
end

erlang = - log(erlang) / erlang_l;


syms erlang_master(x);

erlang_master(x) = 1;

for n = 0:round(erlang_k) - 1
    erlang_master(x) = erlang_master(x) - 1 / factorial(n) * exp(-erlang_l * x) * (erlang_l * x) ^ n;
end

figure(4);

hold on;
plot(sort(erlang), [1:N_erlang] / N_erlang);
fplot(erlang_master, [0, 25], 'y'); % Plot the Erlang CDF
xlim([0 25]);
hold off;



% Hypo exponential

hypo1 = 0.5;
hypo2 = 0.125;

hypo_exponential = -log(uniform(1:5000)) / hypo1 - log(uniform(5001:10000)) / hypo2;


syms hypo_master(x);

hypo_master(x) = 1 - hypo2 * exp(-hypo1* x) / (hypo2 - hypo1) + hypo1 * exp(-hypo2 * x) / (hypo2- hypo1);



figure(5);

hold on;
plot(sort(hypo_exponential), [1:5000] / 5000);
fplot(hypo_master, [0, 25], 'y'); % Plot the Erlang CDF
xlim([0 25]);
hold off;



% Hyper

stages = 2;
probs = [0.55, 1];
H_l1 = 0.5; H_l2 = 0.05; p1 = 0.55;
lambdas = [H_l1, H_l2];

hyper_exponential = zeros(5000, 1);

for j = 1:5000
    r = uniform(j);

    for i = 1:stages
        if r < probs(i)
            break
        end
    end

    hyper_exponential(j) = -log(uniform(5000 + j)) / lambdas(i);
end


syms hyper_master(x);
hyper_master(x) = 1 - p1 * exp(-H_l1 * x) - (1- p1) * exp(-H_l2 * x);


figure(6);

hold on;
plot(sort(hyper_exponential), [1:5000] / 5000);
fplot(hyper_master, [0, 25], 'y'); % Plot the Erlang CDF
xlim([0 25]);
hold off;





% Second part of exercise

% exponential

exp_cheap = exponential(exponential < 10) * 0.01;
exp_exp = exponential(exponential > 10) * 0.02;

exp_total = sum(exp_cheap) + sum(exp_exp);

fprintf("Total exponential: %f\n", exp_total);



% pareto

pareto_cheap = pareto(pareto < 10) * 0.01;
pareto_exp = pareto(pareto > 10) * 0.02;

pareto_total = sum(pareto_cheap) + sum(pareto_exp);

fprintf("Total pareto: %f\n", pareto_total);


% erlang

erlang_cheap = erlang(erlang < 10) * 0.01;
erlang_exp = erlang(erlang > 10) * 0.02;

erlang_total = sum(erlang_cheap) + sum(erlang_exp);

fprintf("Total erlang: %f\n", erlang_total);


% hypo

hypo_cheap = hypo_exponential(hypo_exponential< 10) * 0.01;
hypo_exp = hypo_exponential(hypo_exponential > 10) * 0.02;

hypo_total = sum(hypo_cheap) + sum(hypo_exp);

fprintf("Total hypo: %f\n", hypo_total);



% hyper

hyper_cheap = hyper_exponential(hyper_exponential< 10) * 0.01;
hyper_exp = hyper_exponential(hyper_exponential > 10) * 0.02;

hyper_total = sum(hyper_cheap) + sum(hyper_exp);

fprintf("Total hyper: %f\n", hyper_total);





