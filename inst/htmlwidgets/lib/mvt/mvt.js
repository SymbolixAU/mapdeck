function add_mvt(map_id, map_type, url, layer_id) {

	const mvtLayer = new deck.MVTLayer({
		map_id: map_id,
		data: url,

		minZoom: 0,
    maxZoom: 23,
    getLineColor: [192, 192, 192],
    getFillColor: [140, 170, 180],

    getLineWidth: f => {
      switch (f.properties.class) {
        case 'street':
          return 6;
        case 'motorway':
          return 10;
        default:
          return 1;
      }
    },
    lineWidthMinPixels: 1

	})

		if( map_type == "google_map") {
	  md_update_overlay( map_id, 'mvt-'+layer_id, mvtLayer );
	} else {
	  md_update_layer( map_id, 'mvt-'+layer_id, mvtLayer );
	}



}
