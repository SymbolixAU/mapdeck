function add_terrain(map_id, map_type, layer_id, elevation_data, texture, update_view, bounds, bbox, focus_layer ) {

  const terrainLayer = new deck.TerrainLayer({
  	id: "terrain-"+layer_id,
  	/*
  	elevationDecoder: {
      rScaler: 1,
      gScaler: 1,
      bScaler: 1,
      offset: 1
    },
    */
    elevationData: elevation_data,
    texture: texture,
    bounds: bounds,
  });

  md_update_layer( map_id, 'terrain-'+layer_id, terrainLayer );
  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}
