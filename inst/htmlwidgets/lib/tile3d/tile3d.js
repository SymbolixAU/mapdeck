
function add_tile3d( map_id, map_type, tile_data, layer_id, ion_token, ion_asset ) {

	const TILESET_URL = `https://assets.cesium.com/${ion_asset}/tileset.json`;

	const tileLayer = new deck.Tile3DLayer({
		map_id: map_id,
		id: 'tile3d-'+layer_id,
		data: TILESET_URL,
		pointSize: 2,
		loader: loaders.CesiumIonLoader,
		loadOptions: {
			tileset: {
				throttleRequests: false,
			},
			'cesium-ion': {accessToken: ion_token}
		},
		// override scenegraph subLayer prop
    _subLayerProps: {
      scenegraph: {_lighting: 'flat'}
    }
	});


	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'tile3d-'+layer_id, tileLayer );
	} else {
	  md_update_layer( map_id, 'tile3d-'+layer_id, tileLayer );
	}

  /*
	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  */
  //md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}
