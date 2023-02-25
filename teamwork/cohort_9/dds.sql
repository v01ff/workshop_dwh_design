INSERT INTO dev_dds.sales_point (id, name)
VALUES (1, 'dns')
     , (2, 'eldorado')
     , (3, 'svyaznoy');

INSERT INTO dev_dds.periods (date, month, year)
SELECT CAST('2022-01-01' AS DATE) + (n || ' day')::INTERVAL                     AS date
     , DATE_PART('month', CAST('2022-01-01' AS DATE) + (n || ' day')::INTERVAL) AS month
     , DATE_PART('year', CAST('2022-01-01' AS DATE) + (n || ' day')::INTERVAL)  AS year
FROM GENERATE_SERIES(0, 364) n;

INSERT INTO dev_dds.products(name)
SELECT DISTINCT product AS name
FROM dev_stg.dns_2022
UNION
SELECT DISTINCT product AS name
FROM dev_stg.eldorado_2022
UNION
SELECT DISTINCT product AS name
FROM dev_stg.svyaznoy_2022;

WITH df AS (
  SELECT *, 1 AS sales_point_id
  FROM dev_stg.dns_2022
  UNION
  SELECT *, 2 AS sales_point_id
  FROM dev_stg.eldorado_2022
  UNION
  SELECT *, 3 AS sales_point_id
  FROM dev_stg.svyaznoy_2022
)
INSERT
INTO dev_dds.f_sales_fact (sale_point_id, period_id, product_id, price, sales_count)
SELECT df.sales_point_id
     , per.id      AS period_id
     , prod.id     AS product_id
     , df.price
     , df.sale_cnt AS sales_count
FROM df
JOIN dev_dds.periods  per ON df.sale_date = per.date
JOIN dev_dds.products prod ON df.product = prod.name;



INSERT
INTO dev_dds.f_sales_plan (sale_point_id, period_id, product_id, price, sales_count)
SELECT sp.id         AS sales_point_id
     , per.id        AS period_id
     , prod.id       AS product_id
     , plan.price
     , plan.sale_cnt AS sales_count
FROM dev_stg.plan_2022        plan
LEFT JOIN dev_dds.sales_point sp ON sp.name = plan.sales_point
JOIN      dev_dds.periods     per ON plan.plan_date = per.date
JOIN      dev_dds.products    prod ON plan.product = prod.name;