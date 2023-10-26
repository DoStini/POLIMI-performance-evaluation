M = 1000;
K = 1;

arrivals = @(n) -log(rand(n, 1)) / 0.1;
services = @(n) Erlang(n);

U = zeros(K,1);

while true

    for iter = 1:K
        tA = 0;
        tC = 0;
        Bi = 0;
        tA0 = tA;
        for j = 1:M
	        a_ji = arrivals(1);
	        s_ji = services(1);
        
	        tC = max(tA, tC) + s_ji;
        
	        tA = tA + a_ji;
	        
	        Bi = Bi + s_ji;
        end
        
        Ti = tC - tA0;
        Ui = Bi / Ti;
    
        U(iter) = Ui;
    end


    Um = sum(U) / K;
    Us = 1 / (K - 1) * sum((U - Um) .^ 2);

    Uy = 1.96 * sqrt(Us / K);
    U_mean = [Um - Uy, Um + Uy];

    err = 2 * (U_mean(2) - U_mean(1)) / (U_mean(1) + U_mean(2));

    if err < 0.04
        break
    end
    K = K + 1;
end


