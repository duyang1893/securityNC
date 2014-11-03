%% R. Canetti, J. Garay, G. Itkis, D. Micciancio, M. Naor, and B. Pinkas, “Multicast security: a taxonomy and some efficient constructions,” in IEEE INFOCOM ’99. Conference on Computer Communications. Proceedings., 1999, pp. 708–716 vol.2.

% %% Basic scheme Table I
% % Theoritical relationship (w,q,q_pi) -> (N_verify_key,N_source_key,C)
% w = 10;
% q = 10^(-3);
% q_pi = 10^(-3);
% N_verify_key = ceil(exp(1)*log(1/q));
% N_source_key = N_verify_key*(w+1);
% C = N_source_key*ceil(log2(1/q_pi));
% 
% % construction using random sampling, N_verify_key is different for each users
% sample = 10000;
% number_of_diff_keys = zeros(1,sample);
% for i=1:sample
%     key_u = find(rand(1,N_source_key)<=1/(w+1));  %Warning: maybe empty keys
%     key_w_all = find(rand(1,N_source_key)<=1/(w+1));
%     for j=2:w
%         key_w = find(rand(1,N_source_key)<=1/(w+1));
%         for k=1:length(key_w)
%             if sum(key_w(k)==key_w_all)==0
%                 key_w_all = [key_w_all key_w(k)];
%             end
%         end
%     end
%     for k = 1:length(key_u)
%         if sum(key_u(k)==key_w_all)==0
%             number_of_diff_keys(i)=number_of_diff_keys(i)+1;
%         end
%     end
% end
% prob_q = 1-sum(number_of_diff_keys>0)/sample;
% 
% % Theoretical probability of any two user share at least one key. 
% %prob_shared_key=1-((1-N_verify_key/N_source_key)^(2*N_source_key-N_verify_key+0.5))/((1-2*N_verify_key/N_source_key)^(N_source_key-2*N_verify_key+0.5));
% prob_shared_key=1-(w/(w+1))^N_verify_key;
% 
% % construction using random sampling, N_verify_key is the same for each users
% clear key_w_all;
% number_of_diff_keys_eq = zeros(1,sample);
% number_of_shared_keys = zeros(1,sample);
% eq = (0:(N_verify_key-1))*(w+1);
% for i=1:sample
%     key_u = ceil(rand(1,N_verify_key)*(w+1))+eq;  
%     key_w_all = ceil(rand(1,N_verify_key)*(w+1))+eq;  
%     for j=1:N_verify_key
%         number_of_shared_keys(i) =  number_of_shared_keys(i)+ sum(key_u(j)==key_w_all);
%     end
%     for j=2:w
%         key_w = ceil(rand(1,N_verify_key)*(w+1))+eq;  
%         for k=1:length(key_w)
%             if sum(key_w(k)==key_w_all)==0
%                 key_w_all = [key_w_all key_w(k)];
%             end
%         end
%     end
%     for k = 1:length(key_u)
%         if sum(key_u(k)==key_w_all)==0
%             number_of_diff_keys_eq(i)=number_of_diff_keys_eq(i)+1;
%         end
%     end
% end
% prob_q_eq = 1-sum(number_of_diff_keys_eq>0)/sample;
% prob_shared = sum(number_of_shared_keys>0)/sample;

% %% Low Communication 
% % Theoritical relationship (w,q,q_pi) -> (N_verify_key,N_source_key,C)
% w = 10;
% q = 10^(-3);
% q_pi = 0.5;
% N_verify_key = ceil(exp(1)*log(1/q))*4;
% N_source_key = N_verify_key*(w+1);
% C = N_source_key*ceil(log2(1/q_pi));
% 
% 
% %% Perfect Sec
% % Theoritical relationship (w,n,q_pi) -> (q,N_verify_key,N_source_key,C)
% nn=10:10:1000;
% N_v_key=zeros(1,length(nn));
% N_s_key= zeros(1,length(nn));
% c =zeros(1,length(nn));
% prb_shared = zeros(1,length(nn));
% for j = 1:length(nn)
%     n = nn(j);
%     w = 7;
%     q_pi = 10^(-3);
%     q = n;
%     for i=0:(w-1)
%         q = q*(n-i);
%     end
%     q = 1/(q/factorial(w));
%     N_verify_key = ceil(exp(1)*log(1/q));
%     N_source_key = N_verify_key*(w+1);
%     C = N_source_key*ceil(log2(1/q_pi));
%     prob_shared_key=1-(w/(w+1))^N_verify_key;
%     
%     N_v_key(j)=N_verify_key;
%     N_s_key(j)=N_source_key;
%     c(j) = C;
%     prb_shared(j)=prob_shared_key;
% end
% 
% plot(nn,N_verify_key,'-*')
% plot(nn,N_v_key,'-*')
% hold on
% plot(nn,N_s_key,'r-*')
% hold off
% figure
% plot(nn,prb_shared,'-o')

