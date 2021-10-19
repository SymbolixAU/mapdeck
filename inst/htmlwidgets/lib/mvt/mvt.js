function add_mvt(map_id, map_type, url, layer_id) {

	const mvtLayer = new deck.MVTLayer({
		map_id: map_id,
		data: url
	})

		if( map_type == "google_map") {
	  md_update_overlay( map_id, 'mvt-'+layer_id, mvtLayer );
	} else {
	  md_update_layer( map_id, 'mvt-'+layer_id, mvtLayer );
	}



}
