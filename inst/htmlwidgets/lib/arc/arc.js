
function add_arc( map_id, arc_data ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/arc-layer

  const arcLayer = new ArcLayer({
    id: 'arc-layer',  // TODO
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => [d.lon_from, d.lat_from],
    getTargetPosition: d => [d.lon_to, d.lat_to],
    getSourceColor: d => hexToRgb( d.stroke_from ),
    getTargetColor: d => hexToRgb( d.stroke_to ),
    //onHover: ({object}) => setTooltip(`${object.from.name} to ${object.to.name}`)
  });

  window[map_id + 'map'].setProps({ layers: [ arcLayer ]} );

}
