
function add_screengrid( map_id, screengrid_data, layer_id, opacity, cell_size, colour_range ) {
  const screengridLayer = new deck.ScreenGridLayer({
    id: 'screengrid-'+layer_id,
    data: screengrid_data,
    opacity: opacity,
    cellSizePixels: cell_size,
    colorRange: to_rgba( colour_range ),
    getPosition: d => decode_points( d.polyline ),
    getWeight: d => d.weight,
    onClick: info => layer_click( map_id, "screengrid", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'screengrid-'+layer_id, screengridLayer );
}
