SELECT
  c.fips,
  c.co_name, 
  ST_AsText(st_transform(st_envelope(ST_Buffer(c.shape, (st_ymax(c.shape) - st_ymin(c.shape)) * 0.05)), 4326)) as buffer_bbox,

  -- Miles of existing trails

  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, t.shape))) / 1609.34)
    FROM transportation.all_trails t
    WHERE ST_Intersects(c.shape, t.shape)
  ), 0) AS existing_trail_mi,


  -- -- Miles of circuit trails that are planned, in pipeline, or in progress

  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, ct.shape))) / 1609.34)
    FROM transportation.circuittrails ct
    WHERE ST_Intersects(c.shape, ct.shape) and ct.circuit != 'Existing'
  ), 0) AS planned_trail_mi,


  -- COALESCE((
  --   SELECT (SUM(ST_Length(ST_Intersection(c.shape, lts.shape))) / 1609.34)
  --   FROM transportation.lts_network_v2 lts
  --   WHERE ST_Intersects(c.shape, lts.shape) and lts.lts <= 2
  -- ), 0) AS low_stress,

  -- COALESCE((
  --   SELECT (SUM(ST_Length(ST_Intersection(c.shape, lts.shape))) / 1609.34)
  --   FROM transportation.lts_network_v2 lts
  --   WHERE ST_Intersects(c.shape, lts.shape) and lts.lts > 2
  -- ), 0) AS high_stress,

  -- COALESCE((
  --   SELECT (SUM(ST_Length(ST_Intersection(c.shape, pn.shape))) / 1609.34)
  --   FROM transportation.pedestriannetwork_lines pn
  --   WHERE ST_Intersects(c.shape, pn.shape)
  -- ), 0) AS pedestrian_network_mi,

  -- COALESCE((
  --   SELECT AVG(sw_ratio)
  --   FROM transportation.pedestriannetwork_gaps pg
  --   WHERE ST_Contains(c.shape, st_transform(pg.shape, 26918))
  -- ), 0) AS sw_gap_ratio,

  -- -- Miles of freight rail
  
  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, fr.shape))) / 1609.34)
    FROM freight.freight_rail fr
    WHERE ST_Intersects(c.shape, fr.shape)
  ), 0) AS freight_rail_mi,

  -- -- Miles of highway

  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, hw.shape))) / 1609.34)
    FROM freight.highways hw
    WHERE ST_Intersects(c.shape, hw.shape)
  ), 0) AS highway_mi,


  -- -- Number of freight centers 

  COALESCE((
    SELECT COUNT(*)
    FROM freight.freight_centers fc
    WHERE ST_Area(ST_Intersection(c.shape, fc.shape)) > 0
  ), 0) AS unique_freight_centers,

  COALESCE((
    SELECT COUNT(*)
    FROM transportation.patip_fy2025_2028_line tip
    WHERE ST_Intersects(c.shape, tip.shape)
  ), 0) AS fy25_pa_lines,

    COALESCE((
    SELECT COUNT(*)
    FROM transportation.njtip_fy2026_2029_line tip
    WHERE ST_Intersects(c.shape, tip.shape)
  ), 0) AS fy26_nj_lines,

  COALESCE((
    SELECT COUNT(*)
    FROM transportation.patip_fy2025_2028_point tip
    WHERE ST_Intersects(c.shape, tip.shape)
  ), 0) AS fy25_pa_points,

  COALESCE((
    SELECT COUNT(*)
    FROM transportation.njtip_fy2026_2029_point tip
    WHERE ST_Intersects(c.shape, tip.shape)
  ), 0) AS fy26_nj_points,

  -- COALESCE((
  --   SELECT (SUM(ST_Area(ST_Intersection(c.shape, os.shape))) / 1609.34)
  --   FROM planning.dvrpc_protectedopenspace os
  --   WHERE ST_Intersects(c.shape, os.shape)
  -- ), 0) AS protected_open_space_sq_mi,

  COALESCE((
    SELECT COUNT(*)
    FROM transportation.septa_transitstops sp
    WHERE ST_Intersects(c.shape, ST_transform(sp.shape, 26918))
  ), 0) AS septa_bus_stops,

  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, ST_transform(sp.shape, 26918)))) / 1609.34)
    FROM transportation.septa_transitroutes sp
    WHERE ST_Intersects(c.shape, ST_transform(sp.shape, 26918))
  ), 0) AS septa_bus_routes_mi,

  COALESCE((
    SELECT COUNT(*)
    FROM transportation.njtransit_transitstops njt
    WHERE ST_Intersects(c.shape, ST_transform(njt.shape, 26918))
  ), 0) AS njt_bus_stops,

  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, ST_transform(njt.shape, 26918)))) / 1609.34)
    FROM transportation.njtransit_transitroutes njt
    WHERE ST_Intersects(c.shape, ST_transform(njt.shape, 26918))
  ), 0) AS njt_bus_routes_mi,

  COALESCE((
    SELECT COUNT(*)
    FROM transportation.passengerrailstations prs
    WHERE ST_Intersects(c.shape, prs.shape)
  ), 0) AS passenger_rail_stations,

  COALESCE((
    SELECT (SUM(ST_Length(ST_Intersection(c.shape, pr.shape))) / 1609.34)
    FROM transportation.passengerrail pr
    WHERE ST_Intersects(c.shape, pr.shape)
  ), 0) AS passenger_rail_mi

FROM
  boundaries.countyboundaries c
where c.dvrpc_reg = 'Yes';