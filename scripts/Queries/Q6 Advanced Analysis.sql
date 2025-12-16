-- Statistical Market Behaviour analysis

-- 1. Avg, min, max daily volatility
SELECT
	s.ticker,
	AVG(sp.high_price - sp.low_price) AS avg_volatility,
	MIN(sp.high_price - sp.low_price) AS min_volatility,
	MAX(sp.high_price - sp.low_price) AS max_volatility
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 2. 25th, 50th and 75th percentiles of daily volatility
SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY high_price - low_price) AS p25_volatility,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY high_price - low_price) AS median_volatility,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY high_price - low_price) AS p75_volatility
FROM stock_prices;

-- 3. Stock says in the top 10% of volatility
SELECT
    s.ticker,
    sp.price_date,
    (sp.high_price - sp.low_price) AS daily_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
WHERE (sp.high_price - sp.low_price) >
(
    SELECT
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY high_price - low_price)
    FROM stock_prices
)
ORDER BY daily_volatility DESC;

-- 4. Above-avg perfomance and Below-avg volatility
WITH stock_metrics AS (
    SELECT
        s.ticker,
        AVG((sp.close_price - sp.open_price) / sp.open_price * 100) AS avg_daily_return,
        AVG(sp.high_price - sp.low_price) AS avg_daily_volatility
    FROM stocks s
    JOIN stock_prices sp
        ON s.stock_id = sp.stock_id
    GROUP BY s.ticker
),
market_metrics AS (
    SELECT
        AVG((close_price - open_price) / open_price * 100) AS market_avg_return,
        AVG(high_price - low_price) AS market_avg_volatility
    FROM stock_prices
)
SELECT
    sm.ticker,
    sm.avg_daily_return,
    sm.avg_daily_volatility
FROM stock_metrics sm
CROSS JOIN market_metrics mm
WHERE sm.avg_daily_return > mm.market_avg_return
  AND sm.avg_daily_volatility < mm.market_avg_volatility
ORDER BY sm.avg_daily_return DESC;

-- 5. Volatility stability
SELECT
    s.ticker,
    STDDEV(sp.high_price - sp.low_price) AS volatility_std_dev
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY volatility_std_dev ASC;
