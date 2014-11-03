% Z. Yu, Y. Wei, B. Ramkumar, and Y. Guan,...
% “An Efficient Signature-Based Scheme for Securing Network Coding Against Pollution Attacks,”
% in 2008 IEEE INFOCOM - The 27th Conference on Computer Communications, 2008, pp. 1409–1417.
% The first method using homomorphic hash but without RSA

q = 7;         % modular field size
p = 43;        % modular filed size; p-1 = k*q;
element_order = zeros(1,p-1);
for i=1:p-1
    tmp = mod_exp(i,1:(p-1),p);
    index = find(tmp==1);
    element_order(i) = index(1);    
end
g_potential = find(element_order==q);


S = zeros(1,p-1);
for i=1:p-1
    S(i) = mod_exp(i,(p-1)/q,p);
end

n = 3;          % packet length in symbols
m = 2;           % number of packets per generation
X = randi(q-1,m,n); % one generation of data, size(m,n)
X = [eye(m,m) X];                         % eye(m,m) RLNC coefficients

g = g_potential(1:(m+n));
X_hashed = zeros(m,1);          % each paket pad one symbol
for i=1:m
    X_hashed(i) = mod_exp(g(1),X(i,1),p);
    for j=2:(m+n)
        X_hashed(i) = X_hashed(i)*mod_exp(g(j),X(i,j),p);
        X_hashed(i) = mod(X_hashed(i),p);
    end
end
alpha = randi(q-1,1,m);
x_coded = mod(alpha*X,q);

x_coded_hashed = 1;
for l=1:length(alpha)
    x_coded_hashed = x_coded_hashed*mod_exp(X_hashed(l),alpha(l),p);
    x_coded_hashed = mod(x_coded_hashed,p);
end

v_hashed = mod_exp(g(1),x_coded(1),p);
for j=2:(m+n)
    v_hashed = v_hashed*mod_exp(g(j),x_coded(j),p);
    v_hashed = mod(v_hashed,p);
end

if x_coded_hashed == v_hashed 
    sprintf('verify=true')
else
    sprintf('verify=flase')
end
 v_hashed
 x_coded_hashed







