-- Type - Configuration Audit Script
-- Application Name - Oracle 11g Unix
set termout off
spool ORA_U11g_Unix.txt
set lines 75
set head off
set colsep '|'
set recsepchar '-'
set recsep each


select 'ORA_U11g_3.1.7 **** Data dictionary accessibility Parameter**** ' from dual;
set head on
col name format A20
col value format A20
select name,value from v$parameter where name ='O7_DICTIONARY_ACCESSIBILITY';
col name clear
col value clear 
set head off


select 'ORA_U11g_3.1.11 ####### Security Patches (Insecure Oracle Database release)  ######' from dual;
col version format a20
col status format a20
select '@@@Comp Name: Version: Status@@@' from dual;
set head on
col product format a50
set head on
select product,version,status from product_component_version;
col version clear
col status clear
col product clear
set head off


select 'ORA_U11g_3.4.4. **** Initialize Parameter SEC_RETURN_SERVER_RELEASE_BANNER ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('SEC_RETURN_SERVER_RELEASE_BANNER');
col name clear
col value clear
set head off
select 'ORA_U11g_3.4.4. **** DB_SECUREFILE ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('DB_SECUREFILE');
col name clear
col value clear
set head off


select 'ORA_U11g_3.4.5.(3.6.1) **** Default Database Users **** ' from dual;
set head on
col username format a20
col account_status format a20
col profile format a20
select username,account_status,profile from dba_users order by created;
col username clear
col account_status clear 
col profile clear
set head off


select 'ORA_U11g_3.7.4 **** Access to PL/SQL packages **** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_FILE';
col grantee clear
col table_name clear
set head off


set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_TCP';
col grantee clear
col table_name clear
set head off


set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_HTTP'; 
col grantee clear
col table_name clear
set head off


set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_SMTP';
col grantee clear
col table_name clear
set head off


set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBMS_RANDOM';
col grantee clear
col table_name clear
set head off


select 'ORA_U11g_3.7.5 **** Directory access checking ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name = 'UTL_FILE_DIR';
col name clear
col value clear
set head off


select 'ORA_U11g_3.7.6 **** Insecure Remote login settings ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('remote_login_passwordfile');
col name clear
col value clear
set head off


select 'ORA_U11g_3.7.7, 3.7.9, 3.13.5**** Remote and OS roles settings ****' from dual;
set head on
col name format A20
col value format A20
select name,value from v$parameter where name like 'os_%' or name like 'remote_os%';
col name clear
col value clear
set head off


select 'ORA_U11g_3.7.8 **** init.ora parameters - os_authent_prefix ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('os_authent_prefix');
col name clear
col value clear
set head off


select 'ORA_U11g_3.7.11 **** SYNONYMS ****' from dual;
set head on
col SYNONYM_NAME format a20
col TABLE_NAME format a20
SELECT SYNONYM_NAME, TABLE_NAME FROM ALL_SYNONYMS WHERE TABLE_NAME LIKE('V$%');
col SYNONYM_NAME clear
col TABLE_NAME clear
set head off


select 'ORA_U11g_3.9.2 ,3.9.8-21 **** Password Policies **** ' from dual;
set head on
col profile format a20
col resource_name format a20
col limit format a20
select * from DBA_PROFILES order by PROFILE;
--select profile,resource_name,limit from dba_profiles where resource_type='PASSWORD' order by profile,resource_name;
col profile clear 
col resource_name clear
col limit clear
set head off


select 'ORA_U11g_3.9.3, 3.9.7 **** Default User password **** ' from dual;
set head on
SELECT * FROM DBA_USERS_WITH_DEFPWD;
set head off



select 'ORA_U11g_3.9.4 **** Accounts – Schema Owners **** ' from dual;
set head on
col username format a20
col account_status format a20
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS;
col username clear
col account_status clear
set head off



