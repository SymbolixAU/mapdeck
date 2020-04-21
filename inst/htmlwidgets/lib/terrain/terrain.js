function add_terrain(map_id, map_type, layer_id, elevation_data, texture, elevation_decoder, max_error, update_view, bounds, bbox, focus_layer ) {

  const terrainLayer = new deck.TerrainLayer({
  	id: "terrain-"+layer_id,
  	elevationDecoder: {
  	  rScaler: elevation_decoder[0],
  	  gScaler: elevation_decoder[1],
  	  bScaler: elevation_decoder[2],
  	  offset: elevation_decoder[3]
  	  },
    elevationData: elevation_data,
    texture: texture,
    bounds: bounds,
    meshMaxError: max_error
  });

  md_update_layer( map_id, 'terrain-'+layer_id, terrainLayer );
  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}
