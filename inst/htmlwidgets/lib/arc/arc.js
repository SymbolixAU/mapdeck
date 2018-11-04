
function add_arc( map_id, arc_data, layer_id, auto_highlight, legend ) {

  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRGBA( d.stroke_from, d.stroke_from_opacity ),
    getTargetColor: d => hexToRGBA( d.stroke_to, d.stroke_to_opacity ),
    onClick: info => layer_click( map_id, "arc", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight
  });

  update_layer( map_id, 'arc-'+layer_id, arcLayer );
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }
}

function add_arc_geo( map_id, arc_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.properties.stroke_width,
    getSourcePosition: d => d.geometry.origin.coordinates,
    getTargetPosition: d => d.geometry.destination.coordinates,
    getSourceColor: d => hexToRGBA2( d.properties.stroke_from ),
    getTargetColor: d => hexToRGBA2( d.properties.stroke_to ),
    onClick: info => layer_click( map_id, "arc", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour )
  });

  update_layer( map_id, 'arc-'+layer_id, arcLayer );
  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }
}

function add_arc2( map_id, arc_data, layer_id, auto_highlight, highlight_colour, legend ) {

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