% % construction using random sampling, N_verify_key is the same for each users
%    n = 10;
%     w = 2;
%     q_pi = 10^(-3);
%     q = n;
%     for i=0:(w-1)
%         q = q*(n-i);
%     end
%     q = 1/(q/factorial(w));
%     N_verify_key = ceil(exp(1)*log(1/q));
%     N_source_key = N_verify_key*(w+1);
%     C = N_source_key*ceil(log2(1/q_pi));
% sample = 10000;
% comb_w_n = combnk(1:n,w);
% eq = (0:(N_verify_key-1))*(w+1);
% flag_diff_key = ones(length(comb_w_n),sample);
% for i=1:sample
%     key =zeros(n,N_verify_key);
%     for nn=1:n
%         key(nn,:)=ceil(rand(1,N_verify_key)*(w+1))+eq;  
%     end
% 
%     for kk=1:length(comb_w_n)
%         key_w_all = key(comb_w_n(kk,1),:);
%         for j=2:w
%             key_w = key(comb_w_n(kk,j),:);
%             for k=1:length(key_w)
%                 if sum(key_w(k)==key_w_all)==0
%                     key_w_all = [key_w_all key_w(k)];
%                 end
%             end
%         end
%         for jj=1:n
%             if sum(jj==comb_w_n(kk,:))==0
%                 key_u=key(jj,:);
%                 number_of_diff_keys_eq=0;
%                 for k = 1:length(key_u)
%                     if sum(key_u(k)==key_w_all)==0
%                         number_of_diff_keys_eq=number_of_diff_keys_eq+1;
%                     end
%                 end
%                 if number_of_diff_keys_eq==0
%                     flag_diff_key(kk,i)=0;
%                     break;
%                 end
%             end
%         end
%     end
% end
% prob_q_eq = sum(reshape(flag_diff_key,1,length(comb_w_n)*sample)==0)/sample/length(comb_w_n);
% 
%% construction of double MAC key distribution  
n = 10;
w = 2;
q_pi = 10^(-3);
q = n;
for i=0:(w-1)
    q = q*(n-i);
end
q = 1/(q/factorial(w));
q_sqrt = sqrt(q);
N_verify_key = ceil(exp(1)*log(1/q_sqrt));
N_source_key = N_verify_key*(w+1);
C = N_source_key*2*ceil(log2(1/q_pi));

sample = 10000;
eq = (0:(N_verify_key-1))*(w+1);
flag_diff_key = ones(1,sample);
for i=1:sample
    key_1 =zeros(n,N_verify_key);
    key_2 = zeros(n,N_verify_key);
    for nn=1:n
        key_1(nn,:)=ceil(rand(1,N_verify_key)*(w+1))+eq;  
        key_2(nn,:)=ceil(rand(1,N_verify_key)*(w+1))+eq;  
    end

    comp_nodes_id = randsample(n,w);
    key_1_w_all = key_1(comp_nodes_id(1),:);
    key_2_w_all = key_2(comp_nodes_id(1),:);
    for j=2:w
        key_w = key_1(comp_nodes_id(j),:);
        for k=1:length(key_w)
            if sum(key_w(k)==key_1_w_all)==0
                key_1_w_all = [key_1_w_all key_w(k)];
            end
        end
        key_w = key_2(comp_nodes_id(j),:);
        for k=1:length(key_w)
            if sum(key_w(k)==key_2_w_all)==0
                key_2_w_all = [key_2_w_all key_w(k)];
            end
        end            
    end
    for jj=1:n
        if sum(jj==comp_nodes_id)==0
            key_1_u=key_1(jj,:);
            number_of_diff_keys_1_eq=0;
            key_2_u=key_2(jj,:);
            number_of_diff_keys_2_eq=0;
            for k = 1:length(key_1_u)
                if sum(key_1_u(k)==key_1_w_all)==0
                    number_of_diff_keys_1_eq=number_of_diff_keys_1_eq+1;
                end
            end
             for k = 1:length(key_2_u)
                if sum(key_2_u(k)==key_2_w_all)==0
                    number_of_diff_keys_2_eq=number_of_diff_keys_2_eq+1;
                end
            end           
            
            if number_of_diff_keys_1_eq==0 && number_of_diff_keys_2_eq==0
                flag_diff_key(i)=0;
                break;
            end
        end
    end
