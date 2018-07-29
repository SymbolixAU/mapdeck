
function add_line( map_id, line_data, layer_id ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/line-layer
  const lineLayer = new LineLayer({
    id: 'line-'+layer_id,  // TODO
    data: line_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getColor: d => hexToRgb( d.stroke_colour ),
    onClick: info => layer_click( map_id, "line", info ),
  });

  window[map_id + 'layers'].push( lineLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });

}
