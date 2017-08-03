tic
clc;clear
result=[];
for i=1:50
    min_bottleneck=Traffic_Particle();
    try
        result=[result;min_bottleneck];
    catch
        
    end
%     figure
%     axis([0 2.5*10^4 0 20])
%     legend('the queue before enter document checkpoint 1','the queue before enter document checkpoint 2','the queue before enter document checkpoint 3','the queue before entering baggage and body screening checkpoint 1','the queue before entering baggage and body screening checkpoint 2','the queue before entering baggage and body screening checkpoint 3','the queue before entering baggage and body screening checkpoint 4','the queue before entering baggage and body screening checkpoint 5','the queue before entering baggage and body screening checkpoint 6','the queue before entering baggage and body screening checkpoint 7','the queue before entering baggage and body screening checkpoint 8','the queue before entering baggage and body screening checkpoint 9','the queue before entering baggage and body screening checkpoint 10','the number of passengers from the security checkpoint to the baggage check','the number of passengers packing luggage')
end
toc
