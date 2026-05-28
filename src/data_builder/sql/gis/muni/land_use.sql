select
  geoid,
  ROUND(SUM(acres), 2) as total_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Agriculture' THEN acres ELSE 0 END), 2) AS agriculture_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Commercial' THEN acres ELSE 0 END), 2) AS commercial_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Industrial' THEN acres ELSE 0 END), 2) AS industrial_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Institutional' THEN acres ELSE 0 END), 2) AS institutional_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Military' THEN acres ELSE 0 END), 2) AS military_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Mining' THEN acres ELSE 0 END), 2) AS mining_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Recreation' THEN acres ELSE 0 END), 2) AS recreation_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Residential' THEN acres ELSE 0 END), 2) AS residential_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Transportation' THEN acres ELSE 0 END), 2) AS transportation_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Undeveloped' THEN acres ELSE 0 END), 2) AS undeveloped_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Utility' THEN acres ELSE 0 END), 2) AS utility_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Water' THEN acres ELSE 0 END), 2) AS water_acres,
  ROUND(SUM(CASE WHEN lu23catn = 'Wooded' THEN acres ELSE 0 END), 2) AS wooded_acres
FROM planning.dvrpc_landuse_2023
GROUP BY geoid;
