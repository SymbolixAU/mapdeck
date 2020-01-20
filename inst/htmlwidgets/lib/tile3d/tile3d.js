
function add_tile3d( map_id, map_type, tile_data, layer_id, ion_token ) {

  console.log( ion_token );

	const tileLayer = new deck.Tile3DLayer({
		map_id: map_id,
		id: 'tile3d-'+layer_id,
		data: tile_data,
		//_ionAssetId: 43978,
		//_ionAccessToken: ion_token,
		pointSize: 2.0,
		opacity: 1.0,
		//onTilesetLoad: (tileset) => {
		//	console.log( "loaded tileset" );
		//	console.log( tileset );
		//	// recenter
			//const {cartographicCenter, zoom} = tileset;
			//this.setState({
			//	viewState: {
			//		...this.state.viewState,
			//		longitude: cartographicCenter[0],
			//		latitude: cartographicCenter[1],
			//		zoom
			//	}
			//});
		//},
		//onTileError: (tileHeader, url, message ) => {
		//	console.log( "load failed" );
		//	console.log( tileHeader );
		//	console.log( url );
		//	console.log( message );
		//}
	});

	console.log( tileLayer );



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