select 'ORA_U11g_3.9.22 **** Oracle Database password - SEC_CASE_SENSITIVE_LOGON **** ' from dual;
set head on
col name format A20
col value format A20
SELECT NAME,UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_CASE_SENSITIVE_LOGON' ;
select name,value from v$parameter where name in('SEC_CASE_SENSITIVE_LOGON');
col name clear
col value clear
 set head off
 
 
select 'ORA_U11g_3.9.23 **** Maximum failed login attempts **** ' from dual;
set head on
col name format A20
col value format A20
SELECT NAME,UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_MAX_FAILED_LOGIN_ATTEMPTS' ;
select name,value from v$parameter where name in('SEC_MAX_FAILED_LOGIN_ATTEMPTS');
col name clear
col value clear



select 'ORA_U11g_3.10.1 **** Privileges **** ' from dual;
set head on
SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE LIKE('%ANY%'); 
set head off


select 'ORA_U11g_3.10.2 **** Password protect roles **** ' from dual;
set head on
SELECT * FROM DBA_ROLES;
set head off

select 'ORA_U11g_3.10.4 **** Default Tablespace **** ' from dual;
set head on
col username format a20
col DEFAULT_TABLESPACE format a20
SELECT USERNAME, DEFAULT_TABLESPACE FROM DBA_USERS; 
col username clear
col DEFAULT_TABLESPACE clear
set head off


select 'ORA_U11g_3.10.5 **** Tablespace Quotas **** ' from dual;
set head on
SELECT * FROM DBA_TS_QUOTAS;
set head off


select 'ORA_U11g_3.10.6 **** Any dictionary objects **** ' from dual;
set head on

SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SELECT ANY DICTIONARY';

set head off


select 'ORA_U11g_3.10.7 **** DBA Role **** ' from dual;
set head on
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='DBA';
set head off



select 'ORA_U11g_3.10.9 **** Public role permissions **** ' from dual;
set head on
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='PUBLIC';
set head off

select 'ORA_U11g_3.10.10 **** Prevent access to SYS.LINK$ ****' from dual;
select '********** ' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
select grantee, privilege from dba_tab_privs where TABLE_NAME='LINK$'; 
col grantee clear
col privilege clear
col table_name clear  
set head off



select 'ORA_U11g_3.10.11 **** Prevent access to SYS.AUD$ ****' from dual;
select '********** ' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
select grantee, privilege from dba_tab_privs where TABLE_NAME='AUD$'; 
set head off
col grantee clear
col privilege clear
col table_name clear  


select 'ORA_U11g_3.10.12 **** Prevent access to USER_HISTORY$ ****' from dual;
set head on
col grantee format a20
col privilege format a20
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER_HISTORY$';
col grantee clear
col privilege clear
set head off


select 'ORA_U11g_3.10.13 **** Prevent access to SYS.USER$ ****' from dual;
select '********** ' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
select grantee, privilege from dba_tab_privs where TABLE_NAME='USER$'; 
col grantee clear
col privilege clear
col table_name clear  
set head off


select 'ORA_U11g_3.10.14 **** Prevent access to SYS.SOURCE$ ****' from dual;
set head on
col grantee format a20
col privilege format a20
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='SOURCE$';
col grantee clear
col privilege clear
set head off



select 'ORA_U11g_3.10.15 **** Prevent access to STATS$SQLTEXT ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='STATS$SQLTEXT';
col grantee clear
col privilege clear
col table_name clear
set head off



select 'ORA_U11g_3.10.16 **** Prevent access to STATS$SQLSUM ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='STATS$SQLSUM';
col grantee clear
col privilege clear
col table_name clear
set head off




select 'ORA_U11g_3.10.17 **** Prevent access to any X$ table ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME LIKE('X$%');
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.18 **** PUBLIC VIEW ****' from dual;
set head on
--SELECT TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME LIKE('ALL_%') AND GRANTEE='PUBLIC';
select grantee,table_name,substr(privilege,1,20) privilege from sys.dba_tab_privs where table_name in ('ALL_USERS','ALL_TAB_PRIVS','ALL_SOURCE','ALL_DB_LINKS') and grantee = 'PUBLIC';
set head off



