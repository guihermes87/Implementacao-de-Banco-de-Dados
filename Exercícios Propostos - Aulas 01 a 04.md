# Exercícios Propostos — Aulas 01 a 04

> Compilado dos enunciados propostos ao final de cada tema dos slides das Aulas 01, 02, 03 e 04
> (Disciplina: Banco de Dados II / Implementação de Banco de Dados — Prof. Herysson R. Figueiredo).
> Base de dados de referência: `EMPRESA.sql` (Funcionario, Departamento, Projeto, Trabalha_em, Dependente, Dept_localizacoes).

---

## Aula 01 — Introdução a Banco de Dados

### Atividade de Nivelamento
Desenvolva **uma** das duas atividades propostas:

1. **BIBLIOTECA** — modelar/implementar o banco conforme o diagrama do slide.
2. **PALEONTOLOGIA** — modelar/implementar o banco conforme o diagrama do slide.

> Os diagramas estão no PDF `Aula 01 - Atividade - Nivelamento.pdf` (conteúdo em imagem).

### Exemplos de manipulação (banco UNIVERSIDADE)

**Consultas:**

1. Recuperar as disciplinas ministradas pelo Prof. Bruno Santos.
2. Selecionar os alunos que tiraram nota igual ou superior a 6.0 em "Matemática Discreta".
3. Listar os pré-requisitos da disciplina "Banco de Dados I".

**Atualizações:**

4. Atualizar o curso do aluno Pedro Santos para PRO.
5. Criar uma nova disciplina chamada "Engenharia de Software".
6. Alterar a nota de João Lage em "Programação de Computadores I" para 8.0.

---

## Aula 02 — Consultas

### SELECT DISTINCT
1. Liste as diferentes faixas salariais dos funcionários.

### Cláusula WHERE
2. Recupere todas as informações do(s) funcionário(s) com primeiro nome "João".

### AND
3. Liste os funcionários do sexo masculino com salário maior ou igual a R$ 30.000,00.

### OR
4. Liste os funcionários que moram em São Paulo ou em Curitiba.

### NOT
5. Liste os funcionários que não moram em São Paulo.

### ORDER BY
6. Preciso cortar orçamento: liste os funcionários em ordem decrescente de salário.

### IS NULL
7. Encontre os funcionários que não possuem supervisor (`Cpf_supervisor`).

### IS NOT NULL
8. Recupere o(s) nome(s) do(s) funcionário(s) que possuem supervisor.

### SELECT TOP / LIMIT
9. Recupere o registro dos 3 funcionários que têm o maior salário.

### MIN()
10. Recupere as informações do funcionário com o menor salário.

### MAX()
11. Recupere as informações do funcionário com o maior salário.

### COUNT()
12. Quantos funcionários possuímos cadastrados no banco?

### AVG()
13. Qual é a média salarial dos meus funcionários?

### SUM()
14. Qual é o meu custo mensal com folha de pagamento dos funcionários?

### LIKE
15. Recupere o(s) funcionário(s) nascido(s) no ano de 72.

### IN (lista de valores)
16. Recupere as informações dos funcionários que recebem R$ 25.000 e R$ 30.000.

### IN (subconsulta)
17. Recupere os registros dos funcionários que trabalham (`TRABALHA_EM`) no mesmo projeto e na mesma quantidade de horas do "Fernando" (`Fcpf = '33344555587'`).

### BETWEEN
18. Recuperar todos os funcionários do departamento 5 cujo salário esteja entre R$ 30.000 e R$ 40.000.

### Alias de coluna
19. Recupere `Pnome` como **Nome** e `Unome` como **Sobrenome** da tabela `Funcionario`.

### Alias de tabela
20. Recupere o nome de todos os funcionários que fazem parte do departamento de "Pesquisa".

---

## Aula 03 — Consultas com Joins

