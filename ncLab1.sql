/*1.	�������� ������, ��������� ��� ���������� � �������������. ����������� �� ���� ������������.
*/
select  D.*
  from  DEPARTMENTS D
  order by  D.DEPARTMENT_ID
;

/*2.	�������� ������, ���������� ID, ���+������� (� ���� ������ ������� ����� ������) 
� ����� ����������� ����� ���� ��������. (������������ ������������ �����
� �������������� ������� � ������ � �������� �� �NAME�). ����������� �� ���� �������.
*/
select  C.CUSTOMER_ID,
        C.CUST_FIRST_NAME || ' ' || C.CUST_LAST_NAME as CUST_NAME,
        C.CUST_EMAIL
  from  CUSTOMERS C
  order by  C.CUSTOMER_ID
;

/*3.	�������� ������, ��������� �����������, �������� ������� �� ��� ����� � ��������� �� 100 �� 200 ���. ���., 
���������� �� �� ���������� ���������, �������� (�� ������� � �������) � �������. 
��������� ������ ������ �������� �������, ���, ��������� (��� ���������), email, �������, 
�������� �� ����� �� ������� �������. ����� �������, ��� � ��� ������������� ����� ���������������:
� �������� �� ��� �� 100 �� 150 ���. ���. ����� ���������� 30%, ���� � 35%. ��������� ��������� �� ������ ���.
����������� ������������ between � case.
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

/*4.	������� ������ � ���������������� DE, IT ��� RU. ������������� ������� �� ���� �������, ��������� �������. ����������� �� �������� ������
*/
select  C.COUNTRY_ID as "��� ������",
        C.COUNTRY_NAME as "�������� ������"
  from  COUNTRIES C
  where C.COUNTRY_ID in ('DE', 'IT', 'RU')
  order by  C.COUNTRY_NAME
;

/*5.	������� ���+������� �����������, � ������� � ������� ������ ����� �a� (���������), 
� � ����� ������������ ����� �d� (�� �����, � ����� ��������). ����������� �� �����. 
������������ �������� like � ������� ���������� � ������� ��������.
*/
select  E.FIRST_NAME || ' ' || E.LAST_NAME as EMP_NAME
  from  EMPLOYEES E
  where E.LAST_NAME like '_a%' and
        lower(E.FIRST_NAME) like '%d%'
  order by  E.FIRST_NAME
;

/*6.	������� ����������� � ������� ������� ��� ��� ������ 5 ��������. 
����������� ������ �� ��������� ����� ������� � �����, ����� �� ����� �������, ����� ������ �� �������, ����� ������ �� �����.
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

/*7.	������� ��������� � ������� �� ����������� (������� ��������,
�� ������� ����� �������-�������������� ����������� � ������������ �������). 
����� ��������� ��������� ������ ���� �������, � ������ ���������� �������� ����������� �� ���� ���������. 
������� ������� ��� ���������, �������� ���������, ������� �������� ����� �������, ����������� �� �����.
������� ����� ��������������� ������� � 18%.
*/

select  J.JOB_ID,
        J.JOB_TITLE,
        round(((J.MAX_SALARY + J.MIN_SALARY) * 0.82 / 2), -2) as AVG_SALARY
  from  JOBS J
  order by  AVG_SALARY  desc,
            J.JOB_ID
;

/*8.  ����� �������, ��� ��� ������� ������� �� ��������� A, B, C. ��������� A � ������� � ��������� ������� >= 3500, B >= 1000, 
C � ��� ���������. ������� ���� ��������, ���������� �� �� ��������� � �������� ������� (������� ������� ��������� A), 
����� �� �������. ������� ������� �������, ���, ���������, �����������. � ����������� ��� �������� ��������� A 
������ ���� ������ ���������, VIP-��������, ��� ��������� �������� ����������� ������ �������� ������ (NULL).
*/

select  C.CUST_LAST_NAME,
        C.CUST_FIRST_NAME,
        case
          when C.CREDIT_LIMIT > 3500 then 'A'
          when C.CREDIT_LIMIT > 1000 then 'B'
          else 'C'
        end as CATEGORY,
        case
          when C.CREDIT_LIMIT > 3500 then '��������, VIP-�������'
        end as COMMENTS
  from  CUSTOMERS C
  order by  CATEGORY,
            C.CUST_LAST_NAME
;
/*9.	������� ������ (�� �������� �� �������), � ������� ���� ������ � 1998 ����. ������ �� ������ ����������� � ������ ���� �����������.
������������ ����������� �� ������� extract �� ���� ��� ���������� ������������ ������� � decode ��� ������ �������� ������ �� ��� ������.
���������� �� ������������.
*/

select  extract(month from O.ORDER_DATE) as MONTH
  from  ORDERS O
  where O.ORDER_DATE >= date'1998-01-01' and
        O.ORDER_DATE < date'1999-01-01'
  group by  extract(month from O.ORDER_DATE)
  order by  MONTH
