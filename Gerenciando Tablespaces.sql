

SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;

-- CRIANDO TABLESPACE

-- COM OMF

CREATE TABLESPACE TBS_DBAOCM;

SET LINES 400
COL FILE_NAME FOR A50
SELECT FILE_NAME, BYTES/1024/1024 "TAMANHO MB", AUTOEXTENSIBLE FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TBS_DBAOCM';

-- SEM OMF

CREATE TABLESPACE TBS_DBAOCM DATAFILE '/u02/oradata/my_datafile.dbf' SIZE 10M AUTOEXTEND ON NEXT 512M;

SET LINES 400
COL FILE_NAME FOR A50
SELECT FILE_NAME, BYTES/1024/1024 "TAMANHO MB", AUTOEXTENSIBLE FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TBS_DBAOCM';


-- BIGFILE TABLESPACE

-- COM OMF

CREATE BIGFILE TABLESPACE TBS_BIG;

-- SEM OMF

CREATE TABLESPACE TBS_BIG DATAFILE '/u02/oradata/my_big_datafile.dbf' SIZE 200M AUTOEXTEND ON NEXT 512M;

SELECT TABLESPACE_NAME, BIGFILE, EXTENT_MANAGEMENT, SEGMENT_SPACE_MANAGEMENT FROM DBA_TABLESPACES;

-- TEMPORARY TABLESPACE

-- COM OMF

CREATE TEMPORARY TABLESPACE TBS_TEMP;

-- SEM OMF

CREATE TEMPORARY TABLESPACE TBS_TEMP2 TEMPFILE '/u02/oradata/my_tempfile2.dbf' SIZE 10M AUTOEXTEND ON NEXT 512M;

-- BIGFILE TABLESPACE

-- COM OMF

CREATE BIGFILE TEMPORARY TABLESPACE TBS_BIG_TEMP;

-- SEM OMF

CREATE BIGFILE TEMPORARY TABLESPACE TBS_BIG_TEMP1 TEMPFILE '/u02/oradata/my_big_tempfile.dbf' SIZE 200M AUTOEXTEND ON NEXT 512M;

SELECT TABLESPACE_NAME, FILE_NAME FROM DBA_TEMP_FILES;

-- CONSULTANDO A TABLESPACE TEMPORARIA PADRAO

SELECT PROPERTY_NAME, PROPERTY_VALUE FROM DATABASE_PROPERTIES WHERE PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';

-- REDEFININDO A TABLESPACE TEMPORARIA PADRAO

ALTER DATABASE DEFAULT TEMPORARY TABLESPACE TBS_TEMP;

-- TABLESPACE NOLOGGING

CREATE TABLESPACE TBS_NOLOG NOLOGGING;


-- Alterando a Disponibilidade das Tablespaces

ALTER TABLESPACE TBS_DBAOCM OFFLINE;

SELECT TABLE_NAME, STATUS FROM DBA_TABLESPACES;

ALTER TABLESPACE TBS_DBAOCM ONLINE;

-- TABLESPACE READ ONLY

CREATE TABLE MY_TABLE (C1 NUMBER) TABLESPACE TBS_DBAOCM;

INSERT INTO MY_TABLE VALUES (1);
COMMIT;

ALTER TABLESPACE TBS_DBAOCM READ ONLY;

INSERT INTO MY_TABLE VALUES (1);

CREATE TABLE MY_TABLE2 (C1 NUMBER) TABLESPACE TBS_DBAOCM;

DROP TABLE MY_TABLE;

ALTER TABLESPACE TBS_DBAOCM READ WRITE;

CREATE TABLE MY_TABLE2 (C1 NUMBER) TABLESPACE TBS_DBAOCM;

-- alterando e mantendo tablespaces

-- SMALLFILE

ALTER TABLESPACE TBS_DBAOCM ADD DATAFILE;

ALTER TABLESPACE TBS_DBAOCM ADD DATAFILE '/u02/oradata/ORCL/my_datafile2.dbf' SIZE 100M AUTOEXTEND ON NEXT 512M MAXSIZE 32767M;

