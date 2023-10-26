clear all;

K0 = 1;
maxK = 20000;
M = 500;
DK = 1;
MaxRelErr = 0.04;

gam = 0.95;

arrivalRnd = @() -log(rand(1, 1)) / 0.1;
serviceRnd = @() Erlang(1);


arrivals = @(n) -log(rand(n, 1)) / 0.1;
services = @(n) Erlang(n);





d_gamma = norminv((1+gam)/2);

K = K0;

tA = 0;
tC = 0;

U = 0;
U2 = 0;
R = 0;
R2 = 0;

newIters = K;
CiU = 1;
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
	
	Um = U / K;
	Us = sqrt((U2 - U^2/K)/(K-1));
	CiU = [Um - d_gamma * Us / sqrt(K), Um + d_gamma * Us / sqrt(K)];
	errU = 2 * d_gamma * Us / sqrt(K) / Um;
	
	if errU < MaxRelErr
		break;
    end
	K = K + DK;
	newIters = DK;
end



