--1. 가로로 펼치기
select student_no
    ,  sum(case when substr(year_mon, -2) = '06' then kor end) as 국어6월
    ,  sum(case when substr(year_mon, -2) = '07' then kor end) as 국어7월
    ,  sum(case when substr(year_mon, -2) = '08' then kor end) as 국어8월
    ,  sum(kor) as 총점
    from ted_score
    where year_mon like '2017%'
    and student_no = 'A099'
    group by student_no
;

--2. 세로로 펼치기
select a.*, b.*
    from(
      select student_no
      ,  sum(case when substr(year_mon, -2) = '06' then kor end) as 국어6월
      ,  sum(case when substr(year_mon, -2) = '07' then kor end) as 국어7월
      ,  sum(case when substr(year_mon, -2) = '08' then kor end) as 국어8월
      ,  sum(kor) as 총점
      from ted_score
      where year_mon like '2017%'
      and student_no = 'A099'
      group by student_no
    ) a,
    ted_dummy b
  where b.numval <= 3
;

--3. 최종 결과물
select a.student_no
    ,  case when numval = 1 then '2017/06'
            when numval = 2 then '2017/07'
            when numval = 3 then '2017/08' end as year_mon
    ,  case when numval = 1 then 국어6월
            when numval = 2 then 국어7월
            when numval = 3 then 국어8월 end 국어
    from(
      select student_no
      ,  sum(case when substr(year_mon, -2) = '06' then kor end) as 국어6월
      ,  sum(case when substr(year_mon, -2) = '07' then kor end) as 국어7월
      ,  sum(case when substr(year_mon, -2) = '08' then kor end) as 국어8월
      ,  sum(kor) as 총점
      from ted_score
      where year_mon like '2017%'
      and student_no = 'A099'
      group by student_no
    ) a,
    ted_dummy b
  where b.numval <= 3
;

--4. 숙제 - Cross Join
select decode(d.flag, 1, c.acct_id, NULL) as 계정ID
    ,  decode(d.flag, 1, max(c.acct_nm), 'TOTAL') as 계정명
    ,  sum(c.last_year) as 전년누계
    ,  sum(c.last_mon)  as 전월누계
    ,  sum(c.this_mon)  as 당월
    ,  sum(c.last_mon + c.this_mon) as 당월누계
    ,  sum(c.last_year + c.last_mon + c.this_mon) as 계
  from (select a.acct_id
             , a.acct_nm
             , nvl(b.last_year,0) as last_year
             , nvl(b.last_mon, 0) as last_mon
             , nvl(b.this_mon, 0) as this_mon
          from ted_account a
             , (select a.acct_id
                     , sum(case when a.year_mon < substr(:year_mon, 1, 4) then a.cost end) as last_year
                     , sum(case when substr(:year_mon, 1, 4) < a.year_mon and a.year_mon < :year_mon
                                then a.cost end) as last_mon
                     , sum(case when a.year_mon = :year_mon then a.cost end) as this_mon

                  from ted_cost a
                 where a.year_mon <= :year_mon
                 group by a.acct_id
               ) b
         where a.acct_id = b.acct_id(+)
        ) c,
        (select 1 as flag from dual union all
         select 2 as flag from dual
        ) d
    group by d.flag, decode(d.flag, 1, c.acct_id, NULL)
    order by d.flag, decode(d.flag, 1, c.acct_id, NULL), decode(d.flag, 1,  sum(c.last_year + c.last_mon + c.this_mon))
;

