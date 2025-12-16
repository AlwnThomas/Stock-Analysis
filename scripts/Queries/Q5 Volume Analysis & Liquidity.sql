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


		
	
	 