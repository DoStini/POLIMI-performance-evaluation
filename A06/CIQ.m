clear all;

K0 = 1000;
maxK = 20000;
M = 500;
DK = 100;
MaxRelErr = 0.05;

gam = 0.95;

arrivalRnd = @() -log(rand()) * 10;
serviceRnd = @() -log(rand()) * 8;






d_gamma = norminv((1+gam)/2);

K = K0;

tA = 0;
tC = 0;

U = 0;
U2 = 0;
R = 0;
R2 = 0;

newIters = K;

while K < maxK
	for i = 1:newIters
		Bi = 0;
		Wi = 0;
		tA0 = tA;
	
		for j = 1:M
			a_ji = arrivalRnd();
			s_ji = serviceRnd();
			
			tC = max(tA, tC) + s_ji;
			ri = tC - tA;
			Rd((i-1)*M+j,1) = ri;
	
			tA = tA + a_ji;
			
			Bi = Bi + s_ji;
			
			Wi = Wi + ri;
		end
		
		Ri = Wi / M;
		R = R + Ri;
		R2 = R2 + Ri^2;
		
		Ti = tC - tA0;
		Ui = Bi / Ti;
		U = U + Ui;
		U2 = U2 + Ui^2;
	end
	
	Rm = R / K;
	Rs = sqrt((R2 - R^2/K)/(K-1));
	CiR = [Rm - d_gamma * Rs / sqrt(K), Rm + d_gamma * Rs / sqrt(K)];
	errR = 2 * d_gamma * Rs / sqrt(K) / Rm;
	
	Um = U / K;
	Us = sqrt((U2 - U^2/K)/(K-1));
	CiU = [Um - d_gamma * Us / sqrt(K), Um + d_gamma * Us / sqrt(K)];
	errU = 2 * d_gamma * Us / sqrt(K) / Um;
	
	if errR < MaxRelErr && errU < MaxRelErr
		break;
	else
		K = K + DK;
		newIters = DK;
	end
end

if errR < MaxRelErr && errU < MaxRelErr
	fprintf(1, "Maximum Relative Error reached in %d Iterations\n", K);
else
	fprintf(1, "Maximum Relative Error NOT REACHED in %d Iterations\n", K);
end	

fprintf(1, "Utilization in [%g, %g], with %g confidence. Relative Error: %g\n", CiU(1,1), CiU(1,2), gam, errU);
fprintf(1, "Resp. Time in [%g, %g], with %g confidence. Relative Error: %g\n", CiR(1,1), CiR(1,2), gam, errR);

