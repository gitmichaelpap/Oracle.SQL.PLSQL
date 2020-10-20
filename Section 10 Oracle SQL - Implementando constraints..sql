
TALUNO
  COD_ALUNO - PK -> Chave Primaria -> PRIMARY KEY

TCONTRATO
  COD_CONTRATO - PK -> Chave Primaria -> PRIMARY KEY
  COD_ALUNO - FK -> Chave primaria que vem de outra tabela


SELECT * FROM USER_CONSTRAINTS;

SELECT * FROM ALL_CONSTRAINTS;


--DROP TABLE tcidade

CREATE TABLE tcidade (
  cod_cidade INTEGER NOT NULL,
  nome VARCHAR2(40),
  CONSTRAINT pk_cidade PRIMARY KEY(cod_cidade)
);


CREATE TABLE tbairro (
  cod_cidade INTEGER NOT NULL,
  cod_bairro INTEGER NOT NULL,
  nome       VARCHAR2(40),
  CONSTRAINT pk_bairro PRIMARY KEY(cod_cidade,cod_bairro)
);

      1 - 1
      1 - 2
      2 - 1
      2 - 2

--Add chave estrangeira
ALTER TABLE tbairro ADD CONSTRAINT fk_cod_cidade
FOREIGN KEY (COD_CIDADE)
REFERENCES tcidade(COD_CIDADE);




CREATE TABLE trua(
  cod_rua INTEGER NOT NULL,
  cod_cidade INTEGER ,
  cod_bairro INTEGER ,
  nome VARCHAR(40),
  CONSTRAINT pk_rua PRIMARY KEY(cod_rua)
);


ALTER TABLE TRUA ADD CONSTRAINT fk_cidadebairro
FOREIGN KEY(cod_cidade, cod_bairro)
REFERENCES tbairro(cod_cidade, cod_bairro);



--DROP TABLE tpessoa  (Fornec ou Cliente)
CREATE TABLE tpessoa (
  cod_pessoa INTEGER      NOT NULL,
  tipo       VARCHAR2(1)  NOT NULL,
  nome       VARCHAR2(30) NOT NULL,
  pessoa     VARCHAR2(1)  NOT NULL,
  cod_rua    INTEGER      NOT NULL,
  cpf        VARCHAR2(15) ,
  CONSTRAINT pk_pessoa PRIMARY KEY (cod_pessoa)
);


--ALTER TABLE TPESSOA DROP CONSTRAINT NOME_CONSTRAINT
ALTER TABLE TPESSOA ADD CONSTRAINT FK_PESSOA_RUA
FOREIGN KEY (COD_RUA)
REFERENCES TRUA;


-----Cidade
INSERT INTO TCIDADE VALUES(1,'NOVO HAMBURGO');
INSERT INTO TCIDADE VALUES(2,'IVOTI');
INSERT INTO TCIDADE VALUES(3,'SAPIRANGA');
INSERT INTO TCIDADE VALUES(4,'TAQUARA');

SELECT * FROM TCIDADE

-----Bairro
INSERT INTO TBAIRRO VALUES(1,1,'CENTRO');
INSERT INTO TBAIRRO VALUES(2,1,'RIO BRANCO');
INSERT INTO TBAIRRO VALUES(3,1,'CENTRO');
INSERT INTO TBAIRRO VALUES(4,1,'FRITZ');


-----Rua
INSERT INTO TRUA VALUES (1,1,1,'MARCILIO DIAS');
INSERT INTO TRUA VALUES (2,2,1,'FRITZ');
INSERT INTO TRUA VALUES (3,3,1,'JACOBINA');
INSERT INTO TRUA VALUES (4,3,1,'JOAO DA SILVA');


--Check
ALTER TABLE TPESSOA ADD CONSTRAINT CK_PESSOA_TIPO
CHECK (TIPO IN ('C','F'));


ALTER TABLE TPESSOA ADD CONSTRAINT CK_PESSOA_JF
CHECK (PESSOA IN ('J','F'));


--Excluir constraint
ALTER TABLE TPESSOA DROP CONSTRAINT UK_CPF;

--Unique Key
ALTER TABLE TPESSOA ADD CONSTRAINT UK_CPF UNIQUE(CPF);

DELETE FROM TPESSOA;

INSERT INTO TPESSOA VALUES(1,'C','MARCIO','F',1,'1234');
INSERT INTO TPESSOA VALUES(2,'F','BEATRIZ','F',2,'123');
INSERT INTO TPESSOA VALUES(3,'F','PEDRO','F',4,'1238');
INSERT INTO TPESSOA VALUES(4,'C','MARIA','J',3,'1239');

SELECT * FROM TPESSOA


--Foreign Key Drop
ALTER TABLE TPESSOA DROP CONSTRAINT NOME_DA_CONSTRAINT
CASCADE CONSTRAINT;

--Check
ALTER TABLE TCONTRATO
ADD CONSTRAINT CK_CONTRATO_DESCONTO
CHECK (DESCONTO BETWEEN 0 AND 30);

SELECT * FROM TCONTRATO

--Desabilitando/Habilitando constraint
ALTER TABLE TPESSOA DISABLE CONSTRAINT uk_cpf;
ALTER TABLE TPESSOA ENABLE CONSTRAINT uk_cpf;

--Excluir Constraint
ALTER TABLE TPESSOA DROP CONSTRAINT uk_cpf;

SELECT * FROM user_constraints
WHERE table_name = 'TPESSOA';

--Constraint e as colunas associadas
SELECT constraint_name, column_name
FROM user_cons_columns
WHERE table_name = 'TPESSOA';

--
SELECT OBJECT_NAME, OBJECT_TYPE
FROM USER_OBJECTS
WHERE OBJECT_NAME IN ('TPESSOA')


SELECT * FROM TPESSOA


COMMIT;