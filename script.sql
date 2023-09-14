-- Criação da tabela aluno
CREATE TABLE aluno(
id serial not null,
nome varchar(40),
matricula varchar(8),
primary key(id)
);

-- Adição de dados na tabela aluno:
INSERT INTO aluno(nome, matricula) VALUES('João', '12345678');
INSERT INTO aluno(nome, matricula) VALUES('Maria', '87654321');

-- Criação da tabela para armazenar os registros excluidos
CREATE TABLE aluno_excluido(
id serial not null,
id_anterior int,
matricula varchar(8),
nome varchar(40),
data_exclusao date default now(),
primary key(id)
);

-- Criação da function para ser executada pela trigger
CREATE OR REPLACE FUNCTION
guardar_informacoes() RETURNS trigger AS $$
BEGIN
INSERT INTO aluno_excluido(id_anterior, matricula, nome)
VALUES(OLD.id, OLD.matricula, OLD.nome);
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Criação da trigger
CREATE TRIGGER tg_guardar_aluno_excluido
  AFTER DELETE
  ON aluno
FOR EACH ROW
  EXECUTE PROCEDURE guardar_informacoes();
