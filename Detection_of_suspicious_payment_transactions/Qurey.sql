#inspect all
SELECT * FROM transfer_log;

#inspect the max. amount per user_id
SELECT from_user, max(amount) AS max_amount
FROM transfer_log
GROUP BY from_user;

#Find the cumulated transfer amount within any 5 days that are more than $1,000,000.
SELECT *
FROM (
	SELECT *,
    sum(amount) OVER (PARTITION BY from_user ORDER BY log_ts RANGE INTERVAL '5' DAY PRECEDING) AS total_amount
    FROM transfer_log
    WHERE type = 'Transfer'
    ) c
WHERE c.total_amount > 1000000;

#Query the frequency of transations between sender and receiver that is more than 3 times within 5 days. 
SELECT *
FROM (
	SELECT *,
    count(1) OVER (PARTITION BY from_user, to_user ORDER BY log_ts RANGE INTERVAL '5' DAY PRECEDING) AS frequency
    FROM transfer_log
    WHERE type = 'Transfer'
    ) c
WHERE c.frequency >= 3;

#inspect whether if we have sender and receiver belongs to the same account in any of these transactions.
SELECT *
FROM transfer_log
WHERE from_user = to_user
GROUP BY log_id