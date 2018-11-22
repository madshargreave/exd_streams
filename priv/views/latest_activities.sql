SET `stream.cap` = 10;
CREATE STREAM exd_latest_activities AS (
    SELECT
        a.id,
        a.role_id,
        a.type,
        a.name
    FROM activities a
)
