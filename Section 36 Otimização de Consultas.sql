Otimiza��o de Consulta
Otimiza��o de Consulta
AJUSTE DE SQL

Uma das principais vantagens da linguagem SQL � que voc� n�o precisa dizer ao banco de dados exatamente como ele deve obter os dados solicitados. Basta executar uma consulta especificando as informa��es desejadas e o software de banco de dados descobre a melhor maneira de obt�-las. �s vezes, voc� pode melhorar o desempenho de suas instru��es SQL �ajustando-as�. Nas se��es a seguir, voc� ver� dicas de ajuste que podem fazer suas consultas executarem mais rapidamente e t�cnicas de ajuste mais avan�adas.

 

USE UMA CL�USULA WHERE PARA FILTRAR LINHAS

Muitos iniciantes recuperam todas as linhas de uma tabela quando s� querem uma delas (ou algumas poucas). Isso � muito desperd�cio. Uma estrat�gia melhor � adicionar uma cl�usula WHERE em uma consulta. Desse modo, voc� restringe as linhas recuperadas apenas �quelas realmente necess�rias.

Por exemplo, digamos que voc� queira os detalhes dos clientes n� 1 e 2. A consulta a seguir recupera todas as linhas da tabela customers no esquema store (desperd�cio):

-- RUIM (recupera todas as linhas da tabela customers)

 

SELECT * FROM TALUNO;
  

A pr�xima consulta adiciona uma cl�usula WHERE ao exemplo anterior para obter apenas os

alunos n� 1 e 2:

 

-- BOM (usa uma cl�usula WHERE para limitar as linhas recuperadas)

SELECT *
FROM TALUNO
WHERE COD_ALUNO IN (1, 2);
 

USE JOINS DE TABELA EM VEZ DE V�RIAS CONSULTAS

Se voc� precisa de informa��es de v�rias tabelas relacionadas, deve usar condi��es de join, em vez

de v�rias consultas. No exemplo inadequado a seguir, s�o usadas duas consultas para obter o nome

e o tipo do produto n� 1 (usar duas consultas � desperd�cio). A primeira consulta obt�m os valores

de coluna nome e cod_aluno da tabela products para o produto n� 1. A segunda consulta

utiliza esse valor de cod_aluno para obter a coluna name da tabela TALUNO.

 

-- RUIM (duas consultas separadas, quando uma seria suficiente)

SELECT nome, cod_aluno
FROM taluno
WHERE cod_aluno = 1;
 

Em vez de usar duas consultas, voc� deve escrever uma �nica consulta que utilize um join

entre as tabelas products e product_types. A consulta correta a seguir mostra isso:

-- BOM (uma �nica consulta com um join)

SELECT CON.DATA, ALU.NOME, TOTAL
FROM TCONTRATO CON, TALUNO ALU
WHERE CON.COD_ALUNO = ALU.COD_ALUNO
AND CON.COD_CONTRATO = 1;
 

Essa consulta resulta na recupera��o do mesmo nome e tipo de produto do primeiro exemplo,

mas os resultados s�o obtidos com uma �nica consulta. Uma s� consulta geralmente � mais

eficiente do que duas.

Voc� deve escolher a ordem de jun��o em sua consulta de modo a juntar menos linhas nas

tabelas posteriormente. 

 

USE REFER�NCIAS DE COLUNA TOTALMENTE QUALIFICADAS AO FAZER JOINS

Sempre inclua apelidos de tabela em suas consultas e utilize o apelido de cada coluna (isso � conhecido

como �qualificar totalmente� suas refer�ncias de coluna). Desse modo, o banco de dados

n�o precisar� procurar nas tabelas cada coluna utilizada em sua consulta.

 

-- RUIM (as colunas TOTAL n�o esta totalmente qualificada)

SELECT CON.DATA, ALU.NOME
FROM TCONTRATO CON, TALUNO ALU
WHERE CON.COD_ALUNO = ALU.COD_ALUNO
AND CON.COD_CONTRATO = 1;
 

USE EXPRESS�ES CASE EM VEZ DE V�RIAS CONSULTAS

