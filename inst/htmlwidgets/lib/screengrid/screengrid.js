function add_screengrid_geo( map_id, screengrid_data, layer_id, opacity, cell_size, colour_range, bbox, update_view, focus_layer ) {

  const screengridLayer = new deck.ScreenGridLayer({
    map_id: map_id,
    id: 'screengrid-'+layer_id,
    data: screengrid_data,
    opacity: opacity,
    cellSizePixels: cell_size,
    colorRange: md_to_rgba( colour_range ),
    getPosition: d => md_get_point_coordinates( d ),
    getWeight: d => d.properties.weight,
    onClick: info => md_layer_click( map_id, "screengrid", info ),
    onHover: md_update_tooltip,
    pickable: true
  });
  md_update_layer( map_id, 'screengrid-'+layer_id, screengridLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_screengrid_polyline( map_id, screengrid_data, layer_id, opacity, cell_size, colour_range, bbox, update_view, focus_layer ) {

  const screengridLayer = new deck.ScreenGridLayer({
    map_id: map_id,
    id: 'screengrid-'+layer_id,
    data: screengrid_data,
    opacity: opacity,
    cellSizePixels: cell_size,
    colorRange: md_to_rgba( colour_range ),
    getPosition: d => md_decode_points( d.polyline ),
    getWeight: d => d.weight,
    onClick: info => md_layer_click( map_id, "screengrid", info ),
    onHover: md_update_tooltip,
    pickable: true
  });
  md_update_layer( map_id, 'screengrid-'+layer_id, screengridLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
