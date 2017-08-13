function [min_bottleneck,throughput,average_waiting_time]=Traffic_Particle()
clc;clear
n_security_checkpoints = 3;%安检口数
n_X_ray = 10;%X_ray检查口数目
min_value=0;
min_i=[];
deltaTime=0.01;
p_carry_contraband=0.1;%携带违禁品的概率

rand('twister',mod(floor(now*8640000),2^31-1));%设置种子值

%初始化
for i=1:n_security_checkpoints
    lanes_security_checkpoints(i).passengers.v=0;
    lanes_security_checkpoints(i).passengers.time=[];
    lanes_security_checkpoints(i).passengers.isInitialization=1;
    lanes_security_checkpoints(i).thresholdTime=0;
    lanes_security_checkpoints(i).waitTime=0;
end

for i=1:n_X_ray
    lanes_X_ray(i).passengers.v=0;
    lanes_X_ray(i).passengers.time=[];
    lanes_X_ray(i).passengers.isInitialization=1;
    lanes_X_ray(i).thresholdTime=0;
    lanes_X_ray(i).waitTime=0;
end

lane_beforeQueue.passengers.v=0;
lane_beforeQueue.passengers.time=[];
lane_beforeQueue.passengers.isInitialization=0;
lane_beforeQueue.thresholdTime=0;
lane_beforeQueue.waitTime=0;

lane_afterQueue.passengers.v=0;
lane_afterQueue.passengers.time=[];
lane_afterQueue.passengers.isInitialization=0;
lane_afterQueue.waitTime=0;

lane_checkpointsToX_ray.passengers.v=0;
lane_checkpointsToX_ray.passengers.time=[];
lane_checkpointsToX_ray.isInitialization=0;
lane_checkpointsToX_ray.waitTime=0;
lane_checkpointsToX_ray.min_i=0;

temp_passenger.v=0;
temp_passenger.time=[];
temp_passenger.isInitialization=0;

%初始化安检口前的队伍
for i=1:n_security_checkpoints
    for j=1:round(rand()*4+1)
        temp_passenger = GeneratePassenger();
        lanes_security_checkpoints(i).passengers=Add(lanes_security_checkpoints(i).passengers,temp_passenger);
        lanes_security_checkpoints(i).passengers(end).isInitialization=1;
        lanes_security_checkpoints(i).thresholdTime = temp_passenger.time(2); 
        lanes_security_checkpoints(i).waitTime = 0;
    end
end

%初始化X_ray前的队伍
for i=1: n_X_ray
    for j=1:round(rand()*4+1)
        temp_passenger=GeneratePassenger();
        lanes_X_ray(i).passengers=Add(lanes_X_ray(i).passengers,temp_passenger);
        lanes_X_ray(i).passengers(end).isInitialization=1;
        lanes_X_ray(i).thresholdTime = temp_passenger.time(3)+ temp_passenger.time(4)+ temp_passenger.time(5);
        lanes_X_ray(i).waitTime = 0;
    end
end

total_time=0;
temp_length=[];
queue_length=ones(1,n_security_checkpoints +n_X_ray+2);
start_throughput=0;%吞量
end_throughput=0;%吐量
average_waiting_time=0;%平均等待时间
temp_passenger=GeneratePassenger();
lane_beforeQueue.passengers=Add(lane_beforeQueue.passengers,temp_passenger);
lane_beforeQueue.thresholdTime=lane_beforeQueue.passengers(1).time(1);

while total_time<250
    %创建一条虚拟的等待进入安检口队列的队列
    lane_beforeQueue.waitTime = lane_beforeQueue.waitTime+deltaTime;
    if(lane_beforeQueue.waitTime>lane_beforeQueue.thresholdTime)
        %选择最优的安检口
        min_value = length(lanes_security_checkpoints(1).passengers);
        min_i=1;
        for i=2:length(lanes_security_checkpoints)
            if (min_value == length(lanes_security_checkpoints(i).passengers))
%                 try
%                     if(lanes_security_checkpoints(i).passengers(1).time(2)<20)
%                         min_i=[min_i i];
%                     end
%                 catch
                    min_i=[min_i i];
%                 end
            end
            if (min_value > length(lanes_security_checkpoints(i).passengers))
%                 try
%                     if(lanes_security_checkpoints(i).passengers(1).time(2)<20)
%                         min_value = length(lanes_security_checkpoints(i).passengers);
%                         min_i = i;
%                     end
%                 catch
                    min_value = length(lanes_security_checkpoints(i).passengers);
                    min_i = i;