Use express�es CASE, em vez de v�rias consultas, quando precisar efetuar muitos c�lculos nas

mesmas linhas em uma tabela. O exemplo inadequado a seguir usa v�rias consultas para contar o

n�mero de produtos dentro de diversos intervalos de pre�o:

-- RUIM (tr�s consultas separadas, quando uma �nica instru��o CASE

funcionaria)

 

SELECT COUNT(*) FROM TCURSO WHERE VALOR < 800;
 

SELECT COUNT(*) FROM TCURSO WHERE VALOR BETWEEN 1000 AND 1500;
  

SELECT COUNT(*)
FROM TCURSO
WHERE VALOR > 1200;
 

 

Em vez de usar tr�s consultas, voc� deve escrever uma �nica que utilize express�es CASE. Isso

est� mostrado no exemplo correto a seguir:

 

-- BOM (uma �nica consulta com uma express�o CASE)

SELECT
COUNT(CASE WHEN VALOR < 800 THEN 1 ELSE null END) baixo,
COUNT(CASE WHEN VALOR BETWEEN 800 AND 1200 THEN 1 ELSE null END) medio,
COUNT(CASE WHEN VALOR > 1500 THEN 1 ELSE null END) alto
FROM TCURSO;
  

 

ADICIONE �NDICES NAS TABELAS

Ao procurar um t�pico espec�fico em um livro, voc� pode percorrer o livro inteiro ou utilizar o

�ndice para encontrar o local. Conceitualmente, um �ndice de uma tabela de banco de dados �

semelhante ao �ndice de um livro, exceto que os �ndices de banco de dados s�o usados para encontrar

linhas espec�ficas em uma tabela. O inconveniente dos �ndices � que, quando uma linha �

adicionada na tabela, � necess�rio tempo adicional para atualizar o �ndice da nova linha.

Geralmente, voc� deve criar um �ndice em uma coluna quando est� recuperando um pequeno

n�mero de linhas de uma tabela que contenha muitas linhas. Uma boa regra geral �:

Crie um �ndice quando uma consulta recuperar <= 10% do total de linhas de uma tabela.

Isso significa que a coluna do �ndice deve conter uma ampla variedade de valores. Uma boa

candidata � indexa��o seria uma coluna contendo um valor exclusivo para cada linha (por exemplo,

um n�mero de CPF). Uma candidata ruim para indexa��o seria uma coluna que contivesse

somente uma pequena variedade de valores (por exemplo, N, S, E, O ou 1, 2, 3, 4, 5, 6). Um banco

de dados Oracle cria um �ndice automaticamente para a chave prim�ria de uma tabela e para as

colunas inclu�das em uma restri��o �nica.

Al�m disso, se o seu banco de dados � acessado por muitas consultas hier�rquicas (isto �,

uma consulta contendo uma cl�usula CONNECT BY), voc� deve adicionar �ndices nas colunas referenciadas

nas cl�usulas START WITH e CONNECT BY

Por fim, para uma coluna que contenha uma pequena variedade de valores e seja usada

freq�entemente na cl�usula WHERE de consultas, voc� deve considerar a adi��o de um �ndice de

bitmap nessa coluna. Os �ndices de bitmap s�o normalmente usados em ambientes de data warehouse,

que s�o bancos de dados contendo volumes de dados muito grandes. Os dados de um

data warehouse normalmente s�o lidos por muitas consultas, mas n�o s�o modificados por muitas

transa��es concorrentes.

Normalmente, o administrador do banco de dados � respons�vel pela cria��o de �ndices.

Entretanto, como desenvolvedor de aplicativos, voc� poder� fornecer informa��es para ele sobre

quais colunas s�o boas candidatas � indexa��o, pois talvez saiba mais sobre o aplicativo do que o

DBA.

 

USE WHERE EM VEZ DE HAVING

A cl�usula WHERE � usada para filtrar linhas; a cl�usula HAVING, para filtrar grupos de linhas. Como

a cl�usula HAVING filtra grupos de linhas depois que elas foram agrupadas (o que leva algum tempo

para ser feito), quando poss�vel, voc� deve primeiro filtrar as linhas usando uma cl�usula WHERE.

