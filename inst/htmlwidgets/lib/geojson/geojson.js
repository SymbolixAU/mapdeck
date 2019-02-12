

function add_geojson_sf( map_id, geojson, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  geojson = geojson.features;

  const geojsonLayer = new deck.GeoJsonLayer({
    map_id: map_id,
    id: 'geojson-'+layer_id,
    data: geojson,
    pickable: true,
    stroked: true,
    filled: true,
    extruded: true,
    wireframe: false,
    pointRadiusScale: 1,
    pointRadiusMinPixels: 0.5,
    lineWidthScale: 1,
    lineWidthMinPixels: 1,
    lineJointRounded: true,
    getFillColor: g => md_hexToRGBA( g.properties.fill_colour ),
    getLineColor: g => md_hexToRGBA( g.properties.stroke_colour),
    getRadius: g => g.properties.radius,
    getLineWidth: g => g.properties.stroke_width,
    getElevation: g => g.properties.elevation,
    lightSettings: light_settings,
    onClick: info => md_layer_click( map_id, "geojson", info ),
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

  md_update_layer( map_id, 'geojson-'+layer_id, geojsonLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }

  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_geojson( map_id, geojson, layer_id, light_settings, auto_highlight, highlight_colour, bbox, update_view, focus_layer, js_transition ) {

  const geojsonLayer = new deck.GeoJsonLayer({
    map_id: map_id,
    id: 'geojson-'+layer_id,
    data: geojson,
    pickable: true,
    stroked: true,
    filled: true,
    extruded: true,
    wireframe: false,
    pointRadiusScale: 1,
    pointRadiusMinPixels: 0.5,
    lineWidthScale: 1,
    lineWidthMinPixels: 1,
    lineJointRounded: true,
    getFillColor: g => md_hexToRGBA( geojson_fill_colour( g ) ),
    getLineColor: g => md_hexToRGBA( geojson_line_colour( g ) ),
    getRadius: g => geojson_radius( g ),
    getLineWidth: g => geojson_line_width( g ),
    getElevation: g => geojson_elevation( g ),
    lightSettings: light_settings,
    onClick: info => md_layer_click( map_id, "geojson", info ),
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

  md_update_layer( map_id, 'geojson-'+layer_id, geojsonLayer );
}

function geojson_radius( g ) {
  if (g.properties === undefined) {
    return 10;
  }
  if (g.properties.radius === undefined) {
    return 10;
  }
  return g.properties.radius;
}

function geojson_elevation( g ) {
  if (g.properties === undefined) {
    return 0;
  }
  if (g.properties.elevation === undefined) {
    return 0;
  }
  return g.properties.elevation;
}

function get_fill_colour( p ) {
	switch( true ) {
		case p.fill_colour !== undefined:
			return p.fill_colour;
		case p.fill_color !== undefined:
			return p.fill_color;
		case p.fillColour !== undefined:
			return p.fillColour;
		case p.fillColor !== undefined:
			return p.fillColor;
		case p.fill !== undefined:
			return p.fill;
		default:
		  return "#440154FF";
	}
}

function geojson_fill_colour( g ) {
	switch( true ) {
		case g.properties !== undefined:
			return get_fill_colour( g.properties );
		default:
		  return "#440154FF";
	}
}


function get_line_colour( p ) {
	switch( true ) {
		case p.line_colour !== undefined:
			return p.line_colour;
		case p.line_color !== undefined:
			return p.line_color;
		case p.lineColour !== undefined:
			return p.lineColour;
		case p.lineColor !== undefined:
			return p.lineColor;
		case p.line !== undefined:
			return p.line;
		case p.stroke_colour !== undefined:
			return p.stroke_colour;
		case p.stroke_color !== undefined:
			return p.stroke_color;
		case p.strokeColour !== undefined:
			return p.strokeColour;
		case p.strokeColor !== undefined:
			return p.strokeColor;
		case p.stroke !== undefined:
			return p.stroke;
		default:
		  return "#440154FF";
	}
}

function geojson_line_colour( g ) {
	switch( true ) {
		case g.properties !== undefined:
			return get_line_colour( g.properties );
		default:
		  return "#440154FF";
	}
}


function get_line_width( p ) {
	switch( true ) {
		case p.line_width !== undefined:
			return p.line_width;
		case p.lineWidth !== undefined:
			return p.lineWidth;
		case p.stroke_width !== undefined:
			return p.stroke_width;
		case p.strokeWidth !== undefined:
			return p.strokeWidth;
		case p.width !== undefined:
			return p.width;
		default:
		  return 10;
	}
}

function geojson_line_width( g ) {
	switch( true ) {
		case g.properties !== undefined:
			return get_line_width( g.properties );
		default:
		  return 10;
	}
}
