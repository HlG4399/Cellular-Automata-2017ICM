function temp_passenger=GeneratePassenger()
temp_passenger.v = 1.41;%��λm/s
% temp_rand=rand;
% p_elderly=0.174;%�����˿ڱ���
% p_set=[697.1/31600 592.8/31600 826/31600 1962.1/31];
% if temp_rand<=p_set(1)%DC��
%     if rand<p_elderly%�ж��Ƿ�Ϊ������
%         temp_passenger.v=1.18;
%     else
%         temp_passenger.v=1.43;
%     end
% else
%     if temp_rand<=p_set(1)+p_set(2)%MD��
%         if rand<p_elderly%�ж��Ƿ�Ϊ������
%             temp_passenger.v=1.17;
%         else
%             temp_passenger.v=1.44;
%         end
%     else
%         if temp_rand<=p_set(1)+p_set(2)+p_set(3)%VA��
%             if rand<p_elderly%�ж��Ƿ�Ϊ������
%                 temp_passenger.v=1.21;
%             else
%                 temp_passenger.v=1.44;
%             end
%         else
%             if temp_rand<=p_set(1)+p_set(2)+p_set(3)+p_set(4)%NY��
%                 if rand<p_elderly%�ж��Ƿ�Ϊ������
%                     temp_passenger.v=1.34;
%                 else
%                     temp_passenger.v=1.58;
%                 end
%             end
%         end
%     end
% end

%�����˿͵��ܽ����̶ȣ�1�����ܽ����̶ȸߣ�2�����ܽ����̶��У�3�����ܽ����̶ȵ�
temp_rand=rand;
p_set=[0.1 0.6 0.3];
if temp_rand<=p_set(1)%��ä
    education_level=1;
else
    if temp_rand<=p_set(1)+p_set(2)%�ܽ����̶��е�
        education_level=2;
    else
        education_level=3;
    end
end

if (rand< 0.45)
    while 1
        temp_passenger.time(1) = normrnd(9.2, 9.4)+Penalty_time(education_level);
        if(temp_passenger.time(1)>0)
            break
        end
    end
    while 1
        temp_passenger.time(2) = normrnd(12.6, 4.2)+Penalty_time(education_level);
        if(temp_passenger.time(2)>0)
            break
        end
    end
else
    while 1
        temp_passenger.time(1) = normrnd(12.9, 15.8)+Penalty_time(education_level);
        if(temp_passenger.time(1)>0)
            break
        end
    end
    while 1
        temp_passenger.time(2) = normrnd(10.2, 2.8)+Penalty_time(education_level);
        if(temp_passenger.time(2)>0)
            break
        end
    end
end
while 1
    temp_passenger.time(3) = normrnd(11.6, 5.8)+Penalty_time(education_level);
    if(temp_passenger.time(3)>0)
        break
    end
end
while 1
    temp_passenger.time(4) = normrnd(7.5, 7.8)+Penalty_time(education_level);
    if(temp_passenger.time(4)>0)
        break
    end
end
while 1
    temp_passenger.time(5) = normrnd(3.7, 2.7)+Penalty_time(education_level);
    if(temp_passenger.time(5)>0)
        break
    end
end
while 1
    temp_passenger.time(6) = normrnd(28, 13.5)+Penalty_time(education_level);
    if(temp_passenger.time(6)>0)
        break
    end
end

%�˿ʹӰ�����ƶ���X_ray������ʱ��
temp_passenger.time(7) = 10/temp_passenger.v ;

temp_passenger.isInitialization=0;%�ж��Ƿ����

