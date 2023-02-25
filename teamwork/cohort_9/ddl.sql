CREATE SCHEMA dev_dds;

CREATE TABLE dev_dds.periods (
  id    SERIAL    NOT NULL PRIMARY KEY,
  date  TIMESTAMP NOT NULL,
  month INTEGER   NOT NULL,
  year  INTEGER   NOT NULL
);

CREATE TABLE dev_dds.products (
  id   SERIAL  NOT NULL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE TABLE dev_dds.sales_point (
  id   SERIAL  NOT NULL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE TABLE dev_dds.f_sales_fact (
  id            SERIAL NOT NULL PRIMARY KEY,
  sale_point_id INTEGER,
  period_id     INTEGER,
  product_id    INTEGER,
  price         NUMERIC(14, 2),
  sales_count   INTEGER,
  FOREIGN KEY (sale_point_id) REFERENCES dev_dds.sales_point (id),
  FOREIGN KEY (period_id) REFERENCES dev_dds.periods (id),
  FOREIGN KEY (product_id) REFERENCES dev_dds.products (id)
);

CREATE TABLE dev_dds.f_sales_plan (
  id            SERIAL NOT NULL PRIMARY KEY,
  sale_point_id INTEGER,
  period_id     INTEGER,
  product_id    INTEGER,
  price         NUMERIC(14, 2),
  sales_count   INTEGER,
  FOREIGN KEY (sale_point_id) REFERENCES dev_dds.sales_point (id),
  FOREIGN KEY (period_id) REFERENCES dev_dds.periods (id),
  FOREIGN KEY (product_id) REFERENCES dev_dds.products (id)
);
