--Трех клиентов, сумма заказов которых за все время больше всех остальных
declare
    v_cnt       integer := 0;
    v_fio       clients.fio%type;
    v_order     operations.price_for_one%type;
    v_max_order operations.price_for_one%type;
    
    --список клиентов и сумм заказов
    cursor cv_MaxCustomerOrder is
    select
        c.fio,
        sum(o.amount * o.price_for_one)
    from 
        operations o,
        clients c
    where o.client_id = c.id
    group by c.fio
    order by 2 desc;
begin
    open cv_MaxCustomerOrder;
    
    v_cnt       := 0;
    v_max_order := 0;
   
    loop 
        fetch cv_MaxCustomerOrder
        into 
            v_fio,
            v_order;
            
        if (v_max_order = 0) then
            v_max_order := v_order;
        end if;
        
        if (v_max_order = v_order) then
            DBMS_OUTPUT.PUT_LINE(v_fio);
        end if;
        
        v_cnt := v_cnt + 1;
        
        exit when ((v_cnt = 3) or (v_max_order <> v_order) or (cv_MaxCustomerOrder%NOTFOUND));
    end loop;
    close cv_MaxCustomerOrder;     
    
end;
/