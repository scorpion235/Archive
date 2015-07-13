create or replace function get_min
  (pVal1 number := null, 
   pVal2 number := null, 
   pVal3 number := null) 
return number
is
  min_value number;
begin
  min_value := pVal1;
  
  if (pVal2 < min_value) then
    min_value := pVal2;
  end if;
  
  if (pVal3 < min_value) then
    min_value := pVal3;
  end if;
     
  return min_value;   
end;
