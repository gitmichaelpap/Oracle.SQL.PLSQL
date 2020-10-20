CREATE OR REPLACE DIRECTORY DIRETORIO AS 'F:\Temp';

DECLARE
 arquivo_saida UTL_File.File_Type;
 Cursor Cur_Linha is
 SELECT COD_ALUNO, NOME, CIDADE FROM TALUNO; 
BEGIN
 arquivo_saida := UTL_File.Fopen('DIRETORIO','Lista.txt','w');
 For Reg_Linha in Cur_linha Loop
 UTL_File.Put_Line(arquivo_saida, Reg_linha.COD_ALUNO||'-'||Reg_linha.NOME);
 UTL_File.Put_Line(arquivo_saida, Reg_linha.COD_ALUNO);
 End Loop;
 UTL_File.Fclose(arquivo_saida);
 Dbms_Output.Put_Line('Arquivo gerado com sucesso.');
EXCEPTION
 WHEN UTL_FILE.INVALID_OPERATION THEN
 Dbms_Output.Put_Line('Operação inválida no arquivo.');
 UTL_File.Fclose(arquivo_saida);
 WHEN UTL_FILE.WRITE_ERROR THEN
 Dbms_Output.Put_Line('Erro de gravação no arquivo.');
 UTL_File.Fclose(arquivo_saida);
 WHEN UTL_FILE.INVALID_PATH THEN
 Dbms_Output.Put_Line('Diretório inválido.');
 UTL_File.Fclose(arquivo_saida);
 WHEN UTL_FILE.INVALID_MODE THEN
 Dbms_Output.Put_Line('Modo de acesso inválido.');
 UTL_File.Fclose(arquivo_saida);
 WHEN Others THEN
 Dbms_Output.Put_Line('Problemas na geração do arquivo.');
 UTL_File.Fclose(arquivo_saida);
END;
Exemplo: Roteiro para leitura de arquivo texto:

DECLARE
 arquivo UTL_File.File_Type;
 Linha Varchar2(100);
BEGIN
 arquivo := UTL_File.Fopen('DIRETORIO','Lista.txt', 'r');
 Loop
 UTL_File.Get_Line(arquivo, Linha);
 Dbms_Output.Put_Line('Registro: '||linha);
 End Loop;
 UTL_File.Fclose(arquivo);
 Dbms_Output.Put_Line('Arquivo processado com sucesso.');
EXCEPTION
 WHEN No_data_found THEN
 UTL_File.Fclose(arquivo);
 WHEN UTL_FILE.INVALID_PATH THEN
 Dbms_Output.Put_Line('Diretório inválido.');
 UTL_File.Fclose(arquivo);
 WHEN Others THEN
 Dbms_Output.Put_Line ('Problemas na leitura do arquivo.');
 UTL_File.Fclose(arquivo);
END;
MAIS EXEMPLOS DE UTL_FILE

Rodar bloco anonimo conectado com seu usuario normal

DECLARE
 VLINHA VARCHAR2(2000) := '';
 VARQUIVO UTL_FILE.FILE_TYPE;
BEGIN
 VARQUIVO := UTL_FILE.FOPEN('DIRETORIO', 'Lista.TXT', 'w');
 FOR x in 1..8 LOOP
 VLINHA := 'LINHA ' || x;
 UTL_FILE.PUT_LINE(VARQUIVO, VLINHA);
 Dbms_Output.Put_Line('Registro: '||Vlinha);
 END LOOP;
 UTL_FILE.FCLOSE(VARQUIVO);
END;
Confira o arquivo na pasta F:\temp