Prob_of_attack=[0.000000 0.100000 0.200000 0.300000 0.400000 0.500000];

%Topology='singlePath';
Topology='singlePath';
if strcmp(Topology,'singlePath')
    Prob_of_PLR(1)=0.023810;
else
    Prob_of_PLR(1)=0.01;
end

attackType='data-pollution';
num_polluteTags=1;
KeydistAlg='Random';
numKeyperNode=3;
numAdvs=1;
Adversary_Node_Index=2;
Titletext=sprintf('%s,%s,%s,advID=%d,numKeyR=%d',Topology,attackType,KeydistAlg,Adversary_Node_Index,numKeyperNode);
if strcmp(attackType,'tag-pollution') && strcmp(KeydistAlg,'nonRandom') && strcmp(Topology,'singlePath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.333333 0.690476 0.761905 0.904762 0.964286]; 
    avg_polluted_hops_org=[7.000000 7.056940 7.000000 7.005450 7.009412];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.023810 0.142857 0.285714 0.511905 0.702381];
    avg_polluted_hops_joint=[1.000000 1.000000 1.000000 1.000000 1.000000 ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.023810 0.142857 0.285714 0.511905 0.702381];
    avg_polluted_hops_rss=[1.000000 1.000000 1.000000 1.000000 1.000000];
end
if strcmp(attackType,'tag-pollution') && strcmp(KeydistAlg,'Random') && strcmp(Topology,'singlePath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.314286 0.309524 0.616667 0.554762 0.340476 ]; 
    avg_polluted_hops_org=[4.047421 3.040486 5.017930 6.267441 5.400000 ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.097619 0.259524 0.402381 0.602381 0.740476 ];
    avg_polluted_hops_joint=[1.000000 1.000000 1.000000 1.000000 1.000000 ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.119048 0.266667 0.409524 0.607143 0.697619 ];
    avg_polluted_hops_rss=[1.000000 1.000000 1.000000 1.000000 1.000000];
end
if strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'nonRandom') && strcmp(Topology,'singlePath')
%     numTx=500
%     Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.071429 0.273810 0.511905 0.547619 0.773810 ]; 
%     avg_polluted_hops_org=[1.000000 1.000000 1.000000 1.024390 1.041825 ];
%     Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.071429 0.238095 0.440476 0.642857 0.714286  ];
%     avg_polluted_hops_joint=[1.000000 1.000000 1.019868 1.033493 1.031008];
%     Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.071429 0.261905 0.357143 0.464286 0.773810];
%     avg_polluted_hops_rss=[1.000000 1.000000 1.000000 1.000000 1.031873 ];

%     numTx=1000    
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.059880 0.245509 0.413174 0.556886 0.766467]; 
    avg_polluted_hops_org=[1.056818 1.015957 1.030864 1.000000 1.022857];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.089820 0.263473 0.449102 0.616766 0.820359 ];
    avg_polluted_hops_joint=[1.000000 1.000000 1.019868 1.033493 1.031008];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.095808 0.269461 0.425150 0.586826 0.706587 ];
    avg_polluted_hops_rss=[1.037383 1.000000 1.034268 1.000000 1.018711 ];

end

if strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'Random') && strcmp(Topology,'singlePath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.195238 0.259524 0.433333 0.616667 0.747619  ]; 
    avg_polluted_hops_org=[1.400000 1.016853 1.017443 1.218318 1.424882 ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.157143 0.257143 0.428571 0.652381 0.809524  ];
    avg_polluted_hops_joint=[1.200000 1.029341 1.021741 1.247825 1.218720 ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.085714 0.440476 0.407143 0.628571 0.740476 ];
    avg_polluted_hops_rss=[1.052174 1.614815 1.016143 1.429056 1.023170 ];
end
if strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'Random') && strcmp(Topology,'singlePath') && numKeyperNode==3
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.088095 0.257143 0.411905 0.533333 0.740476 ]; 
    avg_polluted_hops_org=[ 1.000000 1.000000 1.000000 1.015181 1.021961 ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.104762 0.242857 0.454762 0.576190 0.735714 ];
    avg_polluted_hops_joint=[1.029640 1.010417 1.008284 1.000000 1.000794  ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.085714 0.330952 0.414286 0.621429 0.745238  ];
    avg_polluted_hops_rss=[1.000000 1.000000 1.000000 1.003738 1.000000  ];
