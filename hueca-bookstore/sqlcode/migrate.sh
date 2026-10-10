#!/bin/sh
# Runs the Flyway migrations:
#   0. sqlcmd creates the "flyway" database (owner db_sa) if missing. RDS doesn't
#      allow creating objects in master, so Flyway's bootstrap history lives there.
#   1. bootstrap/ against flyway, as the db_sa login (creates the db_api login,
#      makes it an owner of flyway, and creates hueca_bookstore)
#   2. schema/ against hueca_bookstore, as the db_api login (tables, etc.)
#
# Required env vars: DB_HOST, DB_SA_USER, DB_SA_PASSWORD, DB_API_USER, DB_API_PASSWORD
# Optional env vars: DB_PORT (default 1433), DB_JDBC_OPTIONS
set -eu

: "${DB_HOST:?DB_HOST is required}"
: "${DB_SA_USER:?DB_SA_USER is required}"
: "${DB_SA_PASSWORD:?DB_SA_PASSWORD is required}"
: "${DB_API_USER:?DB_API_USER is required}"
: "${DB_API_PASSWORD:?DB_API_PASSWORD is required}"
DB_PORT="${DB_PORT:-1433}"
DB_JDBC_OPTIONS="${DB_JDBC_OPTIONS:-encrypt=true;trustServerCertificate=true}"

jdbc_url() {
  echo "jdbc:sqlserver://${DB_HOST}:${DB_PORT};databaseName=$1;${DB_JDBC_OPTIONS}"
}

echo "==> Create database flyway (if missing) as ${DB_SA_USER}"
SQLCMDPASSWORD="$DB_SA_PASSWORD" sqlcmd \
  -S "tcp:${DB_HOST},${DB_PORT}" -U "$DB_SA_USER" -d master \
  -N true -C -b -l 30 \
  -Q "IF DB_ID(N'flyway') IS NULL CREATE DATABASE flyway;"

echo "==> Bootstrap: flyway as ${DB_SA_USER}"
FLYWAY_URL="$(jdbc_url flyway)" \
FLYWAY_USER="$DB_SA_USER" \
FLYWAY_PASSWORD="$DB_SA_PASSWORD" \
FLYWAY_LOCATIONS="filesystem:/flyway/sql/bootstrap" \
FLYWAY_PLACEHOLDERS_DB_API_PASSWORD="$(printf '%s' "$DB_API_PASSWORD" | sed "s/'/''/g")" \
  flyway migrate

echo "==> Schema: hueca_bookstore as ${DB_API_USER}"
FLYWAY_URL="$(jdbc_url hueca_bookstore)" \
FLYWAY_USER="$DB_API_USER" \
FLYWAY_PASSWORD="$DB_API_PASSWORD" \
FLYWAY_LOCATIONS="filesystem:/flyway/sql/schema" \
  flyway migrate
