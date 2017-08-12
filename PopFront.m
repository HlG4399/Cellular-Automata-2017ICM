function passengers=PopFront(passengers)
if(length(passengers)>1)
    passengers=passengers(2:end);
else
    passengers.v=[];
    passengers.time=[];
end