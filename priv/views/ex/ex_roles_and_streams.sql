SET `key` = role_id;
SET `permission` = 'system';
SET `stream.offset` = 'earliest';

CREATE TABLE jobs (
    id PRIMARY KEY,
    title varchar(300),
    location varchar(300),
    salary float,
    timestamp datetime,
    INDEX idx_title (title)
)

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

CREATE STREAM notifications AS (
    INSERT INTO emails(to, from, subject, content)
    SELECT STREAM
        s.email AS to,
        'notifications@jobber.io' AS from,
        'New jobs received' AS subject,
        j.description AS content
    FROM jobs j
    JOIN subscribers s ON j.category IN s.categories
)
