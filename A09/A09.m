Q = [
    -0.50277008 1/2 0 1/722 0 1/722 ;
    1/18 -0.05826558 1/738 0 1/738 0;
    0 1/722 -0.50414747 1/2 0 1/362;
    1/728 0 1/8 -0.12909101 1/368 0;
    0 1/722 0 1/362 -0.50414747 1/2;
    1/723 0 1/363 0 1/3 -0.33747128;
];

a1 = [12 0.1 12 0.1 12 0.1];
a2 = [1 0 1 0 1 0];
epsilon = [
    0 1 0 1 0 1;
    0 0 0 0 0 0;
    0 1 0 1 0 1;
    0 0 0 0 0 0 ;
    0 1 0 1 0 1;
    0 0 0 0 0 0;
];


p0 = [1 0 0 0 0 0];
Qp = [ones(6,1), Q(:,2:6)];
pi = p0 / Qp;

[t, sol] = ode45(@(t,x) Q' * x, [0 5000], p0');

plot(t, sol);
legend("Night scan", "Night sleep", "Cloudy Scan", "Cloudy sleep", "Sunny Scan", "Sunny sleep");

steady_probs = pi;

power_consumption = sum(steady_probs .* a1);
utilization = sum(steady_probs .* a2);

throughput = sum(sum(Q .* epsilon) .* steady_probs) * 24 * 60;

fprintf("Power consumption %f\n", power_consumption);
fprintf("Utilization %f\n", utilization);
fprintf("Scans per day %f\n", throughput);

