clear all;

%% Constant Values
p = 256;         % GF size
n = 10;         % packet length in GF symbols. A small value is chosen to accecerlate the simulation.
m = 4;           % number of packets per generation
L = 7;           % number of tags
numTx = 500;

numNodes=10;
sourceIndex=1;
destIndex=numNodes;
ovp=0.5;      % percentage of overshooting at source node

%% Invetigate Vlues
beta=0.0;     % ovp*beta is the percentage of procuding polluted packets

Topology='singlePath';
%Topology='multiPath';
%LinkType='broadcast';
LinkType='point2point';

attackType='data_pollution';
%attackType='tag_pollution_tail';
num_polluteTags = 1;   % supposed to be less than the numKeyperNode

HMACscheme='RSS-HMAC';
%HMACscheme='joint_padding';
%HMACscheme='orth_padding';

%KeydistAlg='nonRandom';
KeydistAlg='Random';
numKeyperNode=3;

numAdvs=1;
%advNodes = randsample(2:numNodes-1,numAdvs);
advNodes = [2];

FID = fopen('results.txt','a');
fprintf(FID,'*************\n');
if strcmp(Topology,'singlePath')
    fprintf(FID,'Topology=%s\n',Topology);
else 
    fprintf(FID,'Topology=%s\n',Topology);
    fprintf(FID,'LinkType=%s\n',LinkType);
end
if strcmp(attackType,'data_pollution')
    fprintf(FID,'attackType=%s\n',attackType);
else
    fprintf(FID,'attackType=%s\n',attackType);
    fprintf(FID,'num_polluteTags=%d\n',num_polluteTags);
end
fprintf(FID,'HMACscheme=%s\n',HMACscheme);
fprintf(FID,'KeydistAlg=%s\n',KeydistAlg);
fprintf(FID,'numKeyperNode=%d\n',numKeyperNode);
fprintf(FID,'numAdvs=%d\n',numAdvs);
fprintf(FID,'Adversary Node Index: ');
for i=1:numAdvs
    fprintf(FID,' %d',advNodes(i));
end
fprintf(FID,'\n');


%% Generate dependent parameters
% Connected Graph
Cgraph = zeros(numNodes,numNodes);
 if strcmp(Topology,'singlePath')
    for i=1:numNodes-1
        Cgraph(i,i+1)=1;
    end
 end
if strcmp(Topology,'multiPath')
    Cgraph(1,[2 5 8])=1;
    Cgraph(2,3)=1;
    Cgraph(3,4)=1;
    Cgraph(4,10)=1;
    Cgraph(5,6)=1;
    Cgraph(6,7)=1;
    Cgraph(7,10)=1;
    Cgraph(8,9)=1;
    Cgraph(9,10)=1;
end
%if strcmp(Topology,'randomGraph')
%   prob_connect=0.5;
%   Cgraph = (rand(numNodes,numNodes)>prob_connect);
%   for i=1:numNodes
%     for j=i:-1:1
%         Cgraph(i,j)=0;
%     end
%    end
%end

% pool of symmetric keys
if strcmp(HMACscheme,'RSS-HMAC')
    key = gf(randi(p-1,(m+n+L),L),log(p)/log(2));
    b = randsample((m+1):(m+n),L);
    H = key(b,:);  %% H needs to be full rank, checking omitted. 
    while rank(H)~=L
        b = randsample(1:(m+n),L);
        H = key(b,:);  %% H needs to be full rank, checking omitted. 
    end
    G = inv(H);
end
if strcmp(HMACscheme,'joint_padding')
    key = gf(randi(p-1,(m+n+L),L),log(p)/log(2));
    b = (m+n+1):(m+n+L);
     H = key(b,:);  %% H needs to be full rank, checking omitted. 
    while rank(H)~=L
       key = gf(randi(p-1,(m+n+L),L),log(p)/log(2));
        H = key(b,:);  %% H needs to be full rank, checking omitted. 
    end
    G = inv(H);   
end
if strcmp(HMACscheme,'orth_padding')
    key = gf(randi(p-1,(m+n+1),L),log(p)/log(2)); 
end

% key distribution to all relay nodes and destination node
keyIndex=zeros(numKeyperNode,numNodes);
if strcmp(KeydistAlg,'nonRandom')
    tmpCounter=0;
    for i=2:numNodes
        for j=1:numKeyperNode
            tmpCounter=tmpCounter+1;
            keyIndex(j,i)=rem(tmpCounter,L);
            if keyIndex(j,i)==0
                keyIndex(j,i)=L;
            end
        end
    end
    nRepeat=1;
