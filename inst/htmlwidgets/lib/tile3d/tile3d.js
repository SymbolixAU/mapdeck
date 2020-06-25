
function add_cesium( map_id, map_type, tile_data, layer_id, ion_token ) {

	const tileLayer = new deck.Tile3DLayer({
		map_id: map_id,
		id: 'cesium-'+layer_id,
		data: tile_data,
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
	  md_update_overlay( map_id, 'cesium-'+layer_id, tileLayer );
	} else {
	  md_update_layer( map_id, 'cesium-'+layer_id, tileLayer );
	}

  /*
	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  */
  //md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}


function add_i3s( map_id, map_type, tile_data, layer_id ) {

	const tileLayer = new deck.Tile3DLayer({
		map_id: map_id,
		id: 'i3s-'+layer_id,
		data: tile_data,
		//pointSize: 2,
		loader: loaders.I3SLoader
	});


	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'i3s-'+layer_id, tileLayer );
	} else {
	  md_update_layer( map_id, 'i3s-'+layer_id, tileLayer );
	}

  /*
	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  */
  //md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}