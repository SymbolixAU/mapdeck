

function add_terrain(map_id, layer_id, elevation_data, texture, bounds ) {

  const terrainLayer = new deck.TerrainLayer({
  	elevationDecoder: {
      rScaler: 2,
      gScaler: 0,
      bScaler: 0,
      offset: 0
    },
    // Digital elevation model from https://www.usgs.gov/
    elevationData: elevation_data,
    texture: texture,
    bounds: bounds,
  });

  md_update_layer( map_id, 'terrain-'+layer_id, terrainLayer );
  //md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
