/*1.	Написать запрос, выводящий всю информацию о департаментах. Упорядочить по коду департамента.
*/
select  D.*
  from  DEPARTMENTS D
  order by  D.DEPARTMENT_ID
;

/*2.	Написать запрос, выбирающий ID, имя+фамилию (в виде одного столбца через пробел) 
и адрес электронной почты всех клиентов. (Использовать конкатенацию строк
и переименование столбца с именем и фамилией на «NAME»). Упорядочить по коду клиента.
*/
select  C.CUSTOMER_ID,
        C.CUST_FIRST_NAME || ' ' || C.CUST_LAST_NAME as CUST_NAME,
        C.CUST_EMAIL
  from  CUSTOMERS C
  order by  C.CUSTOMER_ID
;

/*3.	Написать запрос, выводящий сотрудников, зарплата которых за год лежит в диапазоне от 100 до 200 тыс. дол., 
упорядочив их по занимаемой должности, зарплате (от большей к меньшей) и фамилии. 
Выбранные данные должны включать фамилию, имя, должность (код должности), email, телефон, 
зарплату за месяц за вычетом налогов. Будем считать, что у нас прогрессивная шкала налогообложения:
с зарплаты за год от 100 до 150 тыс. дол. налог составляет 30%, выше – 35%. Результат округлить до целого дол.
Обязательно использовать between и case.
*/
select  E.LAST_NAME,
        E.FIRST_NAME,
        E.JOB_ID,
        E.EMAIL,
        E.PHONE_NUMBER,
        case
          when E.SALARY * 12 between 100000 and 150000 then
            E.SALARY * 0.3
          when  E.SALARY * 12 between 150000 and 200000 then  
            E.SALARY * 0.35
        end
        as  SALARY
  from  EMPLOYEES E
  where E.SALARY * 12 between 100000 and 200000
  order by  E.JOB_ID,
            E.SALARY desc,
            E.LAST_NAME
;

/*4.	Выбрать страны с идентификаторами DE, IT или RU. Переименовать столбцы на «Код страны», «Название страны». Упорядочить по названию страны
*/
select  C.COUNTRY_ID as "Код страны",
        C.COUNTRY_NAME as "Название страны"
  from  COUNTRIES C
  where C.COUNTRY_ID in ('DE', 'IT', 'RU')
  order by  C.COUNTRY_NAME
;

/*5.	Выбрать имя+фамилия сотрудников, у которых в фамилии вторая буква «a» (латинская), 
а в имени присутствует буква «d» (не важно, в каком регистре). Упорядочить по имени. 
Использовать оператор like и функции приведения к нужному регистру.
*/
select  E.FIRST_NAME || ' ' || E.LAST_NAME as EMP_NAME
  from  EMPLOYEES E
  where E.LAST_NAME like '_a%' and
        lower(E.FIRST_NAME) like '%d%'
  order by  E.FIRST_NAME
;

/*6.	Выбрать сотрудников у которых фамилия или имя короче 5 символов. 
Упорядочить записи по суммарной длине фамилии и имени, затем по длине фамилии, затем просто по фамилии, затем просто по имени.
*/
select  E.*
  from  EMPLOYEES E
  where length(E.LAST_NAME) <= 5 or
        length(E.FIRST_NAME) <= 5
  order by  length(E.LAST_NAME) + length(E.FIRST_NAME),
            length(E.LAST_NAME),
            E.LAST_NAME,
            E.FIRST_NAME
;

/*7.	Выбрать должности в порядке их «выгодности» (средней зарплаты,
за среднюю взять среднее-арифметическое минимальной и максимальной зарплат). 
Более «выгодные» должности должны быть первыми, в случае одинаковой зарплаты упорядочить по коду должности. 
Вывести столбцы код должности, название должности, средняя зарплата после налогов, округленная до сотен.
Считаем шкалу налогообложения плоской – 18%.
*/

select  J.JOB_ID,
        J.JOB_TITLE,
        round(((J.MAX_SALARY + J.MIN_SALARY) * 0.82 / 2), -2) as AVG_SALARY
  from  JOBS J
  order by  AVG_SALARY  desc,
            J.JOB_ID
;

