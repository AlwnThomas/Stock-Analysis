-- Identifying the best and worst performers, large daily moves, and cumulative performance.

-- 1. Highest single-day percentage gain across the entire dataset
SELECT s.ticker, sp.price_date, ((sp.close_price - sp.open_price) / sp.open_price * 100) AS daily_percent_change
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
ORDER BY daily_percent_change DESC
LIMIT 3;

-- 2.Largest single-day percentage loss?
SELECT s.ticker, sp.price_date, ((sp.close_price - sp.open_price) / sp.open_price * 100) AS daily_percent_change
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
ORDER BY daily_percent_change ASC
LIMIT 3;

-- 3 Top 3 stocks with the highest daily % gain, for each day
WITH ranked_gains AS (
    SELECT 
        s.ticker,
        sp.price_date,
        ((sp.close_price - sp.open_price) / sp.open_price) * 100 AS daily_percent_change,
        RANK() OVER (
            PARTITION BY sp.price_date
            ORDER BY ((sp.close_price - sp.open_price) / sp.open_price) * 100 DESC
        ) AS gain_rank
    FROM stocks s
    JOIN stock_prices sp
        ON s.stock_id = sp.stock_id
)
SELECT
    ticker,
    price_date,
    daily_percent_change
FROM ranked_gains
WHERE gain_rank <= 3
ORDER BY price_date, daily_percent_change DESC;

-- 4. Highest average daily percentage return
SELECT 
    s.ticker,
    AVG((sp.close_price - sp.open_price) / sp.open_price * 100) AS avg_daily_percent_return
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY avg_daily_percent_return DESC;

-- 5. Cumulative percentage return per stock
SELECT DISTINCT
    s.ticker,
    FIRST_VALUE(sp.close_price) OVER (
        PARTITION BY s.stock_id
        ORDER BY sp.price_date
    ) AS first_close_price,
    LAST_VALUE(sp.close_price) OVER (
        PARTITION BY s.stock_id
        ORDER BY sp.price_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_close_price,
    (
        LAST_VALUE(sp.close_price) OVER (
            PARTITION BY s.stock_id
            ORDER BY sp.price_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )
        -
        FIRST_VALUE(sp.close_price) OVER (
            PARTITION BY s.stock_id
            ORDER BY sp.price_date
        )
    )
    /
    FIRST_VALUE(sp.close_price) OVER (
        PARTITION BY s.stock_id
        ORDER BY sp.price_date
    ) * 100 AS cumulative_percent_return
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id;

-- 6. Longest positive streak per stock
WITH labelled_days AS (
    SELECT
        s.stock_id,
        s.ticker,
        sp.price_date,
        CASE 
            WHEN sp.close_price > sp.open_price THEN 1 
            ELSE 0 
        END AS is_positive
    FROM stocks s
    JOIN stock_prices sp
        ON s.stock_id = sp.stock_id
),

streak_starts AS (
    SELECT
        stock_id,
        ticker,
        price_date,
        is_positive,
        CASE
            WHEN is_positive = 1
             AND LAG(is_positive, 1, 0) 
                 OVER (PARTITION BY stock_id ORDER BY price_date) = 0
            THEN 1
            ELSE 0
        END AS streak_start
    FROM labelled_days
),

streak_groups AS (
    SELECT
        stock_id,
        ticker,
        price_date,
        SUM(streak_start) OVER (
            PARTITION BY stock_id
            ORDER BY price_date
        ) AS streak_id
    FROM streak_starts
    WHERE is_positive = 1
)

SELECT
    ticker,
    MAX(streak_length) AS longest_positive_streak
FROM (
    SELECT
        ticker,
        streak_id,
        COUNT(*) AS streak_length
    FROM streak_groups
    GROUP BY ticker, streak_id
) sub
GROUP BY ticker
ORDER BY longest_positive_streak DESC;