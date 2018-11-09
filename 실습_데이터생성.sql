insert into ted_dummy
select * 
  from (
        select 1, '01'  from dual union
        select 2, '02'  from dual union
        select 3, '03'  from dual union
        select 4, '04'  from dual union
        select 5, '05'  from dual union
        select 6, '06'  from dual union
        select 7, '07'  from dual union
        select 8, '08'  from dual union
        select 9, '09'  from dual union
        select 10, '10'  from dual
       )
;
------------------------------------------------------------------------------
insert into ted_student(student_no, student_nm, ent_date, grade_class_no)
select * 
  from (
        select 'A001', 'ȫ�浿', sysdate, '0101' from dual union
        select 'A002', '������', sysdate, '0101' from dual union
        select 'A003', '��ö��', sysdate, '0101' from dual union
        select 'A004', '�ڸ���', sysdate, '0101' from dual union
        select 'A005', '������', sysdate, '0101' from dual union
        select 'A006', '������', sysdate, '0101' from dual union
        select 'A007', '���̽�', sysdate, '0101' from dual union
        select 'A008', '���޻�', sysdate, '0101' from dual union
        select 'A009', '�̾�ħ', sysdate, '0101' from dual union
        select 'A010', '�ڸ���', sysdate, '0101' from dual union
        
        select 'A011', '����', sysdate, '0201' from dual union
        select 'A012', '������', sysdate, '0201' from dual union
        select 'A013', '��ȣ��', sysdate, '0201' from dual union
        select 'A014', '���', sysdate, '0201' from dual union
        select 'A015', '����', sysdate, '0201' from dual union
        select 'A016', '�ڰ���', sysdate, '0201' from dual union
        select 'A017', '���', sysdate, '0201' from dual union
        select 'A018', '���', sysdate, '0201' from dual union
        select 'A019', '���¾�', sysdate, '0201' from dual union
        select 'A020', '�̿���', sysdate, '0201' from dual union
        select 'A099', '������', sysdate, '0201' from dual union
        
        select 'A021', '���¾�', sysdate, '0301' from dual union
        select 'A022', '�̸�', sysdate, '0301' from dual union
        select 'A023', '��âȣ', sysdate, '0301' from dual union
        select 'A024', '������', sysdate, '0301' from dual union
        select 'A025', '�̼���', sysdate, '0301' from dual union
        select 'A026', '���屺', sysdate, '0301' from dual union
        select 'A027', '���屺', sysdate, '0301' from dual union
        select 'A028', '���屺', sysdate, '0301' from dual union
        select 'A029', '������', sysdate, '0301' from dual union
        select 'A030', 'ȫ�浿', sysdate, '0301' from dual union
        
        select 'A031', '������', sysdate, '0302' from dual union
        select 'A032', '����', sysdate, '0302' from dual union
        select 'A033', '�Ż絿', sysdate, '0302' from dual union
        select 'A034', '�絿��', sysdate, '0302' from dual union
        select 'A035', '���¾�', sysdate, '0302' from dual union
        select 'A036', '�Ѱ���', sysdate, '0302' from dual union
        select 'A037', '���ϳ�', sysdate, '0302' from dual union
        select 'A038', '�̵���', sysdate, '0302' from dual union
        select 'A039', '������', sysdate, '0302' from dual union
        select 'A040', '���¼�', sysdate, '0302' from dual union
        select 'A092', '������', sysdate, '0302' from dual union 
        
        select 'A041', 'ȫ�浿', sysdate, '0102' from dual union
        select 'A042', '������', sysdate, '0102' from dual union
        select 'A043', '�̱���', sysdate, '0102' from dual union
        select 'A044', '�ڱ���', sysdate, '0102' from dual union
        select 'A045', '�ֽþ�', sysdate, '0102' from dual union
        select 'A046', '�Ӳ���', sysdate, '0102' from dual union
        select 'A047', '���ؿʹ�', sysdate, '0102' from dual union
        select 'A048', '��ȫ��', sysdate, '0102' from dual union
        select 'A049', '����ǳ', sysdate, '0102' from dual union
        select 'A050', '������', sysdate, '0102' from dual union
        select 'A093', '�ż���', sysdate, '0102' from dual union
        select 'A094', '�Ѹ���', sysdate, '0102' from dual union
        select 'A095', '��õ��', sysdate, '0102' from dual union
        
        select 'A051', '������', sysdate, '0202' from dual union
        select 'A052', '������', sysdate, '0202' from dual union
        select 'A053', '������', sysdate, '0202' from dual union
        select 'A054', '�鰡��', sysdate, '0202' from dual union
        select 'A055', '������', sysdate, '0202' from dual union
        select 'A056', '�ݰ���', sysdate, '0202' from dual union
        select 'A057', '�߻���', sysdate, '0202' from dual union
        select 'A058', '�ֿ���', sysdate, '0202' from dual union
        select 'A059', '�絿ö', sysdate, '0202' from dual union
        select 'A060', '�ȸ���', sysdate, '0202' from dual union
        select 'A091', '��ȣ��', sysdate, '0202' from dual 
       )
