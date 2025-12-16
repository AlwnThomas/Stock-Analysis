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