### INNER JOIN
1. Selecionar o primeiro nome, último nome e endereço dos funcionários que trabalham no departamento de "Pesquisa".
2. Liste o nome dos funcionários que estão desenvolvendo o "ProdutoX".
3. Para cada projeto localizado em "Mauá", liste o número do projeto, o número do departamento que o controla e o sobrenome, endereço e data de nascimento do gerente do departamento.

### LEFT JOIN
4. Liste o último nome de TODOS os funcionários e os seus respectivos departamentos, caso possuam.
5. Encontre os funcionários que **não** possuem um departamento vinculado.
   - *Preparação:* inserir 3 novos departamentos e 3 novos funcionários sem departamento.
6. Encontre os departamentos que **não** possuem funcionários vinculados.
   - *Preparação:* inserir 3 novos departamentos e 3 novos funcionários sem departamento.

### RIGHT JOIN
7. Encontre os departamentos que não possuem nenhum funcionário.

### CROSS JOIN
8. Teste o CROSS JOIN entre as relações `Funcionario` e `Departamento`.

### SELF JOIN
9. Crie uma consulta que mostra apenas os funcionários que têm um supervisor.

### UNION
10. Listar todos os nomes, sexo e data de nascimento de todas as pessoas do banco.
11. A diretoria quer uma lista de todas as cidades onde a empresa possui alguma atividade, seja a localização de um departamento ou a localização de um projeto.

### UNION ALL
12. Mesma consulta anterior (cidades com atividade da empresa), agora permitindo valores duplicados.

### EXCEPT
13. Listar os CPFs dos funcionários que não são gerentes de nenhum departamento.
14. Encontre os funcionários que **NÃO** são supervisores.

### INTERSECT
15. Encontre os funcionários que **são** supervisores.

### GROUP BY
16. Quantidade de funcionários por sexo.
17. Contar o número de funcionários por departamento.
18. Somar os salários por departamento.
19. Média de horas trabalhadas por projeto.
20. Maior salário em cada departamento.
21. Número de projetos em cada local.

### HAVING
22. Encontrar departamentos com mais de 3 funcionários.
23. Listar projetos que exigem no mínimo 50 horas de trabalho no total.

### EXISTS
24. Listar funcionários que são gerentes de algum departamento.
25. Listar departamentos que possuem projetos associados.

### ANY
26. Encontrar funcionários que ganham mais do que qualquer funcionário do departamento de "Administração".

### ALL
27. Encontrar projetos que exigem mais horas do que todos os projetos no local "Itu".

---

## Aula 04 — Variáveis, Conversões, IF/ELSE e WHILE

### Atribuição de valor com SELECT
1. Recupere o nome do departamento com `Dnumero = 4` (armazenando em variável).

### Exemplos com cálculo
2. Calcular o novo salário da Jennifer com um aumento de 10%.
3. Calcular a idade da Jennifer.
   - *Dica:* usar `YEAR(GETDATE())` ou `DATEDIFF(intervalo, data_inicial, data_final)`.

### CAST
4. Usando `CAST`, converter o salário decimal em string, resultando em:
   `O funcionário(a) Jennifer tem um salário de : R$ 43000.`

### CONVERT
5. Usando `CONVERT`, converter o salário decimal em string, resultando em:
   `O funcionário(a) Jennifer tem um salário de : R$ 43000.`
6. Converter a data de nascimento da Jennifer para o padrão brasileiro: `dd/mm/aaaa`.

### IF / ELSE
7. Verificar se um funcionário recebe abaixo da média salarial.
8. Verificar se um funcionário está próximo da aposentadoria (considerar 60 anos como idade de aposentadoria).
9. Verificar se um funcionário já recebeu bônus este ano.
10. Verificar se o funcionário é um novo contratado (últimos 6 meses).
    - *Dica:* `DATEDIFF(intervalo, data_inicial, data_final)` — intervalo: `DAY`, `MONTH`, `YEAR`.
11. Verificar o tamanho de um departamento: até 1 funcionário → "pequeno"; de 2 a 3 → "médio"; mais de 3 → "grande".

### WHILE
12. Aumentar o salário da "Joice Leite" em 5% repetidamente até que ele chegue em R$ 30.000.