;

select  decode(extract(month from O.ORDER_DATE),
          1,  '������',
          2,  '�������',
          3,  '����',
          4,  '������',
          5,  '���',
          6,  '����',
          7,  '����',
          8,  '������',
          9,  '��������',
          10, '�������',
          11, '������',
          12, '�������'
        ) as MONTH
  from  ORDERS O
  where O.ORDER_DATE >= date'1998-01-01' and
        O.ORDER_DATE < date'1999-01-01'
  group by extract (month from O.ORDER_DATE)
  order by extract (month from O.ORDER_DATE)
;
  
/*10. �������� ���������� ������, ��������� ��� ��������� �������� ������ �������
to_char (������� ��� ������� nls_date_language 3-� ����������). ������ �����������
������������ distinct, ���������� �� ������������.
*/ 
select  distinct trim(to_char(O.ORDER_DATE, 'month', 'nls_date_language=american')) as MONTH --russian  american
  from  ORDERS  O
  where O.ORDER_DATE >= date'1998-01-01' and
        O.ORDER_DATE < date'1999-01-01'
  order by  to_date(MONTH, 'month', 'nls_date_language=american') 
;

/*11. �������� ������, ��������� ��� ���� �������� ������. ������� ����� ������ �������
�� sysdate. ������ ������� ������ ��������� ����������� � ���� ������ ���������
��� ������ � �����������. ��� ����������� ��� ������ ��������������� �������
to_char. ��� ������ ����� �� 1 �� 31 ����� ��������������� �������������� rownum,
������� ������ �� ����� �������, ��� ���������� ����� ����� 30.
*/

--trunc(sysdate,'MM') + rownum  as  DT

select  add_months(last_day(sysdate), -1) + rownum as DT,
        to_char(add_months(last_day(sysdate), -1) + rownum, 'DAY','nls_date_language=american') d1,
        decode(to_char(add_months(last_day(sysdate), -1) + rownum, 'dy', 'nls_date_language=american'),
          'sat' ,'��������',
          'sun','��������'
          ) as COMMENTS
  from  ORDERS O
  where rownum <= extract (day from last_day(sysdate))
;

/*12.	������� ���� ����������� (��� ����������, �������+��� ����� ������, ��� ���������, ��������, �������� - %),
������� �������� �������� �� �������. ��������������� ������������ is not null.
����������� ����������� �� �������� �������� (�� �������� � ��������), ����� �� ���� ����������.
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

/*13.	�������� ���������� �� ����� ������ �� 1995-2000 ���� � ������� ��������� (1 ������� � ������-���� � �.�.).
� ������� ������ ���� 6 �������� � ���, ����� ������ �� 1-��, 2-��, 3-�� � 4-�� ��������, � ����� ����� ����� ������ �� ���.
����������� �� ����. ��������������� ������������ �� ����, � ����� ������������� �� ��������� � case ��� decode,
������� ����� �������� ������� �� ������ �������.*/

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

/*14. ������� �� ������� ������� ��� ����������� ������. ������� ������� ����� �����
��� �������� � �������� ������ ������ � MB ��� GB (� ����� ��������), ��������
������ �� ���������� � HD, � ����� � ������ 30 �������� �������� ������ ��
����������� ����� disk, drive � hard. ������� �������: ��� ������, �������� ������,
��������, ���� (�� ������ � LIST_PRICE), url � ��������. � ���� �������� ������ ����
�������� ����� ����� � ���������� ������� �������� (������, ��� �������� ����� ����
��� � �����). ����������� �� ������� ������ (�� �������� � ��������), ����� �� ����
(�� ������� � �������). ������ ��� �������������� ������� �� �������� ������ ��
������� NN MB/GB (�� ������ ��� ���� ��������������� GB � ���������) c �������
regexp_replace. Like �� ������������, ������ ���� ������������ regexp_like � �����
���������, ��� ������� ���� ������� ������������.
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
--regexp_substr(P.PRODUCT_NAME, '(\d+)\s*(GB|MB)', 1,  1,  'i',  1) ����� � 2 � ����� decode ���� GB ��������
/*15. ������� ����� ���������� �����, ���������� �� ��������� �������. ����� ���������
������� � ������� ������ ���� ������ � ���� ������, �������� �21:30�. ������ ��������
������� ���� � ������� ���� �� ������. ����� ��������������� ����������� �������
to_char/to_date.*/

/*select  (to_char(to_date('15:00','HH24:MI'),  'hh24') - to_char(sysdate,  'hh24'))  * 60  +
        (to_char(to_date('15:00','HH24:MI'),  'mi') - to_char(sysdate,  'mi'))  as  minutes
  from dual
*/
--(add_months(last_day(sysdate), -1) +1) - ������ ���� � ������� ������ 


select  round((to_date('21:30','HH24:MI') - (add_months(last_day(sysdate), -1) +1)) * 24 * 60) dddd
  from  dual
;