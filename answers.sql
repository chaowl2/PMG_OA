--Question 1
SELECT date, SUM(impressions) AS total_impressions
FROM marketing_performance
GROUP BY date
ORDER BY date;

--Question 2
SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
Limit 3;

--Question 3
-- VSCode shows syntax errors but this query runs.
SELECT ci.name AS campaign_name,
ROUND(SUM(COALESCE(mp.cost, 0)), 2) AS total_cost,
SUM(COALESCE(mp.impressions, 0)) AS total_impressions,
SUM(COALESCE(mp.clicks, 0)) AS total_clicks,
SUM(COALESCE(wr.revenue, 0)) AS total_revenue
FROM campaign_info ci
LEFT JOIN (
SELECT campaign_id, SUM(cost) AS cost, SUM(impressions) AS impressions, SUM(clicks) AS clicks
FROM marketing_performance
GROUP BY campaign_id
) mp ON ci.id = mp.campaign_id
LEFT JOIN (
SELECT campaign_id, SUM(revenue) AS revenue
FROM website_revenue
GROUP BY campaign_id
) wr ON ci.id = wr.campaign_id
GROUP BY ci.id, ci.name
ORDER BY total_revenue DESC;

--Question 4
SELECT wd.geo AS state, SUM(wd.conversions) AS total_conversions
FROM marketing_performance wd
JOIN campaign_info ci ON wd.campaign_id = ci.id
WHERE ci.name = 'Campaign5'
GROUP BY wd.geo;

--Question 5
SELECT ci.name, (SUM(wr.revenue) - SUM(md.cost)) / SUM(md.cost) AS roi
FROM website_revenue wr
JOIN marketing_performance md ON wr.campaign_id = md.campaign_id
JOIN campaign_info ci ON wr.campaign_id = ci.id
GROUP BY md.campaign_id
ORDER BY roi DESC;

-- I think that campaign 4 was the most efficient. I calculated the ROI 
-- of each campaign and then sorted in descending order to get the result.

-- Question 6 - bonus
-- something like this but it doesnt work.

SELECT
CASE STRFTIME('%w', WEEKDAY(md.date))
WHEN '0' THEN 'Sunday'
WHEN '1' THEN 'Monday'
WHEN '2' THEN 'Tuesday'
WHEN '3' THEN 'Wednesday'
WHEN '4' THEN 'Thursday'
WHEN '5' THEN 'Friday'
WHEN '6' THEN 'Saturday'
ELSE 'Unknown'
END AS day_of_week,
AVG(wr.revenue) AS avg_daily_revenue
FROM marketing_performance md
JOIN website_revenue wr ON md.campaign_id = wr.campaign_id
GROUP BY STRFTIME('%w', md.date)
ORDER BY avg_daily_revenue DESC
LIMIT 1;
