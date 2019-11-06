
function add_tile3d( map_id, map_type, tile_data, layer_id ) {

	const tileLayer = new Tile3DLayer({

	});

	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'tile3d-'+layer_id, tileLayer );
	} else {
	  md_update_layer( map_id, 'tile3d-'+layer_id, tileLayer );
	}

	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  //md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}