;
------------------------------------------------------------------------------
insert into ted_score(student_no, year_mon)
select student_no
     , '2017/07' 
  from ted_student
;

update ted_score
   set kor  = rownum + 31
     , eng  = rownum + 25
     , math = rownum + 15
;

insert into ted_score
select student_no
     , '2017/08' 
     , kor - 1
     , eng + 1
     , math + 3
  from ted_score
;

insert into ted_score
select student_no
     , '2017/06' 
     , kor - 2
     , eng + 3
     , math + 4
  from ted_score
  where year_mon = '2017/07'
;

update ted_score
   set kor  = null
     , eng  = null
     , math = null
 where rownum in (1, 10, 40)
;

update ted_score
   set kor  = null
     , eng  = null
     , math = null
 where rownum in (1, 10, 40)
;

 update ted_score
    set (kor, eng, math) =  (select kor, eng, math from ted_score where student_no = 'A009' and year_mon = '2017/07')
  where student_no = 'A008'
    and year_mon = '2017/07'   
;
------------------------------------------------------------------------------
insert into ted_region 
select * 
  from (
        select 1, '����' from dual union
        select 2, '�λ�' from dual union
        select 3, '��õ' from dual union
        select 4, '����' from dual union
        select 5, '����' from dual union
        select 6, '�뱸' from dual union
        select 7, '���' from dual union
        select 8, '��â' from dual union
        select 9, '���ֵ�' from dual union
        select 10, '�︪��' from dual 
       )
;

update ted_student
   set region_id = mod(rownum, 10)+1
;

update ted_student
   set region_id = null
 where region_id =10
;
-------------------------------------------------------------------------------
insert into ted_account 
select * 
  from (
        select 1, '����' from dual union
        select 2, '�빫��' from dual union
        select 3, '���ֺ�' from dual union
        select 4, '����'  from dual union
        select 5, '�޷�' from dual union
        select 6, '������' from dual union
        select 7, '�����Ļ���' from dual union
        select 8, '��������' from dual union
        select 9, '����������' from dual union
        select 10, '�Ҹ�ǰ��' from dual union
        select 11, '������ߺ�' from dual union
        select 12, '�������' from dual union
        select 13, '��ź�' from dual union 
        select 14, '����������' from dual union
        select 15, '����������' from dual union
        select 16, '�����󰢺�' from dual union
        select 17, '�����' from dual union 
        select 18, '�����' from dual union
        select 19, '���޼�����' from dual union
        select 20, '��������' from dual 
       )
;

commit;
-------------------------------------------------------------------------------
insert into ted_cost
select '2017/07'
     , seq_ed_cost.nextval
     , a.acct_id
     , 2300 * rownum
  from ted_account a
     , ted_dummy b
;
commit;

insert into ted_cost
select '2017/07'
     , seq_ed_cost.nextval
     , a.acct_id
     , round(a.cost * 0.5) * (mod(rownum, 10)+1)
  from ted_cost a
     , ted_dummy b
     , ted_dummy c
;
commit;

insert into ted_cost
select to_char(2018 - c.numval) || '/06'
     , seq_ed_cost.nextval
     , a.acct_id
     , round(a.cost * 0.2) * (mod(rownum, 100)+1)
  from ted_cost a
     , ted_dummy b
     , ted_dummy c
 where b.numval <= 2     
;
commit;

insert into ted_cost
select '2017/08'
     , seq_ed_cost.nextval
     , a.acct_id
     , round(a.cost * 0.2) * (mod(rownum, 100)+1)
  from ted_cost a
 where year_mon like '____/06' 

;
commit;

insert into ted_cost
select substr(a.year_mon,1,4) || '/05'
     , seq_ed_cost.nextval
     , a.acct_id
     , round(a.cost * 0.1) * (mod(rownum, 100)+1)
  from ted_cost a
 where year_mon like '____/06'  
;
commit;

update ted_cost
   set cost = round(cost / 1000)
;
commit;

insert into ted_account 
select * 
  from (
        select 21, '�����' from dual 
       )
;
  
------------------------------------------------------------------------
insert into ted_budget
select a.year_mon, a.acct_id, round(sum(a.cost) * 1.1)
  from ted_cost a
 where  a.acct_id <= 5
 group by a.year_mon, a.acct_id
;
commit;

insert into ted_budget
select '2017/' || strval
     , 21
     , round(1000000 * (100 - numval) / 100)
  from ted_dummy
 where rownum <= 12
;

commit
;
---------------------------------------------------------------------------
insert into ted_t1
select 101, null from dual union all
select 102, null from dual union all
select 106, null from dual 
; 

insert into ted_t2
select 101, 'A' from dual union all
select 101, 'B' from dual union all
select 102, 'A' from dual union all
select 102, 'B' from dual union all
select 103, 'A' from dual

;  
insert into ted_t3
select 101, 'A' from dual union all
select 101, 'B' from dual union all
select 102, 'A' from dual union all
select 102, 'B' from dual union all
select 105, 'A' from dual

; 

