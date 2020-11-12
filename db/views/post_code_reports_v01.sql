SELECT	c.post_code,
		COUNT(c.id) as total_places,
		SUM(c.chairs) as total_chairs,
		ROUND(CAST((SUM(c.chairs)::float / (SELECT SUM(c2.chairs) FROM cafes c2) * 100) as numeric), 2) as pct_chairs,
		MAX(c5.name) as place_with_max_chairs
FROM cafes c
LEFT JOIN (SELECT c3.name, c3.post_code, c3.chairs
	FROM cafes c3
	WHERE (c3.post_code, c3.chairs) IN ( SELECT c4.post_code, MAX(c4.chairs) FROM cafes c4 GROUP BY c4.post_code)) c5
ON c.post_code = c5.post_code
GROUP BY c.post_code
ORDER BY c.post_code
