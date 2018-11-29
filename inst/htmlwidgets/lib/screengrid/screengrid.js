function add_screengrid_geo( map_id, screengrid_data, layer_id, opacity, cell_size, colour_range, bbox, update_view, focus_layer ) {

  const screengridLayer = new deck.ScreenGridLayer({
    map_id: map_id,
    id: 'screengrid-'+layer_id,
    data: screengrid_data,
    opacity: opacity,
    cellSizePixels: cell_size,
    colorRange: to_rgba( colour_range ),
    getPosition: d => get_point_coordinates( d ),
    getWeight: d => d.properties.weight,
    onClick: info => layer_click( map_id, "screengrid", info ),
    onHover: updateTooltip,
    pickable: true
  });
  update_layer( map_id, 'screengrid-'+layer_id, screengridLayer );
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_screengrid_polyline( map_id, screengrid_data, layer_id, opacity, cell_size, colour_range, bbox, update_view, focus_layer ) {

  const screengridLayer = new deck.ScreenGridLayer({
    map_id: map_id,
    id: 'screengrid-'+layer_id,
    data: screengrid_data,
    opacity: opacity,
    cellSizePixels: cell_size,
    colorRange: to_rgba( colour_range ),
    getPosition: d => decode_points( d.polyline ),
    getWeight: d => d.weight,
    onClick: info => layer_click( map_id, "screengrid", info ),
    onHover: updateTooltip,
    pickable: true
  });
  update_layer( map_id, 'screengrid-'+layer_id, screengridLayer );
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
