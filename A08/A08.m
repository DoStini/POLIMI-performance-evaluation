Q = [
    -6 3.6 1.8 0.6;
    0.05 -0.38 0.33 0;
    0.05 0.6 -1.05 0.4;
    0.05 0 1 -1.05;
];


p0 = [0 0 1 0];


[t, sol] = ode45(@(t,x) Q' * x, [0 8], p0');

plot(t, sol)
legend("Down", "Low", "Medium", "High");



p0 = [1 0 0 0];


figure(2);
[t, sol] = ode45(@(t,x) Q' * x, [0 8], p0');
plot(t, sol);

legend("Down", "Low", "Medium", "High");