/*8.  Будем считать, что все клиенты делятся на категории A, B, C. Категория A – клиенты с кредитным лимитом >= 3500, B >= 1000, 
C – все остальные. Вывести всех клиентов, упорядочив их по категории в обратном порядке (сначала клиенты категории A), 
затем по фамилии. Вывести столбцы фамилия, имя, категория, комментарий. В комментарии для клиентов категории A 
должно быть строка «Внимание, VIP-клиенты», для остальных клиентов комментарий должен остаться пустым (NULL).
*/

select  C.CUST_LAST_NAME,
        C.CUST_FIRST_NAME,
        case
          when C.CREDIT_LIMIT > 3500 then 'A'
          when C.CREDIT_LIMIT > 1000 then 'B'
          else 'C'
        end as CATEGORY,
        case
          when C.CREDIT_LIMIT > 3500 then 'Внимание, VIP-клиенты'
        end as COMMENTS
  from  CUSTOMERS C
  order by  CATEGORY,
            C.CUST_LAST_NAME
;
/*9.	Вывести месяцы (их название на русском), в которые были заказы в 1998 году. Месяцы не должны повторяться и должны быть упорядочены.
Использовать группировку по функции extract от даты для исключения дублирования месяцев и decode для выбора названия месяца по его номеру.
Подзапросы не использовать.
*/

select  extract(month from O.ORDER_DATE) as MONTH
  from  ORDERS O
  where O.ORDER_DATE >= date'1998-01-01' and
        O.ORDER_DATE < date'1999-01-01'
  group by  extract(month from O.ORDER_DATE)
  order by  MONTH
;

select  decode(extract(month from O.ORDER_DATE),
          1,  'Январь',
          2,  'Февраль',
          3,  'Март',
          4,  'Апрель',
          5,  'Май',
          6,  'Июнь',
          7,  'Июль',
          8,  'Август',
          9,  'Сентябрь',
          10, 'Октябрь',
          11, 'Ноябрь',
          12, 'Декабрь'
        ) as MONTH
  from  ORDERS O
  where O.ORDER_DATE >= date'1998-01-01' and
        O.ORDER_DATE < date'1999-01-01'
  group by extract (month from O.ORDER_DATE)
  order by extract (month from O.ORDER_DATE)
;
  
/*10. Написать предыдущий запрос, используя для получения названия месяца функцию
to_char (указать для функции nls_date_language 3-м параметром). Вместо группировки
использовать distinct, подзапросы не использовать.
*/ 
select  distinct trim(to_char(O.ORDER_DATE, 'month', 'nls_date_language=american')) as MONTH --russian  american
  from  ORDERS  O
  where O.ORDER_DATE >= date'1998-01-01' and
        O.ORDER_DATE < date'1999-01-01'
  order by  to_date(MONTH, 'month', 'nls_date_language=american') 
;

/*11. Написать запрос, выводящий все даты текущего месяца. Текущий месяц должен браться
из sysdate. Второй столбец должен содержать комментарий в виде строки «Выходной»
для суббот и воскресений. Для определения дня недели воспользоваться функций
to_char. Для выбора чисел от 1 до 31 можно воспользоваться псевдостолбцом rownum,
выбирая данные из любой таблицы, где количество строк более 30.
*/

--trunc(sysdate,'MM') + rownum  as  DT

select  add_months(last_day(sysdate), -1) + rownum as DT,
        to_char(add_months(last_day(sysdate), -1) + rownum, 'DAY','nls_date_language=american') d1,
        decode(to_char(add_months(last_day(sysdate), -1) + rownum, 'dy', 'nls_date_language=american'),
          'sat' ,'Выходной',
          'sun','Выходной'
          ) as COMMENTS
  from  ORDERS O
  where rownum <= extract (day from last_day(sysdate))
;

/*12.	Выбрать всех сотрудников (код сотрудника, фамилия+имя через пробел, код должности, зарплата, комиссия - %),
которые получают комиссию от заказов. Воспользоваться конструкцией is not null.
Упорядочить сотрудников по проценту комиссии (от большего к меньшему), затем по коду сотрудника.
*/

select  E.EMPLOYEE_ID,
        E.FIRST_NAME || ' ' || E.LAST_NAME as EMP_NAME,
        E.JOB_ID,
        E.SALARY,
        E.COMMISSION_PCT  
  from  EMPLOYEES E
  where E.COMMISSION_PCT is not null
  order by  E.COMMISSION_PCT desc,
            E.JOB_ID
;