end
if strcmp(KeydistAlg,'Random')
    for i=2:numNodes
        keyIndex(:,i)=randsample(1:L,numKeyperNode);
    end
    nRepeat=5;
end


% keys process by adversaries 
num_advKey=0;
index_advKey=zeros(1,numAdvs);
for i=1:numAdvs
    tmp=keyIndex(:,advNodes(i));
    [nrow, ncol]=size(tmp);
    tmp=reshape(tmp,1,nrow*ncol);
    for j=1:nrow*ncol
        if sum(tmp(j)==index_advKey)==0
            num_advKey=num_advKey+1;
            index_advKey(num_advKey)=tmp(j);        
        end
    end
end
index_advKey=index_advKey(1:num_advKey);
advKey = key(:,index_advKey);


%% Simulation
BETA=0.2:0.2:1;
%BETA=0;
record_avg_polluted_hops=zeros(nRepeat,length(BETA));
record_percentage_rx_ratio=zeros(nRepeat,length(BETA));
record_percentage_correct_rx_gen=zeros(nRepeat,length(BETA));

for ii=1:length(BETA)
    beta=BETA(ii);


for nn=1:nRepeat
    
    if strcmp(KeydistAlg,'Random')
        for i=2:numNodes
            keyIndex(:,i)=randsample(1:L,numKeyperNode);
        end

        num_advKey=0;
        index_advKey=zeros(1,numAdvs);
        for i=1:numAdvs
        tmp=keyIndex(:,advNodes(i));
        [nrow, ncol]=size(tmp);
        tmp=reshape(tmp,1,nrow*ncol);
        for j=1:nrow*ncol
            if sum(tmp(j)==index_advKey)==0
                num_advKey=num_advKey+1;
                index_advKey(num_advKey)=tmp(j);        
            end
        end
        end
        index_advKey=index_advKey(1:num_advKey);
        advKey = key(:,index_advKey);
    end

%% storage parameters
buffer = cell(1,numNodes);
buffer_pollute_flag = cell(1,numNodes);

genIndex=zeros(1,numNodes);
current_genIndex=zeros(1,numNodes);
    
%% Record variables
record_polluted=[];
record_detected=[];
record_undetected_dest=[];

counter_tx_source=0;
counter_rx_dest=0;