%                 end
            end
        end
        if (length(min_i) > 1)
            min_i = min_i(round((length(min_i)-1)*rand+1) );
        end
        lanes_security_checkpoints(min_i).passengers=Add(lanes_security_checkpoints(min_i).passengers,lane_beforeQueue.passengers(1));
        if(length(lanes_security_checkpoints(min_i).passengers)==1)
            lanes_security_checkpoints(min_i).thresholdTime=lanes_security_checkpoints(min_i).passengers(1).time(2);
        end
        temp_passenger = GeneratePassenger();
        start_throughput=start_throughput+1;
        lane_beforeQueue.passengers=temp_passenger;
        lane_beforeQueue.thresholdTime = temp_passenger.time(1);
        lane_beforeQueue.waitTime = 0;
    end
    
    %安检口检查→X_ray检查
    for i=1:n_security_checkpoints
        if(~(isempty(lanes_security_checkpoints(i).passengers) || isempty(lanes_security_checkpoints(i).passengers(1).time)))%判断队列是否为空
            lanes_security_checkpoints(i).waitTime=lanes_security_checkpoints(i).waitTime+deltaTime;
            if (lanes_security_checkpoints(i).waitTime>lanes_security_checkpoints(i).thresholdTime)
                temp_passenger = lanes_security_checkpoints(i).passengers(1);
                lanes_security_checkpoints(i).passengers=PopFront(lanes_security_checkpoints(i).passengers);
                if(~isempty(lanes_security_checkpoints(i).passengers(1).time))
                    lanes_security_checkpoints(i).thresholdTime = lanes_security_checkpoints(i).passengers(1).time(2);
                else
                    lanes_security_checkpoints(i).thresholdTime=233;
                end
                lanes_security_checkpoints(i).waitTime = 0;
                %选择最优的X_ray
                min_value = length(lanes_X_ray(1).passengers);
                min_i = 1;
                for j=2:length(lanes_X_ray)
                    if (min_value == length(lanes_X_ray(j).passengers))
%                         try
%                             if(lanes_X_ray(j).passengers(1).time(3)<lanes_X_ray(j).passengers(1).time(4)+lanes_X_ray(j).passengers(1).time(5))
%                                 if(lanes_X_ray(j).passengers(1).time(4)+lanes_X_ray(j).passengers(5)<20)
%                                     min_i=[min_i i];
%                                 end
%                             else
%                                 if(lanes_X_ray(j).passengers(1).time(3)<20)
                                    min_i=[min_i i];
%                                 end
%                             end
%                         catch
%                             min_i=[min_i i];
%                         end
                    end
                    if (min_value >length( lanes_X_ray(j).passengers))
%                         try
%                             if(lanes_X_ray(j).passengers(1).time(3)<lanes_X_ray(j).passengers(1).time(4)+lanes_X_ray(j).passengers(1).time(5))
%                                 if( lanes_X_ray(j).passengers(1).time(4)+lanes_X_ray(j).passengers(1).time(5)<20)
%                                     min_value = length(lanes_X_ray(j).passengers);
%                                     min_i =  j ;
%                                 end
%                             else
%                                 if( lanes_X_ray(j).passengers(1).time(3)<20)
%                                     min_value = length(lanes_X_ray(j).passengers);
%                                     min_i =  j ;
%                                 end
%                             end
%                         catch
                            min_value = length(lanes_X_ray(j).passengers);
                            min_i =  j ;
