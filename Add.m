function passengers=Add(passengers,temp_passenger)
if(isempty(passengers))
    passengers=temp_passenger;
    return
end
if(isempty(passengers(1).time))
    passengers(1)=temp_passenger(1);
else
    passengers(length(passengers)+1)=temp_passenger;
end