for i=1:numTx
    if rem(i-1,ceil(m*(1+ovp)))==0    
        X = gf(randi(p-1,m,n),log(p)/log(2)); % one generation of data, size(m,n)
        U = [eye(m,m) X];                         % eye(m,m) RLNC coefficients
        genIndex(sourceIndex)=genIndex(sourceIndex)+1;
        X_input{genIndex(sourceIndex)}=X;     
        
        % Homomorphic subspace MAC using semmytric key
        if strcmp(HMACscheme,'RSS-HMAC') || strcmp(HMACscheme,'joint_padding')
            U_pad = [U zeros(m,L)];                          % each paket pad one symbol
            U_swap = U_pad;
            U_swap(:,m+n+1:end)=U_pad(:,b);
            U_swap(:,b)=0;
            pad = (0-U_swap*key)*G;
            U_bar=U_swap;
            U_bar(:,b)=pad;
            buffer{sourceIndex}=U_bar;
        end
        if  strcmp(HMACscheme,'orth_padding')
            U_pad = [U zeros(m,L)];       
            for mm=1:m
                for pp=1:L
                    pad = (0-U(mm,:)*key(1:end-1,pp))/key(end,pp);
                    U_pad (mm,m+n+pp)=pad;
                end
            end  
            buffer{sourceIndex}=U_pad;
        end
    end
    
    tx_vector = cell(1,numNodes);    
    pollute_flag = cell(1,numNodes);     
    Cgraph_tmp=Cgraph;
    for j=1:numNodes
        if ~isempty(buffer{j})
            if (strcmp(Topology,'multiPath') && strcmp(LinkType,'point2point') && sum(Cgraph(j,:)==1)>1)
                rxIndex=find(Cgraph(j,:)==1);
                activeIndex=rem(i,length(rxIndex))+1;
                Cgraph_tmp(j,:)=0;
                Cgraph_tmp(j,rxIndex(activeIndex))=1;
            end
                if sum(advNodes==j)==1 && rand()<max(ovp*beta,0)
                    if strcmp(attackType,'data_pollution')
                        forge_x= gf(randi(p-1,1,m+n+L),log(p)/log(2));
                        if strcmp(HMACscheme,'RSS-HMAC') || strcmp(HMACscheme,'joint_padding')
                            tmp_index = randsample((m+1):(m+n+L),num_advKey);
                            tmp_A = advKey(tmp_index,:);
                            while(rank(tmp_A)<num_advKey)
                                tmp_index = randsample((m+1):(m+n+L),num_advKey);
                                tmp_A = advKey(tmp_index,:);                            
                            end
                            forge_x(tmp_index)= gf(0,log(p)/log(2));
                            tmp_b =forge_x*advKey;
                            tmp_x = tmp_b*inv(tmp_A); %#ok<MINV>
                            forge_x(tmp_index)=tmp_x;
                        end
                        if  strcmp(HMACscheme,'orth_padding')
                            for pp=1:num_advKey
                                pad = (0-forge_x(1:(m+n))*advKey(1:end-1,pp))/advKey(end,pp);
                                forge_x(m+n+index_advKey(pp))=pad;                             
                            end
                        end
                        tx_vector{j}=forge_x;
                        record_polluted=[record_polluted j];
                        sprintf('generate one polluted packet')
                        pollute_flag{j}=1;
                    end
                    if  strcmp(attackType,'tag_pollution_tail')
                        [nrow, ncol]=size(buffer{j});
                        alpha = gf(randi(p-1,1,nrow),log(p)/log(2));
                        tmp_x = alpha*buffer{j};
                        index_polluted_tags = keyIndex(1:num_polluteTags,j);
                        old_value = tmp_x(m+n+index_polluted_tags);
                        tmp_x(m+n+index_polluted_tags)= gf(randi(p-1,1,num_polluteTags),log(p)/log(2));
                        while (old_value==tmp_x(m+n+index_polluted_tags))
                             tmp_x(m+n+index_polluted_tags)= gf(randi(p-1,1,num_polluteTags),log(p)/log(2));
                        end
                        tx_vector{j}=tmp_x;
                        record_polluted=[record_polluted j];
                        sprintf('generate one tag polluted packet')
                        pollute_flag{j}=sum(buffer_pollute_flag{j})+1;
                    end               
                else    
                    [nrow, ncol]=size(buffer{j});
                    alpha = gf(randi(p-1,1,nrow),log(p)/log(2));     
                    tx_vector{j}= alpha*buffer{j};     
                    if sum(buffer_pollute_flag{j})==0
                         pollute_flag{j}=sum(buffer_pollute_flag{j});
                    else
                          pollute_flag{j}=max(buffer_pollute_flag{j})+1;
                    end
                    if j==sourceIndex
                        counter_tx_source=counter_tx_source+1;
                    end
                end
                current_genIndex(j)=genIndex(j);
        end
    end
    
    for j=1:numNodes
        if ~isempty(tx_vector{j})
            rxIndex=find(Cgraph_tmp(j,:)==1);
            for k=1:length(rxIndex)
                Kn=key(:,keyIndex(:,rxIndex(k)));
                x_coded=tx_vector{j};
                
                verify=true;
                if strcmp(HMACscheme,'RSS-HMAC') || strcmp(HMACscheme,'joint_padding')
                    delta=x_coded*Kn;
                    for kk=1:length(delta)
                        if delta(kk)~=0
                            verify=false;
                        end
                    end
                end
                if  strcmp(HMACscheme,'orth_padding')
                    tmp_pp=keyIndex(:,rxIndex(k));
                    for kk=1:length(tmp_pp)
                        delta=[x_coded(1:m+n) x_coded(m+n+tmp_pp(kk))]*Kn(:,kk);
                        if delta~=0
                            verify=false;
                        end
                    end
                end
                
                if verify