/*13.	Получить статистику по сумме продаж за 1995-2000 годы в разрезе кварталов (1 квартал – январь-март и т.д.).
В выборке должно быть 6 столбцов – год, сумма продаж за 1-ый, 2-ой, 3-ий и 4-ый квартала, а также общая сумма продаж за год.
Упорядочить по году. Воспользоваться группировкой по году, а также суммированием по выражению с case или decode,
которое будут отделять продажи за нужный квартал.*/

select  extract(year from O.ORDER_DATE) as YEAR,
        sum(case when to_char(O.ORDER_DATE, 'q') = 1 then O.ORDER_TOTAL end) as QUART1_SUM,
        sum(case when to_char(O.ORDER_DATE, 'q') = 2 then O.ORDER_TOTAL end) as QUART2_SUM,
        sum(case when to_char(O.ORDER_DATE, 'q') = 3 then O.ORDER_TOTAL end) as QUART3_SUM,
        sum(case when to_char(O.ORDER_DATE, 'q') = 4 then O.ORDER_TOTAL end) as QUART4_SUM,
        sum(O.ORDER_TOTAL) as YEAR_SUM
  from  ORDERS  O
  where O.ORDER_DATE >= date'1995-01-01' and O.ORDER_DATE < date'2001-01-01'
  group by extract(year  from  O.ORDER_DATE)
  order by  YEAR
;

/*14. Выбрать из таблицы товаров всю оперативную память. Считать таковой любой товар
для которого в названии указан размер в MB или GB (в любом регистре), название
товара не начинается с HD, а также в первых 30 символах описания товара не
встречаются слова disk, drive и hard. Вывести столбцы: код товара, название товара,
гарантия, цена (по прайсу – LIST_PRICE), url в каталоге. В поле гарантия должно быть
выведено целое число – количество месяцев гарантии (учесть, что гарантия может быть
год и более). Упорядочить по размеру памяти (от большего к меньшему), затем по цене
(от меньшей к большей). Размер для упорядочивания извлечь из названия товара по
шаблону NN MB/GB (не забыть при этом сконвертировать GB в мегабайты) c помощью
regexp_replace. Like не использовать, вместо него использовать regexp_like с явным
указанием, что регистр букв следует игнорировать.
*/

select  P.PRODUCT_ID,
        P.PRODUCT_NAME,
        substr(P.WARRANTY_PERIOD, 2, 2) * 12 + substr(P.WARRANTY_PERIOD, 5, 2) as WARRANTY_PERIOD,
        P.LIST_PRICE,
        P.CATALOG_URL
  from  PRODUCT_INFORMATION P
  where regexp_like(P.PRODUCT_NAME, '(\d+)\s*(GB|MB)', 'i')  and  
        not regexp_like(P.PRODUCT_NAME, '^HD', 'i') and
        not regexp_like(substr(P.PRODUCT_DESCRIPTION, 1, 30), 'disk|drive|hard')
  order by  decode(regexp_substr(P.PRODUCT_NAME, '(\d+)\s*(GB|MB)', 1, 1, 'i', 2),
                  'GB', regexp_substr(P.PRODUCT_NAME, '(\d+)\s*(GB|MB)', 1, 1, 'i', 1) * 1024,
                  regexp_substr(P.PRODUCT_NAME, '(\d+)\s*(GB|MB)', 1, 1, 'i', 1)) desc,
            P.LIST_PRICE desc   
;
--regexp_substr(P.PRODUCT_NAME, '(\d+)\s*(GB|MB)', 1,  1,  'i',  1) взять с 2 и через decode если GB заменить
/*15. Вывести целое количество минут, оставшихся до окончания занятий. Время окончания
занятия в запросе должно быть задано в виде строки, например «21:30». Явного указания
текущей даты в запросе быть не должно. Можно воспользоваться комбинацией функций
to_char/to_date.*/

/*select  (to_char(to_date('15:00','HH24:MI'),  'hh24') - to_char(sysdate,  'hh24'))  * 60  +
        (to_char(to_date('15:00','HH24:MI'),  'mi') - to_char(sysdate,  'mi'))  as  minutes
  from dual
*/
--(add_months(last_day(sysdate), -1) +1) - первый день в текущем месяце 


select  round((to_date('21:30','HH24:MI') - (add_months(last_day(sysdate), -1) +1)) * 24 * 60) dddd
  from  dual
;