select c.acct_id as 계정ID
    ,  decode(grouping(c.acct_id), 1, '합계', max(c.acct_nm)) as 계정명
    ,  sum(c.last_year) as 전년누계
    ,  sum(c.last_mon)  as 전월누계
    ,  sum(c.this_mon)  as 당월
    ,  sum(c.last_mon + c.this_mon) as 당월누계
    ,  sum(c.last_year + c.last_mon + c.this_mon) as 계
  from (select a.acct_id
             , a.acct_nm
             , nvl(b.last_year,0) as last_year
             , nvl(b.last_mon, 0) as last_mon
             , nvl(b.this_mon, 0) as this_mon
          from ted_account a
             , (select a.acct_id
                     , sum(case when a.year_mon < substr(:year_mon, 1, 4) then a.cost end) as last_year
                     , sum(case when substr(:year_mon, 1, 4) < a.year_mon and a.year_mon < :year_mon
                                then a.cost end) as last_mon
                     , sum(case when a.year_mon = :year_mon then a.cost end) as this_mon

                  from ted_cost a
                 where a.year_mon <= :year_mon
                 group by a.acct_id
               ) b
         where a.acct_id = b.acct_id(+)
        ) c
    group by rollup(c.acct_id)
    order by c.acct_id
;


-- 5. Grouping Sets
select decode(grouping(a.acct_id), 1, null, a.acct_id)  as 계정ID
    ,  decode(grouping(a.acct_id), 1, '합계', max(a.acct_nm)) as 계정명
    ,  nvl(sum(b.last_year), 0) as 전년누계
    ,  nvl(sum(b.last_mon), 0)  as 전월누계
    ,  nvl(sum(b.this_mon), 0)  as 당월
    ,  sum(nvl(b.last_mon, 0) + nvl(b.this_mon, 0)) as 당월누계
    ,  sum(nvl(b.last_year, 0) + nvl(b.last_mon, 0) + nvl(b.this_mon, 0)) as 계
    from ted_account a
        , (select a.acct_id
               ,  sum(case when a.year_mon < substr(:year_mon, 1, 4) then a.cost end) as last_year
               ,  sum(case when substr(:year_mon, 1, 4) < a.year_mon and a.year_mon < :year_mon
                           then a.cost end) as last_mon
               ,  sum(case when a.year_mon = :year_mon then a.cost end) as this_mon
               from ted_cost a
            where a.year_mon <= :year_mon
            group by a.acct_id
        ) b
    where a.acct_id = b.acct_id(+)
    group by grouping sets(a.acct_id, ())    — Grouping Sets은 Rollup의 최신버전이다.
    order by max(a.acct_nm)
;

-- 기타: Rollup, Cube
-- ROLLUP
select a.region_id as 지역ID
    ,  decode(grouping(a.region_id), 1, '합계', max(b.region_nm)) as 지역명
    ,  count(*)
    ,  grouping(a.region_id) as 그룹1
    from ted_student a
      ,  ted_region b
    where a.region_id = b.region_id
    group by rollup(a.region_id)
;

select grouping(a.region_id)
    from ted_student a
      ,  ted_region b
    where a.region_id = b.region_id
    group by rollup(a.region_id)
;

select a.region_id as 지역ID
    ,  decode(grouping(a.region_id), 1, '합계', max(b.region_nm)) as 지역명
    ,  decode(grouping(a.grade_class_no), 1, '소계', a.grade_class_no) as 학년반
    ,  count(*)
    ,  grouping(a.region_id) as 그룹1
    ,  grouping(a.grade_class_no) as 그룹2
    ,  grouping_id(a.region_id, a.grade_class_no) as 그룹3
    from ted_student a
      ,  ted_region b
    where a.region_id = b.region_id
    group by rollup(a.region_id, a.grade_class_no)
;

-- CUBE
select a.region_id as 지역ID
    ,  decode(grouping(a.region_id), 1, '합계', max(b.region_nm)) as 지역명
    ,  decode(grouping(a.grade_class_no), 1, '소계', a.grade_class_no) as 학년반
    ,  count(*)
    ,  grouping(a.region_id) as 그룹1
    ,  grouping(a.grade_class_no) as 그룹2
    ,  grouping_id(a.region_id, a.grade_class_no) as 그룹3
    from ted_student a
      ,  ted_region b
    where a.region_id = b.region_id
    group by cube(a.region_id, a.grade_class_no)
;
