M = 1000;
K = 1;

arrivals = @(n) -log(rand(n, 1)) / 0.1;
services = @(n) rand(n,1) * 5 + 5;


while true
    U = zeros(K,1);
    Tr = zeros(K,1);
    R = zeros(K,1);
    Rvar = zeros(K, 1);
    NumJobs = zeros(K,1);
        
    for iter = 1:K
        tA = 0;
        tC = 0;
        Bi = 0;
    	Wi = 0;
        tA0 = tA;

        Ris = zeros(M, 1);

        for j = 1:M
	        a_ji = arrivals(1);
	        s_ji = services(1);

	        tC = max(tA, tC) + s_ji;
            ri = tC - tA;

	        tA = tA + a_ji;

	        Bi = Bi + s_ji;
			Wi = Wi + ri;

            Ris(j) = ri;
        end

        Ti = tC - tA0;
        Ui = Bi / Ti;
    
        U(iter) = Ui;

	    Ri = Wi / M;
	    R(iter) = Ri;

        Rvar(iter) = sum((Ris - Ri) .^ 2) / M;

        Through = M / Ti;
        Tr(iter) = Through;

        NumJobs(iter) = Wi / Ti;
    end

	Rm = sum(R) / K;
    Rs = 1 / (K - 1) * sum((R - Rm) .^ 2);

    Ry = 1.96 * sqrt(Rs / K);
    R_mean = [Rm - Ry, Rm + Ry];
    R_err = 2 * (R_mean(2) - R_mean(1)) / (R_mean(1) + R_mean(2));


    Rvarm = sum(Rvar) / K;
    Rvars = 1 / (K - 1) * sum((Rvar - Rvarm) .^ 2);

    Rvary = 1.96 * sqrt(Rvars / K);
    Rvarmean = [Rvarm - Rvary, Rvarm + Rvary];
    Rvar_err = 2 * (Rvarmean(2) - Rvarmean(1)) / (Rvarmean(1) + Rvarmean(2));

    

	NJm = sum(NumJobs) / K;
    NJs = 1 / (K - 1) * sum((NumJobs - NJm) .^ 2);

    NJy = 1.96 * sqrt(NJs / K);
    NJ_mean = [NJm - NJy, NJm + NJy];
    NJ_err = 2 * (NJ_mean(2) - NJ_mean(1)) / (NJ_mean(1) + NJ_mean(2));


	Trm = sum(Tr) / K;
    Trs = 1 / (K - 1) * sum((Tr - Trm) .^ 2);

    Try = 1.96 * sqrt(Trs / K);
    Tr_mean = [Trm - Try, Trm + Try];
    Tr_err = 2 * (Tr_mean(2) - Tr_mean(1)) / (Tr_mean(1) + Tr_mean(2));


    Um = sum(U) / K;
    Us = 1 / (K - 1) * sum((U - Um) .^ 2);

    Uy = 1.96 * sqrt(Us / K);
    U_mean = [Um - Uy, Um + Uy];

    U_err = 2 * (U_mean(2) - U_mean(1)) / (U_mean(1) + U_mean(2));

    if U_err < 0.04 && R_err < 0.04 && Tr_err < 0.04 && NJ_err < 0.04 && Rvar_err < 0.04
        break
    end
    K = K + 1;
end


fprintf("Stopped at %d iterations\n", K);
fprintf("Utilization: [%f %f] with %f error\n", U_mean(1), U_mean(2), U_err);
fprintf("Response time: [%f %f],with %f error\n", R_mean(1), R_mean(2), R_err);
fprintf("Response time variance: [%f %f],with %f error\n", Rvarmean(1), Rvarmean(2), Rvar_err);
fprintf("Throughput: [%f %f] with %f error\n", Tr_mean(1), Tr_mean(2), Tr_err);
fprintf("Average number of jobs: [%f %f] with %f error\n", NJ_mean(1), NJ_mean(2), NJ_err);

