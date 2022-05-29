CREATE TABLE IF NOT EXISTS users
(
    email character varying(30),
    first_name character varying(30),
    last_name character varying(30),
    id serial primary key
);