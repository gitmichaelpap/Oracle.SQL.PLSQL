Cria��o de �ndices
Porque o �ndice � importante?
�ndices (Index) s�o importantes pois diminuem processamento e I/O em disco. Quando usamos um comando SQL para retirar informa��es de uma tabela, na qual, a coluna da mesma n�o possui um �ndice, o Oracle faz um Acesso Total a Tabela para procurar o dado, ou seja, realiza-se um FULL TABLE SCAN degradando a performance do Banco de Dados Oracle. Com o �ndice isso n�o ocorre, pois com o �ndice isso apontar� para a linha exata da tabela daquela coluna retirando o dado muito mais r�pido.

Crie �ndices quando:

Uma coluna contiver uma grande faixa de valores

Uma coluna contiver muitos valores nulos

Quando uma ou mais colunas forem usadas frequentemente em clausulas WHERE ou emJOINS

Se a tabela for muito grande e as consultas realizadas recuperarem menos de 5% dos registros.

N�O Crie �ndices quando:

As colunas n�o s�o usadas frequentemente como condi��o nas consultas

A tabela for pequena ou se os resultados das consultas forem maiores que 5-10% dos registros.

A tabela for atualizada com frequ�ncia

As colunas fizerem parte de uma express�o*

* Express�o � quando usado regra de filtro na clausula where, como por exemplo:

SELECT TABLE_NAME

FROM ALL_TABLES

WHERE TABLE_NAME||OWNER = 'DUALSYS'

Observe que na clausula de compara��o as colunas TABLE_NAME e OWNER fazem uma express�o de compara��o e por consequencia um �ndice n�o ajudaria em nada.

 

Outras coisas importantes de lembrar:

�NDICES N�O S�O ALTER�VEIS! (Para voc� alterar um �ndice voc� deve remov�-lo e recri�-lo. )
�NDICES ONERAM A PERFORMANCE DE INSERT / UPDATE  ( N�o d� pra fazer milagres, se sua tabela tiver muitos �ndices as performances de altera��es podem ser comprometidas )




Monitorando uso dos �ndices
Monitorando uso dos �ndices
Monitorando uso dos �ndices

Existem muitos bancos de dados em que �ndices est�o criados mais n�o s�o utilizados. Por exemplo, ter criado um �ndice para um determinado procedimento, que � executado somente uma vez e ap�s seu uso n�o � removido, ou at� mesmo o Oracle perceber que leitura por scans completos pode ser mais vantajoso do que utilizar um determinado �ndice (isso acontece).

Criar �ndice em uma base, deve ser algo realmente estudado, pois podem ter impacto negativo sobre o desempenho das opera��es DML. Al�m de modificar o valor do bloco da data, tamb�m � necess�rio atualizar o bloco do �ndice.

Por esse motivo que devesse notar muito bem a utiliza��o de um �ndice, caso n�o seja utilizado prejudica o desempenho do banco de dados.

Abaixo est� um exemplo para descobrir se um �ndice est� sendo ou n�o utilizado

--Cria��o de tabela de teste

create table teste (codigo number,  nome varchar2(40) );

  --Cria��o de indice create index ind_codigo on teste (codigo);

--Novo registro insert into teste values (1, 'MARCIO');

commit;

--Verificado se o �ndices j� foi usado

select index_name, table_name, used from v$object_usage;

--Alterado �ndice

alter index ind_codigo monitoring usage;

 

--Select para usar o indice select * from teste where codigo=1;

 

--Verificado se o �ndices j� foi usado novamente

select index_name, table_name, used from v$object_usage;

--Alterado �ndice para n�o ser monitorado

alter index ind_codigo nomonitoring usage;

Veja que a view v$OBJECT_USAGE, ter� cada �ndice do seu esquema cujo uso est� sendo monitorando, caso o �ndice n�o for usado, pode ser exclui-lo para melhorar performance de DML.