Desse modo, voc� evita o tempo gasto para agrupar as linhas filtradas.

 

? Utiliza a cl�usula GROUP BY para agrupar as linhas em blocos

? Utiliza a cl�usula HAVING para filtrar os resultados retornados em fun��es de grupo

 

-- RUIM (usa HAVING em vez de WHERE)

SELECT COD_ALUNO, AVG(TOTAL)
FROM TCONTRATO
GROUP BY COD_ALUNO
HAVING COD_ALUNO IN (1, 2);
 

A consulta correta a seguir reescreve o exemplo anterior usando WHERE, em vez de HAVING,

para primeiro filtrar as linhas naquelas cujo valor de cod_aluno � 1 ou 2:

 

-- BOM (usa WHERE em vez de HAVING)

SELECT COD_ALUNO, AVG(TOTAL)
FROM TCONTRATO
WHERE COD_ALUNO IN (1, 2)
GROUP BY COD_ALUNO;
 

 

USE UNION ALL EM VEZ DE UNION

Voc� usa UNION ALL para obter todas as linhas recuperadas por duas consultas, incluindo as linhas

duplicadas; UNION � usado para obter todas as linhas n�o duplicadas recuperadas pelas consultas.

Como UNION remove as linhas duplicadas (o que leva algum tempo para ser feito), quando poss�vel,

voc� deve usar UNION ALL.

A consulta inadequada a seguir usa UNION (ruim, porque UNION ALL funcionaria) para obter

as linhas das tabelas products e more_products. Observe que todas as linhas n�o duplicadas de

products e more_products s�o recuperadas:

-- RUIM (usa UNION em vez de UNION ALL)

SELECT COD_ALUNO, NOME, CIDADE
FROM TALUNO
 
WHERE ESTADO = 'RS'
UNION
SELECT COD_ALUNO, NOME, CIDADE
FROM COD_ALUNO = 1;
A consulta correta a seguir reescreve o exemplo anterior para usar UNION ALL. Observe que

todas as linhas de products e more_products s�o recuperadas, incluindo as duplicadas:

 

-- BOM (usa UNION ALL em vez de UNION)

SELECT COD_ALUNO, NOME, CIDADE
FROM TALUNO
 
WHERE ESTADO = 'RS'
UNION ALL
SELECT COD_ALUNO, NOME, CIDADE
FROM COD_ALUNO = 1;
USE EXISTS EM VEZ DE IN

Voc� usa IN para verificar se um valor est� contido em uma lista. EXISTS � usado para verificar

a exist�ncia de linhas retornadas por uma subconsulta. EXISTS � diferente de IN: EXISTS apenas

verifica a exist�ncia de linhas, enquanto IN verifica os valores reais. Normalmente, EXISTS oferece

melhor desempenho do que IN com subconsultas. Portanto, quando poss�vel, use EXISTS em vez

de IN.

Consulte a se��o intitulada �Usando EXISTS e NOT EXISTS em uma subconsulta correlacionada�,

(um ponto importante a lembrar � que as subconsultas correlacionadas podem

trabalhar com valores nulos).

A consulta inadequada a seguir usa IN (ruim, porque EXISTS funcionaria) para recuperar os

produtos que foram comprados:

 

 

-- RUIM (usa IN em vez de EXISTS)

SELECT COD_CURSO, NOME
FROM TCURSO
WHERE COD_CURSO IN
(SELECT COD_CURSO
FROM TITEM);
 

 

-- BOM (usa EXISTS em vez de IN)

SELECT COD_CURSO, NOME
FROM TCURSO cur
WHERE EXISTS
(SELECT 1
FROM TITEM ite
WHERE ite.COD_CURSO = cur.COD_CURSO);
USE EXISTS EM VEZ DE DISTINCT
Voc� pode suprimir a exibi��o de linhas duplicadas usando DISTINCT. EXISTS � usado para verificar

a exist�ncia de linhas retornadas por uma subconsulta. Quando poss�vel, use EXISTS em vez de

