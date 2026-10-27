# Plausible's event store: the ClickHouse release Plausible CE ships with,
# plus upstream's low-resource settings and Railway-specific trims.
FROM clickhouse/clickhouse-server:24.12.6.70-alpine

COPY railway.xml low-resources.xml /etc/clickhouse-server/config.d/
COPY default-profile-low-resources-overrides.xml /etc/clickhouse-server/users.d/
# The stock file listens on :: and 0.0.0.0; on Railway :: is already
# dual-stack, so the second bind fails with a warning on every boot.
# Overwritten, not deleted: Railway resurrects files removed in a later layer.
COPY listen.xml /etc/clickhouse-server/config.d/docker_related_config.xml

# Railway hosts run transparent huge pages "always": jemalloc frees 4K pages
# inside 2 MB huge pages that stay charged, so idle ClickHouse creeps ~25 MB/min.
ENV CLICKHOUSE_DB=plausible_events_db \
    CLICKHOUSE_USER=plausible \
    MALLOC_CONF=thp:never
