function add_contour_geo( map_id, contour_data, layer_id, cell_size ) {

  const contourLayer = new deck.ContourLayer({
    id: 'contour-'+layer_id,
    data: contour_data,
    cellSize: cell_size,
    getPosition: d => d.geometry.geometry.coordinates
  });
  update_layer( map_id, 'contour-'+layer_id, contourLayer );
}

function add_contour_polyline( map_id, contour_data, layer_id, cell_size ) {

  const contourLayer = new deck.ContourLayer({
    map_id: map_id,
    id: 'grid-'+layer_id,
    data: contour_data,
    cellSize: cell_size,
    getPosition: d => decode_polyline( d.polyline )[0]
  });
  update_layer( map_id, 'contour-'+layer_id, contourLayer );
}

function clear_contour( map_id, layer_id ) {
  clear_layer( map_id, 'contour-'+layer_id );
  clear_legend( map_id, layer_id );
}
