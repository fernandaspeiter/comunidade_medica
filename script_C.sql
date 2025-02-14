USE comunidade_medica;

-- Disable ONLY_FULL_GROUP_BY from session’s sql_mode
SET @@sql_mode = SYS.LIST_DROP(@@sql_mode, 'ONLY_FULL_GROUP_BY');

#####################################################
-- TOTAL POSTS
-- usuario_id, total_posts (lista o total de posts por usuário)
CREATE VIEW total_posts_view AS
SELECT u.usuario_id,
  COUNT(cf.cf_id) AS total_posts
FROM usuario u
LEFT JOIN
  conteudo_forum cf ON u.usuario_id = cf.created_by AND cf.type = 'POST'
GROUP BY u.usuario_id;

-- ID DOS POSTS
-- usuario_id, id, created_at (lista o id e a data de cada post)
CREATE VIEW posts_id_view AS
SELECT 
cf.created_by AS usuario_id,
cf.cf_id, cf.created_at
FROM conteudo_forum cf
LEFT JOIN usuario u ON cf.created_by = u.usuario_id 
WHERE cf.type = 'POST';

#####################################################
-- POTS RECENTES E ANTIGOS
-- usuario_id, id, post_recente (lista o post mais recente de cada usuário)
CREATE VIEW posts_recente_view AS
SELECT usuario_id, cf_id, post_recente
FROM (
  SELECT piv.usuario_id, piv.cf_id, piv.created_at AS post_recente,
    ROW_NUMBER() OVER (PARTITION BY piv.usuario_id ORDER BY piv.created_at DESC) AS row_num
  FROM posts_id_view piv
) AS ranked
WHERE row_num = 1;

-- usuario_id, id, post_antigo (lista o post mais antigo de cada usuário)
CREATE VIEW posts_antigo_view AS
SELECT usuario_id, cf_id, post_antigo
FROM (
  SELECT piv.usuario_id, piv.cf_id, piv.created_at AS post_antigo,
    ROW_NUMBER() OVER (PARTITION BY piv.usuario_id ORDER BY piv.created_at ASC) AS row_num
  FROM posts_id_view piv
) AS ranked
WHERE row_num = 1;

#####################################################
-- INTERAÇÕES DO POST

-- COMMENTS ------------------------------------------
-- usuario_id, comments_recente (lista o n° de comments no post mais recente de cada usuário)
CREATE VIEW comments_recente_view AS
SELECT pr.usuario_id,   
	COUNT(cf.parent_id) AS comments_post_recente 
FROM (SELECT * FROM posts_recente_view) as pr
LEFT JOIN conteudo_forum cf on pr.cf_id = cf.parent_id
GROUP BY pr.usuario_id;

-- usuario_id, comments_antigo (lista o n° de comments no post mais antigo de cada usuário)
CREATE VIEW comments_antigo_view AS
SELECT pa.usuario_id, 
COUNT(cf.parent_id) AS comments_post_antigo 
FROM (SELECT * FROM posts_antigo_view) as pa
LEFT JOIN conteudo_forum cf on pa.cf_id = cf.parent_id
GROUP BY pa.usuario_id;

-- LIKES --------------------------------------------
-- usuario_id, likes_recente (lista o n° de likes no post mais recente de cada usuário)
CREATE VIEW likes_recente_view AS
SELECT pr.usuario_id,  
	SUM(clike.likes) AS likes_post_recente 
FROM (SELECT * FROM posts_recente_view) as pr
LEFT JOIN conteudo_forum_likes clike on pr.cf_id = clike.forum_content_id
GROUP BY pr.usuario_id;

-- usuario_id, likes_antigo (lista o n° de likes no post mais antigo de cada usuário)
CREATE VIEW likes_antigo_view AS
SELECT pa.usuario_id, 
	SUM(clike.likes) AS likes_post_antigo 
FROM (SELECT * FROM posts_antigo_view) as pa
LEFT JOIN conteudo_forum_likes clike on pa.cf_id = clike.forum_content_id
GROUP BY pa.usuario_id;

-- SHARE ----------------------------------------------
-- usuario_id, share_recente (lista o n° de compartilhamentos do post mais antigo de cada usuário)
CREATE VIEW share_recente_view AS
SELECT pr.usuario_id, 
	COUNT(cshare.forum_content_id) AS share_post_recente 
