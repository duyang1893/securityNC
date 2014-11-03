% proposed "random-swap-spread HMAC" scheme 

p = 256;         % GF size
n = 10;          % packet length in GF symbols
m = 3;           % number of packets per generation
X = gf(randi(p-1,m,n),log(p)/log(2)); % one generation of data, size(m,n)
U = [eye(m,m) X];                         % eye(m,m) RLNC coefficients

L = 7;           % number of tags
key = gf(floor(rand((m+n+L),L)*p),log(p)/log(2));
b = randsample(1:(m+n),L);

H = key(b,:);  %% H needs to be full rank, checking omitted. 
G = inv(H);

% Homomorphic subspace MAC using semmytric key
U_pad = [U zeros(m,L)];                          % each paket pad one symbol
U_swap = U_pad;
U_swap(:,m+n+1:end)=U_pad(:,b);
U_swap(:,b)=0;

pad = (0-U_swap*key)*G;
U_bar=U_swap;
U_bar(:,b)=pad;

alpha = gf(floor(rand(1,m)*p),log(p)/log(2));
x_coded = alpha*U_bar;
x_coded*key

Kn=key(:,2);
if x_coded*Kn==0
    sprintf('verify=true')
else
    sprintf('verify=flase')
end
