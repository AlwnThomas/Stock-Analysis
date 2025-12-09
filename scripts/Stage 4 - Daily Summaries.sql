-- Creating queries that summarises each day's market performance metrics

-- 1. Daily Highest Gainer
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

-- 2. Daily Biggest Loser
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

-- 3. Daily Highest Volume
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
