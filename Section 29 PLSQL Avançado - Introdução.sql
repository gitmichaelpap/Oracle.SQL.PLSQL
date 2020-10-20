Script criação de tablespace

-- Deleta TableSpace
 
-- DROP TABLESPACE tbs_dados INCLUDING contents;
-- Cria tablespace p/ dados
 
CREATE TABLESPACE tbs_dados
 
datafile 'c:\oracle\oradata\tbs_dados.dbf' SIZE 2500M reuse
 
AUTOEXTEND ON NEXT 200M MAXSIZE 3000M
 
DEFAULT STORAGE (INITIAL 512K NEXT 256K
MINEXTENTS 1
MAXEXTENTS unlimited
PCTINCREASE 0)
ONLINE;
-- Cria usuário (dono das tabelas) 

create user curso --
Usuario
identified by "curso" --Senha
 
default tablespace tbs_dados
 
temporary tablespace temp;
-- Cria e define a "role" de privilégios create role ROLE_master;

grant
create cluster,
create database link,
create procedure,
create session,
create sequence,
create synonym,
create table,
create any type,
create trigger,
create any index,
create view
to role_master;
Grant alter session to role_master;
Grant role_master to curso;
Grant unlimited tablespace to curso;