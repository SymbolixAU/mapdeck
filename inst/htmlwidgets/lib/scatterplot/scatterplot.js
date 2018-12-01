

function add_scatterplot_geo( map_id, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const scatterLayer = new deck.ScatterplotLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: 1,
    getRadius: d => d.properties.radius,
    getPosition: d => get_point_coordinates( d ),
    getColor: d => hexToRGBA2( d.properties.fill_colour ),
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    onClick: info => layer_click( map_id, "scatterplot", info ),
    onHover: updateTooltip,
    transitions: js_transition || {}
  });
  update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_scatterplot_polyline( map_id, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {
  const scatterLayer = new deck.ScatterplotLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: 1,
    getRadius: d => d.radius,
    getPosition: d => decode_points( d.polyline ),
    getColor: d => hexToRGBA2( d.fill_colour ),
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    onClick: info => layer_click( map_id, "scatterplot", info ),
    onHover: updateTooltip,
    transitions: js_transition || {}
  });
  update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