DISTINCT, pois DISTINCT classifica as linhas recuperadas antes de suprimir as linhas duplicadas.

A consulta inadequada a seguir usa DISTINCT (ruim, porque EXISTS funcionaria) para recuperar

os produtos que foram comprados:

 

-- RUIM (usa DISTINCT quando EXISTS funcionaria)

SELECT DISTINCT ITE.COD_CURSO, CUR.NOME

FROM TCURSO cur, TITEM ite

WHERE ITE.COD_CURSO = CUR.COD_CURSO;

 

A consulta correta a seguir reescreve o exemplo anterior usando EXISTS em vez de DISTINCT:

 

-- BOM (usa EXISTS em vez de DISTINCT)

SELECT product_id, name
FROM products outer
WHERE EXISTS
(SELECT 1
FROM purchases inner
WHERE inner.product_id = outer.product_id);
 

 

USE GROUPING SETS EM VEZ DE CUBE

Normalmente, a cl�usula GROUPING SETS oferece melhor desempenho do que CUBE. Portanto,

quando poss�vel, voc� deve usar GROUPING SETS em vez de CUBE. Isso foi abordado detalhadamente

na se��o intitulada �Usando a cl�usula GROUPING SETS�.

 

USE VARI�VEIS DE BIND

O software de banco de dados Oracle coloca as instru��es SQL em cache; uma instru��o SQL colocada

no cache � reutilizada se uma instru��o id�ntica � enviada para o banco de dados. Quando

uma instru��o SQL � reutilizada, o tempo de execu��o � reduzido. Entretanto, a instru��o SQL

deve ser absolutamente id�ntica para ser reutilizada. Isso significa que:

? Todos os caracteres na instru��o SQL devem ser iguais

? Todas as letras na instru��o SQL devem ter a mesma caixa

? Todos os espa�os na instru��o SQL devem ser iguais

Se voc� precisa fornecer valores de coluna diferentes em uma instru��o, pode usar vari�veis

de bind em vez de valores de coluna literais. Exemplos que esclarecem essas id�ias s�o mostrados

a seguir.

 

Instru��es SQL n�o id�nticas

Nesta se��o, voc� ver� algumas instru��es SQL n�o id�nticas. As consultas n�o id�nticas a seguir

recuperam os produtos n� 1 e 2:

SELECT * FROM products WHERE product_id = 1;

SELECT * FROM products WHERE product_id = 2;

Essas consultas n�o s�o id�nticas, pois o valor 1 � usado na primeira instru��o, mas o valor 2

� usado na segunda. As consultas n�o id�nticas t�m espa�os em posi��es diferentes:

SELECT * FROM products WHERE product_id = 1;

SELECT * FROM products WHERE product_id = 1;

As consultas n�o id�nticas a seguir usam uma caixa diferente para alguns dos caracteres:

select * from products where product_id = 1;

SELECT * FROM products WHERE product_id = 1;

Agora que voc� j� viu algumas instru��es n�o id�nticas, vejamos instru��es SQL id�nticas

que utilizam vari�veis de bind.

 

Instru��es SQL id�nticas que usam vari�veis de bind

Voc� pode garantir que uma instru��o seja id�ntica utilizando vari�veis de bind para representar

valores de coluna. Uma vari�vel de bind � criada com o comando VARIABLE do SQL*Plus. Por

exemplo, o comando a seguir cria uma vari�vel chamada v_product_id de tipo NUMBER:

VARIABLE v_product_id NUMBER

 

COMPARANDO O CUSTO DA EXECU��O DE CONSULTAS

O software de banco de dados Oracle usa um subsistema conhecido como otimizador para gerar

o caminho mais eficiente para acessar os dados armazenados nas tabelas. O caminho gerado pelo

otimizador � conhecido como plano de execu��o. O Oracle Database 10g e as vers�es superiores

re�nem estat�sticas sobre os dados de suas tabelas e �ndices automaticamente, para gerar o melhor

plano de execu��o (isso � conhecido como otimiza��o baseada em custo).

A compara��o dos planos de execu��o gerados pelo otimizador permite a voc� julgar o custo

