SELECT 	c.category,
		COUNT(c.id) as total_places,
		SUM(c.chairs) as total_chairs
FROM cafes c
GROUP BY c.category
ORDER BY c.category
