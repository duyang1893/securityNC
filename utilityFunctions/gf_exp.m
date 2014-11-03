% Calculate base^exponent mod p, in Galios Field GF(p=2^x)
function result = gf_exp(base,exponent,p)
    result = gf(zeros(1,length(exponent)),log(p)/log(2));
    for j = 1:length(exponent)
        result(j) = base;
        exp = exponent(j);
        for i = 1:(exp.x-1)
            result(j) = result(j) *base;
        end 
    end
end