relativo de uma instru��o SQL em rela��o � outra. � poss�vel usar os resultados para aprimorar

suas instru��es SQL. Nesta se��o, voc� vai aprender a ver e interpretar dois exemplos de planos de

execu��o.


 

Examinando planos de execu��o

O otimizador gera um plano de execu��o para uma instru��o SQL. Voc� pode examinar o plano de

execu��o usando o comando EXPLAIN PLAN do SQL*Plus. O comando EXPLAIN PLAN preenche

uma tabela chamada plan_table com o plano de execu��o da instru��o SQL (plan_table � freq�entemente

referida como �tabela de plano�). Voc� pode ent�o examinar esse plano de execu��o

consultando a tabela de plano. A primeira coisa que voc� deve fazer � verificar se a tabela de plano

j� existe no banco de dados.

 

Gerando um plano de execu��o

Uma vez que voc� tenha uma tabela de plano, pode usar o comando EXPLAIN PLAN para gerar um

plano de execu��o para uma instru��o SQL. A sintaxe do comando EXPLAIN PLAN �:

EXPLAIN PLAN SET STATEMENT_ID = id_instru��o FOR instru��o_sql;

onde

? id_instru��o � o nome que voc� deseja dar ao plano de execu��o. Pode ser qualquer

texto alfanum�rico.

? instru��o_sql � a instru��o SQL para a qual voc� deseja gerar um plano de execu��o.

O exemplo a seguir gera o plano de execu��o para uma consulta que recupera todas as linhas

da tabela customers (observe que o valor de id_instru��o � configurado como 'CUSTOMERS'):

EXPLAIN PLAN SET STATEMENT_ID = 'CUSTOMERS' FOR

SELECT customer_id, first_name, last_name FROM customers;

Explained

Depois que o comando terminar, voc� pode examinar o plano de execu��o armazenado na

tabela de plano. Voc� vai aprender a fazer isso a seguir.

NOTA

A consulta na instru��o EXPLAIN PLAN n�o retorna linhas da tabela customers. A instru��o

EXPLAIN PLAN simplesmente gera o plano de execu��o que seria usado se a consulta fosse

executada.

Consultando a tabela de plano

Para consultar a tabela de plano, fornecemos um script SQL*Plus chamado explain_plan.sql no

diret�rio SQL. O script solicita o valor de statement_id (id_instru��o) e depois exibe o plano de

execu��o para essa instru��o.

O script explain_plan.sql cont�m as seguintes instru��es:

-- Exibe o plano de execu��o da statement_id especificada

UNDEFINE v_statement_id;
SELECT
id ||
DECODE(id, 0, '', LPAD(' ', 2*(level � 1))) || ' ' ||
operation || ' ' ||
options || ' ' ||
object_name || ' ' ||
object_type || ' ' ||
DECODE(cost, NULL, '', 'Cost = ' || position)
AS execution_plan
FROM plan_table
CONNECT BY PRIOR id = parent_id
AND statement_id = '&&v_statement_id'
START WITH id = 0
AND statement_id = '&v_statement_id';
 

Um plano de execu��o � organizado em uma hierarquia de opera��es de banco de dados

semelhante a uma �rvore; os detalhes dessas opera��es s�o armazenados na tabela de plano. A

opera��o com o valor de id igual a 0 � a raiz da hierarquia e todas as outras opera��es do plano

procedem dessa raiz. A consulta do script recupera os detalhes das opera��es, come�ando com a

opera��o raiz e, ent�o, percorre a �rvore a partir da raiz.

O exemplo a seguir mostra como executar o script explain_plan.sql para recuperar o plano

'CUSTOMERS' criado anteriormente:

SQL> @ c:\sql_book\sql\explain_plan.sql

Enter value for v_statement_id: CUSTOMERS

old 12: statement_id = '&&v_statement_id'

new 12: statement_id = 'CUSTOMERS'

old 14: statement_id = '&v_statement_id'

new 14: statement_id = 'CUSTOMERS'

EXECUTION_PLAN

----------------------------------------------

0 SELECT STATEMENT Cost = 3

