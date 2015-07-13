CREATE OR REPLACE PROCEDURE PROC_XML IS  
    --������� ������� (��������, ��������� � ����������� ������), ������� ����� ��������� ������� � ������� XML �� ����� (reqpipe), � �������� ������ � ������� XML � ����� (anspipe)     
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
    --������ ����
    status := DBMS_PIPE.RECEIVE_MESSAGE(DBMS_PIPE.UNIQUE_SESSION_NAME, 10);
    if status <> 0 then
      RAISE_APPLICATION_ERROR(-20011, '������ ��� ��������� �������. ������ = '||status);
    end if;
    
    DBMS_PIPE.UNPACK_MESSAGE(xml);      
    
    --�������� xml �� �����
    --xml := '<request><WarehouseIn><RqId>60023</RqId><supply><ProductId>123000</ProductId><ProductName>������ �1</ProductName><Amount>100</Amount><PriceForOne>10</PriceForOne><Employee>��������� �.�1.</Employee></supply><supply><ProductId>123001</ProductId><ProductName>������ �2</ProductName><Amount>9</Amount><PriceForOne>80</PriceForOne><Employee>��������� �.�.</Employee></supply><supply><ProductId>123002</ProductId><ProductName>������ �3</ProductName><Amount>398</Amount><PriceForOne>70.5</PriceForOne><Employee>������ �.�.</Employee></supply></WarehouseIn></request>';
    --xml := '<request><WarehouseOut><RqId>67890</RqId><charge><ProductId>123000</ProductId><ProductName>������ �1</ProductName><Amount>76</Amount><Employee>��������� �.�.</Employee></charge><charge><ProductId>123001</ProductId><ProductName>������ �2</ProductName><Amount>9</Amount><Employee>��������� �.�.</Employee></charge></WarehouseOut></request>';
    --xml := '<request><Buy><Item><ProductId>123000</ProductId><ProductName>������ �1</ProductName><Amount>7</Amount><Summ>9000</Summ><Employee>��������� �.�.</Employee><CliId>32311</CliId><CliFIO>������� �.�</CliFIO></Item><Item><ProductId>123001</ProductId><ProductName>������ �2</ProductName><Amount>1</Amount><Summ>100</Summ><Employee>��������� �.�.</Employee><CliId>32311</CliId><CliFIO>������� �.�</CliFIO></Item><AllSumm>9100</AllSumm></Buy></request>';
                          
    oper_type := 0;
    
    --���������� ��� ������� (������, ��������, ������� �� ������)
    if (length(xml) - length(replace(xml, 'WarehouseIn')) > 0) then 
        oper_type := 1;
    elsif (length(xml) - length(replace(xml, 'WarehouseOut')) > 0) then 
        oper_type := 2; 
    elsif (length(xml) - length(replace(xml, 'Buy')) > 0) then 
        oper_type := 3;    
    end if;         
    
    --����������� ��� ������� 
    if (oper_type = 0) then
        DBMS_OUTPUT.PUT_LINE('����������� ��� �������.'||xml); 
               
    --������
    elsif (oper_type = 1) then              
        doc      := DBMS_XMLDOM.newDOMDocument(XMLType(xml));                       
        docelem  := DBMS_XMLDOM.getDocumentElement(doc);        
        nodelist := DBMS_XMLDOM.getElementsByTagName(docelem, 'supply');        
                
        DBMS_OUTPUT.put_line('������. '||DBMS_XMLDOM.getlength (nodelist)||' ������.'||chr(13)||chr(10));
        for i in 0..DBMS_XMLDOM.getlength (nodelist)-1 loop 
            --������ ������ �� xml       
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
            
            --���� ����������� ����� � �����������           
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
           
           --����� �� ������
            if (product_exist = 0) then
                insert into products
                values(product_id, product_name);
                
                DBMS_OUTPUT.put_line('�������� ����� � ����������: ProductId = '||product_id||', ProductName = '||product_name);                               
            end if;
            
            --���� ���������� � �����������           
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
            
            --��������� �� ������
            if (employee_exist = 0) then
                DBMS_OUTPUT.put_line('��������� "'||employee||' �� ������ � �����������, ���������� �������� ��������.');
                
            --��������� ������ 
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
                DBMS_OUTPUT.put_line('��������� ��������: ProductId = '||product_id||', ProductName = '||product_name||', Amount = '||amount||', PriceForOne = '||price_for_one||', Employee = '||employee);                       
            end if;                                                              
        end loop;
        
    --��������
    elsif (oper_type = 2) then                     
        doc      := DBMS_XMLDOM.newDOMDocument(XMLType(xml));                       
        docelem  := DBMS_XMLDOM.getDocumentElement(doc);        
        nodelist := DBMS_XMLDOM.getElementsByTagName(docelem, 'charge');        
                
        DBMS_OUTPUT.put_line('��������. '||DBMS_XMLDOM.getlength (nodelist)||' ������.'||chr(13)||chr(10));
        for i in 0..DBMS_XMLDOM.getlength (nodelist)-1 loop 
            --������ ������ �� xml       
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
            
            --���� ����������� ����� � �����������           
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
           
           --����� �� ������
            if (product_exist = 0) then
                --��������� �� ������ � ����
                DBMS_PIPE.SEND_MESSAGE('<answer><'||RqId||'>50920</RqId><Status>-1<Status><StatusDesc>no_data_found<StatusDesc></answer>');                
                DBMS_OUTPUT.put_line('����� �� ������: ProductId = '||product_id||', ProductName = '||product_name);
                RqId := RqId + 1;
            
            --����� ������
            else
                --���� ���������� � �����������           
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
                
                --��������� �� ������
                if (employee_exist = 0) then
                    DBMS_OUTPUT.put_line('��������� "'||employee||' �� ������ � �����������, ���������� �������� ��������.');
                    
                --��������� ������ 
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
                    DBMS_OUTPUT.put_line('��������� ��������: ProductId = '||product_id||', ProductName = '||product_name||', Amount = '||amount||', Employee = '||employee);                       
                end if;
            end if;                                                              
        end loop;
     
    --������� �� ������
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
                
        DBMS_OUTPUT.put_line('������� �� ������. '||DBMS_XMLDOM.getlength (nodelist)||' ������.'||chr(13)||chr(10));
        for i in 0..DBMS_XMLDOM.getlength (nodelist)-1 loop 
            --������ ������ �� xml       
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
            
            --���� ����������� ����� � �����������           
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
           
           --����� �� ������
            if (product_exist = 0) then
                --��������� �� ������ � ����
                DBMS_PIPE.SEND_MESSAGE('<answer><'||RqId||'>50920</RqId><Status>-1<Status><StatusDesc>no_data_found<StatusDesc></answer>');                
                DBMS_OUTPUT.put_line('����� �� ������: ProductId = '||product_id||', ProductName = '||product_name);
                RqId := RqId + 1;
            
            --����� ������
            else
                --���� ���������� � �����������           
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
                
                --��������� �� ������
                if (employee_exist = 0) then
                    DBMS_OUTPUT.put_line('��������� "'||employee||' �� ������ � �����������, ���������� �������� ��������.');
                    
                --��������� ������ 
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
                    DBMS_OUTPUT.put_line('��������� ��������: ProductId = '||product_id||', ProductName = '||product_name||', Amount = '||amount||', Employee = '||employee);                       
                end if;                
                summ_total := summ_total + summ;
            end if;                                                                                      
        end loop; 
        
        --c���� �� ������� ���������� ������ �� ��������� � ����������� ������
        if (summ_total <> all_summ) then
            --��������� �� ������ � ����
            DBMS_PIPE.SEND_MESSAGE('<answer><'||RqId||'>50920</RqId><Status>-1<Status><StatusDesc>'����� �� ������� ���������� ������ ('||summ_total||') �� ��������� � ����������� ������ ('||all_summ||')'<StatusDesc></answer>');                
            DBMS_OUTPUT.put_line('����� �� ������� ���������� ������ ('||summ_total||') �� ��������� � ����������� ������ ('||all_summ||')');
            RqId := RqId + 1;   
        end if;                  
    end if;    
end;
/