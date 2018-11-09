-- 1. View
cursor c_score is
  select *
    from ved_score
   where year_mon = '2017/07'
;

create or replace view ved_score as
select a.p_year_mon
    ,  a.student_no
    ,  b.student_nm
    ,  b.grade_class_no
    ,  b.end_date
    ,  nvl(a.kor, 0) as kor
    ,  nvl(a.eng, 0) as eng
    ,  nvl(a.math, 0)
    ,  nvl(a.kor, 0) + nvl(eng, 0) + nvl(math,0)  as total
    ,  round((nvl(a.kor,0) + nvl(a.eng,0) + nvl(a.math,0)) / 3, 2)  as avg
    ,  case when 90 <= round((nvl(a.kor, 0) + nvl(a.eng, 0) + nvl(a.math, 0)) / 3, 2) then 'A'
    ,       when 80 <= round((nvl(a.kor, 0) + nvl(a.eng, 0) + nvl(a.math, 0)) / 3, 2) then 'B'
    ,       else 'C' end as grade
  from ted_score a
    ,  ted_student b
 where a.studnet_no = b.student_no
  with read only
;
