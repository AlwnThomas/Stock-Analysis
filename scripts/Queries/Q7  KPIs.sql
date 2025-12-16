-- Core insights in a business setting

-- 1. Best performing stock overall
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
    ON s.stock_id = sp.stock_id
ORDER BY cumulative_percent_return DESC
LIMIT 1;

-- 2. Worst performing stock overall
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
    ON s.stock_id = sp.stock_id
ORDER BY cumulative_percent_return ASC
LIMIT 1;

-- 3. Most volatile stock
SELECT s.ticker,
       AVG(sp.high_price - sp.low_price) AS avg_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY avg_volatility DESC
LIMIT 1;

-- 4. Most liquid stock
SELECT
	s.ticker,
	SUM(sp.volume) AS total_volume
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY total_volume DESC
LIMIT 1;

-- 5. Summary
SELECT
	s.ticker,
	AVG(sp.close_price - sp.open_price) AS avg_daily_return,
	AVG(sp.high_price - sp.low_price) AS avg_daily_volatility,
	SUM(sp.volume) AS total_market_volume
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
GROUP BY s.ticker;
