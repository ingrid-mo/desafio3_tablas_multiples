CREATE DATABASE desafio3_ingrid_morales_567;

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY ,
    email VARCHAR,
    nombre VARCHAR,
    rol VARCHAR,
    apellido VARCHAR,
  );

INSERT INTO  usuarios(id, email, nombre, apellido, rol) VALUES
(DEFAULT,'juan@mail.com', 'juan', 'perez', 'administrador'),
 (DEFAULT,'diego@mail.com', 'diego', 'munoz', 'usuario'),
(DEFAULT,'maria@mail.com', 'maria', 'meza', 'usuario'),
(DEFAULT,'roxana@mail.com','roxana', 'diaz', 'usuario'),
(DEFAULT,'pedro@mail.com', 'pedro', 'diaz', 'usuario');

CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    destacado BOOLEAN,
    usuario_id BIGINT,
    titulo VARCHAR, 
    contenido TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id));

  
INSERT INTO post(id, titulo, contenido, fecha_creacion,
fecha_actualizacion, destacado, usuario_id) VALUES 
(DEFAULT, 'prueba','contenido prueba', '01/01/2021', '01/02/2021', true, 1),
 (DEFAULT, 'prueba2','contenido prueba2', '01/03/2021', '01/03/2021', true, 1),
 (DEFAULT,'ejercicios', 'contenido ejercicios', '02/05/2021', '03/04/2021', true,2),
 (DEFAULT,'ejercicios2', 'contenido ejercicios2', '03/05/2021', '04/04/2021',false, 2),
 (DEFAULT, 'random','contenido random', '03/06/2021', '04/05/2021', false, null);

CREATE TABLE comentario (
    id SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT,
    contenido TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (post_id) REFERENCES post(id)
    
);
INSERT INTO comentario (id, contenido, fecha_creacion, usuario_id,
post_id) VALUES 
(DEFAULT, 'comentario 1', '03/06/2021', 1, 1),
(DEFAULT, 'comentario 2', '03/06/2021', 2, 1),
 (DEFAULT, 'comentario 3', '04/06/2021', 3, 1),
  (DEFAULT, 'comentario 4', '04/06/2021', 1, 2),
  (DEFAULT, 'comentario 5', '04/06/2021', 2, 2);



-- 3. Muestra el id, título y contenido de los posts de los administradores.

SELECT post.id, post.titulo, post.contenido
FROM post
INNER JOIN usuarios ON post.usuario_id = usuarios.id
WHERE usuarios.rol = 'administrador';


-- 4. Cuenta la cantidad de posts de cada usuario.


SELECT usuarios.id, usuarios.email, COUNT(post.id) AS cantidad_posts
FROM usuarios
LEFT JOIN post ON usuarios.id = post.usuario_id
GROUP BY usuarios.id, usuarios.email;


-- 5. Muestra el email del usuario que ha creado más posts.


SELECT usuarios.email
FROM usuarios
LEFT JOIN post ON usuarios.id = post.usuario_id
GROUP BY usuarios.id, usuarios.email
ORDER BY COUNT(post.id) DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT usuarios.id, usuarios.email, MAX(post.fecha_creacion) AS fecha_ultimo_post
FROM usuarios
LEFT JOIN post ON usuarios.id = post.usuario_id
GROUP BY usuarios.id, usuarios.email;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT post.titulo, post.contenido
FROM post
LEFT JOIN comentario ON post.id = comentario.post_id
GROUP BY post.id, post.titulo, post.contenido
HAVING COUNT(comentario.id) = (SELECT MAX(comentarios) 
FROM (SELECT post.id, COUNT(comentario.id) as comentarios FROM post LEFT JOIN
 comentario ON post.id = comentario.post_id GROUP BY post.id) AS post_comentarios);


-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
-- de cada comentario asociado a los posts mostrados, junto con el email del usuario
-- que lo escribió.

SELECT post.titulo AS post_titulo, post.contenido AS post_contenido, comentario.contenido AS comentario_contenido, usuarios.email
FROM post
LEFT JOIN comentario ON post.id = comentario.post_id
LEFT JOIN usuarios ON comentario.usuario_id = usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario.

SELECT usuarios.id, usuarios.email, comentario.contenido AS ultimo_comentario
FROM usuarios
LEFT JOIN comentario ON usuarios.id = comentario.usuario_id
WHERE comentario.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentario WHERE usuario_id = usuarios.id);

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.


SELECT usuarios.email
FROM usuarios
LEFT JOIN comentario ON usuarios.id = comentario.usuario_id
GROUP BY usuarios.id, usuarios.email
HAVING COUNT(comentario.id) IS NULL;


