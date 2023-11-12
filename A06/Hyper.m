function hyper_exponential = Hyper()
    stages = 2;
    probs = [0.1, 1];
    H_l1 = 0.02; H_l2 = 0.2;
    lambdas = [H_l1, H_l2];
   

    r = rand();

    for i = 1:stages
        if r < probs(i)
            break
        end
    end

    hyper_exponential = -log(rand()) / lambdas(i);
end

