CREATE DATABASE escola;

USE escola;

CREATE table Aluno(

ID int AUTO_INCREMENT PRIMARY key,
nome VARCHAR(50), 
idade int,
curso VARCHAR(50)

);

desc Alunos;

INSERT into Aluno(nome, idade, curso)
VALUES
('Maria', "22", "História"),
("Pedro", "21", "CC"),
("Ana", "19", "Biologia"),
("Carlos", "23", "Economia");

Create table professor (

ID int AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50),
idade int,
disciplina VARCHAR(50)

);

insert into professor(id, nome, idade, disciplina)
VALUES
(1,"Ricardo","47", "CC"),
(2,"Alexandre", "50", 'Filosofia'),
(3,"Manoel", "40", "Artes Cênicas");
(4,"Moel", "30", "Artes Cênicas"),
(5,"José", "50", "Física");



create table matricula(

ID int AUTO_INCREMENT PRIMARY KEY,
id_aluno int,
id_professor INT,
data_matricula DATE,

FOREIGN KEY (id_aluno) REFERENCES Aluno(id),
FOREIGN KEY (id_professor) REFERENCES Professor(id)

);

INSERT INTO matricula(id_aluno, id_professor, data_matricula)
VALUES
(1,1,'2023-01-15'),
(2,2,'2023-02-20'),
(3,3,'2023-03-10'),
(4,4,'2023-05-12'),
(5,5,'2023-05-12');

DROP TABLE professor;

USE escola;

DELETE FROM matricula;
DELETE FROM professor;

ALTER TABLE professor AUTO_INCREMENT = 1;
ALTER TABLE matricula AUTO_INCREMENT = 1;

INSERT INTO professor (nome, idade, disciplina)
VALUES
    ('Ricardo',   47, 'CC'),
    ('Alexandre', 50, 'Filosofia'),
    ('Manoel',    40, 'Artes Cênicas'),
    ('Moel',      30, 'Artes Cênicas'),
    ('José',      50, 'Física');

INSERT INTO matricula (id_aluno, id_professor, data_matricula)
VALUES
    (1, 1, '2023-01-15'),
    (2, 2, '2023-02-20'),
    (3, 3, '2023-03-10'),
    (4, 4, '2023-05-12'),
    (5, 5, '2023-05-12');

SELECT * FROM professor;

USE escola;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM professor;
ALTER TABLE professor AUTO_INCREMENT = 1;

INSERT INTO professor (nome, idade, disciplina)
VALUES
    ('Ricardo',   47, 'CC'),
    ('Alexandre', 50, 'Filosofia'),
    ('Manoel',    40, 'Artes Cênicas'),
    ('Moel',      30, 'Artes Cênicas'),
    ('José',      50, 'Física');

SET FOREIGN_KEY_CHECKS = 1;



