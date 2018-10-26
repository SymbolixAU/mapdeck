
function add_path( map_id, path_data, layer_id, auto_highlight, legend ) {

  console.log( path_data );
    
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
    onHover: updateTooltip,
    autoHighlight: auto_highlight
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );
    
  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
}

function add_path2( map_id, path_data, layer_id, auto_highlight, highlight_colour, legend ) {
    
  console.log( path_data );

  const pathLayer = new PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => decode_polyline( d.polyline ),  // needs to be one row per polyline
    getColor: d => hexToRGBA2( d.stroke_colour ),
    getWidth: d => d.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour )
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );
    
  if ( legend !== false ) {
      add_legend( map_id, layer_id, legend );
  }
}

function add_path_geo( map_id, path_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const pathLayer = new PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => d.geometry.coordinates,
    getColor: d => hexToRGBA2( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour )
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );
    
  if ( legend !== false ) {
      add_legend( map_id, layer_id, legend );
  }
}


function clear_path( map_id, layer_id ) {
  clear_layer( map_id, 'path-'+layer_id );
  clear_legend( map_id, layer_id );
}

