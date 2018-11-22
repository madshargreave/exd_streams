CREATE VIEW exd_current_streams AS (
    SELECT
        s.id,
        s.name,
        s.user_id,
        COUNT(s.groups) AS groups,
        COUNT(s.consumers) AS consumers,
        CURRENT_TIMESTAMP() AS updated_at
    FROM streams_created s
    GROUP BY s.id, s.name
)
