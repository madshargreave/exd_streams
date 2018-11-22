SET `key` = 'stream_id';
CREATE VIEW latest_stream_records AS (
    SELECT
        s.stream_id,
        s.data
    FROM stream_record_created s
)
