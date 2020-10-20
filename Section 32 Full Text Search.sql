-- Criação de um diretório que indica a localização do documento

--Conectado como usuario system grant create any directory to marcio;

--Conectado como usuario normal create or replace directory arquivos as 'C:\Temp';

 

Agora conectado como usuário normal de desenvolvimento no SQL Developer vamos criar uma tabela

create table teste (
  codigo number,
  nome varchar2(40),
  documento blob
);
create sequence seq_doc;
-- Criação de uma procedure para carregar o arquivo para o banco de dados

create or replace procedure grava_arquivo (p_file in varchar(40))
as
  v_bfile bfile;
  v_blob blob;
begin
  insert into teste (codigo,nome,documento)
  values (seq_doc.nextval,p_file_name,empty_blob())
  return documento into v_blob;
  -- Informação de directory tem que ser maiusculo 
  v_bfile := bfilename('ARQUIVOS',p_file);
  dbms_lob.fileopen(v_bfile, dbms_lob.file_readonly);     
  dbms_lob.loadfromfile(v_blob,v_bfile,dbms_lob.getlength(v_bfile));
  dbms_lob.fileclose(v_bfile);
  commit;
end;
-- Grava o arquivo para a tabela 

execute grava_arquivo('arquivo.doc');
 

--Para testar se gravou o registro faça select na tabela

Select * from teste;
e

Select dbms_lob.getlength(documento) bytes from teste;
--Vamos criar índice que vai permitir pesquisar dentro deste arquivo grava na tabela

create index ind_teste_doc on teste (documento) indextype is ctxsys.context parameters ('sync (on commit)');
--Para verificar se houve erro na criação do índice

select * from ctx_user_index_errors;
--Podemos verificar que foram criados alguns índices adicionais usando o selects abaixo

select table_name from user_tables;
select index_name,table_name from user_indexes;
--Fazendo pesquisar no documento gravando na tabela

select codigo, nome from teste where contains(documento, 'Marcio', 1) > 0;
select codigo,nome from teste where contains(documento, 'curso', 1) > 0;