%                    sprintf('verify=true')
                    if current_genIndex(j)~=genIndex(rxIndex(k))
                        buffer{rxIndex(k)}=[];
                        buffer_pollute_flag{rxIndex(k)}=[];
                        genIndex(rxIndex(k))=current_genIndex(j);
                    end
                    if isempty(buffer{rxIndex(k)})
                         tmp_A=[];
                    else
                        tmp_A=buffer{rxIndex(k)}(1:end,1:m);
                    end
                    buffer_tmp_A=[tmp_A; x_coded(1:m)];
                    if rank(tmp_A)<m && rank(buffer_tmp_A)>rank(tmp_A)
                        buffer{rxIndex(k)}=[ buffer{rxIndex(k)}; x_coded];
                        buffer_pollute_flag{rxIndex(k)}=[buffer_pollute_flag{rxIndex(k)} pollute_flag{j}];
                        if rxIndex(k)==destIndex
                            counter_rx_dest=counter_rx_dest+1;
                        end
                    end
                    if rxIndex(k)==destIndex &&  rank(tmp_A)==m
                        if strcmp(HMACscheme,'RSS-HMAC') || strcmp(HMACscheme,'joint_padding')
                             tmp_B=buffer{rxIndex(k)}(1:m,:);
                             tmp_x = inv(tmp_A)*tmp_B;
                             tmp_swap_x= tmp_x;
                             tmp_swap_x(:,b)=tmp_x(:,m+n+1:end);
                             X_output{genIndex(destIndex)}=tmp_swap_x(:,(m+1):(m+n));
                             X_output_pollute_flag(genIndex(destIndex))=sum(buffer_pollute_flag{destIndex}>0);
                        end
                        if strcmp(HMACscheme,'orth_padding')
                             tmp_B=buffer{rxIndex(k)}(1:m,:);
                             tmp_x = inv(tmp_A)*tmp_B;
                             X_output{genIndex(destIndex)}=tmp_x(:,(m+1):(m+n));
                             X_output_pollute_flag(genIndex(destIndex))=sum(buffer_pollute_flag{destIndex}>0);                          
                        end
                    end 
                     if rxIndex(k)==destIndex &&  pollute_flag{j}~=0 
                         record_undetected_dest=[record_undetected_dest pollute_flag{j}];
                     end
                else
                    sprintf('detected one polluted packet')
                    record_detected=[record_detected pollute_flag{j}];
                end
            end
        end
    end
    sprintf('nn=%d, beta(ii)=%f, i=%d',nn, beta,i)
end

%% Data processing
avg_polluted_hops = mean([record_detected record_undetected_dest]);
percentage_rx_ratio = counter_rx_dest/counter_tx_source;
counter_correct_rx_gen=0;
counter_empty=0;
if exist('X_output','var')
    for i=1:length(X_output)
        if ~isempty(X_output{i})
            if X_output{i}==X_input{i}
                counter_correct_rx_gen=counter_correct_rx_gen+1;
            end
        else
            counter_empty=counter_empty+1;
        end
    end
else
    counter_correct_rx_gen=0;
end
percentage_correct_rx_gen=counter_correct_rx_gen/length(X_input);

clear X_input;
if exist('X_output','var') 
    clear X_output=0; 
end
if exist('X_output_pollute_flag','var')
    clear X_output_pollute_flag;
end

%% Record data
record_avg_polluted_hops(nn,ii)=avg_polluted_hops;
record_percentage_rx_ratio(nn,ii)=percentage_rx_ratio;
record_percentage_correct_rx_gen(nn,ii)=percentage_correct_rx_gen;

end

end

record_avg_polluted_hops= mean(record_avg_polluted_hops,1);
record_percentage_rx_ratio= mean(record_percentage_rx_ratio,1);
record_percentage_correct_rx_gen=mean(record_percentage_correct_rx_gen,1);

fprintf(FID,'Prob_of_attack: ');
for i=1:length(BETA)
    fprintf(FID,'%f ',BETA(i)*ovp);
end
fprintf(FID,'\n');

fprintf(FID,'Prob_of_PLR:');
for i=1:length(BETA)
    fprintf(FID,'%f ',1-record_percentage_correct_rx_gen(i));
end
fprintf(FID,'\n');

fprintf(FID,'avg_polluted_hops:');
for i=1:length(BETA)
    fprintf(FID,'%f ',record_avg_polluted_hops(i));
end
fprintf(FID,'\n');

fprintf(FID,'Prob_rx_ratio:');
for i=1:length(BETA)
    fprintf(FID,'%f ',record_percentage_rx_ratio(i));
end
fprintf(FID,'\n');

fprintf(FID,'*************\n\n\n');
fclose(FID);