-------------------------------------------------------------------------------
insert into ted_trade_data
select trade_nm, work_nm, '02-000-00' || to_char(trim(to_char(rownum,'09'))), reg_type_nm, rating
  from ( 
        select '(��)ü�̽��ڸ���' trade_nm, '�׽�Ʈ����1' work_nm, '' tel, '����' reg_type_nm, 5 rating from dual union all
        select '(��)ü�̽��ڸ���', '�׽�Ʈ����2', '', '����', 2.4  from dual union all
        select '(��)ü�̽��ڸ���', '��������', '', '����', 3.5  from dual union all
        select '�߰�â�Ǽ�', '��������', '', '', 4.1  from dual union all
        select '�߱��ϰ���', 'Ÿ�ϰ���', '', '', 2.7  from dual union all
        select '(��)��������Ͼ', '���뿪', '', '', 5  from dual union all
        select '(��)�뱳����Ǽ�', '�������', '', '', 4.9  from dual union all
        select '(��)�뿵����', '�������', '', '', 3.9  from dual union all
        select '(��)���ż���', '������', '', '', 1.9  from dual union all
        select '(��)�����÷�', '�׷��Ȱ���', '', '', 3.5  from dual union all
        select '(��)���ϰǱ�', '��âȣ����', '', '', 4.6  from dual union all
        select '(��)����Ƽ���̰Ǽ�', '���ذ���', '', '', 4.2  from dual union all
        select '(��)��������', '�������', '', '', 4.3  from dual union all
        select '(��)���Ͼ�Ű��', '��������', '', '', 3.4  from dual union all
        select '(��)ȭ���̿���', '�������', '', '', 0  from dual union all
        select '���ϰǼ�(��)', '��������', '', '', 5  from dual union all
        select '�ݼ��������(��)', '�ҹ����', '', '', 2.4  from dual union all
        select '���������Ͼ(��)', '�ڵ��������', '', '', 4.1  from dual union all
        select '�������(��)', '�ݼӰ���', '', '', 2.7  from dual union all
        select '�������(��)', '��������', '', '', 4.9  from dual union all
        select '�������(��)', '�������', '', '', 3.9  from dual union all
        select '�����Ǽ�(��)', '���밡������', '', '', 3.5  from dual union all
        select '������ũ��Ǽ����(��)', '�ܿ�����', '', '', 4.6  from dual union all
        select '�ѿ��������(��)', '��Ű���', '', '', 4.2  from dual union all
        select '��ȭ���ؾ�(��)', 'âȣ����', '', '', 4.3  from dual union all
        select '�մ��Ǽ�(��)', '��ŷ����', '', '', 3.4  from dual union all
        select '�մ��Ǽ�(��)', '�����', '', '', 4.6  from dual union all
        select '���簳��', '�������', '', '', 4.2  from dual union all
        select 'ȭ���̿���(��)', '�������', '', '', 3.4  from dual union all
        select 'Ȳ��Ǽ�(��)', '��������', '', '', 1.2  from dual union all
        select 'Ȳ��Ǽ�(��)', '�����', '', '', 5  from dual 
       ) a
; 

update ted_trade_data
   set reg_type = '����'
 where reg_type is null
;

insert into ted_trade
select rownum, trade_nm
from (select trade_nm
        from ted_trade_data
       group by trade_nm
     )
;

insert into ted_work
select rownum, work_nm
from (select work_nm
        from ted_trade_data
       where reg_type is not null
       group by work_nm
        )
;

insert into ted_code
select 'ED', 'Ż�ױ���',  '*' from dual union all
select 'ED10', '�������',  'ED' from dual union all
select 'ED1001', '����',  'ED10' from dual union all
select 'ED1002', '����',  'ED10' from dual union all
select 'ED1003', '����',  'ED10' from dual 
;

insert into ted_trade_work
select b.trade_id, c.work_id, a.tel, d.cd, a.rating
  from ted_trade_data a
     , ted_trade b
     , ted_work c
     , ted_code d
 where a.trade_nm = b.trade_nm(+)
   and a.work_nm  = c.work_nm(+)
   and a.reg_type = d.cd_nm(+)
;

insert into ted_data_type
select 'ABCD', '�ѱ�', sysdate, 12345678901234567890, 1234567890, 12.5, '�޸�' from dual
;

insert into ted_rslt_code
select 'S', '����' from dual union all
select 'C', '����' from dual union all
select 'P', '����' from dual 
;

insert into ted_dept
select 1, '����',  0 from dual union all
select 2, '�����',  1 from dual union all
select 3, '�濵����',  1 from dual union all
select 7, '��ȹ��',  3 from dual union all
select 8, '�濵������',  3 from dual union all
select 13, '�λ��',  3 from dual union all
select 12, '�λ���',  13 from dual union all
select 17, '�ѹ���',  13 from dual union all
select 4, '�繫��������',  1 from dual union all
select 9, '�ڱ���',  4 from dual union all
select 5, '���޺���',  1 from dual union all
select 10, '������',  5 from dual union all
select 11, '������',  5 from dual union all
select 6, '��������',  1 from dual union all
select 14, '����1��',  6 from dual union all
select 15, '����2��',  6 from dual union all
select 16, '����3��',  6 from dual 
;


insert into ted_trade_work2
select * from ted_trade_work
;

commit;


