global t0 N match_durations win_rate wins;

t = 0;
t0 = 0;
N = 0;
state = @Entrance;
match_durations = [];
win_rate = [];
wins = 0;

actual_prob = 1 - 0.14 - 0.21 - 0.56 * (0.2+0.375 + (0.3 + 0.125) * 0.4) - 0.09 * 0.4;

fprintf("Actual win prob %f\n", actual_prob);

while N < 2000
    [t, state] = state(t);

end

plot(win_rate);

fprintf("The average match time is %f minutes\n", mean(match_durations));
fprintf("The win probability is %f \n", win_rate(end));
fprintf("The troughput of the game is %f games per hour \n", N / t * 60);


function [new_time, new_state] = Entrance(t)
    global t0;
    t0 = t;
    probs = cumsum([0.56, 0.14, 0.21, 0.09]);

    p = rand();

    if p < probs(1)
        dt = Erlang(4,1.5);
        new_state = @C1;
    elseif p < probs(2)
        dt = Exponential(0.5);
        new_state = @Fall;
    elseif p < probs(3)
        dt = Exponential(0.25);
        new_state = @Fall;
    else
        dt = Uniform(3,6);
        new_state = @C2;
    end

    new_time = t + dt;
end


function [new_time, new_state] = C1(t)
    probs = cumsum([0.375, 0.2, 0.125, 0.3]);

    p = rand();
    if p < probs(1)
        dt = Exponential(0.4);
        new_state = @Fall;
    elseif p < probs(2)
        dt = Exponential(0.2);
        new_state = @Fall;
    elseif p < probs(3)
        dt = Erlang(3,2);
        new_state = @C2;
    else
        dt = Exponential(0.15);
        new_state = @C2;
    end

    new_time = t + dt;
end


function [new_time, new_state] = C2(t)
    new_time = t + Erlang(5, 0.4);
    probs = cumsum([0.4, 0.6]);

    p = rand();

    if p < probs(1)
        new_state = @Fall;
    else
        new_state = @Exit;
    end
end

function [new_time, new_state] = Fall(t)
    global N match_durations wins win_rate t0
    N = N + 1;
    match_durations = [match_durations, t - t0];
    win_rate = [win_rate, wins / N];

    new_time = t + 5;
    new_state = @Entrance;
end


function [new_time, new_state] = Exit(t)
    global N match_durations wins win_rate t0
    N = N + 1;
    match_durations = [match_durations, t - t0];
    wins = wins + 1;
    win_rate = [win_rate, wins / N];

    new_time = t + 5;
    new_state = @Entrance;
end

