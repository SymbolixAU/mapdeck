
function add_cesium( map_id, map_type, tile_data, point_size, layer_id, ion_token ) {

	const tileLayer = new deck.Tile3DLayer({
		map_id: map_id,
		id: 'cesium-'+layer_id,
		data: tile_data,
		pointSize: point_size,
		loader: loaders.CesiumIonLoader,
		loadOptions: {
			tileset: {
				throttleRequests: false,
			},
			'cesium-ion': {accessToken: ion_token}
		},
		onTilesetLoad: (tileset) => {
      // Recenter to cover the tileset
      console.log(tileset);
      /*
      const {cartographicCenter, zoom} = tileset;
      this.setState({
          viewState: {
            ...this.state.viewState,
            longitude: cartographicCenter[0],
            latitude: cartographicCenter[1],
            zoom
          }
      });
      */
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
