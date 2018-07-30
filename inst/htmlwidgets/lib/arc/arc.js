
var triggerCounter = 0;

function add_arc( map_id, arc_data, layer_id ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/arc-layer
  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,  // TODO
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRgb( d.stroke_from ),
    getTargetColor: d => hexToRgb( d.stroke_to ),
    onClick: info => layer_click( map_id, "arc", info ),
  });

  update_layer( map_id, 'arc-'+layer_id, arcLayer );
}
