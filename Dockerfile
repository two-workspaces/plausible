# Official Plausible Community Edition image plus a start script that
# migrates, creates the admin from env on an empty database, then serves.
FROM ghcr.io/plausible/community-edition:v3.2.1
COPY --chmod=555 railway-start.sh railway-admin.exs /railway/
CMD ["/railway/railway-start.sh"]