%                         end
                    end
                end
                if (length(min_i) > 1)
                    min_i = min_i(round((length(min_i)-1)*rand+1) );
                end
                lane_checkpointsToX_ray.passengers=Add(lane_checkpointsToX_ray.passengers,temp_passenger);
                lane_checkpointsToX_ray.waitTime(length(lane_checkpointsToX_ray.passengers))=0;
                lane_checkpointsToX_ray.min_i(length(lane_checkpointsToX_ray.passengers))=min_i(1);
            end
        end
    end
    
    %乘客从安检口走向X_ray
    delete_i=[];
    for i=1:length(lane_checkpointsToX_ray.passengers)
        if(~(isempty(lane_checkpointsToX_ray.passengers) || isempty(lane_checkpointsToX_ray.passengers(i).time)))%判断队列是否为空
            lane_checkpointsToX_ray.waitTime(i) = lane_checkpointsToX_ray.waitTime(i)+deltaTime;
            if (lane_checkpointsToX_ray.waitTime(i) > lane_checkpointsToX_ray.passengers(i).time(7))
                lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers=Add(lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers,lane_checkpointsToX_ray.passengers(i));
                if(length(lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers)==1)
                    if(lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers(1).time(3)<lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers(1).time(4)+ lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers(1).time(5))
                        lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).thresholdTime = lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers(1).time(4)+ lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers(1).time(5);
                    else
                        lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).thresholdTime = lanes_X_ray(lane_checkpointsToX_ray.min_i(i)).passengers(1).time(3);
                    end
                end
                delete_i=[delete_i i];
            end
        else
            delete_i=[delete_i i];
        end
    end
    lane_checkpointsToX_ray.passengers(delete_i)=[];
    lane_checkpointsToX_ray.waitTime(delete_i)=[];
    lane_checkpointsToX_ray.min_i(delete_i)=[];
    
    %X_ray检查
    for i=1:length(lanes_X_ray)
        if(~(isempty(lanes_X_ray(i).passengers) || isempty(lanes_X_ray(i).passengers(1).time)))%判断队列是否为空
            lanes_X_ray(i).waitTime = lanes_X_ray(i).waitTime+deltaTime;
            if(lanes_X_ray(i).waitTime>lanes_X_ray(i).thresholdTime)
                %如果携带违禁品，则将乘客转移至D区，即直接将该乘客从该队列中弹出
                if(rand<p_carry_contraband)
                    lanes_X_ray(i).passengers=PopFront(lanes_X_ray(i).passengers);
                else
                    lane_afterQueue.passengers=Add(lane_afterQueue.passengers,lanes_X_ray(i).passengers(1));
                    lane_afterQueue.waitTime(length(lane_afterQueue.passengers))=0;
                    lanes_X_ray(i).passengers=PopFront(lanes_X_ray(i).passengers);
                end
                if(~isempty(lanes_X_ray(i).passengers(1).time))
                    if(lanes_X_ray(i).passengers(1).time(3)<lanes_X_ray(i).passengers(1).time(4)+ lanes_X_ray(i).passengers(1).time(5))
                        lanes_X_ray(i).thresholdTime = lanes_X_ray(i).passengers(1).time(4)+ lanes_X_ray(i).passengers(1).time(5);
                    else
                        lanes_X_ray(i).thresholdTime = lanes_X_ray(i).passengers(1).time(3);
                    end
                else
                    lanes_X_ray(i).thresholdTime=233;
                end
                lanes_X_ray(i).waitTime = 0;
            end
        end
    end
    
    %收拾行李的队伍（无先进先出规则）
    delete_i=[];
    for i=1:length(lane_afterQueue.passengers)
        if(~(isempty(lane_afterQueue.passengers) || isempty(lane_afterQueue.passengers(i).time)))%判断队列是否为空
            lane_afterQueue.waitTime(i) = lane_afterQueue.waitTime(i)+deltaTime;
            if (lane_afterQueue.waitTime(i) > lane_afterQueue.passengers(i).time(6))
                delete_i=[delete_i i];
                if(lane_afterQueue.passengers(i).isInitialization==0)%不对初始化产生的乘客计算
                    if(lane_afterQueue.passengers(i).time(3)<lane_afterQueue.passengers(i).time(4)+lane_afterQueue.passengers(i).time(5))
                        average_waiting_time=average_waiting_time+total_time-(lane_afterQueue.passengers(i).time(1)+lane_afterQueue.passengers(i).time(2)+lane_afterQueue.passengers(i).time(4)+lane_afterQueue.passengers(i).time(5)+lane_afterQueue.passengers(i).time(6)+lane_afterQueue.passengers(i).time(7));
                    else
                        average_waiting_time=average_waiting_time+total_time-(lane_afterQueue.passengers(i).time(1)+lane_afterQueue.passengers(i).time(2)+lane_afterQueue.passengers(i).time(3)+lane_afterQueue.passengers(i).time(6)+lane_afterQueue.passengers(i).time(7));
                    end
                end
            end
        else
            delete_i=[delete_i i];
        end
    end
    end_throughput=end_throughput+length(delete_i);
    lane_afterQueue.passengers(delete_i)=[];
    lane_afterQueue.waitTime(delete_i)=[];
    
    total_time=total_time+deltaTime;
    
    for i=1:n_security_checkpoints
        temp_length=[temp_length length(lanes_security_checkpoints(i).passengers)];
    end
    for i=1:n_X_ray
        temp_length=[temp_length length(lanes_X_ray(i).passengers)];
    end
    temp_length=[temp_length length(lane_checkpointsToX_ray.passengers) length(lane_afterQueue.passengers)];
    queue_length(round(total_time/deltaTime),:)=temp_length;
    temp_length=[];
end

%绘制队列长度变化图
color={'b-','g:','r-.','c--','m-','y:','k-.','b--','g-','r:','c-.','m--','y-','k:','b-.'};
hold on
for i=1:(n_security_checkpoints +n_X_ray+2)
    plot(1:size(queue_length(:,i)),queue_length(:,i),color{i},'LineWidth',3)
end
xlabel('Time step','fontsize',20)
ylabel('Queue length','fontsize',20)

%计算瓶颈系数
bottleneck=[];
for i=1:(n_security_checkpoints +n_X_ray+2)
     k = find([true;diff(queue_length(:,i))~=0;true]);
     r = [k(1:end-1) diff(k)];
     if size(r,1)<2
         bottleneck=[bottleneck -233];
         continue
     end
     temp_sum=0;
     for j=2:size(r,1)
         temp_sum=temp_sum+(r(j- 1,1)-r(j,1))*r(j-1,2)/10^7;
     end
     bottleneck=[bottleneck temp_sum];
end
min_bottleneck=find(bottleneck==min(bottleneck));

%计算吞吐率
throughput=(end_throughput-start_throughput)/total_time;

%计算平均等待时间
average_waiting_time=average_waiting_time/start_throughput;