-- BIGFILE

ALTER TABLESPACE TBS_BIG ADD DATAFILE;

ALTER TABLESPACE TBS_BIG RESIZE 300M;

ALTER TABLESPACE TBS_BIG AUTOEXTEND ON NEXT 1G;

-- RENAME

ALTER TABLESPACE TBS_DBAOCM OFFLINE;

ALTER TABLESPACE TBS_DBAOCM RENAME TO TBS_DBAOCM_RENAME;

ALTER TABLESPACE TBS_DBAOCM ONLINE;

ALTER TABLESPACE TBS_DBAOCM RENAME TO TBS_DBAOCM_RENAME;


-- DROP

DROP TABLESPACE TBS_DBAOCM;

SET LINES 300
COL FILE_NAME FOR A70
COL TABLESPACE_NAME FOR A10
SELECT FILE_NAME, TABLESPACE_NAME, BYTES/1024/1024 MB, AUTOEXTENSIBLE, MAXBYTES/1024/1024 
FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TBS_DBAOCM_RENAME';

DROP TABLESPACE TBS_DBAOCM INCLUDING CONTENTS;

SET LINES 300
COL FILE_NAME FOR A70
COL TABLESPACE_NAME FOR A10
SELECT FILE_NAME, TABLESPACE_NAME, BYTES/1024/1024 MB, AUTOEXTENSIBLE, MAXBYTES/1024/1024 
FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TBS_DBAOCM';

-- INCLUDING DATAFILES

CREATE TABLESPACE TBS_DBAOCM;

ALTER TABLESPACE TBS_DBAOCM ADD DATAFILE '/u02/oradata/ORCL/my_datafil3.dbf' SIZE 100M AUTOEXTEND ON NEXT 512M;

CREATE TABLE MY_TABLE2 (C1 NUMBER) TABLESPACE TBS_DBAOCM;

SET LINES 300
COL FILE_NAME FOR A70
COL TABLESPACE_NAME FOR A10
SELECT FILE_NAME, TABLESPACE_NAME, BYTES/1024/1024 MB, AUTOEXTENSIBLE, MAXBYTES/1024/1024 
FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TBS_DBAOCM';

DROP TABLESPACE TBS_DBAOCM INCLUDING CONTENTS AND DATAFILES;

-- KEEP DATAFILES

CREATE TABLESPACE TBS_DBAOCM;

ALTER TABLESPACE TBS_DBAOCM ADD DATAFILE '/u02/oradata/ORCL/my_datafile2.dbf' SIZE 100M AUTOEXTEND ON NEXT 512M;

CREATE TABLE MY_TABLE2 (C1 NUMBER) TABLESPACE TBS_DBAOCM;

SET LINES 300
COL FILE_NAME FOR A70
COL TABLESPACE_NAME FOR A10
SELECT FILE_NAME, TABLESPACE_NAME, BYTES/1024/1024 MB, AUTOEXTENSIBLE, MAXBYTES/1024/1024 
FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TBS_DBAOCM';

DROP TABLESPACE TBS_DBAOCM INCLUDING CONTENTS KEEP DATAFILES;


-- Consultas Úteis

-- Espaço livre de tablespaces

SET PAGESIZE 140 LINESIZE 200
COLUMN used_pct FORMAT A11

SELECT tablespace_name,
       size_mb,
       free_mb,
       max_size_mb,
       max_free_mb,
       TRUNC((max_free_mb/max_size_mb) * 100) AS free_pct,
       RPAD(' '|| RPAD('X',ROUND((max_size_mb-max_free_mb)/max_size_mb*10,0), 'X'),11,'-') AS used_pct
FROM   (
        SELECT a.tablespace_name,
               b.size_mb,
               a.free_mb,
               b.max_size_mb,
               a.free_mb + (b.max_size_mb - b.size_mb) AS max_free_mb
        FROM   (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024) AS free_mb
                FROM   dba_free_space
                GROUP BY tablespace_name) a,
               (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024) AS size_mb,
                       TRUNC(SUM(GREATEST(bytes,maxbytes))/1024/1024) AS max_size_mb
                FROM   dba_data_files
                GROUP BY tablespace_name) b
        WHERE  a.tablespace_name = b.tablespace_name
       )
