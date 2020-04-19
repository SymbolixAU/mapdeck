
function add_terrain(map_id, layer_id, elevation_data, texture, update_view, bounds, bbox, focus_layer ) {

  console.log( layer_id );
  console.log( elevation_data );
  console.log( texture );
  console.log( update_view );
  console.log( bounds );
  console.log( bbox );

  const terrainLayer = new deck.TerrainLayer({
  	id: "terrain-"+layer_id,
  	elevationDecoder: {
      rScaler: 2,
      gScaler: 0,
      bScaler: 0,
      offset: 0
    },
    elevationData: elevation_data,
    texture: texture,
    bounds: bounds,
  });

  md_update_layer( map_id, 'terrain-'+layer_id, terrainLayer );
  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
