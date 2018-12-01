CREATE TABLE ex_roles_and_streams AS (
    SELECT STREAM
        a.role_id,
        SUM(
            IF(type = 'streams.created', 1, -1)
        ) AS streams
    FROM ex_all_activites a
    WHERE type = 'stream.created' OR type = 'stream.deleted'
    GROUP BY role_id
);
