% Schnorr_sig example
% Three questions:
% 1) how to efficiently find p and q
% 2) how to efficiently find order-q element a

p = 43;    % prime number; public; usually 1024-bit long
q = 7;     % prime number; public; usually 160-bit long
k = (p-1)/q; % q|(p-1)
% Searching for an integer has order q: a^q mod p = 1
element_order = zeros(1,p-1);
for i=1:p-1
    tmp = mod_exp(i,1:(p-1),p);
    index = find(tmp==1);
    element_order(i) = index(1);    
end
a_potential = find(element_order==q);
% (k*p+a_potential)^q mod p = 1 mod p  
a = a_potential(1);        % {a,p,q} comprise a gobal public knowledge

s = randi(q-1);            % private key s \in (0,q)
v = mod_exp(mod_exp(a,q-1,p),s,p);  % public key; v=a^(-s) mod p; a^(-1) mod p = a^(q-1) mod p

r = randi(q-1);            % random integer r \in (0,q)
x = mod_exp(a,r,p);
e = randi(p+1);%hash([M x]);  %%Question: the range of e?
y = mod((r+e*s),q);       % signature is (e,y)

x_pi=mod(mod_exp(a,y,p)*mod_exp(v,e,p),p);
if x_pi==x  % True verification should be e==hash([M || x_pi]); since x is not transmitted
    sprintf('verification success')
else
    sprintf('verification fail')
end

% represent s*e as se=k*q+delta; then a^(se mod q)*a^(-se) = a^(delta)*a^(-kq-delta); becase a^q mod p =1 then a^(-kq-delta)= a^(-delta);  





