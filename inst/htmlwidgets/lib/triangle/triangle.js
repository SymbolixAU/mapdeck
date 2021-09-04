
function add_triangle( map_id, map_type, polygon_data, layer_id, light_settings, auto_highlight, highlight_colour, bbox, update_view, focus_layer, js_transition, is_extruded, elevation_scale, brush_radius ) {

  var extensions = [];

  let hasTooltip = polygon_data.data.data.tooltip !== undefined;
  //console.log("hasTooltip " + hasTooltip);

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

	const binaryLocation = new Float32Array( polygon_data.data.coordinates );
 	const binaryFill = new Float32Array( polygon_data.data.data.fill_colour );
 	const binaryElevation = new Float32Array( polygon_data.data.data.elevation );
 	const binaryStartIndices = new Uint16Array( polygon_data.data.start_indices );

	const stride = polygon_data.data.stride[ 0 ] ;
	const n_points = binaryLocation.length / stride;
	const n_points_per_tri = 3;

	// the number of triangles is the number of pairs of coordinates / stride
	// which is binaryLocation.count / stride / 3;

	const len = n_points / n_points_per_tri;  // the number of triangles

	// the 'indices' attribute is the index where each coordinate being drawn starts

	const binaryIndices = new Uint16Array( binaryLocation.length / stride );
	for( var i = 0; i < binaryLocation.length / stride; i++ ) {
		binaryIndices[i] = i;
	}

	//console.log( binaryIndices );

	var attributes = {
			getPolygon: {value: binaryLocation, size: stride},
    	getFillColor: {value: binaryFill, size: 4},
    	//getElevation: {value: binaryElevation, size: 1}  // Don't use elevation in Triangles because picking is difficult
    	indices: binaryIndices
  };

  const polygonLayer = new deck.SolidPolygonLayer({
  	map_id: map_id,
    id: 'polygon-'+layer_id,
    //data: polygon_data,
    //stroked: true,
    filled: true,
    parameters: {
	    depthTest: true
	  },
    wireframe: true,
    extruded: is_extruded,
    //lineWidthMinPixels: 0,
    elevationScale: elevation_scale,

    data: {
    	length: len,
    	startIndices: binaryStartIndices,
    	attributes,
    	tooltip: polygon_data.data.data.tooltip
    },
    _normalize: false, // skip normalization for ear-cut polygons
    pickable: true,
    autoHighlight: auto_highlight,
    onHover: info => hasTooltip ? md_update_binary_tooltip( info.layer, info.index, info.x, info.y ) : null,

		/*
    getPolygon: d => md_get_polygon_coordinates( d ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineWidth: d => d.properties.stroke_width,
    getElevation: d => d.properties.elevation,
    */


    lightSettings: light_settings,
    //autoHighlight: auto_highlight,
    //highlightColor: md_hexToRGBA( highlight_colour ),
    //highlightColor: md_hexToRGBA( "#AAFFFF80")
    //onHover: md_update_tooltip,
    //onClick: info => md_layer_click( map_id, "polygon", info ),
    transitions: js_transition || {},
    //brushingRadius: brush_radius,
    //extensions: extensions
  });

  if( map_type == "google_map") {
    md_update_overlay( map_id, 'polygon-'+layer_id, polygonLayer );
  } else {

	  md_update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
  }

	if ( polygon_data.legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, polygon_data.legend, "rgb" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function test_hover({x,y,object,layer,index}) {
	//console.log("hovering");
}


