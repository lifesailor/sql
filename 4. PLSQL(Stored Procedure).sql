--1. BASIC
create or replace procedure sp_ed_add_dummy_data
(
    p_num   in number   --최대 생성개수
)
is
    v_num   number;
    v_next_numval   number;  --최대 numval 값

begin   -- 블록 시작
    v_num := case when nvl(p_num, 0) > 10 then 10
                  else nvl(p_num, 0) end;

    if v_num <> 0 then
        select max(nvl(numval, 0))
            into v_next_numval
            from ted_dummy
        ;
        insert into ted_dummy
        select v_next_numval + a.numval
            ,  lpad(v_next_numval + a.numval, 2, '00')
            from ted_dummy a
         where a.numval <= v_num
        ;
    end if;
    commit;
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;    -- 블록의 끝

execute SP_ED_ADD_DUMMY_DATA(10)
;

select *
    from ted_dummy
;

--2. Control
create or replace procedure sf_ed_exam_results
is
    v_sum   number; -- 총점
    v_avg   number(5,2);    -- 평균
    v_grade varchar2(1);    -- 등급
    v_rows  number; -- 행의 수
    v_year_mon  varchar2(7) := '2017/07';   --기준년월
    v_result    varchar2(500);  -- 출력값

    v_score ted_score%rowtype;  -- 행 타입
begin
    -- 전체 데이터 건수와 최초 학생번호 구하기
    select count(*),  min(student_no)
        into v_rows,  v_score.student_no
        from ted_score
        where year_mon = v_year_mon
    ;

    -- 학생번호가 작은 것부터 순차적으로 가져온다.
    for i in 1..v_rows loop
        select *
            into v_score
            from ted_score
           where year_mon = v_year_mon
             and student_no = (select min(student_no)
                                from ted_score
                               where year_mon = v_year_mon
                                 and student_no = v_score.student_no
                               )
        ;

        -- 총점과 평균 계산 --
        v_sum := nvl(v_score.kor, 0) + nvl(v_score.eng, 0) + nvl(v_score.math, 0);
        v_avg := round(v_sum / 3, 2);

        case when 90 <= v_avg then v_grade := 'A';
             when 80 <= v_avg then v_grade := 'B';
             else v_grade := 'C';
        end case;

        -- 출력
        v_result := v_score.student_no
                    || ' '
                    || to_char(nvl(v_score.kor, 0), '99999')
                    || to_char(nvl(v_score.eng, 0), '99999')
                    || to_char(nvl(v_score.math, 0), '99999')
                    || to_char(nvl(v_sum, '99999'))
                    || to_char(v_avg, '99999.99')
                    || ' '
                    || v_grade;

        dbms_output.put_line(v_result);

        -- 다음 학생번호로 구한다.
        select min(student_no)
          into v_score.student_no
          from ted_score
         where year_mon = v_year_mon
           and student_no > v_score.student_no
        ;
    end loop;
end;

execute sf_ed_exam_results;

SET SERVEROUTPUT ON;

--3. CURSOR
create or replace procedure sf_ed_exam_results_cursor
is
    v_result    varchar2(500);

    cursor c_score is
        select student_no
            ,  nvl(kor, 0)  as kor
            ,  nvl(eng, 0)  as eng
            ,  nvl(math, 0) as math
            ,  nvl(kor, 0) + nvl(eng, 0) + nvl(math, 0) as total
            ,  round((nvl(kor, 0) + nvl(eng, 0) + nvl(math, 0)) / 3, 2) as avg
            ,  case when 90 <= round((nvl(kor, 0) + nvl(eng, 0) + nvl(math, 0)) / 3, 2) then 'A'
                    when 80 <= round((nvl(kor, 0) + nvl(eng, 0) + nvl(math, 0)) / 3, 2) then 'B'
                    else 'C' end as grade
            from ted_score
          where year_mon = '2017/07'
    ;

begin
    for cur in c_score loop
       v_result := cur.student_no
                    || ' '
                    || to_char(nvl(cur.kor, 0), '99999')
                    || to_char(nvl(cur.eng, 0), '99999')
                    || to_char(nvl(cur.math, 0), '99999')
                    || to_char(nvl(cur.total, '99999'))
                    || to_char(cur.avg, '99999.99')
                    || ' '
                    || cur.grade;
        dbms_output.put_line(v_result);
    end loop;
end;

-- 실전 Example
-- 데이터를 정리한 뒤에 한꺼번에 테이블을 넣는 것이 아니라 데이터를 나누어서 단계적으로 넣는다.

create or replace procedure edu.sp_ed_save_rslt_suammary
(
    p_year_mon in varchar2 -- 집계년월
  , p_salm_amt in number   -- 매출금액
)
begin
    -- 집계년월의 관련 데이터 삭제
    delete ted_budget_cost
     where year_mon = p_year_mon
    ;

    delete ted_rslt_summary
     where year_mon = p_year_mon
    ;

    -- 예산 및 원가 집계
    insert into ted_budget_cost
    select p_year_mon
        ,  a.acct_id
        ,  'W'
        ,  nvl(b.budget, 0)
        ,  nvl(c.cost, 0)
      from ted_account a
        ,  ted_budget b
        ,  (select acct_id, sum(cost) as cost
              from ted_cost
             where year_mon = p_year_mon
             group by acct_id
           ) c
     where a.acct_id = b.acct_id(+)    — 2개 이상의 테이블을 한 번에 JOIN 할 수 있다.
       and a.acct_id = c.acct_id(+)
       and b.year_mon(+) = p_year_mon
    ;

    insert into ted_budget_cost
    select year_mon
        ,  acct_id
        ,  'T'
        ,  nvl(round(budget/1000), 0)
        ,  nvl(cost, 0)
      from ted_budget_cost
     where year_mon = p_year_mon
       and unit = 'W'
    ;

    -- 실적 요약
    insert into ted_rslt_summary
    select (p_year_mon
          , 'S'
          ,  p_sale_amt
          )
    ;

    insert into ted_rslt_summary
    select year_mon
        ,  'C'
        ,  nvl(sum(cost), 0)
      from ted_budget_cost
     where year_mon = p_year_mon
       and unit = 'W'
     group by year_mon
    ;

    insert into ted_rslt_summary
    select year_mon
        ,  'P'
        ,  nvl(sum(case when rslt_cd = 'C' then -rslt_amt
                        else rslt_amt end), 0)
      from ted_rslt_summary
     where year_mon = p_year_mon
     group by year_mon
    ;

    commit;

exception
  where others then
    rollback;
    dmbs_output.put_line(sqlcode || ' : ' || sqlerrm);
end;
