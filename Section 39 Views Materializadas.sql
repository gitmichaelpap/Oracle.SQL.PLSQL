Views Materializadas Utilizamos elas para fazermos c�lculos, armazenamentos de dados e dar agilidade na troca de informa��es entre um banco de dados ou entre tabelas. Este recurso � muito utilizado em ambientes de Data Warehouse, que trabalha com uma enorme quantidade de informa��es. Pois com elas conseguimos melhorar a performance do sistema e trazer diversos benef�cios ao Oracle.

As Views Materializadas s�o utilizadas para fazer atualiza��es, a pr�pria Oracle garante que as atualiza��es s�o feitas com sucesso numa tabela destinat�ria ap�s terem sido efetivadas nas tabelas originais. Isso nos d� mais tranquilidade na administra��o e no desenvolvimento.

Exemplo de como se faz uma Views Materializadas:

CREATE MATERIALIZED VIEW VM_ALUNO BUILD IMMEDIATE  REFRESH FAST ENABLE QUERY REWRITE  AS (SELECT * FROM TALUNO WHERE CIDADE=�NOVO HAMBURGO�) BUILD IMMEDIATE

A View Materializada dever� utilizar os dados imediatamente na query rewrite (Seu SELECT), desde modo os dados ser�o processados com mais agilidade.

Existe tamb�m outro m�todo, chamado build deferred que significa que a view n�o ter� nenhum tipo de dados a ser utilizada automaticamente, esse modo seria um processamento manual das informa��es, que ser� depois atualizado pelo Refresh, resumindo, que com essa op��o o comando SELECT n�o ser� executado imediatamente.

REFRESH FAST

Esse m�todo � para dizer que as modifica��es ser�o utilizadas somente pela View Materializada, para utilizar este recurso com seguran�a, sugiro criar uma View Materializada Log, para ter controle sobre as modifica��es que est�o sendo feitas.

ENABLE QUERY REWRITE

Essa linha de comando � o que indica que o SELECT presente dentro da View Materializada ser� reescrita e atualizada para os novos valores passados pela VIEW. A query rewrite pode ter tr�s n�veis de integridade que vai desde o modo ENFORCED at� o STALE_TOLERATED, que indicar� ao banco de dados que tipo de confian�a ele poder� ter nos dados. Sobre as integridades, falaremos na pr�xima coluna tamb�m, pois e um pouco mais delicado.

AS SELECT

Aqui ser� colocado seu SELECT, onde poder� fazer alguns c�lculos ou visualiza��es de informa��es para outras tabelas, como no exemplo de SELECT a seguir.

SELECT * FROM TALUNO WHERE cidade = �NOVO HAMBURGO�
SELECTS que devemos utilizar dentro das Views Materializadas devem seguir um padr�o delas, como, por exemplo, n�o utilizar cl�usulas como UNION, UNION ALL, INTERSECT e MINUS. 



View Materializada Scripts
--Conectado como system --Direito para criar view materializada GRANT CREATE ANY MATERIALIZED VIEW TO marcio;

--Criar log para view CREATE MATERIALIZED VIEW LOG ON taluno TABLESPACE tbs_dados

--Excluir View DROP MATERIALIZED VIEW V_MAT;

--Criar View 

CREATE MATERIALIZED VIEW V_MAT
TABLESPACE tbs_dados
BUILD IMMEDIATE
REFRESH FAST ON COMMIT AS
(SELECT COD_ALUNO, NOME, CIDADE FROM TALUNO 
WHERE CIDADE = 'NOVO HABURGO');
INSERT INTO TALUNO (COD_ALUNO,NOME,CIDADE)
VALUES(SEQ_ALUNO.NEXTVAL,'TESTE 2','NOVO HAMBURGO');
SELECT * FROM TALUNO;
SELECT * FROM V_MAT;