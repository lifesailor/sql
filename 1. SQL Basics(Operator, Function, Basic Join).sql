-- 1. Operators
select 'Data' || 123
  from dual
;

select *
    from TED_SCORE
  where kor >= 80 or eng >= 80 and math < 70
;

select *
     from TED_SCORE
  where (kor >= 80 or eng >= 80) and math < 70
;

select *
    from TED_STUDENT
  where student_no like 'A0_2'
;

SELECT a.*
   from ted_score a
  where exists(select x.student_no
                from ted_student x
                where x.student_no = a.student_no0
                  and x.grade_class_no = '0101')
;

-- 2. Functions
select instr('database', 'ab')
    ,  instr('database', 'a', 3)
    ,  instr('database', 'a', 1, 2)
    ,  instr('database', 'a', -1, 2)
  from dual
;

select length('database')
    ,  length('데이터베이스')
    ,  lengthb('데이터베이스')
from dual
;

select chr(65)
    ,  ascii('A')
    ,  concat('Data', 'base')
    ,  'Data' || 'base'
    ,  initcap('database')
    ,  lower('DATABASE')
    ,  upper('database')
  from dual
;

select lpad('123', 6)
    ,  lpad('123', 6, '0')
    ,  lpad('12345', 3, '0')
    ,  rpad('123', 6, '0')
    ,  rpad('12345', 3, '0')
  from dual
;

select ltrim('    12345')
    ,  ltrim('abcdef12345', 'a')
    ,  rtrim('aabcdef1234555', '5')
    ,  trim('   abcd    ')
  from dual
;

select replace('*123*45*', '*', '+')
    ,  replace('*123*45*', '*', 'AB')
    ,  translate('*123*45*', '*', '+')
    ,  translate('diat2ab3ase', '123', 'ABC')
  from dual
;

select substr('database', 5)
    ,  substr('database', 5, 2)
    ,  substr('database', -4)

    ,  substr('홍길동', 2)
    ,  substrb('홍길동', 4)
  from dual
;

select add_months('2017-07-21', 3)
    ,  last_day('2017-07-21')

    ,  months_between('2017-07-31', '2017-04-30')
    ,  months_between('2017-04-30', '2017-07-31')
    ,  months_between('2017-07-31', '2017-04-29')

    ,  next_day('2017-07-21', 4)

    ,  round(to_date('2017-07-16'), 'month')
    ,  round(to_date('2017-07-15'), 'month')

    ,  trunc(to_date('2017-07-16'), 'month')
    ,  trunc(to_date('2017-07-15'), 'month')
  from dual
;

select student_no
    ,  kor
    ,  eng
    ,  math

    ,  decode(substr(student_no, -1), '1', '1번') as decode1
    ,  decode(substr(student_no, -1), '1', '1번', '나머지') as decode2

    ,  case when substr(student_no, -1) = '1' then '1번' end as case1
    ,  case when substr(student_no, -1) = '1' then '1번' else '나머지' end as case2

  from ted_score
  where year_mon = '2017/07'
;

-- 3. Join
select count(*) from ted_score
    where year_mon = '2017/07'
;

select a.student_no
    ,  b.student_nm
    ,  c.region_nm
    ,  a.kor
    ,  a.eng
    ,  a.math

    from ted_score a
      ,  ted_student b
      ,  ted_region c

    where a.year_mon = '2017/07'
      and a.student_no = b.student_no(+)
      and b.region_id = c.region_id(+)
;

-- inner join
select a.student_no
    ,  a.student_nm
    ,  b.region_nm

    from ted_student a
      ,  ted_region b
   where a.region_id = b.region_id
;

--left outer join
select a.student_no
    ,  a.student_nm
    ,  b.region_nm
  from TED_STUDENT a
    ,  TED_REGION b
 where a.region_id = b.region_id(+)
;

-- cross join
select a.*, b.*
    from ted_region a
      ,  ted_dummy b
   where b.numval <= 5
;

-- self join
select b.*
  from ted_dept a
    ,  ted_dept b
 where a.dept_id = 3
   and a.dept_id = b.up_dept_id
;

--set
select a.*
  from (select region_id, region_nm
          from ted_region

        union all

        select region_id, region_nm
          from ted_region)  a
;

select *
    from ted_score
   where year_mon = '2017/07'
     and student_no in (select student_no
                          from ted_student
                         where region_id = 1
                        )
;

select a.*
    from ted_score a
       , ted_student b
   where a.year_mon = '2017/07'
     and a.student_no = b.student_no
     and b.region_id = 1
;

-- subquery
select a.student_no
    , round(b.total / 3, 2) as 평균
    , case when b.total / 3 >= 80 then 'A등급'
           when b.total / 3 >= 70 then 'B등급'
           when b.total / 3 >= 60 then 'C등급'
           else 'F등급' end as 등급
    from ted_score a
      , (select student_no
              , nvl(kor, 0) + nvl(eng, 0) + nvl(math, 0) as total
            from ted_score
          where year_mon = '2017/07'
        ) b
  where year_mon = '2017/07'
    and a.student_no = b.student_no
;