select 'ORA_U11g_3.10.19 **** PREVENT ACCESS TO DBA VIEW ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME LIKE('DBA_$%');
col grantee clear
col privilege clear
col table_name clear
set head off



select 'ORA_U11g_3.10.20 **** Prevent access to any V_$ _views ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME LIKE('V$%');
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.21 **** Prevent access to ALL_SOURCE _views ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='ALL_SOURCE';
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.22 **** Prevent access to DBA_ROLES ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBA_ROLES' ;
col grantee clear
col privilege clear
col table_name clear
set head off



select 'ORA_U11g_3.10.23 **** Prevent access to DBA_SYS_PRIVS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBA_SYS_PRIVS';
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.24 **** Prevent access to DBA_ROLE_PRIVS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBA_ROLE_PRIVS';
col grantee clear
col privilege clear
col table_name clear
set head off



select 'ORA_U11g_3.10.25 **** Prevent access to DBA_TAB_PRIVS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBA_TAB_PRIVS';
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.26 **** Prevent access to DBA_USERS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBA_USERS';
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.27 **** Prevent access to ROLE_ROLE_PRIVS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='ROLE_ROLE_PRIVS';
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.28 **** Prevent access to USER_TAB_PRIVS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER_TAB_PRIVS';
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.29 **** Prevent access to USER_ROLE_PRIVS ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER_ROLE_PRIVS';
col grantee clear
col privilege clear
col table_name clear
set head off

 
select 'ORA_U11g_3.10.30 **** Prevent assignment of roles that have _CATALOG_ ****' from dual;
set head on
col grantee format a20
col privilege format a20
col table_name format a20
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME LIKE('%_CATALOG_%'); 
col grantee clear
col privilege clear
col table_name clear
set head off


select 'ORA_U11g_3.10.31 **** Prevent assignment of RESOURCE  ****' from dual;
--set head on
--SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='RESOURCE';
--set head off
set head on

select 'ROLE',grantee,granted_role from dba_role_privs p, dba_roles r where  granted_role in ('RESOURCE','CONNECT') and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,granted_role from dba_role_privs p, dba_users u where  granted_role in ('RESOURCE','CONNECT') and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status in ('OPEN','EXPIRE');

set head off




select 'ORA_U11g_3.10.32 **** Restrict system privileges. ****' from dual;
set head on
SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE LIKE('%ANY%');
set head off


select 'ORA_U11g_3.10.33 ****  EXEMPT ACCESS POLICY (EAP)  ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE='EXEMPT ACCESS POLICY';
--set head off

set head on
col grantee format a20
col privilege format a20
select 'ROLE',grantee,privilege from dba_sys_privs p, dba_roles r where  privilege = 'EXEMPT ACCESS POLICY' and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,privilege from dba_sys_privs p, dba_users u where  privilege = 'EXEMPT ACCESS POLICY' and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status like ('OPEN');
set head off
col grantee clear
col privilege clear






select 'ORA_U11g_3.10.34 **** Prevent granting of privileges that have WITH ADMIN ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE ADMIN_OPTION='YES';
--set head off
set head on
col grantee format a20
select 'ROLE',grantee from dba_role_privs p,dba_roles r where p.grantee=r.role and admin_option='YES' and r.role not in ('DBA')
union select 'USER',grantee from dba_sys_privs p,dba_users u where p.grantee=u.username and admin_option='YES' and u.username not in ('SYS','SYSTEM') and account_status like ('OPEN');
col grantee clear
set head off




select 'ORA_U11g_3.10.35 **** Prevent granting of privileges that have WITH GRANT ****' from dual;
set head on
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTABLE='YES';
set head off



select 'ORA_U11g_3.10.36 **** Prevent granting of privileges that have CREATE ****' from dual;
set head on
SELECT * FROM DBA_SYS_PRIVS FROM PRIVILEGE LIKE('CREATE %'); 
set head off


