--Volatility analysis queries measuring daily and average price fluctuations for each stock.

-- 1. Daily volatility for every stock (high − low)
SELECT s.ticker,
       sp.price_date,
       (sp.high_price - sp.low_price) AS daily_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id;

-- 2. Average daily volatility per stock
SELECT s.ticker,
       AVG(sp.high_price - sp.low_price) AS avg_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
GROUP BY s.ticker;

-- 3. The single day with the lowest volatility
SELECT s.ticker,
       sp.price_date,
       (sp.high_price - sp.low_price) AS daily_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
ORDER BY daily_volatility ASC
LIMIT 1;

-- 3. The single day with the lowest volatility
SELECT s.ticker,
       sp.price_date,
       (sp.high_price - sp.low_price) AS daily_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
ORDER BY daily_volatility ASC
LIMIT 1;

-- 5. Stocks with volatility higher than overall average volatility
SELECT s.ticker,
       AVG(sp.high_price - sp.low_price) AS avg_volatility
FROM stocks s
JOIN stock_prices sp
    ON s.stock_id = sp.stock_id
GROUP BY s.ticker
HAVING AVG(sp.high_price - sp.low_price) >
      (SELECT AVG(high_price - low_price)
       FROM stock_prices);

-- 6. AAPL days where volatility > 5% of closing price
SELECT s.ticker,
       sp.price_date,
       ((sp.high_price - sp.low_price) / sp.close_price * 100) AS volatility_percentage
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
WHERE s.ticker = 'AAPL'
  AND ((sp.high_price - sp.low_price) / sp.close_price * 100) > 5
ORDER BY sp.price_date ASC;

-- 7. Maximum daily volatility per stock
SELECT s.ticker,
       MAX(sp.high_price - sp.low_price) AS max_volatility
FROM stocks s
JOIN stock_prices sp ON s.stock_id = sp.stock_id
GROUP BY s.ticker
ORDER BY max_volatility DESC;
