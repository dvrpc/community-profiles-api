SELECT
    county_id as fips,
    SUM(CASE WHEN metric = 'PM2' AND pavement_condition = 'Good' THEN miles ELSE 0 END) AS road_pm2_good,
    SUM(CASE WHEN metric = 'PM2' AND pavement_condition = 'Fair' THEN miles ELSE 0 END) AS road_pm2_fair,
    SUM(CASE WHEN metric = 'PM2' AND pavement_condition = 'Poor' THEN miles ELSE 0 END) AS road_pm2_poor,
    SUM(CASE WHEN metric = 'IRI' AND pavement_condition = 'Good' THEN miles ELSE 0 END) AS road_iri_good,
    SUM(CASE WHEN metric = 'IRI' AND pavement_condition = 'Fair' THEN miles ELSE 0 END) AS road_iri_fair,
    SUM(CASE WHEN metric = 'IRI' AND pavement_condition = 'Poor' THEN miles ELSE 0 END) AS road_iri_poor,
    SUM(CASE WHEN metric = 'DOT Pavement Index' AND pavement_condition = 'Good' THEN miles ELSE 0 END) AS road_dot_index_good,
    SUM(CASE WHEN metric = 'DOT Pavement Index' AND pavement_condition = 'Fair' THEN miles ELSE 0 END) AS road_dot_index_fair,
    SUM(CASE WHEN metric = 'DOT Pavement Index' AND pavement_condition = 'Poor' THEN miles ELSE 0 END) AS road_dot_index_poor
FROM
    "4e632db0-9830-4f7b-9ff3-072353ea9e6a"
WHERE
    year = (SELECT MAX(year) FROM "4e632db0-9830-4f7b-9ff3-072353ea9e6a") AND road_type = 'Total'
GROUP BY
    county_id