select 'ORA_U11g_3.10.37 **** Prevent granting of CREATE LIBRARY ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE='CREATE LIBRARY';
--set head off
set head on
col grantee format a20
col privilege format a20
select 'ROLE',grantee,privilege from dba_sys_privs p, dba_roles r where  privilege = 'CREATE LIBRARY' and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,privilege from dba_sys_privs p, dba_users u where  privilege = 'CREATE LIBRARY' and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status like ('OPEN');
set head off
col grantee clear
col privilege clear



select 'ORA_U11g_3.10.38 **** Prevent granting of ALTER SYSTEM ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE='ALTER SYSTEM';
--set head off
set head on
col grantee format a20
col privilege format a20
select 'ROLE',grantee,privilege from dba_sys_privs p, dba_roles r where  privilege = 'ALTER SYSTEM' and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,privilege from dba_sys_privs p, dba_users u where  privilege = 'ALTER SYSTEM' and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status like ('OPEN');
set head off
col grantee clear
col privilege clear





select 'ORA_U11g_3.10.39 **** Prevent granting of BECOME USER ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE LIKE('BECOME USER');
--set head off
set head on
col grantee format a20
col privilege format a20
select 'ROLE',grantee,privilege from dba_sys_privs p, dba_roles r where  privilege = 'BECOME USER' and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,privilege from dba_sys_privs p, dba_users u where  privilege = 'BECOME USER' and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status like ('OPEN');
set head off
col grantee clear
col privilege clear


select 'ORA_U11g_3.10.40 **** Prevent granting of CREATE PROCEDURE ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE='CREATE PROCEDURE';
--set head off
set head on
col grantee format a20
col privilege format a20
select 'ROLE',grantee,privilege from dba_sys_privs p, dba_roles r where  privilege = 'CREATE PROCEDURE' and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,privilege from dba_sys_privs p, dba_users u where  privilege = 'CREATE PROCEDURE' and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status like ('OPEN');
set head off
col grantee clear
col privilege clear




select 'ORA_U11g_3.10.41 **** Prevent granting of SELECT ANY TABLE ****' from dual;
set head on
SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE LIKE('SELECT ANY%');
set head off



select 'ORA_U11g_3.10.42 **** Prevent granting of AUDIT SYSTEM ****' from dual;
--set head on
--SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE='AUDIT SYSTEM';
--set head off
set head on
col grantee format a20
col privilege format a20
select 'ROLE',grantee,privilege from dba_sys_privs p, dba_roles r where  privilege = 'AUDIT SYSTEM' and p.grantee = r.role and r.role not in ('DBA') union select 'USER',grantee,privilege from dba_sys_privs p, dba_users u where  privilege = 'AUDIT SYSTEM' and p.grantee = u.username and u.username not in ('SYS','SYSTEM')and u.account_status like ('OPEN');
set head off
col grantee clear
col privilege clear


select 'ORA_U11g_3.10.43 **** Review privileges granted to PUBLIC ****' from dual;
set head on
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='PUBLIC';
set head off


select 'ORA_U11g_3.10.44 **** Limit access to V$ synonym ****' from dual;
set head on 
SELECT SYNONYM_NAME, TABLE_NAME FROM ALL_SYNONYMS WHERE TABLE_NAME LIKE('V$%'); 
set head off


select 'ORA_U11g_3.11.2 ###### Change the listener port ######' from dual;
set head on
select value from v$parameter where name='local_listener';
set head off


select 'ORA_U11g_3.12.15 **** Configure the REMOTE_LOGIN_PASSWORDFILE parameter. ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('remote_login_passwordfile');
col name clear
col value clear
set head off


select 'ORA_U11g_3.13.12 **** Configure the SEC_PROTOCOL_ERROR_FURTHER_ACTION ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('SEC_PROTOCOL_ERROR_FURTHER_ACTION');
col name clear
col value clear
set head off


