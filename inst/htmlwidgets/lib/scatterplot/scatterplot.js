
function add_scatterplot( map_id, scatter_data, layer_id ) {
  const scatterLayer = new deck.ScatterplotLayer({
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: 1,
    getRadius: d => d.radius,
    getPosition: d => decode_points( d.polyline ),
    getColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
    //onClick: info => layer_click( map_id, "scatterplot", info ),
    //onHover: updateTooltip
  });
  update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
}