1 TABLE ACCESS FULL CUSTOMERS TABLE Cost = 1

As opera��es mostradas na coluna EXECUTION_PLAN s�o executadas na seguinte ordem:

? A opera��o recuada mais � direita � executada primeiro, seguida de todas as opera��es

pai que est�o acima dela.

? Para opera��es com o mesmo recuo, a opera��o mais acima � executada primeiro, seguida

de todas as opera��es pai que est�o acima dela.

Cada opera��o envia seus resultados de volta no encadeamento at� sua opera��o pai imediata

e, ent�o, a opera��o pai � executada. Na coluna EXECUTION_PLAN, a ID da opera��o � mostrada

na extremidade esquerda. No exemplo de plano de execu��o, a opera��o 1 � executada primeiro,

com seus resultados sendo passados para a opera��o 0. O exemplo a seguir ilustra a ordem para

um exemplo mais complexo:

0 SELECT STATEMENT Cost = 6
1 MERGE JOIN Cost = 1
2 TABLE ACCESS BY INDEX ROWID PRODUCT_TYPES TABLE Cost = 1
3 INDEX FULL SCAN PRODUCT_TYPES_PK INDEX (UNIQUE) Cost = 1
4 SORT JOIN Cost = 2
5 TABLE ACCESS FULL PRODUCTS TABLE Cost = 1
A ordem em que as opera��es s�o executadas nesse exemplo � 3, 2, 5, 4, 1 e 0.

Agora que voc� j� conhece a ordem na qual as opera��es s�o executadas, � hora de aprender

para o que elas fazem realmente.  O plano de execu��o da consulta 'CUSTOMERS' era:

0 SELECT STATEMENT Cost = 3

1 TABLE ACCESS FULL CUSTOMERS TABLE Cost = 1

A opera��o 1 � executada primeiro, com seus resultados sendo passados para a opera��o 0.

A opera��o 1 envolve uma varredura integral � indicada pela string TABLE ACCESS FULL � da

tabela customers. Este � o comando original usado para gerar a consulta 'CUSTOMERS':

EXPLAIN PLAN SET STATEMENT_ID = 'CUSTOMERS' FOR
SELECT customer_id, first_name, last_name FROM customers;
 

Uma varredura integral da tabela � realizada porque a instru��o SELECT especifica que todas

as linhas da tabela customers devem ser recuperadas.

O custo total da consulta � de tr�s unidades de trabalho, conforme indicado na parte referente

ao custo mostrada � direita da opera��o 0 no plano de execu��o (0 SELECT STATEMENT Cost =

3). Uma unidade de trabalho � a quantidade de processamento que o software precisa para realizar

determinada opera��o. Quanto mais alto o custo, mais trabalho o software do banco de dados precisa

realizar para concluir a instru��o SQL.

NOTA

Se voc� estiver usando uma vers�o do banco de dados anterior ao Oracle Database 10g, a sa�da

do custo da instru��o global poder� estar em branco. Isso ocorre porque as vers�es de banco de

dados anteriores n�o re�nem estat�sticas de tabela automaticamente. Para reunir estat�sticas, voc�

precisa usar o comando ANALYZE. Voc� vai aprender a fazer isso na se��o �Reunindo estat�sticas

de tabela�.

Planos de execu��o envolvendo joins de tabela

Os planos de execu��o para consultas com joins de tabelas s�o mais complexos. O exemplo a seguir

gera o plano de execu��o de uma consulta que junta as tabelas products e product_types:

EXPLAIN PLAN SET STATEMENT_ID = 'PRODUCTS' FOR
SELECT p.name, pt.name
FROM products p, product_types pt
WHERE p.product_type_id = pt.product_type_id;
O plano de execu��o dessa consulta est� mostrado no exemplo a seguir:

@ c:\sql_book\sql\explain_plan.sql

Enter value for v_statement_id: PRODUCTS

EXECUTION_PLAN

----------------------------------------------------------------

