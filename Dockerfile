FROM flyway/flyway:7.5.4
COPY ./conf /flyway/conf
COPY ./migration /flyway/sql
