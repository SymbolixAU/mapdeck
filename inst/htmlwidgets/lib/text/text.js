
function add_text_geo( map_id, text_data, layer_id ) {

  const textLayer = new TextLayer({
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    getPosition: d => get_point_coordinates( d ),
    getColor: d => hexToRGBA2( d.properties.fill_colour ),
    getText: d => d.properties.text,
    getSize: d => d.properties.size,
    getAngle: d => d.properties.angle,
    getTextAnchor: d => d.properties.anchor,
    getAlignmentBaseline: d => d.properties.alignment_baseline,
    onClick: info => layer_click( map_id, "text", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'text-'+layer_id, textLayer );
}

function add_text_polyline( map_id, text_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const textLayer = new TextLayer({
    map_id: map_id,
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    getPosition: d => decode_points( d.polyline ),
    getColor: d => hexToRGBA2( d.fill_colour ),
    getText: d => d.text,
    getSize: d => d.size,
    getAngle: d => d.angle,
    getTextAnchor: d => d.anchor,
    getAlignmentBaseline: d => d.alignment_baseline,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    onClick: info => layer_click( map_id, "text", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'text-'+layer_id, textLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}

function clear_text( map_id, layer_id ) {
  clear_layer( map_id, 'text-'+layer_id );
  clear_legend( map_id, layer_id );
}
