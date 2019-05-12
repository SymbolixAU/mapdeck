
function add_trips_geo( map_id, trips_data, layer_id, trail_length, start_time, end_time, animation_speed, legend ) {

  var tripsLayer = new TripsLayer({
    id: 'trips-'+layer_id,
    data: trips_data,
    getPath: d => md_trip_coordinates( d.geometry.geometry.coordinates, start_time ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    opacity: 0.3,
    widthMinPixels: 2,
    rounded: true,
    trailLength: trail_length,
    currentTime: 0
  });

  console.log( tripsLayer );

  md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );

/*
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }
*/

  animate_trips( map_id, trips_data, layer_id, trail_length, start_time, end_time, animation_speed );

  //function animate_trips( tripsLayer ) {
function animate_trips( map_id, trips_data, layer_id, trail_length, start_time, end_time, animation_speed ) {

  	var loopLength = end_time - start_time; // unit corresponds to the timestamp in source data
    var animationSpeed = animation_speed; // unit time per second

    const timestamp = Date.now() / 1000;
    const loopTime = loopLength / animationSpeed;

    var time = ((timestamp % loopTime) / loopTime) * loopLength;

		var tripsLayer = new TripsLayer({
		    id: 'trips-'+layer_id,
		    data: trips_data,
		    getPath: d => md_trip_coordinates( d.geometry.geometry.coordinates, start_time ),
		    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
		    opacity: 0.3,
		    widthMinPixels: 2,
		    trailLength: trail_length,
		    rounded: true,
		    currentTime: time
		  });

   md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );

   window.requestAnimationFrame( function() {
   	  animate_trips( map_id, trips_data, layer_id, trail_length, start_time, end_time, animation_speed );
   });

  }
}

function md_trip_coordinates( coords, start_time ) {
	//console.log( coords );
	//return [ coords[0], coords[1], coords[3] ];     // TODO( return 3rd or 4th column)
	// because the sf object has either Z and or M
	var res = [];
	var inner = [];
	var x, y, z;
	for( i = 0; i < coords.length; i++ ) {
		inner = coords[i];
		x = inner[0];
		y = inner[1];
		z = inner[3] - start_time;
		res[i] = [x,y,z];
	}
	return res;
}

