% public and private key generation
nbits_p = 3;           % number of bits for p
nbits_q = 4;            % number of bits for q
p = 2^nbits_p+1;        % private
q = 2^nbits_q+1;        % private
ntest_p = 1;
ntest_q = 1;
while ~isprime(p)
    ntest_p = ntest_p+1;
    p = p+2;
end
while ~isprime(q)
    ntest_q = ntest_q+1;
    q = q+2;
end
n = p*q;                  % public
tn = (p-1)*(q-1);  % Totient of n;
gcd_e_tn =2;
ntest_e = 1;
while gcd_e_tn~=1
    ntest_e = ntest_e+1;
    e = randi(tn-1);                    % public key; common choice are 3, 7 and 65537
    [~,d,gcd_e_tn]=extended_Euclidean_mod(tn,e,tn);
end

% Attack 1: factoring publical value n
% security constraines are
% 1) n should be 1024-bit or 2048-bits long
% 2) p and q should be differ in length by only a few digits 
% 3) both (p-1) and (q-1) should contain large prime factoring
% 4) gcd(p-1,q-2) should be small
% 5) if e<n and d<n^(1/4); d is easy to determinate
guess_p = 3;
while mod(n,guess_p)~=0;
    guess_p = guess_p+2;
    while ~isprime(guess_p)
        guess_p=guess_p+2;
    end
end
guess_q = n/guess_p;

% Attack 2: timing attack by obsevering the decrtiption time
% contermeasures include 1) constante exponential time; 2) random delay and
% 3) blinding as follows
M = randi(n-1);     % plain message;
C = mod_exp(M,e,n); % cipher text c = m^e mod n;
M_decrypt = mod_exp(C,d,n); % without blinding, decrypted message m'=c^d mod n = m^(ed) mod n = m; 
% blinding method
gcd_r_n=2;
while gcd_r_n~=1
    r = randi(n-1);
    [~,r_inv,gcd_r_n]=extended_Euclidean_mod(n,r,n);
end
C_blind = mod(mod(C,n)*mod_exp(r,e,n),n);
M_blind = mod_exp(C_blind,d,n);
M_decrypt_b = mod(M_blind*r_inv,n);

% Attack 3 Chosen ciphertext attack

% A fast decryption algorithm using chinese reminder theorem (CRT)