select 'ORA_U11g_3.13.13 ****Configure the SEC_PROTOCOL_ERROR_TRACE_ACTION ****' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name in('SEC_PROTOCOL_ERROR_TRACE_ACTION');
col name clear
col value clear
set head off


select 'ORA_U10g_3.16.1 **** Configure  AUDIT_TRAIL parameters ' from dual;
set head on
col name format A20
col value format A20
select name, value from v$parameter where name = 'audit_trail';
col name clear
col value clear
set head off


select 'ORA_U11g_3.16.3 **** Enable the AUDIT_SYS_OPERATIONS **** ' from dual;
set head on
col name format a20
col value format a20
select name,value from v$parameter where name = 'audit_sys_operations';
set head off
col name clear
col value clear




select 'ORA_U11g_3.16.4 **** Implement Security Auditing **** ' from dual;
Select 'AlterANYTable' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER ANY TABLE' ;
set head off

Select 'AlterUser' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER USER';
set head off

select 'CreateStatement' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION LIKE('CREATE%') ;
set head off

Select 'AuditCreaterole' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='CREATE ROLE';
set head off 

Select 'AuditCreateUser' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='CREATE USER';
set head off 

Select 'CreateSession' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='CREATE SESSION';
set head off

Select 'DropStatement' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION LIKE('DROP%');
set head off

select 'DropAnyprocedure' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP PROCEDURE' ;
set head off 

Select 'DropAnyTable' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP ANY TABLE';
set head off

Select 'GrantAnyPrivilege' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='GRANT ANY PRIVILEGE';
set head off

Select 'GrantAnyRole' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='GRANT ANY ROLE';
set head off

Select 'AuditInsertFailure' from dual;
set head on
SELECT OBJECT_NAME, INS FROM DBA_OBJ_AUDIT_OPTS;
set head off





select 'ORA_U11g_3.16.5 **** Auditing **** ' from dual;
select 'AuditExecuteProcedure' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='EXECUTE PROCEDURE';
set head off


select 'AuditSelectAnyDictionary' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SELECT ANY DICTIONARY';
set head off

select 'GrantAnyObject' from dual;
set head on
SELECT * FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='GRANT ANY OBJECT';
set head off



select 'ORA_U11g_3.16.10 **** DBA Audit Policy **** ' from dual;
SET head ON
SELECT policy_name FROM DBA_AUDIT_POLICIES;
set head off



select 'ORA_U11g_3.16.14 **** Set AUDIT ALL ON SYS.AUD$ BY ACCESS **** ' from dual;
set head on
SELECT * FROM DBA_OBJ_AUDIT_OPTS WHERE OBJECT_NAME='AUD$';
set head off

  
select 'ORA_U11g_3.17.1 **** Review the ACL for usage of the UTL_FILE package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_FILE';
col grantee clear
col table_name clear
set head off


select 'ORA_U11g_3.17.2 **** Review the ACL for usage of the UTL_TCP package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_TCP';
col grantee clear
col table_name clear
set head off



select 'ORA_U11g_3.17.3 **** Review the ACL for usage of the UTL_HTTP package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_HTTP'; 
col grantee clear
col table_name clear
set head off


select 'ORA_U11g_3.17.4 **** Review the ACL for usage of the UTL_SMTP package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='UTL_SMTP';
col grantee clear
col table_name clear
set head off


select 'ORA_U11g_3.17.5 **** Review the Access for usage of the DBMS_LOB package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBMS_LOB';
col grantee clear
col table_name clear
set head off


select 'ORA_U11g_3.17.6 **** Review the Access for usage of the DBMS_SYS_SQL package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBMS_SYS_SQL';
col grantee clear
col table_name clear
set head off



select 'ORA_U11g_3.17.7 **** Review the Access for usage of the DBMS_JOB package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBMS_JOB';
col grantee clear
col table_name clear
set head off



