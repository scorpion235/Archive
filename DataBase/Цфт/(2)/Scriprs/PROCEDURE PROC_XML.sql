CREATE OR REPLACE PROCEDURE PROC_XML IS  
    --Создать процесс (например, процедура с бесконечным циклом), которая будет принимать запросы в формате XML из пайпы (reqpipe), и отдавать ответы в формате XML в пайпу (anspipe)     
    status         number;    
    xml            varchar2(2000);
    oper_type      integer;
    doc            DBMS_XMLDOM.DOMDocument;
    docelem        DBMS_XMLDOM.DOMElement; 
    nodelist       DBMS_XMLDOM.DOMNodelist;
    node           DBMS_XMLDOM.DOMNode;
    childnode      DBMS_XMLDOM.DOMNode;
    product_id     products.id%type;
    product_name   products.name%type;
    amount         operations.amount%type;
    price_for_one  operations.price_for_one%type;
    employee       employees.fio%type;
    summ           operations.price_for_one%type;
    client_id      clients.id%type;
    client_fio     clients.fio%type;
    all_summ       operations.price_for_one%type;
    summ_total     operations.price_for_one%type;
    product_exist  integer;
    employee_exist integer;    
    RqId           integer := 1000;    
begin
    --читаем пайп
    status := DBMS_PIPE.RECEIVE_MESSAGE(DBMS_PIPE.UNIQUE_SESSION_NAME, 10);
    if status <> 0 then
      RAISE_APPLICATION_ERROR(-20011, 'Ошибка при получении запроса. Статус = '||status);
    end if;
    
    DBMS_PIPE.UNPACK_MESSAGE(xml);      
    
    --тестовые xml из файла
    --xml := '<request><WarehouseIn><RqId>60023</RqId><supply><ProductId>123000</ProductId><ProductName>Деталь №1</ProductName><Amount>100</Amount><PriceForOne>10</PriceForOne><Employee>Сухоруков И.А1.</Employee></supply><supply><ProductId>123001</ProductId><ProductName>Деталь №2</ProductName><Amount>9</Amount><PriceForOne>80</PriceForOne><Employee>Сухоруков И.А.</Employee></supply><supply><ProductId>123002</ProductId><ProductName>Деталь №3</ProductName><Amount>398</Amount><PriceForOne>70.5</PriceForOne><Employee>Иванов Е.В.</Employee></supply></WarehouseIn></request>';
    --xml := '<request><WarehouseOut><RqId>67890</RqId><charge><ProductId>123000</ProductId><ProductName>Деталь №1</ProductName><Amount>76</Amount><Employee>Сухоруков И.А.</Employee></charge><charge><ProductId>123001</ProductId><ProductName>Деталь №2</ProductName><Amount>9</Amount><Employee>Сухоруков И.А.</Employee></charge></WarehouseOut></request>';
    --xml := '<request><Buy><Item><ProductId>123000</ProductId><ProductName>Деталь №1</ProductName><Amount>7</Amount><Summ>9000</Summ><Employee>Сухоруков И.А.</Employee><CliId>32311</CliId><CliFIO>Федоров И.Б</CliFIO></Item><Item><ProductId>123001</ProductId><ProductName>Деталь №2</ProductName><Amount>1</Amount><Summ>100</Summ><Employee>Сухоруков И.А.</Employee><CliId>32311</CliId><CliFIO>Федоров И.Б</CliFIO></Item><AllSumm>9100</AllSumm></Buy></request>';
                          
    oper_type := 0;
    
    --определяем тип запроса (приход, отгрузка, продажа со склада)
    if (length(xml) - length(replace(xml, 'WarehouseIn')) > 0) then 
        oper_type := 1;
    elsif (length(xml) - length(replace(xml, 'WarehouseOut')) > 0) then 
        oper_type := 2; 
    elsif (length(xml) - length(replace(xml, 'Buy')) > 0) then 
        oper_type := 3;    
    end if;         
    
    --неизвестный тип запроса 
    if (oper_type = 0) then
        DBMS_OUTPUT.PUT_LINE('Неизвестный тип запроса.'||xml); 
               
    --приход
    elsif (oper_type = 1) then              
        doc      := DBMS_XMLDOM.newDOMDocument(XMLType(xml));                       
        docelem  := DBMS_XMLDOM.getDocumentElement(doc);        
        nodelist := DBMS_XMLDOM.getElementsByTagName(docelem, 'supply');        
                
        DBMS_OUTPUT.put_line('ПРИХОД. '||DBMS_XMLDOM.getlength (nodelist)||' товара.'||chr(13)||chr(10));
        for i in 0..DBMS_XMLDOM.getlength (nodelist)-1 loop 
            --парсим данные из xml       
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'ProductId');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            product_id    := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ProductId: '||product_id);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'ProductName');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            product_name  := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ProductName: '||product_name);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Amount');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            amount        := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Amount: '||amount);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'PriceForOne');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            price_for_one := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('PriceForOne: '||price_for_one);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Employee');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            employee      := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Employee: '||employee); 
            
            --ищем поступивший товар в справочнике           
            select case
                when exists
                (
                    select 1
                    from products
                    where id = product_id
                ) 
                then 1
                else 0
            end
            into product_exist
            from dual;
           
           --товар не найден
            if (product_exist = 0) then
                insert into products
                values(product_id, product_name);
                
                DBMS_OUTPUT.put_line('Добавлен товар в справочник: ProductId = '||product_id||', ProductName = '||product_name);                               
            end if;
            
            --ищем кладовщика в справочнике           
            select case
                when exists
                (
                    select 1
                    from employees
                    where fio = employee
                ) 
                then 1
                else 0
            end
            into employee_exist
            from dual;
            
            --кладовщик не найден
            if (employee_exist = 0) then
                DBMS_OUTPUT.put_line('Кладовщик "'||employee||' не найден в справочнике, добавление операции отменено.');
                
            --кладовщик найден 
            else         
                insert into operations
                values
                (
                    (select max(id) + 1 from operations), 
                    1,
                    sysdate,
                    (select id from employees where fio = employee),
                    product_id,
                    amount,
                    to_number(price_for_one),
                    null
                );
                DBMS_OUTPUT.put_line('Добавлена операция: ProductId = '||product_id||', ProductName = '||product_name||', Amount = '||amount||', PriceForOne = '||price_for_one||', Employee = '||employee);                       
            end if;                                                              
        end loop;
        
    --отгрузка
    elsif (oper_type = 2) then                     
        doc      := DBMS_XMLDOM.newDOMDocument(XMLType(xml));                       
        docelem  := DBMS_XMLDOM.getDocumentElement(doc);        
        nodelist := DBMS_XMLDOM.getElementsByTagName(docelem, 'charge');        
                
        DBMS_OUTPUT.put_line('ОТГРУЗКА. '||DBMS_XMLDOM.getlength (nodelist)||' товара.'||chr(13)||chr(10));
        for i in 0..DBMS_XMLDOM.getlength (nodelist)-1 loop 
            --парсим данные из xml       
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'ProductId');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            product_id    := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ProductId: '||product_id);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'ProductName');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            product_name  := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ProductName: '||product_name);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Amount');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            amount        := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Amount: '||amount);                       
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Employee');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            employee      := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Employee: '||employee); 
            
            --ищем поступивший товар в справочнике           
            select case
                when exists
                (
                    select 1
                    from products
                    where id = product_id
                ) 
                then 1
                else 0
            end
            into product_exist
            from dual;
           
           --товар не найден
            if (product_exist = 0) then
                --сообщение об ошибке в пайп
                DBMS_PIPE.SEND_MESSAGE('<answer><'||RqId||'>50920</RqId><Status>-1<Status><StatusDesc>no_data_found<StatusDesc></answer>');                
                DBMS_OUTPUT.put_line('Товар не найден: ProductId = '||product_id||', ProductName = '||product_name);
                RqId := RqId + 1;
            
            --товар найден
            else
                --ищем кладовщика в справочнике           
                select case
                    when exists
                    (
                        select 1
                        from employees
                        where fio = employee
                    ) 
                    then 1
                    else 0
                end
                into employee_exist
                from dual;
                
                --кладовщик не найден
                if (employee_exist = 0) then
                    DBMS_OUTPUT.put_line('Кладовщик "'||employee||' не найден в справочнике, добавление операции отменено.');
                    
                --кладовщик найден 
                else         
                    insert into operations
                    values
                    (
                        (select max(id) + 1 from operations), 
                        2,
                        sysdate,
                        (select id from employees where fio = employee),
                        product_id,
                        amount,
                        null,
                        null
                    );
                    DBMS_OUTPUT.put_line('Добавлена операция: ProductId = '||product_id||', ProductName = '||product_name||', Amount = '||amount||', Employee = '||employee);                       
                end if;
            end if;                                                              
        end loop;
     
    --продажа со склада
    elsif (oper_type = 3) then
        summ_total := 0;
    
        doc      := DBMS_XMLDOM.newDOMDocument(XMLType(xml));                       
        docelem  := DBMS_XMLDOM.getDocumentElement(doc);        
        nodelist := DBMS_XMLDOM.getElementsByTagName(docelem, 'Buy');
        
        nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'AllSumm');
        node          := DBMS_XMLDOM.item(nodelist, 0);
        childnode     := DBMS_XMLDOM.getFirstChild(node);
        all_summ      := DBMS_XMLDOM.getNodeValue(childnode);               
        DBMS_OUTPUT.put_line('AllSumm: '||all_summ);        
                
        DBMS_OUTPUT.put_line('ПРОДАЖА СО СКЛАДА. '||DBMS_XMLDOM.getlength (nodelist)||' товара.'||chr(13)||chr(10));
        for i in 0..DBMS_XMLDOM.getlength (nodelist)-1 loop 
            --парсим данные из xml       
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'ProductId');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            product_id    := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ProductId: '||product_id);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'ProductName');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            product_name  := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ProductName: '||product_name);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Amount');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            amount        := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Amount: '||amount);                       
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Summ');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            summ          := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Summ: '||summ);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'Employee');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            employee      := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('Employee: '||employee); 
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'CliId');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            client_id     := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ClientID: '||client_id);
            
            nodelist      := DBMS_XMLDOM.getElementsByTagName(docelem, 'CliFIO');
            node          := DBMS_XMLDOM.item(nodelist, i);
            childnode     := DBMS_XMLDOM.getFirstChild(node);
            client_fio    := DBMS_XMLDOM.getNodeValue(childnode);
            DBMS_OUTPUT.put_line('ClientFIO: '||client_fio);
            
            --ищем поступивший товар в справочнике           
            select case
                when exists
                (
                    select 1
                    from products
                    where id = product_id
                ) 
                then 1
                else 0
            end
            into product_exist
            from dual;
           
           --товар не найден
            if (product_exist = 0) then
                --сообщение об ошибке в пайп
                DBMS_PIPE.SEND_MESSAGE('<answer><'||RqId||'>50920</RqId><Status>-1<Status><StatusDesc>no_data_found<StatusDesc></answer>');                
                DBMS_OUTPUT.put_line('Товар не найден: ProductId = '||product_id||', ProductName = '||product_name);
                RqId := RqId + 1;
            
            --товар найден
            else
                --ищем кладовщика в справочнике           
                select case
                    when exists
                    (
                        select 1
                        from employees
                        where fio = employee
                    ) 
                    then 1
                    else 0
                end
                into employee_exist
                from dual;
                
                --кладовщик не найден
                if (employee_exist = 0) then
                    DBMS_OUTPUT.put_line('Кладовщик "'||employee||' не найден в справочнике, добавление операции отменено.');
                    
                --кладовщик найден 
                else         
                    insert into operations
                    values
                    (
                        (select max(id) + 1 from operations), 
                        2,
                        sysdate,
                        (select id from employees where fio = employee),
                        product_id,
                        amount,
                        null,
                        null
                    );
                    DBMS_OUTPUT.put_line('Добавлена операция: ProductId = '||product_id||', ProductName = '||product_name||', Amount = '||amount||', Employee = '||employee);                       
                end if;                
                summ_total := summ_total + summ;
            end if;                                                                                      
        end loop; 
        
        --cумма по записям проданного товара не совпадает с контрольной суммой
        if (summ_total <> all_summ) then
            --сообщение об ошибке в пайп
            DBMS_PIPE.SEND_MESSAGE('<answer><'||RqId||'>50920</RqId><Status>-1<Status><StatusDesc>'Сумма по записям проданного товара ('||summ_total||') не совпадает с контрольной суммой ('||all_summ||')'<StatusDesc></answer>');                
            DBMS_OUTPUT.put_line('Сумма по записям проданного товара ('||summ_total||') не совпадает с контрольной суммой ('||all_summ||')');
            RqId := RqId + 1;   
        end if;                  
    end if;    
end;
/