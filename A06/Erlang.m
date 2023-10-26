function erlang = Erlang(M)
    erlang_l = 1.5; erlang_k = 10;
    erlang = ones(M, 1);
    
    for i = 0:erlang_k - 1
        erlang = erlang .* rand(M, 1);
    end
    
    erlang = - log(erlang) / erlang_l;
end

