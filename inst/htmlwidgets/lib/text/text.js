
function add_text_geo( map_id, map_type, text_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, font_family, font_weight, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const textLayer = new deck.TextLayer({
  	map_id: map_id,
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    parameters: {
	    depthTest: false
	  },

    getPosition: d => md_get_point_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getText: d => d.properties.text,
    getSize: d => d.properties.size,
    getAngle: d => d.properties.angle,
    getTextAnchor: d => d.properties.anchor,
    getAlignmentBaseline: d => d.properties.alignment_baseline,

    billboard: billboard,
    fontFamily: font_family,
    fontWeight: font_weight,

    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "text", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'text-'+layer_id, textLayer );
	} else {

	  md_update_layer( map_id, 'text-'+layer_id, textLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_text_polyline( map_id, map_type, text_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, font_family, font_weight, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const textLayer = new deck.TextLayer({
    map_id: map_id,
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    parameters: {
	    depthTest: false
	  },

    getPosition: d => md_decode_points( d.polyline ),
    getColor: d => md_hexToRGBA( d.fill_colour ),
    getText: d => d.text,
    getSize: d => d.size,
    getAngle: d => d.angle,
    getTextAnchor: d => d.anchor,
    getAlignmentBaseline: d => d.alignment_baseline,

    billboard: billboard,
    fontFamily: font_family,
    fontWeight: font_weight,

    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "text", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'text-'+layer_id, textLayer );
	} else {
	  md_update_layer( map_id, 'text-'+layer_id, textLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
