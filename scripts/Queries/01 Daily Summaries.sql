-- Creating queries that summarises each day's market performance metrics
-- Fundamental SQL queries for stock analysis

-- 1. ALL Companies with their tickers
SELECT c.name AS company_name, s.ticker
FROM companies c
JOIN stocks s ON c.company_id = s.company_id;

-- 2. Daily Highest Gainer
SELECT sp.price_date, s.ticker, ((sp.close_price - sp.open_price)/sp.open_price)*100 AS percent_change
FROM stocks s
JOIN stock_prices sp
  ON s.stock_id = sp.stock_id
WHERE ((sp.close_price - sp.open_price)/sp.open_price) = (
    SELECT MAX((sp2.close_price - sp2.open_price)/sp2.open_price)
    FROM stock_prices sp2
    WHERE sp2.price_date = sp.price_date
)
ORDER BY sp.price_date ASC
LIMIT 1;

-- 3. Daily Biggest Loser
SELECT sp.price_date, s.ticker, ((sp.close_price - sp.open_price)/sp.open_price)*100 AS percent_change
FROM stocks s
JOIN stock_prices sp
  ON s.stock_id = sp.stock_id
WHERE ((sp.close_price - sp.open_price)/sp.open_price) = (
    SELECT MIN((sp2.close_price - sp2.open_price)/sp2.open_price)
    FROM stock_prices sp2
    WHERE sp2.price_date = sp.price_date
)
ORDER BY sp.price_date ASC
LIMIT 1;

-- 4. Daily Highest Volume
SELECT sp.price_date, s.ticker, sp.volume
FROM stocks s
JOIN stock_prices sp
  ON s.stock_id = sp.stock_id
WHERE sp.volume = (
    SELECT MAX(sp2.volume)
    FROM stock_prices sp2
    WHERE sp2.price_date = sp.price_date
)
ORDER BY sp.price_date ASC;

-- 5. ALL price records for AAPL in ASC order
SELECT s.ticker,
       sp.price_date,
       sp.open_price,
       sp.close_price,
       sp.high_price,
       sp.low_price,
       sp.volume
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
WHERE s.ticker = 'AAPL'
ORDER BY sp.price_date ASC;

-- 6. Highest closing price for each stock
SELECT s.ticker,
       MAX(sp.close_price) AS highest_close_price
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 7. Total price records for each stock
SELECT s.ticker,
       COUNT(*) AS total_price_records
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 8. Daily price range for each stock
SELECT s.ticker,
       sp.price_date,
       (sp.high_price - sp.low_price) AS daily_price_range
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
ORDER BY sp.price_date ASC;

-- 9. Stock with highest closing price each day
SELECT s.ticker,
       sp.close_price AS highest_close_price
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
ORDER BY sp.close_price DESC
LIMIT 1;

-- 10. Total trading volume per stock
SELECT s.ticker,
       SUM(sp.volume) AS total_volume
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 11. AVG closing price per stock
SELECT s.ticker,
       AVG(sp.close_price) AS avg_close_price
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 12. ALL dates AAPL closed higher than its open
SELECT s.ticker,
       sp.price_date,
       sp.open_price,
       sp.close_price
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
WHERE s.ticker = 'AAPL'
  AND sp.close_price > sp.open_price
ORDER BY sp.price_date ASC;

-- 13. First recorded close price for each stock
SELECT s.ticker,
       sp.price_date,
       sp.close_price
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
WHERE sp.price_date = (
    SELECT MIN(sp2.price_date)
    FROM stock_prices sp2
    WHERE sp2.stock_id = sp.stock_id
)
ORDER BY s.ticker;

