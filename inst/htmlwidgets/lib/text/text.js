

function add_text( map_id, text_data, layer_id ) {
  const textLayer = new TextLayer({
    id: 'text-'+layer_id,
    data: text_data,
    pickable: true,
    getPosition: d => decode_points( d.polyline ),
    getColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
    getText: d => d.text,
    getSize: d => d.size,
    getAngle: d => d.angle,
    getTextAnchor: d => d.anchor,
    getAlignmentBaseline: d => d.alignment_baseline,
    onClick: info => layer_click( map_id, "text", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'text-'+layer_id, textLayer );
}
