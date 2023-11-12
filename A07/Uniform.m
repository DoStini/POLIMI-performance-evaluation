function [uniform] = Uniform(a, b)
    uniform = rand() * (b - a) + a;
end
