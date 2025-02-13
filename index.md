## Apresentação

👩‍⚕️ Esse projeto surgiu a partir de um desafio de uma empresa de desenvolvimento de softwares que criou um hub de comunidades na área médica, conectando usuários de diferentes especialidades da medicina em todo o Brasil.

📊 A missão do desafio era lidar com os dados, projetar pipelines e fornecer insights para auxiliar os times de Marketing e Comercial a compreender o perfil dos usuários e as interações que ocorrem na rede.

Assim, os principais entregáveis requisitados foram:

- **A** - Uma consulta mostrando a quantidade total de usuários médicos por Especialidade Médica, Região e Comunidade;
- **B** - Uma consulta retornando o mês e ano onde cada uma das comunidades apresentadas tiveram seu maior número de postagens;
- **C** - Uma consulta mostrando interações dos usuários em forma de postagem, comentários e curtidas;
- **D** - Dashboard com insights práticos.

Nesse desafio foram utilizados o **MySQL** e o **Power BI**. A seguir, são apresentadas as etapas da resolução do desafio.

---

## Desenvolvimento do projeto

### 2.1 Entendendo o banco de dados

Foram disponibilizadas sete tabelas, contendo as seguintes variáveis:

- **usuario_id**: número de identificação do usuário
- **created**: data de cadastro do usuário na rede
- **deleted**: data de saída do usuário na rede
- **usuario_medico**: mostra se o usuário é médico ou não
- **usuario_tester**: mostra se o usuário é um testador
- **tipo_de_usuario**: mostra se o usuário é membro ou lead
- **especialidade**: especialidade médica do usuário
- **uf**: localização do usuário
- **cd_comunidade**: código de identificação da comunidade
- **comunidade**: nome da comunidade
- **data_time_connect**: data e hora de conexão do usuário em certa comunidade
- **data_time_disconnect**: data e hora de desconexão do usuário em certa comunidade
- **data_cadastro**: data que o usuário entrou em uma comunidade
- **data_delecao**: data que o usuário saiu da comunidade
- **created_by**: mostra qual usuário fez uma interação
- **created_at**: data de criação da interação (POST, COMMENT ou LIKE)
- **deleted_at**: data de deleção da interação (POST, COMMENT ou LIKE)
- **type**: tipo de interação (POST ou COMMENT)
- **parent_id**: identificador do item pai referente à interação do usuário. (Por exemplo, o usuário X comentou no post do usuário Z).
- **forum_content_id**: ID da observação na tabela conteudo_forum

Inicialmente, as tabelas foram importadas por meio da construção de um script no **MySQL**. Em seguida, foi elaborado um **diagrama ER**, proporcionando uma melhor visualização da organização das tabelas e seus relacionamentos.

🔗 O canal **Hashtag Programação** ensina como importar um banco de dados para o MySQL Workbench: [Link](https://www.youtube.com/watch?v=EhT-e4IZrkM)
🔗 O canal do **Tiago A. Silva** no YouTube mostra como criar esse tipo de diagrama: [Link](https://www.youtube.com/watch?v=n8a7Q8JiYCs)

### Figura 1: Diagrama ER do modelo da comunidade médica  
![fig1 ER_diagrama_sql](https://github.com/user-attachments/assets/e331a2be-5da6-41d6-8a6a-bd6571f32ba6)

Um recorte de cada tabela pode ser visto a seguir:

- **Figura 2**: Tabela usuario  
![fig2 tabela usuario](https://github.com/user-attachments/assets/25029e05-4959-4f24-b634-56becc74410d)
  
- **Figura 3**: Tabela comunidade
![fig3 tabela_comunidade](https://github.com/user-attachments/assets/38bbf8f4-3a18-4d03-9931-0243ab158833)
  
- **Figura 4**: Tabela sessao
![fig4 tabela_sessao](https://github.com/user-attachments/assets/56c568bc-f73c-4ea5-b86c-18ff414b9bf2)

- **Figura 5**: Tabela sponsor  
![fig5 tabela sponsor](https://github.com/user-attachments/assets/513553b8-9fb6-4deb-b4f8-d5189312e333)

- **Figura 6**: Tabela conteudo_forum  
![fig6 tabela_conteudo_forum](https://github.com/user-attachments/assets/5e8226e6-3626-4c3f-8f72-14cad7f277b7)
  
- **Figura 7**: Tabela conteudo_forum_share  
![fig7 tabela_forum_share](https://github.com/user-attachments/assets/7852ab34-b4ee-44a4-b539-b29ba5935d60)
  
- **Figura 8**: Tabela conteudo_forum_likes
![fig8 tabela_forum_likes](https://github.com/user-attachments/assets/e3fdc6b3-d22c-4bf0-ba8d-dbecca937532)


