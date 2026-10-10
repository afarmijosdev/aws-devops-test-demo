# Build from the hueca-bookstore directory:
#   docker build --platform linux/amd64 -f sqlcode/Dockerfile -t db-migrations .

# go-sqlcmd: creates the flyway database before Flyway connects to it.
FROM debian:bookworm-slim AS sqlcmd
ARG SQLCMD_VERSION=v1.10.0
ARG SQLCMD_SHA256=92516d98c63d99b0994de5b61350c91f6915f9b76f139a59039fbcb225c2e987
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl bzip2 \
 && curl -fsSL -o /tmp/sqlcmd.tar.bz2 \
      "https://github.com/microsoft/go-sqlcmd/releases/download/${SQLCMD_VERSION}/sqlcmd-linux-amd64.tar.bz2" \
 && echo "${SQLCMD_SHA256}  /tmp/sqlcmd.tar.bz2" | sha256sum -c - \
 && tar -xjf /tmp/sqlcmd.tar.bz2 -C /usr/local/bin sqlcmd

FROM flyway/flyway:11.0.0

ENV FLYWAY_CONNECT_RETRIES=10

COPY --from=sqlcmd /usr/local/bin/sqlcmd /usr/local/bin/sqlcmd
COPY sqlcode/bootstrap/ /flyway/sql/bootstrap/
COPY sqlcode/schema/ /flyway/sql/schema/
COPY sqlcode/migrate.sh /flyway/migrate.sh
RUN chmod 0755 /flyway/migrate.sh

RUN useradd --create-home --uid 10001 flywayuser
USER 10001:10001

ENTRYPOINT ["/flyway/migrate.sh"]
