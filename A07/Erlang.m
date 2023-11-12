function erlang = Erlang(erlang_k, erlang_l)
    erlang = 1;
    
    for i = 0:erlang_k - 1
        erlang = erlang * rand();
    end
    
    erlang = - log(erlang) / erlang_l;
end
