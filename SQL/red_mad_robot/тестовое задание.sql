/*
Есть таблица(table) в которой следующий список столбцов:
userId    - идентификатор пользователя
eventName - название события
time      - время когда пришло событие
product   - продукт, который пользователь скачал/купил или на стрианице корторого находится, если событие не связано с продуктом, то значение null

Ниже представленны возможные значения для столбца eventName:
launch      - событие входа
register    - пользователь зарегестрировался
download    - что-то скачал
buy         - что-то купил
update      - что-то обновил
pageVisited - посетил страницу продукта, который можно скачать, обновить или купить
        
напишите sql запрос, который разобьёт пользователей на понедельные кагорты
и посчитает конверсию в первую загрузку внутри этих кагорт
дополнительные условия:
- первый заход пользователя был не раньше '2023-03-01'
- принадлежность к кагорте определяется по дате регистрации
- ожидаемый вывод: кагорта, конверсия
*/ 
  
  
select s1.week_no, -- кагорта

       case
         when coalesce(s1.register_user_cnt, 0) = 0
         then 0
         else coalesce(s2.min_time_download_cnt, 0) / s1.register_user_cnt
       end
       conversion -- конверсия
from  
(
    select date_trunc('week', time) week_no,          -- кагорта
           count(userId)            register_user_cnt -- количество зарегестрированных пользователей
      from table
     where time      >= '2023-03-01'
       and eventName  = 'register' 
     group by date_trunc('week', time)
) s1

left join 
(
    select s.week_no,                                       -- кагорта
           count(s.min_time_download) min_time_download_cnt -- количество первых загрузок
    from 
    (
        select date_trunc('week', time) week_no,          -- кагорта
               min(time)                min_time_download -- первая загрузка
          from table
         where time      >= '2023-03-01'
           and eventName  = 'download'
         group by date_trunc('week', time),
                  userId
    ) s
) s2
on s2.week_no = s1.week_no