function add_arc_geo( map_id, arc_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.properties.stroke_width,
    getSourcePosition: d => get_origin_coordinates( d ),
    getTargetPosition: d => get_destination_coordinates( d ),
    getSourceColor: d => hexToRGBA2( d.properties.stroke_from ),
    getTargetColor: d => hexToRGBA2( d.properties.stroke_to ),
    onClick: info => layer_click( map_id, "arc", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    //transitions: {
    //	getSourceColor: 10000,
    //	getTargetcolor: 10000,
    //	getStrokeWidth: 1000
    //}
  });

  update_layer( map_id, 'arc-'+layer_id, arcLayer );
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }
}

function add_arc_polyline( map_id, arc_data, layer_id, auto_highlight, highlight_colour, legend ) {

    //console.log( arc_data );

  const arcLayer = new ArcLayer({
    map_id: map_id,
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRGBA2( d.stroke_from ),
    getTargetColor: d => hexToRGBA2( d.stroke_to ),
    onClick: info => layer_click( map_id, "arc", info ),
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    onHover: updateTooltip
  });

  update_layer( map_id, 'arc-'+layer_id, arcLayer );
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }
}

function clear_arc( map_id, layer_id ) {
  clear_layer( map_id, 'arc-'+layer_id );
  clear_legend( map_id, layer_id );
}
