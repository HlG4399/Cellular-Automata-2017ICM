function penalty_time=Penalty_time(education_level)
penalty_time=0;
% %³Í·£Ê±¼ä
% p_set=[0.9973 0.0017 0.00084601 0.00015399;0.6607 0.1631 0.1085 0.0677;0.1178 0.1648 0.2078 0.5096];
% temp_rand=rand;
% switch(education_level)
%     case 1
%         if temp_rand<p_set(1,1)
%             penalty_time=0;
%         else
%             if temp_rand<p_set(1,1)+p_set(1,2)
%                 penalty_time=5;
%             else
%                 if temp_rand<p_set(1,1)+p_set(1,2)+p_set(1,3)
%                     penalty_time=10;
%                 else
%                     penalty_time=30;
%                 end
%             end
%         end
%     case 2
%         if temp_rand<p_set(2,1)
%             penalty_time=0;
%         else
%             if temp_rand<p_set(2,1)+p_set(2,2)
%                 penalty_time=5;
%             else
%                 if temp_rand<p_set(2,1)+p_set(2,2)+p_set(2,3)
%                     penalty_time=10;
%                 else
%                     penalty_time=30;
%                 end
%             end
%         end
%     case 3
%         if temp_rand<p_set(3,1)
%             penalty_time=0;
%         else
%             if temp_rand<p_set(3,1)+p_set(3,2)
%                 penalty_time=5;
%             else
%                 if temp_rand<p_set(3,1)+p_set(3,2)+p_set(3,3)
%                     penalty_time=10;
%                 else
%                     penalty_time=30;
%                 end
%             end
%         end
% end