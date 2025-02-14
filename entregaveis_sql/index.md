---
layout: default
---

[Voltar para a página inicial](/)


# Elaboração dos Scripts Entregáveis no SQL

Foi elaborado um script no MySQL para cada entregável (A, B e C). O banco de dados foi nomeado como **comunidade_medica**.


## Entregável A: Consulta mostrando a quantidade total de usuários médicos por Especialidade Médica, Região e Comunidade


### Script Parte 1 - Quantidade de médicos, não testers e membros por **Especialidade Médica**
```sql
USE comunidade_medica;
SELECT
    especialidade_medica,
    COUNT(CASE WHEN usuario_medico = 'S' THEN 1 END) AS total_usuarios_medicos,
    COUNT(CASE WHEN usuario_tester = 0 THEN 1 END) AS total_nao_testers,
    COUNT(CASE WHEN tipo_de_usuario = 'MEMBRO' THEN 1 END) AS total_membros
FROM usuario
GROUP BY especialidade_medica;
```
Figura 9: Quantidade de médicos, não testers e membros por **Especialidade Médica**  
![fig9 ent_A1](https://github.com/user-attachments/assets/023d1c21-c6a8-4ebf-90f6-3428cda47cfc)


### Script Parte 2 - Quantidade de médicos, não testers e membros por **Região**
```sql
SELECT
    uf,
    COUNT(CASE WHEN usuario_medico = 'S' THEN 1 END) AS total_usuarios_medicos,
    COUNT(CASE WHEN usuario_tester = 0 THEN 1 END) AS total_nao_testers,
    COUNT(CASE WHEN tipo_de_usuario = 'MEMBRO' THEN 1 END) AS total_membros
FROM usuario
GROUP BY uf
ORDER BY uf;
```
Figura 10: Quantidade de médicos, não testers e membros por **Região**  
![fig10 ent_A2](https://github.com/user-attachments/assets/dfe1a465-8c66-45e0-9c00-9685ddc6d424)


### Script Parte 3 - Quantidade de médicos, não testers e membros por **Comunidade**
```sql
SELECT
    s.cd_comunidade,
    COUNT(CASE WHEN usuario_medico = 'S' THEN 1 END) AS total_usuarios_medicos,
    COUNT(CASE WHEN usuario_tester = 0 THEN 1 END) AS total_nao_testers,
    COUNT(CASE WHEN tipo_de_usuario = 'MEMBRO' THEN 1 END) AS total_membros
FROM sessao s
JOIN usuario u ON s.usuario_id = u.usuario_id
GROUP BY s.cd_comunidade
ORDER BY cd_comunidade;
```
Figura 11: Quantidade de médicos, não testers e membros por **Comunidade**  
![fig11 ent_A3](https://github.com/user-attachments/assets/da5dc5a3-f044-489e-99f0-709b3c5b2c92)


## Entregável B: Consulta retornando o mês e ano onde cada comunidade apresentou seu maior número de postagens

### Script - Mês e ano com maior número de posts por comunidade
```sql
USE comunidade_medica;

SELECT
    cf.cd_comunidade,
    c.comunidade,
    YEAR(cf.created_at) AS ano,
    MONTH(cf.created_at) AS mes,
    COUNT(*) AS total_posts
FROM conteudo_forum cf
JOIN comunidade c ON cf.cd_comunidade = c.cd_comunidade
WHERE cf.`type` = 'POST'
GROUP BY cf.cd_comunidade, comunidade, ano, mes
HAVING COUNT(*) = (
    SELECT MAX(post_count)
    FROM (
        SELECT cd_comunidade, YEAR(created_at) AS ano, MONTH(created_at) AS mes, COUNT(*) AS post_count
        FROM conteudo_forum
        WHERE `type` = 'POST'
        GROUP BY cd_comunidade, ano, mes
    ) AS subquery
    WHERE subquery.cd_comunidade = cf.cd_comunidade
)
ORDER BY cf.cd_comunidade;
```
Figura 12: Mês e ano onde cada comunidade teve o maior número de posts  
![fig12 ent_B](https://github.com/user-attachments/assets/a2f38de7-c067-4174-8206-fbd77f60093f)


## Entregável C: Consulta mostrando interações dos usuários em forma de postagens, comentários e curtidas

O script deste entregável é muito extenso. Para acessá-lo, clique aqui --> <a href="script_C.sql" class="button" download>
              <small>Download</small>
              script_C.sql
            </a>

A consulta gerou uma tabela contendo as seguintes variáveis:
- ID do usuário
- Tipo de usuário
- Total de posts do usuário
- Total de comentários realizados em posts de terceiros
- Número de likes realizados em posts de terceiros
- Post mais antigo do usuário
- Quantidade de likes, comentários e compartilhamentos no post mais antigo
- Post mais recente do usuário
- Quantidade de likes, comentários e compartilhamentos no post mais recente

Figura 13: Interações dos usuários em forma de postagens, comentários e curtidas  
![fig13 ent_C](https://github.com/user-attachments/assets/7b9eabd3-ae9f-453a-af9b-dac1332331bb)


### Próxima Etapa
[Adicionar o link para a próxima seção]

