

function add_scatterplot_geo( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, radius_min_pixels, radius_max_pixels ) {

  //console.log( radius_min_pixels );
  console.log( "map_id" );
  console.log( map_id );
  console.log("map_type");
  console.log( map_type );
  console.log("highlight colour");
  console.log( highlight_colour );
/*
  const scatterLayer = new ScatterplotLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: radius_min_pixels || 1,
    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
    lineWidthMinPixels: 0,
    stroked: true,  // TODO( make conditional IFF stroke provided?)
    filled: true,
    parameters: {
	    depthTest: false
	  },
    getRadius: d => d.properties.radius,
    getPosition: d => md_get_point_coordinates( d ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getLineWidth: d => d.properties.stroke_width,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "scatterplot", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

  console.log("constructed layer");
*/

  // if it's a mapbox map, add a 'gl:' property to the 'deck' object?

  //if( map_type == "mapbox" ) {
  var map = window[ map_id + 'map'];  // mapbox map


/*

  	const deck = new Deck({
  		gl: map.painter.context.gl,
  		layers: [
  			new ScatterplotLayer({
			    map_id: map_id,
			    id: 'scatterplot-'+layer_id,
			    data: scatter_data,
			    radiusScale: 1,
			    radiusMinPixels: radius_min_pixels || 1,
			    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
			    lineWidthMinPixels: 0,
			    stroked: true,  // TODO( make conditional IFF stroke provided?)
			    filled: true,
			    parameters: {
				    depthTest: false
				  },
			    getRadius: d => d.properties.radius,
			    getPosition: d => md_get_point_coordinates( d ),
			    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
			    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
			    getLineWidth: d => d.properties.stroke_width,
			    pickable: true,
			    autoHighlight: auto_highlight,
			    highlightColor: md_hexToRGBA( highlight_colour ),
			    onClick: info => md_layer_click( map_id, "scatterplot", info ),
			    onHover: md_update_tooltip,
			    transitions: js_transition || {}
			  })
  		]
  	});

  	console.log( "deck:" );
  	console.log( deck );

   const ml = new MapboxLayer({id: 'scatterplot-'+layer_id, deck: deck });
   console.log( "ml" );
   console.log( ml );

   //map.addLayer();
  //}
*/

  const scatterLayer = new MapboxLayer({
  	//map_id: map_id,
  	type: ScatterplotLayer,
  	id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: radius_min_pixels || 1,
    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
    lineWidthMinPixels: 0,
    stroked: true,  // TODO( make conditional IFF stroke provided?)
    filled: true,
    parameters: {
	    depthTest: false
	  },
    getRadius: d => d.properties.radius,
    getPosition: d => md_get_point_coordinates( d ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getLineWidth: d => d.properties.stroke_width,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "scatterplot", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}

  });

  map.addLayer( scatterLayer );


/*
	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'scatterplot-'+layer_id, scatterLayer );
	} else {

	  md_update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
	}

	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
 */
}

function add_scatterplot_polyline( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, radius_min_pixels, radius_max_pixels ) {

  const scatterLayer = new ScatterplotLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: radius_min_pixels || 1,
    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
    lineWidthMinPixels: 0,
    stroked: true,
    filled: true,
    parameters: {
	    depthTest: false
	  },
    getRadius: d => d.radius,
    getPosition: d => md_decode_points( d.polyline ),
    getFillColor: d => md_hexToRGBA( d.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.stroke_colour ),
    getLineWidth: d => d.stroke_width,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "scatterplot", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'scatterplot-'+layer_id, scatterLayer );
	} else {
	  md_update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
	}

	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }
  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