select 'ORA_U11g_3.17.8 **** Review the Access for usage of the DBMS_RANDOM package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBMS_RANDOM';
col grantee clear
col table_name clear
set head off




select 'ORA_U11g_3.17.10 **** Review the Access for usage of the DBMS_BACKUP_RESTORE package.**** ' from dual;
set head on
col grantee format a20
col table_name format a20
SELECT GRANTEE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE TABLE_NAME='DBMS_BACKUP_RESTORE';
col grantee clear
col table_name clear
set head off



set recsep off
spool off




--------------Operating System Audit Script Generation 

spool host.sh
set term off

select '#!/bin/bash' from dual;

select 'exec >> ORA_U11g_Unix.txt' from dual;

select '####### ORACLE OPERATING SYSTEM AUDIT SETTINGS ######' from dual;
select 'echo "###### Hostname ######"' from dual;
select 'echo' from dual;
select 'hostname' from dual;
select 'echo' from dual;




select 'echo "ORA_U11g_3.1.9. ###### Oracle DBA group membership on this host ######"' from dual;
select 'echo' from dual;
select 'cat /etc/group' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.1.10. ###### Restrict Oracle init file ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.1.22 . ###### Secure Control file ######"' from dual;
select 'echo' from dual;
select 'ls -l '||name from v$controlfile;
select 'echo' from dual;


select 'echo "ORA_U11g_3.1.23. ###### Oracle data files ######"' from dual;
select 'echo' from dual;
select 'echo "Permission on data files"' from dual;
select 'echo' from dual;
select 'ls -l '||file_name from dba_data_files;
select 'echo' from dual;


select 'echo "ORA_U11g_3.1.24 . ###### Verify and set ownership######"' from dual;
select 'ls -l $ORACLE_HOME/bin/*' from dual;
select'echo' from dual;


select 'echo "ORA_U11g_3.1.25 . ###### Disable otrace ######"' from dual;
select 'ls $ORACLE_HOME/otrace/admin/*.dat' from dual;
select'echo' from dual;


