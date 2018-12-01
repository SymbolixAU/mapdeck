function add_grid_geo( map_id, grid_data, layer_id, cell_size, extruded, elevation_scale, colour_range, auto_highlight, highlight_colour, bbox, update_view, focus_layer, js_transition ) {

  const gridLayer = new deck.GridLayer({
  	map_id: map_id,
    id: 'grid-'+layer_id,
    data: grid_data,
    pickable: true,
    extruded: extruded,
    cellSize: cell_size,
    colorRange: to_rgba( colour_range ),
    elevationScale: elevation_scale,
    getPosition: d => get_point_coordinates( d ),
    onClick: info => layer_click( map_id, "grid", info ),
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    transitions: js_transition || {}
  });
  update_layer( map_id, 'grid-'+layer_id, gridLayer );
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_grid_polyline( map_id, grid_data, layer_id, cell_size, extruded, elevation_scale, colour_range, auto_highlight, highlight_colour, bbox, update_view, focus_layer, js_transition ) {

  const gridLayer = new deck.GridLayer({
    map_id: map_id,
    id: 'grid-'+layer_id,
    data: grid_data,
    pickable: true,
    extruded: extruded,
    cellSize: cell_size,
    colorRange: to_rgba( colour_range ),
    elevationScale: elevation_scale,
    getPosition: d => decode_polyline( d.polyline )[0],
    onClick: info => layer_click( map_id, "grid", info ),
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    transitions: js_transition || {}
  });
  update_layer( map_id, 'grid-'+layer_id, gridLayer );
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
