function prime_flag = test_prime(n,iter)
    %%find k and q, so that n-1=2^k*q; q is an odd number
    k=0;
    q=n-1;
    while mod(q,2)==0
        k = k+1;
        q = q/2;
    end
    
    %%iterative test
    for i = 1:iter
        prime_flag=0;
        a = randi(n-1);
        if mod_exp(a,q,n)==1
            prime_flag =1;
        else
            for j=0:k-1
                if mod_exp(a,2^j*q,n)==n-1
                    prime_flag =1;
                    break;
                end
            end
        end
        if prime_flag==0
            break;
        end            
    end   
end