select 'echo "ORA_U11g_3.2.27. ###### Unlimited Access to tkprof utility ######"' from dual;
select 'echo' from dual;
select 'ls -l $ORACLE_HOME/bin/tkprof' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.3.1. ###### Oracle DBA group membership on host ######"' from dual;
select 'echo' from dual;
select 'cat /etc/group' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.4.6. ###### Oracle Installation ######"' from dual;
select 'echo' from dual;
select 'grep -i oracle /etc/passwd' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.6.5. ###### Files in ORACLE_HOME/BIN ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/bin/' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.6.6. ###### Files in $ORACLE_HOME (not including $ORACLE_HOME/bin) ######"' from dual;		
select 'echo' from dual;
select 'ls –la $ORACLE_HOME' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.7.10. ###### Configure SEC_USER_UNAUTHORIZED_ACCESS_BANNER ######"' from dual;
select 'echo' from dual;
select 'grep -i SEC_USER_UNAUTHORIZED_ACCESS_BANNER $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.8.1. ###### Set the TCP.INVITED_NODES to valid values ######"' from dual;
select 'echo' from dual;
select 'grep -i tcp.invited_nodes $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.8.2. ###### Set the tcp.excluded_nodes to valid values ######"' from dual;
select 'echo' from dual;
select 'grep -i tcp.excluded_nodes $ORACLE_HOME/network/admin/sqlnet.ora'from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.10.47. ###### Remove OEM object if not used. ######"' from dual;
select 'echo' from dual;
select 'ls –al $ORACLE_HOME/bin/dbsnmp' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.1. ###### Change the listener port. ######"' from dual;
select 'echo' from dual;
select 'grep default $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.3. ###### Use non-default SID. ######"' from dual;
select 'echo' from dual;
select 'grep -i ORCL $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.4. ###### Limit the listener file permission  ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.5. ###### Configure the LOG_FILE_LISTENER parameter ######"' from dual;
select 'echo' from dual;
select 'grep -i log_file_listener $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;
 
 
select 'echo "ORA_U11g_3.11.6. ###### Configure the TRACE_DIRECTORY_LISTENER_NAME  parameter ######"' from dual;
select 'echo' from dual;
select 'grep -i trace-directory $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.7/8. ###### Oracle Listener - ADMIN_RESTRICTIONS ######"' from dual;
select 'echo' from dual;
select 'grep -i admin_restrictions $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.9. ###### LISTENER PASSWORD  ######"' from dual;
select 'echo' from dual;
select 'lsnrctl status | egrep -i "security"' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.10. ###### Configure the LOGGING_LISTENER parameter  ######"' from dual;
select 'echo' from dual;
select 'grep -i logging_listener $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.11. ###### Use absolute paths in ENVS parameters.  ######"' from dual;
select 'echo' from dual;
select 'grep –i ENVS listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.12. ###### Configure the SECURE_CONTROL_listener_name parameter  ######"' from dual;
select 'echo' from dual;
select 'grep -i SECURE_CONTROL $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.13. ###### Configure the SECURE_PROTOCOL_listener_name parameter  ######"' from dual;
select 'echo' from dual;
select 'grep -i SECURE_PROTOCOL $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.14. ###### Configure the SECURE_REGISTER_listener_name parameter  ######"' from dual;
select 'echo' from dual;
select 'grep -i SECURE_REGISTER $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.15. ###### Configure the DYNAMIC_REGISTRATION_listener_name parameter  ######"' from dual;
select 'echo' from dual;
select 'grep –i DYNAMIC_REGISTRATION $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.16. ###### Configure the EXTPROCS_DLLS parameter  ######"' from dual;
select 'echo' from dual;
select 'grep –i EXTPROCS_DLLS $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.17. ###### Do not set the password manually in listener.ora   ######"' from dual;
select 'echo' from dual;
select 'grep -i PASSWORD $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.21. ###### Turn on logging for all listeners.  ######"' from dual;
select 'echo' from dual;
select 'grep -i logging_listener $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.11.23. ###### Use IP addresses rather than hostnames ######"' from dual;
select 'echo' from dual;
select 'grep -i HOST $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.1. ###### UMASK value for Oracle account ######"' from dual;
select 'echo' from dual;
select 'umask' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.2. ###### Verify and restrict permission on the  spfile.ora ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/dbs/spfile.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.3. ###### Verify and restrict permission on the  init.ora ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.4. ###### Verify and restrict permission ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/dbs/*' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.5. ###### Verify permissions of file referenced by ifile parameter ######"' from dual;
select 'echo' from dual;
select 'grep ifile $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.7. ###### Redo log files ######"' from dual; 
select 'echo' from dual;
select 'grep -i log_archive_duplex_dest $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.8. ###### Specify redo logging must be successful. ######"' from dual; 
select 'echo' from dual;
select 'grep -i LOG_ARCHIVE_MIN_SUCCEED_DEST $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.9. ###### Set BACKGROUND_DUMP_DEST . ######"' from dual; 
select 'echo' from dual;
select 'grep -i BACKGROUND_DUMP_DEST $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.10. ###### Set CORE_DUMP_DEST  . ######"' from dual; 
select 'echo' from dual;
select 'grep -i CORE_DUMP_DEST  $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.11. ###### Ensure restriction on control_files ######"' from dual;
select 'echo' from dual;
select 'echo "Permission on control files"' from dual;
select 'echo' from dual;
select 'ls -l '||name from v$controlfile;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.13. ###### Verify and set permissions in ADMIN directory ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/network/admin/*' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.14. ###### Configure the SQL92_SECURITY parameter. ######"' from dual;
select 'echo' from dual;
select 'grep -i sql92_security $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.16. ###### Disable default ports ftp: 2100 and http:8080 ######"' from dual;
select 'echo' from dual;
select 'grep -i $ORACLE_HOME/dbs/spfile'||instance_name||'.ora' from v$instance;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.17. ###### Remove extproc. ######"' from dual;
select 'echo' from dual;
select 'grep –i EXTPROCS_DLLS $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.18. ###### Restrict sqlnet.ora. ######"' from dual;
select 'echo' from dual;
select 'ls –al $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.20. ###### Configure the INBOUND_CONNECT_TIMEOUT_LISTENER ######"' from dual;
select 'echo' from dual;
select 'grep -i inbound_connect_timeout $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.21. ###### Configure the INBOUND_CONNECT_TIMEOUT ######"' from dual;
select 'echo' from dual;
select 'grep -i inbound_connect_timeout $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.22. ###### Configure the Expire_time parameter ######"' from dual;
select 'echo' from dual;
select 'grep -i expire_time $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.23. ###### Configure the log_directory_client ######"' from dual;
select 'echo' from dual;
select 'grep -i log_directory_client $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;




