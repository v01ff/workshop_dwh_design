CREATE SCHEMA dev_rep;

CREATE OR REPLACE VIEW dev_rep.sales_report AS
SELECT DATE_TRUNC('month', dim_t.date)::DATE                          AS date_month
     , dim_sp.name                                                    AS sales_point
     , dim_p.name                                                     AS product_name
     , SUM(u.plan_revenue_amt)                                        AS plan_revenue_amt
     , SUM(u.fact_revenue_amt)                                        AS fact_revenue_amt
     , (SUM(u.fact_revenue_amt) / SUM(u.plan_revenue_amt) * 100)::INT AS plan_comp_perc
FROM (
  SELECT p.period_id
       , p.sale_point_id
       , p.product_id
       , p.price * p.sales_count AS plan_revenue_amt
       , 0                       AS fact_revenue_amt
  FROM dev_dds.f_sales_plan p
  UNION ALL
  SELECT f.period_id
       , f.sale_point_id
       , f.product_id
       , 0                       AS plan_revenue_amt
       , f.price * f.sales_count AS fact_revenue_amt
  FROM dev_dds.f_sales_fact f
)                        u
JOIN dev_dds.periods     dim_t ON u.period_id = dim_t.id
JOIN dev_dds.products    dim_p ON u.product_id = dim_p.id
JOIN dev_dds.sales_point dim_sp ON u.sale_point_id = dim_sp.id
GROUP BY DATE_TRUNC('month', dim_t.date)::DATE, dim_sp.name, dim_p.name;

