
function add_trips_geo( map_id, map_type, trips_data, opacity, layer_id,
trail_length, start_time, end_time, animation_speed, legend ) {

  var tripsLayer = new deck.TripsLayer({
    id: 'trips-'+layer_id,
    data: trips_data,
    parameters: {
	    depthTest: false
	  },
    getPath: d => md_trip_coordinates( d.geometry.geometry.coordinates ),
    getTimestamps: d => md_trip_timestamp( d.geometry.geometry.coordinates, start_time ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    opacity: opacity,
    widthMinPixels: 2,
    rounded: true,
    trailLength: trail_length,
    currentTime: 0
  });

  if( map_type == "google_map") {
		  md_update_overlay( map_id, 'trips-'+layer_id, tripsLayer );
	} else {
		  md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );
	}

	if (legend !== false) {
	  md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	}

	//md_layer_view( map_id, map_type, layer_id, true, bbox, true );

  animate_trips( map_id, map_type, trips_data, opacity, layer_id, trail_length, start_time, end_time, animation_speed, legend );

  //function animate_trips( tripsLayer ) {
  function animate_trips( map_id, map_type, trips_data, opacity, layer_id,
trail_length, start_time, end_time, animation_speed, legend) {

  	var loopLength = end_time - start_time; // unit corresponds to the timestamp in source data
    var animationSpeed = animation_speed; // unit time per second

    const timestamp = Date.now() / 1000;
    const loopTime = loopLength / animationSpeed;

    var time = ((timestamp % loopTime) / loopTime) * loopLength;

		var tripsLayer = new deck.TripsLayer({
		    id: 'trips-'+layer_id,
		    data: trips_data,
		    parameters: {
			    depthTest: false
			  },

		    getPath: d => md_trip_coordinates( d.geometry.geometry.coordinates ),
		    getTimestamps: d => md_trip_timestamp( d.geometry.geometry.coordinates, start_time ),
		    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
		    getWidth: d => d.properties.stroke_width,
		    opacity: opacity,
		    widthMinPixels: 2,
		    trailLength: trail_length,
		    rounded: true,
		    currentTime: time
		  });

	  if( map_type == "google_map") {
		   md_update_overlay( map_id, 'trips-'+layer_id, tripsLayer );
		} else {
		   md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );
		}

   if (legend !== false) {
	   md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	 }

   window.requestAnimationFrame( function() {
   	  animate_trips( map_id, map_type, trips_data, opacity, layer_id, trail_length,
   	  start_time, end_time, animation_speed, legend );
   });

  }
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