end

if  strcmp(attackType,'tag-pollution') && strcmp(KeydistAlg,'nonRandom') && strcmp(Topology,'multiPath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.011905 0.011905 0.011905 0.011905 0.011905  ]; 
    avg_polluted_hops_org=[3.000000 3.000000 3.000000 3.000000 3.000000 ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.011905 0.011905 0.011905 0.023810 0.083333 ];
    avg_polluted_hops_joint=[ 1.000000 1.000000 1.000000 1.000000 1.000000 ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.011905 0.011905 0.023810 0.035714 0.059524 ];
    avg_polluted_hops_rss=[1.000000 1.000000 1.000000 1.000000 1.000000  ];
end

if  strcmp(attackType,'tag-pollution') && strcmp(KeydistAlg,'Random') && strcmp(Topology,'multiPath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.011905 0.047619 0.011905 0.097619 0.019048  ]; 
    avg_polluted_hops_org=[3.000000 2.800000 3.000000 2.000000 2.600000  ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.011905 0.014286 0.021429 0.040476 0.066667  ];
    avg_polluted_hops_joint=[1.000000 1.000000 1.000000 1.000000 1.000000  ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.011905 0.011905 0.019048 0.047619 0.090476];
    avg_polluted_hops_rss=[1.000000 1.000000 1.000000 1.000000 1.000000 ];
end


if  strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'Random') && strcmp(Topology,'multiPath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1) 0.011905 0.011905 0.019048 0.040476 0.069048 ]; 
    avg_polluted_hops_org=[1.400000 1.004167 1.000000 1.014953 1.011197 ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1) 0.026190 0.011905 0.019048 0.030952 0.073810 ];
    avg_polluted_hops_joint=[ 1.224393 1.014519 1.032723 1.006573 1.036960 ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) 0.011905 0.011905 0.026190 0.095238 0.173810 ];
    avg_polluted_hops_rss=[1.045630 1.426258 1.000000 1.207825 1.244365 ];
end

if  strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'nonRandom') && strcmp(Topology,'multiPath')
    Prob_of_PLR_orth =[ Prob_of_PLR(1)]; 
    avg_polluted_hops_org=[ ];
    Prob_of_PLR_joint=[ Prob_of_PLR(1)   ];
    avg_polluted_hops_joint=[ ];
    Prob_of_PLR_rss=[ Prob_of_PLR(1) ];
    avg_polluted_hops_rss=[ ];
end

figure(1)
subplot(1,2,1);
plot(Prob_of_attack,Prob_of_PLR_orth,'-*','LineWidth',2,'MarkerSize',12);
hold on
plot(Prob_of_attack,Prob_of_PLR_joint,'-o','LineWidth',2,'MarkerSize',12);
plot(Prob_of_attack,Prob_of_PLR_rss,'-x','LineWidth',2,'MarkerSize',12);
hold off
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Probability of attack \beta','FontSize',12,'FontWeight','bold');
ylabel('Packet Loss Ratio','FontSize',12);
axis([0 0.5 0 1]);
axis square
h=legend('HSM','JointPadding','RSS');
set(h,'Location','NorthWest','FontSize',12,'FontWeight','bold');
title(Titletext,'FontSize',12);
subplot(1,2,2)
plot(Prob_of_attack(2:end),avg_polluted_hops_org,'-*','LineWidth',2,'MarkerSize',12);
hold on
plot(Prob_of_attack(2:end),avg_polluted_hops_joint,'-o','LineWidth',2,'MarkerSize',12);
plot(Prob_of_attack(2:end),avg_polluted_hops_rss,'-x','LineWidth',2,'MarkerSize',12);
hold off
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Probability of attack \beta','FontSize',12);
ylabel('Averaged Polluted Hops','FontSize',12);
if strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'nonRandom') && strcmp(Topology,'singlePath')
    axis([0 0.5 0.8 1.2])
elseif strcmp(attackType,'data-pollution') && strcmp(KeydistAlg,'Random') && strcmp(Topology,'singlePath')
     axis([0 0.5 0.8 2])
else
    axis([0 0.5 0 9]);    
end
axis square
h=legend('HSM','JointPadding','RSS');
set(h,'Location','NorthWest','FontSize',12,'FontWeight','bold');
title(Titletext,'FontSize',12);

