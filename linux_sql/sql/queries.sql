-- Group hosts by hardware info
SELECT cpu_number, id, total_mem
FROM host_info
ORDER BY
    cpu_number,
    total_mem DESC;

-- Average memory usage
SELECT U.host_id, I.hostname, U.avg_used_mem_percentage, U.rounded_timestamp
FROM
    (SELECT host_id,
           100 - AVG(cpu_idle) AS avg_used_mem_percentage,
           date_trunc('hour', host_usage.timestamp)
               + (date_part('minute', host_usage.timestamp)::INT / 5) * INTERVAL '5 min' AS rounded_timestamp
    FROM host_usage
    GROUP BY host_id, rounded_timestamp) AS U
INNER JOIN host_info AS I
ON I.id = U.host_id
ORDER BY U.host_id, U.rounded_timestamp;

-- Detect host failure
SELECT host_id,
       COUNT(*) AS entry_count,
       date_trunc('hour', host_usage.timestamp)
           + (date_part('minute', host_usage.timestamp)::INT / 5) * INTERVAL '5 min' AS rounded_timestamp
FROM host_usage
GROUP BY host_id, rounded_timestamp
HAVING COUNT(*) < 3;

