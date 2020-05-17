  SELECT *
 FROM survey
 LIMIT 10; 

 SELECT question, 
  COUNT(DISTINCT user_id) as 'answered'
 FROM survey
 GROUP BY question;

 SELECT *
 FROM quiz
 LIMIT 5;

 SELECT *
 FROM home_try_on
 LIMIT 5;

 SELECT *
 FROM purchase
 LIMIT 5;

SELECT 
  DISTINCT q.user_id, 
  CASE WHEN h.user_id IS NOT NULL 
    THEN 'TRUE'
    ELSE 'FALSE'
    END AS 'is_home_try_on',
  h.number_of_pairs,
  CASE WHEN p.user_id IS NOT NULL 
    THEN 'TRUE'
    ELSE 'FALSE'
    END AS 'is_purchase' 
FROM quiz q
LEFT JOIN home_try_on h
  ON  q.user_id = h.user_id
LEFT JOIN purchase p
  ON q.user_id = p.user_id
LIMIT 10;

WITH funnels AS (SELECT 
  DISTINCT q.user_id, 
  h.user_id IS NOT NULL 
    AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL 
    AS 'is_purchase' 
FROM quiz q
LEFT JOIN home_try_on h
  ON  q.user_id = h.user_id
LEFT JOIN purchase p
  ON q.user_id = p.user_id)
SELECT 
  number_of_pairs,
  SUM(is_home_try_on) AS 'num_tryon',
  SUM(is_purchase) AS 'num_purchase',
  ROUND(100 * SUM(is_purchase) / SUM (is_home_try_on)) AS 'tryon_to_purchase'
FROM funnels
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs
ORDER BY number_of_pairs;
