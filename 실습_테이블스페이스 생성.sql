-- ����  c:\db_edu\20 oracle_database ������ ����
 
create tablespace edu_data01
datafile 'c:\db_edu\20 oracle_database\edu_data01.dbf'  
--'e:\00 MyDoc\Taling Database\db_edu\20 oracle_database\edu_data01.dbf'
size 200m
autoextend on next 20m 
maxsize unlimited
;


create tablespace edu_idx01
datafile 'c:\db_edu\20 oracle_database\edu_idx01.dbf'  
--'e:\00 MyDoc\Taling Database\db_edu\20 oracle_database\edu_idx01.dbf'
size 200m
autoextend on next 20m 
maxsize unlimited
;

