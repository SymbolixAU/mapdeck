
function add_trips_geo( map_id, map_type, trips_data, opacity, layer_id, trail_length, start_time, end_time, animation_speed, legend, focus_layer, bbox, update_view ) {



	const defaultProps = {
	  trailLength: {type: 'number', value: 120, min: 0},
	  currentTime: {type: 'number', value: 0, min: 0}
	};

	class TripsLayerElevated extends PathLayer {
	  getShaders() {
	    const shaders = super.getShaders();
	    shaders.inject = {
	      // Timestamp of the vertex
	      'vs:#decl': `\
				uniform float trailLength;
				varying float vTime;
				`,
	      // Remove the z component (timestamp) from position
	      //'vec3 pos = lineJoin(prevPosition, currPosition, nextPosition);': 'pos.z = 0.0;',
	      // Apply a small shift to battle z-fighting
	      'vs:#main-end': `\
				float shiftZ = mod(instanceEndPositions.z, trailLength) * 1e-4;
				gl_Position.z += shiftZ;
				vTime = instanceStartPositions.z + (instanceEndPositions.z - instanceStartPositions.z) * vPathPosition.y / vPathLength;
				//vTime = instanceTimeStart + (instanceTimeEnd - instanceTimeStart) * vPathPosition.y / vPathLength;
				`,
	      'fs:#decl': `\
				uniform float trailLength;
				uniform float currentTime;
				varying float vTime;
				`,
	      // Drop the segments outside of the time window
	      'fs:#main-start': `\
				if(vTime > currentTime || vTime < currentTime - trailLength) {
				  discard;
				}
				`,
	      // Fade the color (currentTime - 100%, end of trail - 0%)
	      'gl_FragColor = vColor;': 'gl_FragColor.a *= 1.0 - (currentTime - vTime) / trailLength;'
	    };
	    return shaders;
	  }

	  initialieState() {
	  	super.initializeState();

	  	this.state.attributeManager.addInstanced({
	  		instanceTimeStart: {size: 1, accessor: 'getTimeStamp'},
	  		instanceTimeEnd: {size: 1, accessor: 'getTimeStamp'}
	  		//instanceElevatedPath: {size: 4, accessor: 'getElevatedPath'}
	  	});
	  }

	  calculateStartTime(attribute) {

	  }

	  calculateEndTime(attribute) {

	  }

	  draw(params) {
	    const {trailLength, currentTime} = this.props;

	    params.uniforms = Object.assign({}, params.uniforms, {
	      trailLength,
	      currentTime
	    });

	    super.draw(params);
	  }
	}

	TripsLayerElevated.layerName = 'TripsLayerElevated';
	TripsLayerElevated.defaultProps = defaultProps;

  var tripsLayer = new TripsLayerElevated({
    id: 'trips-'+layer_id,
    data: trips_data,
    getPath: d => md_trip_coordinates( d.geometry.geometry.coordinates, start_time ),
    getTimeStamp: d => md_trip_coordinates( d.geometry.geometry.coordinates ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
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
	  md_add_legend( map_id, map_type, layer_id, legend );
	}

	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

  animate_trips( map_id, map_type, trips_data, opacity, layer_id, trail_length,
  start_time, end_time, animation_speed, legend );

  //function animate_trips( tripsLayer ) {
function animate_trips( map_id, map_type, trips_data, opacity, layer_id, trail_length, start_time, end_time, animation_speed, legend ) {

  	var loopLength = end_time - start_time; // unit corresponds to the timestamp in source data
    var animationSpeed = animation_speed; // unit time per second

    const timestamp = Date.now() / 1000;
    const loopTime = loopLength / animationSpeed;

    var time = ((timestamp % loopTime) / loopTime) * loopLength;

		var tripsLayer = new TripsLayerElevated({
		    id: 'trips-'+layer_id,
		    data: trips_data,
		    getPath: d => md_trip_coordinates( d.geometry.geometry.coordinates, start_time ),
		    getTimeStamp: d => md_trip_coordinates( d.geometry.geometry.coordinates ),
		    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
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
	   md_add_legend( map_id, map_type, layer_id, legend );
	 }

   window.requestAnimationFrame( function() {
   	  animate_trips( map_id, map_type, trips_data, opacity, layer_id, trail_length,
   	  start_time, end_time, animation_speed, legend );
   });

  }
}

function md_trip_coordinates( coords, start_time ) {
	// TODO( return 3rd or 4th column)
	// because the sf object has either Z and or M
	var res = [];
	var inner = [];
	var x, y, z;
	for( i = 0; i < coords.length; i++ ) {
		inner = coords[i];
		x = inner[0];
		y = inner[1];
		z = inner[3] - start_time; //|| inner[2] - start_time;
		res[i] = [x,y,z];
	}
	//console.log( res );
	return res;
}

function md_trip_elevation( coords ) {
	var res = [];
	var inner = [];
	var z;
	for( i = 0; i < coords.length; i++ ) {
		inner = coords[i];
		x = inner[2];
		res[i] = [x];
	}
	//console.log( res );
	return res;
}
