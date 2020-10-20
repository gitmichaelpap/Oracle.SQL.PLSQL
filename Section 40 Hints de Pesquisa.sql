Hints de Pesquisa
CONHECENDO HINTS

Otimizador do Oracle � incrivelmente preciso na escolha do caminho de otimiza��o correto e no uso de �ndices para milhares de registros no seu sistema, porem exise casos que � preciso mudar.  O ORACLE possui hints ou sugest�es que voc� poder� usar para determinadas consultas, de modo que o otimizador seja desconsiderado, na esperan�a de conseguir melhor desempenho para determinada consulta.  Os hints modificam o caminho de execu��o quando um otimizador processa uma instru��o espec�fica. O par�metro OPTIMIZER_MODE de init.ora pode ser usado para modificar todas as instru��es no banco de dados para que sigam um caminho de execu��o espec�fico, mas um hint para um caminho de execu��o diferente substitui qualquer coisa que esteja especificada no init.ora. Contudo, a otimiza��o baseada em custo n�o ser� usada se as tabelas n�o tiverem sido analisadas.

Os hints podem ser muito �teis se soubermos quando e qual usar, mas eles podem ser mal�ficos se n�o forem utilizados na situa��o correta ou sem muito conhecimento de suas a��es e consequ�ncias! Nas �ltimas vers�es do SGBD Oracle, um hint obsoleto pode gerar um plano de execu��o ruim, e consequentemente, impactar negativamente na performance da instru��o SQL.

Veremos v�rios hints, como por exemplo: APPEND,PARALLEL e FIRST_ROWS, que s�o muito bons quando s�o utilizados nas situa��es adequadas! O hint APPEND, por exemplo, deve ser utilizado para otimizar cargas de dados via comando INSERT (atrav�s de carga direta) somente quando voc� tiver certeza de que outros usu�rios n�o estar�o atualizando dados concorrentemente na tabela! J� o hint PARALLEL, s� deve ser utilizado em consultas longas e quando houver recursos de processamento, mem�ria e I/O dispon�veis, ou seja, quando estes recursos, n�o estiverem sobrecarregados!




Hints de Pesquisa - Script
--Conectado como system --Vis�o dos hints select * from v$sql_hint

--Conectado como system grant select_catalog_role to marcio; grant select any dictionary to marcio;

-- first_rows: Para for�ar o uso de �ndice de modo geral.  -- Faz com que o otimizador escolha um caminho que recupera N linhas primeiramente  -- e ja mostra enquanto processa o resto

select * from taluno;
create index ind_aluno_nome on taluno(nome);
select /*+ first_rows(2) */ cod_aluno, nome from taluno
-- all_rows: Para for�ar varredura completa na tabela.

select /*+ all_rows (10) */ cod_aluno, nome
from taluno;
-- full: Para for�ar um scan completo na tabela. 
-- A hint full tamb�m pode causar resultados inesperados como varredura 
-- na tabela em ordem diferente da ordem padr�o.
 
select /*+ full_rows (taluno) */ cod_aluno, nome
from taluno
where nome = 'MARCIO' ;
-- index: For�a o uso de um �ndice. -- Nenhum �ndice � especificado.  -- O Oracle pesa todos os �ndices poss�veis e escolhe um ou mais a serem usados.  -- Otimizador n�o far� um scan completo na tabela.

select /*+ index */ cod_aluno, nome
from taluno
where nome = 'MARCIO' ;
---Exemplo do uso da hint index informando os �ndices que devem ser utilizados:

select /*+ index (taluno ind_aluno_nome) */ cod_aluno, nome, cidade
from taluno
where nome = 'MARCIO' ;
-- no_index: Evitar que um �ndice especificado seja usado pelo Oracle.

select /*+ no_index (taluno ind_aluno_nome) */ cod_aluno, nome, cidade
from taluno
where nome = 'MARCIO' ;
-- index_join : Permite mesclar �ndice em uma �nica tabela.  -- Permite acessar somente os �ndices da tabela, e n�o apenas um scan  -- com menos bloco no total, � mais r�pido do que usar um �ndice que faz scan na tabela por rowid.

create index ind_aluno_cidade on taluno(cidade)

select /*+ index_join (taluno ind_aluno_nome, ind_aluno_cidade) */ cod_aluno, nome, cidade
from taluno
where nome = 'MARCIO' AND cidade = 'NOVO HAMBURGO';
-- and_equal : Para acessar todos os �ndices que voc� especificar.  -- A hint and_equal faz com que o otimizador misture v�rios �ndices  -- para uma �nica tabela em vez de escolher qual � ao melhor.

select /*+ and_equal (taluno ind_aluno_nome, ind_aluno_cidade) */ cod_aluno, nome, cidade
from taluno
where nome = 'MARCIO' AND cidade = 'NOVO HAMBURGO';
-- index_ffs: For�a um scan completo do �ndice.  -- Este hint pode oferecer grandes ganhos de desempenho quando a tabela  -- tamb�m possuir muitas colunas.

select /*+ index_ffs (taluno ind_aluno_nome) */ cod_aluno, nome
from taluno
where nome = 'MARCIO'