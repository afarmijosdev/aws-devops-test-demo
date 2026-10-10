# Build from the hueca-bookstore directory:
#   docker build -f sqlcode/Dockerfile -t db-migrations .
FROM flyway/flyway:11.0.0

ENV FLYWAY_CONNECT_RETRIES=10

COPY sqlcode/bootstrap/ /flyway/sql/bootstrap/
COPY sqlcode/schema/ /flyway/sql/schema/
COPY sqlcode/migrate.sh /flyway/migrate.sh
RUN chmod 0755 /flyway/migrate.sh

RUN useradd --create-home --uid 10001 flywayuser
USER 10001:10001

ENTRYPOINT ["/flyway/migrate.sh"]
