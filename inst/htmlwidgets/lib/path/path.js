

function add_path( map_id, path_data, layer_id ) {

  const pathLayer = new PathLayer({
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => decode_polyline( d.polyline ),  // needs to be one row per polyline
    getColor: d => hexToRGBA( d.stroke_colour, d.stroke_opacity ),
    getWidth: d => d.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );
}

