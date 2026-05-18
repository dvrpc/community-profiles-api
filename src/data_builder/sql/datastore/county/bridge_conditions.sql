SELECT
    county_id as fips,
    SUM(CASE WHEN nhs_type = 'All' AND condition = 'Good' THEN count_bridges ELSE 0 END) AS bridge_all_good,
    SUM(CASE WHEN nhs_type = 'All' AND condition = 'Fair' THEN count_bridges ELSE 0 END) AS bridge_all_fair,
    SUM(CASE WHEN nhs_type = 'All' AND condition = 'Poor' THEN count_bridges ELSE 0 END) AS bridge_all_poor,
    SUM(CASE WHEN nhs_type = 'NHS' AND condition = 'Good' THEN count_bridges ELSE 0 END) AS bridge_nhs_good,
    SUM(CASE WHEN nhs_type = 'NHS' AND condition = 'Fair' THEN count_bridges ELSE 0 END) AS bridge_nhs_fair,
    SUM(CASE WHEN nhs_type = 'NHS' AND condition = 'Poor' THEN count_bridges ELSE 0 END) AS bridge_nhs_poor,
    SUM(CASE WHEN nhs_type = 'Non-NHS' AND condition = 'Good' THEN count_bridges ELSE 0 END) AS bridge_nonnhs_good,
    SUM(CASE WHEN nhs_type = 'Non-NHS' AND condition = 'Fair' THEN count_bridges ELSE 0 END) AS bridge_nonnhs_fair,
    SUM(CASE WHEN nhs_type = 'Non-NHS' AND condition = 'Poor' THEN count_bridges ELSE 0 END) AS bridge_nonnhs_poor
FROM
    "6b065499-c75d-48bd-a3c1-6c7bcf030efa" as t
WHERE
    year = (SELECT MAX(year) FROM "6b065499-c75d-48bd-a3c1-6c7bcf030efa")
GROUP BY
    county_id