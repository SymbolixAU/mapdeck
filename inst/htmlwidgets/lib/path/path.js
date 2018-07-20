

function add_path( map_id, path_data, layer_id ) {

  const pathLayer = new PathLayer({
    id: 'path-'+layer_id,  // TODO
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 2,
    getPath: d => decode_polyline( d.polyline ),
    getColor: d => hexToRgb(d.stroke_colour),
    getWidth: d => d.stroke_width,
    //onHover: ({object}) => setTooltip(object.name)  // TODO
    onClick: info => layer_click( map_id, "path", info )
  });

  window[map_id + 'layers'].push(pathLayer);

  console.log( window[map_id + 'layers'] );

  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] } );
}


function clear_path( map_id, layer_id ) {



}

