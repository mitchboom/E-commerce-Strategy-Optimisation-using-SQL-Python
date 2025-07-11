SELECT * FROM gms_project.gms_sessions;


-- Count rows
SELECT 
	COUNT(*) AS total_rows,
    COUNT(session_id) AS total_non_null_rows,
    COUNT(DISTINCT session_id) AS unique_total_non_null_rows
FROM gms_project.gms_sessions;



-- Small overview dataset KPIs
SELECT
    COUNT(DISTINCT session_id) AS total_sessions,
    SUM(transactions) AS total_transactions,
    ROUND(SUM(transactionRevenue)/1e6, 2) AS total_revenue,
    ROUND(SUM(bounces) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct,
    ROUND(AVG(timeOnSite), 2) AS avg_time_on_site_seconds,
    ROUND(AVG(pageviews), 2) AS avg_pageviews,
    SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) AS conversions,
    ROUND(SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate_pct
FROM gms_project.gms_sessions;



-- Website Engagement & Monetization by Device
SELECT
  deviceCategory,
  COUNT(DISTINCT session_id) AS total_sessions,
  ROUND(COUNT(DISTINCT session_id) / SUM(COUNT(DISTINCT session_id)) OVER () * 100, 2) AS session_share_pct,
  ROUND(AVG(timeOnSite), 2) AS avg_time_on_site,
  ROUND(AVG(pageviews), 2) AS avg_pageviews,
  ROUND(SUM(bounces) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct,
  SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) AS conversions,
  ROUND(SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate_pct,
  ROUND(SUM(transactionRevenue) / 1e6, 2) AS total_revenue,
  ROUND(SUM(transactionRevenue) / SUM(SUM(transactionRevenue)) OVER () * 100, 2) AS revenue_share_pct
FROM gms_project.gms_sessions
GROUP BY deviceCategory
ORDER BY session_share_pct DESC;



-- Website Engagement & Monetization by Channel
SELECT
  channelGrouping,
  COUNT(DISTINCT session_id) AS total_sessions,
  ROUND(COUNT(DISTINCT session_id) / SUM(COUNT(DISTINCT session_id)) OVER () * 100, 2) AS session_share_pct,
  ROUND(AVG(timeOnSite), 2) AS avg_time_on_site,
  ROUND(AVG(pageviews), 2) AS avg_pageviews,
  ROUND(SUM(bounces) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct,
  SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) AS conversions,
  ROUND(SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate_pct,
  ROUND(SUM(transactionRevenue) / 1e6, 2) AS total_revenue,
  ROUND(SUM(transactionRevenue) / SUM(SUM(transactionRevenue)) OVER () * 100, 2) AS revenue_share_pct
FROM gms_project.gms_sessions
GROUP BY channelGrouping
ORDER BY session_share_pct DESC;



-- Social Platform Performance Breakdown
SELECT
  channelGrouping,
  CASE
    WHEN source LIKE '%youtube%' THEN 'YouTube'
    WHEN source LIKE '%facebook%' THEN 'Facebook'
    WHEN source LIKE '%reddit%' THEN 'Reddit'
    WHEN source LIKE '%google%' THEN 'Google'
    WHEN source LIKE '%pinterest%' THEN 'Pinterest'
    WHEN source LIKE '%quora%' THEN 'Quora'
    ELSE 'Other'
  END AS social_platform,
  COUNT(DISTINCT session_id) AS total_sessions,
  ROUND(COUNT(DISTINCT session_id) / SUM(COUNT(DISTINCT session_id)) OVER () * 100, 2) AS session_share_pct,
  ROUND(AVG(timeOnSite), 2) AS avg_time_on_site,
  ROUND(AVG(pageviews), 2) AS avg_pageviews,
  ROUND(SUM(bounces) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct,
  SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) AS conversions,
  ROUND(SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate_pct,
  ROUND(SUM(transactionRevenue) / 1e6, 2) AS total_revenue,
  ROUND(SUM(transactionRevenue) / SUM(SUM(transactionRevenue)) OVER () * 100, 2) AS revenue_share_pct
FROM gms_project.gms_sessions
WHERE channelGrouping = 'Social'
GROUP BY channelGrouping, social_platform
ORDER BY session_share_pct DESC;


-- Trends in Website Engagement
SELECT
  YEAR(date) AS year,
  MONTH(date) AS month_number,
  MONTHNAME(date) AS month,
  WEEK(date, 1) AS week_number,
  MIN(date) AS week_start,
  MAX(date) AS week_end,
  COUNT(DISTINCT session_id) AS total_sessions,
  AVG(COUNT(DISTINCT session_id)) OVER(ORDER BY WEEK(date, 1) ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS average_session_trend,
  SUM(COUNT(DISTINCT session_id)) OVER(ORDER BY MONTH(date) RANGE BETWEEN CURRENT ROW AND CURRENT ROW) AS total_sessions_month,
  ROUND(SUM(bounces) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct,
  ROUND(SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate_pct
FROM gms_project.gms_sessions
GROUP BY YEAR(date), MONTH(date), MONTHNAME(date), WEEK(date, 1)
ORDER BY year, MONTH(date), week_number;



SELECT
  DAYNAME(date) AS day,
  COUNT(DISTINCT session_id) AS total_sessions,
  ROUND(COUNT(DISTINCT session_id) / SUM(COUNT(DISTINCT session_id)) OVER () * 100, 2) AS session_share_pct,
  ROUND(AVG(timeOnSite), 2) AS avg_time_on_site,
  ROUND(AVG(pageviews), 2) AS avg_pageviews,
  ROUND(SUM(bounces) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct,
  ROUND(SUM(CASE WHEN transactions >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate_pct,
  ROUND(SUM(transactionRevenue) / 1e6, 2) AS total_revenue,
  ROUND(SUM(transactionRevenue) / SUM(SUM(transactionRevenue)) OVER () * 100, 2) AS revenue_share_pct
FROM gms_project.gms_sessions
GROUP BY DAYNAME(date)
ORDER BY session_share_pct DESC;







