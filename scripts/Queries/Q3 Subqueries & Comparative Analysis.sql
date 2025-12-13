-- Comparing our stocks to "the market" or other stocks

-- 1. Stocks outperforming market avg close price
SELECT s.ticker,
		AVG(sp.close_price) AS avg_close_price
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
GROUP BY s.ticker
HAVING AVG(sp.close_price) >
	(SELECT AVG(close_price)
	FROM stock_prices);
		
-- 2. Highest single day close price in market
SELECT s.ticker,
		sp.price_date,
		sp.close_price
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
WHERE sp.close_price = (SELECT MAX(close_price) FROM stock_prices);

-- 3. Daily % change higher than market avg
SELECT s.ticker,
		sp.open_price,
		sp.close_price,
		((close_price - open_price)/open_price) * 100 AS daily_percent_change
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id 
WHERE ((close_price - open_price)/open_price) * 100 >
	(SELECT AVG(((close_price - open_price)/open_price) * 100) AS avg_market_change
		FROM stock_prices);

-- 4. Top 3 highest-volume trading days per stock
SELECT 
    s.ticker,
    sp.price_date,
    sp.volume
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
WHERE (
    SELECT COUNT(*)
    FROM stock_prices sp2
    WHERE sp2.stock_id = sp.stock_id
      AND sp2.volume > sp.volume
) < 3
ORDER BY s.ticker, sp.volume DESC;
