

function add_scatterplot_geo( map_id, scatter_data, layer_id, auto_highlight, highlight_colour, legend ) {

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
    //transitions: {
    //    getRadius: 300
    //}
  });
  update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}

function add_scatterplot_polyline( map_id, scatter_data, layer_id, auto_highlight, highlight_colour, legend ) {
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
    onHover: updateTooltip
  });
  update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}


function clear_scatterplot( map_id, layer_id ) {
  clear_layer( map_id, 'scatterplot-'+layer_id );
  clear_legend( map_id, layer_id );
}
