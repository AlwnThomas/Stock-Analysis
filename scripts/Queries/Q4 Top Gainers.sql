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