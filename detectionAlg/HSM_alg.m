%P. Zhang, Y. Jiang, and C. Lin, “Padding for orthogonality: efficient subspace authentication for network coding,” in INFOCOM, 2011, pp. 1026–1034.

p = 8;         % GF size
n = 3;          % packet length in GF symbols
m = 2;           % number of packets per generation
X = gf(randi(p-1,m,n),log(p)/log(2)); % one generation of data, size(m,n)
X = [eye(m,m) X];                         % eye(m,m) RLNC coefficients

%% Homomorphic subspace MAC using semmytric key
k = gf(floor(rand(1,(m+n+1))*p),log(p)/log(2));  % key
X_pad = [X zeros(m,1)];                          % each paket pad one symbol
for i=1:m
    pad = (0-X(i,:)*k(1:end-1)')/k(end);
    X_pad (i,end)=pad;
end
alpha = gf(floor(rand(1,m)*p),log(p)/log(2));
x_coded = alpha*X_pad;
if x_coded*k'==0
    sprintf('verify=true')
else
    sprintf('verify=flase')
end

 




