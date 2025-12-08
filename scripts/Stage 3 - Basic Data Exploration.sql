-- 1️⃣ Get all stock tickers and their company names.
SELECT c.name, s.ticker
FROM companies c
INNER JOIN stocks s
ON c.company_id = s.company_id;

-- 2️⃣ List all closing prices for AAPL sorted by date (ascending).
SELECT s.ticker, sp.price_date, sp.close_price
FROM stocks s
INNER JOIN stock_prices sp
ON s.stock_id = sp.stock_id
WHERE s.ticker = 'AAPL'
ORDER BY sp.price_date ASC;

-- 3️⃣ Find the total number of price records per stock.
SELECT s.ticker, COUNT(*) AS record_count
FROM stocks s
INNER JOIN stock_prices sp
ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 4️⃣ Show daily price change (close - open) for each stock.
SELECT s.ticker, sp.price_date,
       (sp.close_price - sp.open_price) AS daily_change
FROM stocks s
INNER JOIN stock_prices sp
ON s.stock_id = sp.stock_id
ORDER BY s.ticker, sp.price_date;

-- 5️⃣ Which stock has the highest single-day closing price?
SELECT s.ticker, MAX(sp.close_price) AS highest_close
FROM stocks s
JOIN stock_prices sp
ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY highest_close DESC
LIMIT 3;

-- 6️⃣️ Which stocks has the average close price higher than the overall average close price?
SELECT s.ticker, AVG(sp.close_price) as avg_close_price
FROM stocks s
JOIN stock_prices sp 
	on s.stock_id = sp.stock_id
group by  s.ticker
having AVG(close_price) >
(
	select AVG(close_price)
	from stock_prices
);