end
prob_q_eq = sum(flag_diff_key==0)/sample;



% %% construction of double MAC key distribution, only for integrity check
% n = 10;
% w = 2;
% q_pi = 10^(-3);
% q = n;
% for i=0:(w-1)
%     q = q*(n-i);
% end
% q = 1/(q/factorial(w));
% q_sqrt = sqrt(q);
% N_verify_key = ceil(exp(1)*log(1/q_sqrt))*5;
% N_source_key = N_verify_key*(w+1);
% C = N_source_key*2*ceil(log2(1/q_pi));
% 
% sample = 10000;
% eq = (0:(N_verify_key-1))*(w+1);
% flag_diff_key = ones(1,sample);
% for i=1:sample
%     key_1 =zeros(n,N_verify_key);
%     key_2 = zeros(n,N_verify_key);
%     for nn=1:n
%         key_1(nn,:)=ceil(rand(1,N_verify_key)*(w+1))+eq;  
%         key_2(nn,:)=ceil(rand(1,N_verify_key)*(w+1))+eq;  
%     end
% 
%     comp_nodes_id = randsample(n,w);
%     key_1_source = ceil(rand(1,N_verify_key)*(w+1))+eq;  
%     key_2_source = ceil(rand(1,N_verify_key)*(w+1))+eq;  
%     
%     intersect_key_size = zeros(2,n);
%     for nn = 1:n
%         key_tmp = intersect(key_1(nn,:),key_1_source);
%         intersect_key_size(1,nn)=length(key_tmp);
%         key_tmp = intersect(key_2(nn,:),key_2_source);
%         intersect_key_size(2,nn)=length(key_tmp);      
%     end
%     
%     key_1_w_all = intersect(key_1(comp_nodes_id(1),:),key_1_source);
%     key_2_w_all = intersect(key_2(comp_nodes_id(1),:),key_2_source);
%     for j=2:w
%         key_w = intersect(key_1(comp_nodes_id(j),:),key_1_source);
%         for k=1:length(key_w)
%             if sum(key_w(k)==key_1_w_all)==0
%                 key_1_w_all = [key_1_w_all key_w(k)];
%             end
%         end
%         key_w = intersect(key_2(comp_nodes_id(j),:),key_2_source);
%         for k=1:length(key_w)
%             if sum(key_w(k)==key_2_w_all)==0
%                 key_2_w_all = [key_2_w_all key_w(k)];
%             end
%         end            
%     end
%     for jj=1:n
%         if sum(jj==comp_nodes_id)==0
%             key_1_u=intersect(key_1(jj,:),key_1_source);
%             number_of_diff_keys_1_eq=0;
%             key_2_u=intersect(key_2(jj,:),key_2_source);
%             number_of_diff_keys_2_eq=0;
%             for k = 1:length(key_1_u)
%                 if sum(key_1_u(k)==key_1_w_all)==0
%                     number_of_diff_keys_1_eq=number_of_diff_keys_1_eq+1;
%                 end
%             end
%              for k = 1:length(key_2_u)
%                 if sum(key_2_u(k)==key_2_w_all)==0
%                     number_of_diff_keys_2_eq=number_of_diff_keys_2_eq+1;
%                 end
%             end           
%             
%             if number_of_diff_keys_1_eq==0 && number_of_diff_keys_2_eq==0
%                 flag_diff_key(i)=0;
%                 break;
%             end
%         end
%     end
% end
% prob_q_eq = sum(flag_diff_key==0)/sample;
