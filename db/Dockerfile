FROM postgres:13.3
ENV POSTGRES_PASSWORD="1234"
ENV POSTGRES_USER="postgres"
ENV POSTGRES_DB="learning"
ENV PGDATA="/var/lib/postgresql/data/pgdata"
COPY create_table_users.sql /docker-entrypoint-initdb.d