ORDER BY free_pct;


set feedback off
set pagesize 70;
set linesize 2000
set head on
COLUMN Tablespace format a25 heading 'Tablespace Name'
COLUMN autoextensible format a11 heading 'AutoExtend'
COLUMN files_in_tablespace format 999 heading 'Files'
COLUMN total_tablespace_space format 99999999 heading 'TotalSpace'
COLUMN total_used_space format 99999999 heading 'UsedSpace'
COLUMN total_tablespace_free_space format 99999999 heading 'FreeSpace'
COLUMN total_used_pct format 9999 heading '%Used'
COLUMN total_free_pct format 9999 heading '%Free'
COLUMN max_size_of_tablespace format 99999999 heading 'ExtendUpto'
COLUM total_auto_used_pct format 999.99 heading 'Max%Used'
COLUMN total_auto_free_pct format 999.99 heading 'Max%Free'
WITH tbs_auto AS
(SELECT DISTINCT tablespace_name, autoextensible
FROM dba_data_files
WHERE autoextensible = 'YES'),
files AS
(SELECT tablespace_name, COUNT (*) tbs_files,
SUM (BYTES/1024/1024) total_tbs_bytes
FROM dba_data_files
GROUP BY tablespace_name),
fragments AS
(SELECT tablespace_name, COUNT (*) tbs_fragments,
SUM (BYTES)/1024/1024 total_tbs_free_bytes,
MAX (BYTES)/1024/1024 max_free_chunk_bytes
FROM dba_free_space
GROUP BY tablespace_name),
AUTOEXTEND AS
(SELECT tablespace_name, SUM (size_to_grow) total_growth_tbs
FROM (SELECT tablespace_name, SUM (maxbytes)/1024/1024 size_to_grow
FROM dba_data_files
WHERE autoextensible = 'YES'
GROUP BY tablespace_name
UNION
SELECT tablespace_name, SUM (BYTES)/1024/1024 size_to_grow
FROM dba_data_files
WHERE autoextensible = 'NO'
GROUP BY tablespace_name)
GROUP BY tablespace_name)
SELECT c.instance_name,a.tablespace_name Tablespace,
CASE tbs_auto.autoextensible
WHEN 'YES'
THEN 'YES'
ELSE 'NO'
END AS autoextensible,
files.tbs_files files_in_tablespace,
files.total_tbs_bytes total_tablespace_space,
(files.total_tbs_bytes - fragments.total_tbs_free_bytes
) total_used_space,
fragments.total_tbs_free_bytes total_tablespace_free_space,
round(( ( (files.total_tbs_bytes - fragments.total_tbs_free_bytes)
/ files.total_tbs_bytes
)
* 100
)) total_used_pct,
round(((fragments.total_tbs_free_bytes / files.total_tbs_bytes) * 100
)) total_free_pct
FROM dba_tablespaces a, v$instance c, files, fragments, AUTOEXTEND, tbs_auto
WHERE a.tablespace_name = files.tablespace_name
AND a.tablespace_name = fragments.tablespace_name
AND a.tablespace_name = AUTOEXTEND.tablespace_name
AND a.tablespace_name = tbs_auto.tablespace_name(+)
order by total_free_pct;


-- Uso da tablespace temporária

select a.tablespace_name tablespace,
d.TEMP_TOTAL_MB,
sum (a.used_blocks * d.block_size) / 1024 / 1024 TEMP_USED_MB,
d.TEMP_TOTAL_MB - sum (a.used_blocks * d.block_size) / 1024 / 1024
TEMP_FREE_MB
from v$sort_segment a,
(
select b.name, c.block_size, sum (c.bytes) / 1024 / 1024 TEMP_TOTAL_MB
from v$tablespace b, v$tempfile c
where b.ts#= c.ts#
group by b.name, c.block_size
) d
where a.tablespace_name = d.name
group by a.tablespace_name, d.TEMP_TOTAL_MB;