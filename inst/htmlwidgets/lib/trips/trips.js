// NOTES
// - Can't have MultiColouredTrips because it adds too many attributes to WebGL
// - but, the way it works anyway, the colours fade into each other anyway


function add_trips_geo( map_id, map_type, path_data, opacity, layer_id,
trail_length, start_time, end_time, animation_speed, bbox, update_view, focus_layer, width_units, width_scale, width_min_pixels, width_max_pixels ) {

		console.log( bbox );

  	var loopLength = end_time - start_time; // unit corresponds to the timestamp in source data
    var animationSpeed = animation_speed; // unit time per second

    const timestamp = Date.now() / 1000;
    const loopTime = loopLength / animationSpeed;

    var time = ((timestamp % loopTime) / loopTime) * loopLength;

    const binaryLocation = new Float32Array( path_data.data.coordinates );
	  const binaryStartIndices = new Uint32Array( path_data.data.start_indices );
	  const binaryLineColour = new Float32Array( path_data.data.data.stroke_colour );
	  const binaryLineWidth = new Float32Array( path_data.data.data.stroke_width );
	  const binaryTimestamps = new Float32Array( path_data.timestamps );

    let stride = path_data.data.stride[0];
  	let data_count = path_data.data.start_indices.length;

  	var attributes = {
			getPath: {value: binaryLocation, size: stride},
      getColor: {value: binaryLineColour, size: 4},
      getWidth: {value: binaryLineWidth, size: 1},
      getTimestamps: {value: binaryTimestamps, size: 1}
	  };

		const layer = {
		    id: 'trips-'+layer_id,
		    pickable: true,
		    widthScale: width_scale,
		    widthUnits: width_units,
		    widthMinPixels: width_min_pixels || 1,
		    widthMaxPixels: width_max_pixels || Number.MAX_SAFE_INTEGER,
		    rounded: true,
		    parameters: {
			    depthTest: false
			  },
				data: {
		      length: data_count,
		      startIndices: binaryStartIndices,
		      attributes,
		      tooltip: path_data.data.data.tooltip
		    },
		    _pathType: 'open',
		    opacity: opacity,
		    trailLength: trail_length,
		    currentTime: time
		  };

		var tripsLayer = new deck.TripsLayer(layer);

	  if( map_type == "google_map") {
		   md_update_overlay( map_id, 'trips-'+layer_id, tripsLayer );
		} else {
		   md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );
		}

	 if ( path_data.legend !== false ) {
		  md_add_legend( map_id, map_type, layer_id, path_data.legend, "rgb" );
		}

		md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

		// passing 'update_view' and 'focus_layer' to false
   window[map_id + 'trip_animation'] = window.requestAnimationFrame( function() {
   	  add_trips_geo( map_id, map_type, path_data, opacity, layer_id,
trail_length, start_time, end_time, animation_speed, bbox, false, false, width_units, width_scale, width_min_pixels, width_max_pixels );
   });
}


function md_stop_trips(map_id, map_type, layer_id, layer, update_view  ) {
	window.cancelAnimationFrame( window[map_id + 'trip_animation'] );
	md_layer_clear( map_id, map_type, layer_id, layer, update_view );
}

