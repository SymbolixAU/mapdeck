
function add_text_geo( map_id, text_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const textLayer = new TextLayer({
  	map_id: map_id,
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    getPosition: d => md_get_point_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getText: d => d.properties.text,
    getSize: d => d.properties.size,
    getAngle: d => d.properties.angle,
    getTextAnchor: d => d.properties.anchor,
    getAlignmentBaseline: d => d.properties.alignment_baseline,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "text", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });
  md_update_layer( map_id, 'text-'+layer_id, textLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_text_polyline( map_id, text_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const textLayer = new TextLayer({
    map_id: map_id,
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    getPosition: d => md_decode_points( d.polyline ),
    getColor: d => md_hexToRGBA( d.fill_colour ),
    getText: d => d.text,
    getSize: d => d.size,
    getAngle: d => d.angle,
    getTextAnchor: d => d.anchor,
    getAlignmentBaseline: d => d.alignment_baseline,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "text", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });
  md_update_layer( map_id, 'text-'+layer_id, textLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
