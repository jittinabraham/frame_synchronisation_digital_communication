close all
lamda=1:16;
tic;
error_probability=0.01:0.04:0.1
%setting up the sync word
%2*hexa2poly('eb90')-1;
sync_word=[1 1 1 0 0 0 1 1 1 0 1 1 0 1 1 0];
%generating for various probability
for e=1:length(error_probability)
    mda=zeros(1,16);%
    pfa=zeros(1,16);
    for k=1:16 % for changing the lamda value
        for j=1:10000 % simulation for 10000 frames
            matric=zeros(1,15);        
           
            Error_vector = rand(1,32)<=error_probability(e) ;% random error vector 
            data = randi([0 1],1,16);
            data_pack = [sync_word,data]; 
            data_pack_recived = xor(data_pack,Error_vector); %data packet at the recv end 
            P=length(data_pack_recived);
            for i=1:length(data_pack_recived)-15
                     
                    temp =data_pack_recived(i:i+15);
                    matric(i)=sum(temp==sync_word);
                     %pfa fault detection count 
                     pfa(lamda(k))=pfa(lamda(k))+(i~=1 && matric(i)>=lamda(k));
                    %mda missed detection count  
                     mda(k)=mda(k)+(matric(i)<lamda(k) && i==1);
                   
             end
     
        end
     pfa(k)=pfa(k)/((P-15)*j); % probability of fault detection
     mda(k)=mda(k)/(j);% probability of missed detection
       
    end
     semilogy(lamda,pfa,'LineWidth',2);
    hold on;
    grid on;
    semilogy(lamda,mda,'LineWidth',2);
    xlabel('Lamda');
    ylabel('P(fault detection) P(missed detection)');
   
    
end
toc
 

    
 


