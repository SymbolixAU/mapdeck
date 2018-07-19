

function add_path( map_id, path_data ) {

  console.log( path_data );

  const pathLayer = new PathLayer({
    id: 'path-layer',  // TODO
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 2,
    getPath: d => decode_polyline( d.polyline ),
    getColor: d => hexToRgb(d.stroke_colour),
    getWidth: d => d.stroke_width,
    //onHover: ({object}) => setTooltip(object.name)  // TODO
  });

  window[map_id + 'map'].setProps({ layers: [ pathLayer ]} );

}
