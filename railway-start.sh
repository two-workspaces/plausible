#!/bin/sh
set -e
if [ "$(id -u)" = 0 ]; then
  mkdir -p "$TMPDIR"
  chown -R plausible:nogroup /var/lib/plausible
  exec su-exec plausible "$0"
fi
/entrypoint.sh db createdb
/entrypoint.sh db migrate
# Plausible hands the instance to whoever registers first; create that
# account from ADMIN_USER_EMAIL / ADMIN_USER_PWD before the port opens.
/app/bin/plausible eval "$(cat /railway/railway-admin.exs)"
exec /entrypoint.sh run
