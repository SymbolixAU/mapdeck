// NOTES
// - Can't have MultiColouredTrips because it adds too many attributes to WebGL


function add_trips_geo( map_id, map_type, path_data, opacity, layer_id,
trail_length, start_time, end_time, animation_speed, width_units, width_scale, width_min_pixels, width_max_pixels ) {
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

   //if (legend !== false) {
	 //  md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	 //}

	 if ( path_data.legend !== false ) {
		  md_add_legend( map_id, map_type, layer_id, path_data.legend, "rgb" );
		}

   window[map_id + 'trip_animation'] = window.requestAnimationFrame( function() {
   	  add_trips_geo( map_id, map_type, path_data, opacity, layer_id,
trail_length, start_time, end_time, animation_speed, width_units, width_scale, width_min_pixels, width_max_pixels );
   });
}


function md_stop_trips(map_id, map_type, layer_id, layer, update_view  ) {
	window.cancelAnimationFrame( window[map_id + 'trip_animation'] );
	md_layer_clear( map_id, map_type, layer_id, layer, update_view );
}



function md_trip_coordinates( coords ) {
	var res = [];
	var inner = [];
	var x, y, z;
	for( i = 0; i < coords.length; i++ ) {
		inner = coords[i];
		x = inner[0];
		y = inner[1];
		z = inner[2] || 0;
		res[i] = [x,y,z];
	}

	return res;
}


function md_trip_timestamp( coords, start_time ) {
	var res = [];
	var inner = [];
	var z;
	for( i = 0; i < coords.length; i++ ) {
		inner = coords[i];
		x = inner[3] - start_time;
		//console.log( x );
		res[i] = [x];
	}
	return res;
}
