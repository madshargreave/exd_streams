CREATE STREAM ex_all_activities AS (
    SELECT STREAM
        'stream.created' AS type,
        role_id
    FROM `streams.created`
    UNION ALL
    SELECT STREAM
        'stream.deleted' AS type,
        role_id
    FROM `streams.deleted`
);
