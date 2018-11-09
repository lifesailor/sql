--1. ted_cost에 없는 account_id 출력

select a.*
    from ted_account a
      ,  ted_cost b
   where a.acct_id = b.acct_id(+)
     and b.acct_id is null
;
select a.*
    from ted_account a
    where a.acct_id not in (select x.acct_id from ted_cost x)
;

--2. year_mon 입력 값이 있으면 해당하는 값 조회 아니면 null 조회
select count(*)
    from ted_cost a
  where (a.year_mon = :year_mon or :year_mon is null)
;
select count(*)
    from ted_cost a
   where a.year_mon like :year_mon || '%'
;

--3. 반드시 null 처리를 한다.
select  trim(to_char(nvl(max(a.acct_id), 0) + 1, ‘0000’))



-- 4. 모범 쿼리
select decode(c.numval, 1, a.acct_id)   as 계정ID
    ,  decode(c.numval, 1, max(a.acct_nm), '합계') as 계정명
    ,  decode(a.flag, 1, '예산', '실적') as 구분
    ,  nvl(sum(b.last_mon), 0) as 전월누계
    ,  nvl(sum(b.this_mon), 0) as 당월
    ,  nvl(sum(b.total), 0) as 당월누계
    from (
    select a.acct_id
        ,  a.acct_nm
        ,  b.numval as flag
      from ted_account a
        ,  ted_dummy b
     where b.numval <= 2
    ) a
   , (
   select 1 as flag -- BUDGET
        ,  a.acct_id
        ,  sum(case when a.year_mon < :year_mon then a.budget end) as last_mon
        ,  sum(case when a.year_mon < :year_mon then a.budget end) as this_mon
        ,  sum(a.budget) as total
      from ted_budget a
     where a.year_mon > substr(:year_mon, 1, 4)
       and a.year_mon <= :year_mon
    group by a.acct_id

    union all

    select 2 as flag
        ,  a.acct_id
        ,  sum(case when a.year_mon < :year_mon then a.cost end) as last_mon
        ,  sum(case when a.year_mon = :year_mon then a.cost end) as this_mon
        ,  sum(a.cost) as total
      from ted_cost a
     where a.year_mon > substr(:year_mon, 1, 4)
       and a.year_mon <= :year_mon
       group by a.acct_id
    ) b
    , ted_dummy c
    where a.acct_id = b.acct_id(+)
      and a.flag = b.flag(+)
      and c.numval <= 2
    group by c.numval, decode(c.numval, 1, a.acct_id), a.flag
    order by c.numval, decode(c.numval, 1, a.acct_id), a.flag