FROM (SELECT * FROM posts_recente_view) AS pr
LEFT JOIN conteudo_forum_share cshare ON pr.cf_id = cshare.forum_content_id
GROUP BY pr.usuario_id;

-- usuario_id, share_antigo (lista o n° de compartilhamentos do post mais antigo de cada usuário)
CREATE VIEW share_antigo_view AS
SELECT pa.usuario_id, 
	COUNT(cshare.forum_content_id) AS share_post_antigo 
FROM (SELECT * FROM posts_antigo_view) AS pa
LEFT JOIN conteudo_forum_share cshare ON pa.cf_id = cshare.forum_content_id
GROUP BY pa.usuario_id;

#####################################################
-- COMMENTS em POSTS de terceiros
-- Id e parent_id dos comentários de cada usuário (lista todos os comentários de cada usuário)
CREATE VIEW comments_id_view AS
SELECT cf.created_by, cf.cf_id, cf.parent_id,
COUNT(*) AS comentarios
FROM conteudo_forum cf
WHERE cf.type = 'COMMENT'
GROUP BY cf.created_by, cf.parent_id;

-- Comentários apenas em POST, excluindo comentários em COMMENT
CREATE VIEW comments_in_posts_view AS
SELECT civ.created_by, civ.cf_id, civ.parent_id, comentarios
FROM comments_id_view civ
INNER JOIN posts_id_view piv
ON civ.parent_id = piv.cf_id;

-- Quantidade de comentários realizados em POSTS de terceiros
CREATE VIEW comments_post_terceiros AS
SELECT
cpv.created_by AS usuario_id,
COUNT(cpv.cf_id) AS comments_posts_terceiros
FROM comments_in_posts_view cpv
WHERE cf_id <> parent_id
GROUP BY cpv.created_by;

#####################################################
-- Quantidade de likes realizados em posts de terceiros

-- lista todos os likes de cada usuário
CREATE VIEW likes_total_view AS
SELECT
    cfl.created_by, 
    cfl.forum_content_id, 
    cfl.likes
FROM conteudo_forum_likes cfl;

-- Likes apenas em POST, excluindo likes em COMMENT
CREATE VIEW likes_in_posts_view AS
SELECT 
	ltv.created_by, ltv.forum_content_id, ltv.likes
FROM likes_total_view ltv
INNER JOIN posts_id_view piv
ON ltv.forum_content_id = piv.cf_id;

CREATE VIEW likes_posts_terceiros AS
SELECT l.created_by, SUM(l.likes) AS likes_posts_terceiros
FROM likes_in_posts_view l
LEFT JOIN conteudo_forum c
ON l.forum_content_id = c.cf_id
   AND l.created_by = c.created_by
WHERE c.cf_id IS NULL
GROUP BY l.created_by;

#####################################################
SELECT 
	u.usuario_id, 
    u.tipo_de_usuario,
	tp.total_posts, 
    cmpt.comments_posts_terceiros,
    lpt.likes_posts_terceiros,
	pa.post_antigo,
	la.likes_post_antigo,
	cma.comments_post_antigo,
	sha.share_post_antigo,
	pr.post_recente,
	lr.likes_post_recente,
	cmr.comments_post_recente,
	shr.share_post_recente
FROM usuario u
	LEFT JOIN total_posts_view tp ON u.usuario_id = tp.usuario_id
	LEFT JOIN posts_antigo_view pa ON u.usuario_id = pa.usuario_id
	LEFT JOIN posts_recente_view pr ON u.usuario_id = pr.usuario_id
	LEFT JOIN likes_antigo_view la ON u.usuario_id = la.usuario_id
	LEFT JOIN likes_recente_view lr ON u.usuario_id = lr.usuario_id
	LEFT JOIN comments_antigo_view cma ON u.usuario_id = cma.usuario_id
	LEFT JOIN comments_recente_view cmr ON u.usuario_id = cmr.usuario_id
	LEFT JOIN share_antigo_view sha ON u.usuario_id = sha.usuario_id
	LEFT JOIN share_recente_view shr ON u.usuario_id = shr.usuario_id
    LEFT JOIN comments_post_terceiros cmpt ON u.usuario_id = cmpt.usuario_id
    LEFT JOIN likes_posts_terceiros lpt ON u.usuario_id = lpt.created_by;


-- FIM