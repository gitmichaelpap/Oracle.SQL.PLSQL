Manipulando XML - Scripts
--XML

SELECT XMLELEMENT("cod_aluno", cod_aluno) AS Aluno
FROM taluno;
SELECT XMLELEMENT("Nome", Nome) || XMLELEMENT("Cidade", cidade)
AS Aluno
FROM taluno;
SELECT XMLELEMENT("DataContrato", TO_CHAR(data, 'MM/DD/YYYY'))||''
AS Data_Contrato
FROM tcontrato;
SELECT XMLELEMENT("Aluno",
XMLELEMENT("cod_aluno", cod_aluno),
XMLELEMENT("nome", nome)) AS aluno
FROM taluno;
-------------------------------
SELECT XMLELEMENT("Aluno",
XMLATTRIBUTES(
cod_aluno AS "cod_aluno",
nome as "nome",
cidade AS "cidade" ) )AS Aluno
FROM taluno;
-------------------------------
SELECT XMLELEMENT("Aluno",
XMLFOREST( cod_aluno AS "codigo",
nome AS "nome",
cidade as "cidade"))AS Aluno
FROM TAluno;
SELECT XMLELEMENT("Aluno",
XMLFOREST(cod_aluno,
nome,
cidade))AS Aluno
FROM taluno
Select * from taluno
SELECT XMLELEMENT("Aluno",
XMLATTRIBUTES(cod_aluno as "cod_aluno"),
XMLFOREST(nome AS "nome", cidade AS "cidade", cep AS "cep") 
)AS aluno
FROM TALUNO
------------------------
SELECT XMLPARSE(CONTENT
'<TAluno><nome>Márcio Konrath</nome></TAluno>'
WELLFORMED
) AS ALUNO
FROM dual;
--Criando arquivo XML a partir de tabela

--Primeiramente temos que configurar o Oracle para aceitar criar arquivos
--Abra o CMD como Administrador set ORACLE_SID=curso
-- SQLPLUS SYS/123 AS SYSDBA

--Fechar o banco de dados SHUTDOWN IMMEDIATE;
--Iniciar o banco de dos sem abrir STARTUP MOUNT;
--Alterar o parâmetro UTL_FILE_DIR: ALTER SYSTEM SET UTL_FILE_DIR = '*' SCOPE = SPFILE;

--Fechar novamente o banco SHUTDOWN IMMEDIATE;
--Abrir o banco STARTUP
--Verificar se o parâmetro foi alterado SHOW PARAMETER UTL_FILE_DIR
--Dar privilegio para qualquer usuário para trabalhar com UTL_FILE GRANT EXECUTE ON UTL_FILE TO PUBLIC;

--Conectar novamente ao usuário no SQL Developer

--Gerando arquivo xml

Declare
  p_directory VARCHAR2(100) := 'D:\Temp';
  p_file_name VARCHAR2(50) := 'arquivo.xml';
  v_file UTL_FILE.FILE_TYPE;
  v_amount INTEGER:= 32767;
  v_xml_data XMLType;
  v_xml clob;
  v_char_buffer VARCHAR2(32767);
BEGIN
  -- abre o arquivo para gravar o texto (até v_amount
  -- caracteres por vez)
  v_file:= UTL_FILE.FOPEN(P_DIRECTORY,p_file_name,'w', v_amount);
  -- grava a linha inicial em v_file
  UTL_FILE.PUT_LINE(v_file, '<?xml version="1.0"?>');
  -- recupera os alunos e os armazena em v_xml_data
  SELECT XMLELEMENT(
  "Aluno",
  XMLFOREST(
  cod_aluno AS "codigo",
  nome AS "nome"
  ))AS Aluno
  INTO v_xml_data
  from taluno where cod_aluno = 1; 
 
  -- obtém o valor da string de v_xml_data e o armazena em v_char_buffer
  v_char_buffer:= v_xml_data.GETSTRINGVAL();
  -- copia os caracteres de v_char_buffer no arquivo
  UTL_FILE.PUT(v_file, v_char_buffer);
  -- descarrega os dados restantes no arquivo
  UTL_FILE.FFLUSH(v_file);
  -- fecha o arquivo
  UTL_FILE.FCLOSE(v_file);
end;
--Lendo arquivo
DECLARE
  arq_leitura UTL_File.File_Type;
  Linha Varchar2(250);
BEGIN
  arq_leitura := UTL_File.Fopen('D:\Temp\','arquivo.xml', 'r');
  Dbms_Output.Put_Line('Processamento');
  Loop
    UTL_File.Get_Line(arq_leitura, Linha);
    DBMS_OUTPUT.PUT('Linha XML: '||Linha);
    exit;
  End Loop;
  UTL_File.Fclose(arq_leitura);
  Dbms_Output.Put_Line('Arquivo processado com sucesso.');
EXCEPTION
  WHEN No_data_found THEN
    UTL_File.Fclose(arq_leitura);
    Commit;
  WHEN UTL_FILE.INVALID_PATH THEN
    Dbms_Output.Put_Line('Diretório inválido.');
    UTL_File.Fclose(arq_leitura);
  WHEN Others THEN
  Dbms_Output.Put_Line ('Problemas na leitura do arquivo.');
  UTL_File.Fclose(arq_leitura);
END;