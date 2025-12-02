-- Creating companies table
create table companies (
	company_id SERIAL primary key,
	name varchar(255) not null,
	sector varchar(100),
	industry varchar(100),
	headquarters varchar(255)
	);

-- Creating stocks table
create table stocks (
	stock_id SERIAL primary key,
	company_id INT not null,
	ticker varchar(10),
	exchange varchar(20),
	foreign key (company_id) references companies(company_id)
	);

-- Creating stock prices table
create table stock_prices (
	price_id SERIAL primary key,
	stock_id int not null,
	price_date date not null,
	open_price decimal (10,2),
	close_price decimal (10,2),
	high_price decimal (10,2),
	low_price decimal (10,2),
	volume BIGINT,
	foreign key (stock_id) references stocks(stock_id)
	);

-- Creating financials table
create table financials (
	financial_id SERIAL primary key,
	company_id int not null,
	fiscal_year int not null,
	revenue bigint,
	net_income bigint,
	assets bigint,
	liabilities bigint,
	foreign key (company_id) references companies(company_id)
	);