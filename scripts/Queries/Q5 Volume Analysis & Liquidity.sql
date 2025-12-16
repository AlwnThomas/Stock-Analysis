-- Analyse trading volume, liquidity patterns and relate volume to price movement

-- 1. Average daily trading volume per stock
SELECT
	s.ticker,
	AVG(sp.volume) AS avg_volume
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 2. Highest single-day colume per stock
SELECT
	s.ticker,
	MAX(sp.volume) AS max_volume
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 3. Volume spikes greates than 2x stock average
SELECT
	s.ticker,
	sp.price_date,
	sp.volume,
	avg_vol.avg_volume
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
JOIN (
	SELECT
		stock_id,
		AVG(volume) AS avg_volume
	FROM stock_prices
	GROUP BY stock_id
	) avg_vol
		ON sp.stock_id = avg_vol.stock_id 
WHERE sp.volume > 2 * avg_vol.avg_volume
ORDER BY s.ticker, sp.volume DESC;

-- 4. Days where volume was above stock average, was stock more likely to close higher?
SELECT
	s.ticker,
	sp.price_date,
	sp.volume,
	sp.open_price,
	sp.close_price
FROM stocks s
JOIN stock_prices sp
 ON s.stock_id = sp.stock_id
JOIN (
	SELECT
		stock_id,
		AVG(volume) AS avg_volume
	FROM stock_prices
	GROUP BY stock_id
) avg_vol
	ON sp.stock_id = avg_vol.stock_id
WHERE sp.volume > avg_vol.avg_volume 
ORDER BY s.ticker, sp.price_date;

-- 5. Highest total trading stocks
SELECT
    s.ticker,
    SUM(sp.volume) AS total_volume
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY total_volume DESC;

-- 6. % of total market volume for each stock
SELECT
	sv.ticker,
	sv.stock_volume,
	mv.market_volume,
	CONCAT(
    ROUND((sv.stock_volume / mv.market_volume) * 100, 2),
    '%'
			) AS volume_percentage
FROM (
	SELECT
		s.ticker,
		SUM(sp.volume) AS stock_volume
	FROM stocks s
	JOIN stock_prices sp
		ON s.stock_id = sp.stock_id
	GROUP BY s.ticker
	) sv
CROSS JOIN (
    SELECT
        SUM(volume) AS market_volume
    FROM stock_prices
) mv
ORDER BY stock_volume DESC;