select 'echo "ORA_U11g_3.12.24. ###### Configure the log_directory_server ######"' from dual;
select 'echo' from dual;
select 'grep -i log_directory_server $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;



select 'echo "ORA_U11g_3.12.25. ###### Configure the trace_directory_client ######"' from dual;
select 'echo' from dual;
select 'grep -i trace_directory_client $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.28. ###### Verify and set permissions xsqlconfig ######"' from dual;
select 'echo' from dual;
select 'ls -al $ORACLE_HOME/xdk/admin/XSQLConfig.xml' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.12.29. ###### Do not use the utl_file_dir parameter directories ######"' from dual;
select 'echo' from dual;
select 'grep -i utl_file_dir $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;

select 'echo "ORA_U11g_3.13.1. ###### Configure the _TRACE_FILES_PUBLIC parameter ######"' from dual;
select 'echo' from dual;
select 'grep –i _trace_files_public $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.2. ###### Configure the TRACE_FILES_Listener Name ######"' from dual;
select 'echo' from dual;
select 'grep -i trace_file $ORACLE_HOME/network/admin/listener.ora' from dual;
select 'echo' from dual;

select 'echo "ORA_U11g_3.13.3. ###### Configure the GLOBAL_NAMES parameter ######"' from dual;
select 'echo' from dual;
select 'grep -i global_names $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.4. ###### Configure the REMOTE_LISTENER parameter ######"' from dual;
select 'echo' from dual;
select 'grep -i remote_listener $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.7. ###### Remove XDB servicec ######"' from dual;
seelct 'echo' from dual;
select 'grep -i XDB $ORACLE_HOME/dbs/spfile'||instance_name||'.ora' from v$instance;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.8. ###### Configure the TCP.VALIDNODE_CHECKING parameter ######"' from dual;
select 'echo' from dual;
select 'grep -i tcp.validnode_checking $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.9. ###### Configure inbound_connect_timeout ######"' from dual;
select 'echo' from dual;
select 'grep -i inbound_connect_timeout $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.10. ###### Configure ALLOWED_LOGIN_VERSION ######"' from dual;
select 'echo' from dual;
select 'grep -i ALLOWED_LOGIN_VERSION $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.11. ###### Configure REMOTE_ADMIN ######"' from dual;
select 'echo' from dual;
select 'grep –i REMOTE_ADMIN $ORACLE_HOME/network/admin/cman.ora' from dual;
select 'echo' from dual;


select 'echo "ORA_U11g_3.13.11. ###### Set the AUDIT_FILE_DEST parameter settings ######"' from dual;
select 'echo' from dual;
select 'grep -i audit_file_dest $ORACLE_HOME/dbs/init.ora' from dual;
select 'echo' from dual;


select 'ORA_U11g_3.16.11 Configure the SEC_USER_AUDIT_ACTION_BANNER parameter' from dual;
select 'echo' from dual;
select 'grep –i SEC_USER_AUDIT_ACTION_BANNER $ORACLE_HOME/network/admin/sqlnet.ora' from dual;
select 'echo' from dual;


spool off
host sh host.sh










