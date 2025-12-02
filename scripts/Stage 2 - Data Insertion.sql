INSERT INTO companies (company_id, name, sector, industry, headquarters)
VALUES
(1, 'Apple Inc', 'Technology', 'Consumer Electronics', 'Cupertino, CA'),
(2, 'Microsoft Corporation', 'Technology', 'Software', 'Redmond, WA'),
(3, 'Tesla Inc', 'Automotive', 'Electric Vehicles', 'Austin, TX'),
(4, 'Amazon.com, Inc', 'Consumer Discretionary', 'E-commerce', 'Seattle, WA'),
(5, 'Nvidia Corporation', 'Technology', 'Semiconductors', 'Santa Clara, CA'),
(6, 'Walmart Inc', 'Consumer Staples', 'Retail', 'Bentonville, AR'),
(7, 'JPMorgan Chase & Co', 'Financials', 'Banking', 'New York, NY'),
(8, 'Netflix, Inc', 'Communication Services', 'Streaming', 'Los Gatos, CA'),
(9, 'Johnson & Johnson', 'Healthcare', 'Pharmaceuticals', 'New Brunswick, NJ'),
(10, 'ExxonMobil Corporation', 'Energy', 'Oil & Gas', 'Irving, TX');

INSERT INTO stocks (stock_id, company_id, ticker, exchange)
VALUES
(1, 1, 'AAPL', 'NASDAQ'),
(2, 2, 'MSFT', 'NASDAQ'),
(3, 3, 'TSLA', 'NASDAQ'),
(4, 4, 'AMZN', 'NASDAQ'),
(5, 5, 'NVDA', 'NASDAQ'),
(6, 6, 'WMT', 'NYSE'),
(7, 7, 'JPM', 'NYSE'),
(8, 8, 'NFLX', 'NASDAQ'),
(9, 9, 'JNJ', 'NYSE'),
(10, 10, 'XOM', 'NYSE');
