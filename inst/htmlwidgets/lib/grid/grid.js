
function add_grid( map_id, grid_data, layer_id, cell_size, extruded, elevation_scale ) {

  //console.log( grid_data );

  const gridLayer = new deck.GridLayer({
    id: 'grid-'+layer_id,  // TODO
    data: grid_data,
    pickable: true,
    extruded: extruded,
    cellSize: cell_size,
    elevationScale: elevation_scale,
    getPosition: d => decode_polyline( d.polyline ),
    onClick: info => layer_click( map_id, "grid", info )
  });

  window[map_id + 'layers'].push( gridLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
}
