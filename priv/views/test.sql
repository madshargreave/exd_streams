SET `key` = 'symbol';

CREATE STREAM coinmarketcap AS (
    WITH
    page AS (
        SELECT
            html_parse_float(r.body, '.total-marketcap > ol > li:nth-child(3)') AS total_marketcap,
            unnest(html_parse_list(r.body, 'table#currencies tbody > tr')) AS row
        FROM fetch('https://coinmarketcap.com') r
    ),
    coins AS (
        SELECT
            p.total_marketcap AS total_marketcap,
            html_parse_text(p.row, 'td.name') AS name,
            html_parse_text(p.row, 'td.symbol > .container:first') AS symbol,
            html_parse_float(p.row, 'td.price') AS price,
            html_parse_float(p.row, 'td.marketcap') AS marketcap,
            html_parse_float(p.row, 'td.volume') AS volume
        FROM page p
    ),
    detail(symbol) AS (
        SELECT
            html_parse_text(r.body, 'td.website') AS website,
            html_parse_text(r.body, 'td.explorer') AS explorer,
        FROM fetch('https://coinmarketcap.com/currencies/{{symbol}}/') r
    ),
    alexa(website) AS (
        SELECT
            html_parse_integer(r.body, '.Rank') AS rank
        FROM fetch('https://alexa.com/website/{{website}}') r
    )
    SELECT
        c.*,
        d.*
    FROM coins c
    JOIN details d on d.symbol = c.symbol
    JOIN alexa a on a.website = d.website
);

WITH
top_coins AS (
    SELECT *
    FROM coins c
    WHERE c.marketcap > 100000000
)
SELECT *
FROM coins
