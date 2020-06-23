
function add_tile3d( map_id, map_type, tile_data, layer_id, ion_token ) {


  const ION_ASSET_ID = 43978;
	const ION_TOKEN =
	  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlYWMxMzcyYy0zZjJkLTQwODctODNlNi01MDRkZmMzMjIxOWIiLCJpZCI6OTYyMCwic2NvcGVzIjpbImFzbCIsImFzciIsImdjIl0sImlhdCI6MTU2Mjg2NjI3M30.1FNiClUyk00YH_nWfSGpiQAjR5V2OvREDq1PJ5QMjWQ';
	const TILESET_URL = `https://assets.cesium.com/${ION_ASSET_ID}/tileset.json`;

  // it's not defined on 'deck'
  console.log( deck.CesiumIonLoader );
  console.log( loaders );
  console.log( loaders.CesiumIonLoader );

  //loaders.registerLoaders([ CesiumIonLoader ]);

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
			'cesium-ion': {accessToken: ION_TOKEN}
		},
		// override scenegraph subLayer prop
    _subLayerProps: {
      scenegraph: {_lighting: 'flat'}
    }
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