0 SELECT STATEMENT Cost = 6
1 MERGE JOIN Cost = 1
2 TABLE ACCESS BY INDEX ROWID PRODUCT_TYPES TABLE Cost = 1
3 INDEX FULL SCAN PRODUCT_TYPES_PK INDEX (UNIQUE) Cost = 1
4 SORT JOIN Cost = 2
5 TABLE ACCESS FULL PRODUCTS TABLE Cost = 1
 

ID da opera��o Descri��o

3 Varredura integral do �ndice product_types_pk (que � um �ndice exclusivo)

para obter os endere�os das linhas na tabela product_types. Os

endere�os est�o na forma de valores de ROWID, os quais s�o passados para

a opera��o 2.

2 Acesso �s linhas da tabela product_types usando a lista de valores de

ROWID passada da opera��o 3. As linhas s�o passadas para a opera��o 1.

5 Acesso �s linhas da tabela products. As linhas s�o passadas para a opera��o

4.

4 Classifica��o das linhas passadas da opera��o 5. As linhas classificadas s�o

passadas para a opera��o 1.

1 Mesclagem das linhas passadas das opera��es 2 e 5. As linhas mescladas

s�o passadas para a opera��o 0.

0 Retorno das linhas da opera��o 1 para o usu�rio. O custo total da consulta

� de 6 unidades de trabalho.

Reunindo estat�sticas de tabela

Se estiver usando uma vers�o do banco de dados anterior ao Oracle Database 10g (como a 9i),

voc� mesmo ter� de reunir estat�sticas de tabela usando o comando ANALYZE. Por padr�o, se

nenhuma estat�stica estiver dispon�vel, a otimiza��o baseada em regra ser� utilizada. Normalmente,

a otimiza��o baseada em regra n�o � t�o boa quanto a otimiza��o baseada em custo. Os

exemplos a seguir usam o comando ANALYZE para reunir estat�sticas para as tabelas products e

product_types:

ANALYZE TABLE products COMPUTE STATISTICS;

ANALYZE TABLE product_types COMPUTE STATISTICS;

Uma vez reunidas as estat�sticas, a otimiza��o baseada em custo ser� usada em vez da otimiza��o

baseada em regra.

Comparando planos de execu��o

Comparando o custo total mostrado no plano de execu��o para diferentes instru��es SQL, voc�

pode determinar o valor do ajuste de seu c�digo SQL. Nesta se��o, voc� ver� como comparar dois

planos de execu��o e a vantagem de usar EXISTS em vez de DISTINCT (uma dica dada anteriormente).

O exemplo a seguir gera um plano de execu��o para uma consulta que usa EXISTS:

EXPLAIN PLAN SET STATEMENT_ID = 'EXISTS_QUERY' FOR
SELECT product_id, name
FROM products outer
WHERE EXISTS
(SELECT 1
FROM purchases inner
WHERE inner.product_id = outer.product_id);
EXPLAIN PLAN SET STATEMENT_ID = 'DISTINCT_QUERY' FOR
SELECT DISTINCT pr.product_id, pr.name
FROM products pr, purchases pu
WHERE pr.product_id = pu.product_id;
O plano de execu��o dessa consulta est� mostrado no exemplo a seguir:

@ c:\sql_book\sql\explain_plan.sql

Enter value for v_statement_id: DISTINCT_QUERY

EXECUTION_PLAN

--------------------------------------------------------------

0 SELECT STATEMENT Cost = 5
1 HASH UNIQUE Cost = 1
2 MERGE JOIN Cost = 1
3 TABLE ACCESS BY INDEX ROWID PRODUCTS TABLE Cost = 1
4 INDEX FULL SCAN PRODUCTS_PK INDEX (UNIQUE) Cost = 1
5 SORT JOIN Cost = 2
6 INDEX FULL SCAN PURCHASES_PK INDEX (UNIQUE) Cost = 1
O custo da consulta � de 5 unidades de trabalho. Essa consulta � mais dispendiosa do que a

anterior, que usou EXISTS (essa consulta tinha um custo de apenas 4 unidades de trabalho). Esses

resultados provam que � melhor usar EXISTS do que DISTINCT.

Refer�ncia Oracle DataBase 11G SQL