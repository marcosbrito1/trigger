-- Cria��o da tabela aluno
CREATE TABLE aluno(
id serial not null,
nome varchar(40),
matricula varchar(8),
primary key(id)
);

-- Adi��o de dados na tabela aluno:
INSERT INTO aluno(nome, matricula) VALUES('Jo�o', '12345678');
INSERT INTO aluno(nome, matricula) VALUES('Maria', '87654321');

-- Cria��o da tabela para armazenar os registros excluidos
CREATE TABLE aluno_excluido(
id serial not null,
id_anterior int,
matricula varchar(8),
nome varchar(40),
data_exclusao date default now(),
primary key(id)
);

-- Cria��o da function para ser executada pela trigger
CREATE OR REPLACE FUNCTION
guardar_informacoes() RETURNS trigger AS $$
BEGIN
INSERT INTO aluno_excluido(id_anterior, matricula, nome)
VALUES(OLD.id, OLD.matricula, OLD.nome);
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Cria��o da trigger
CREATE TRIGGER tg_guardar_aluno_excluido
  AFTER DELETE
  ON aluno
FOR EACH ROW
  EXECUTE PROCEDURE guardar_informacoes();
