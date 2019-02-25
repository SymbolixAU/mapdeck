function add_contour_geo( map_id, contour_data, layer_id, cell_size ) {

  const contourLayer = new deck.ContourLayer({
    id: 'contour-'+layer_id,
    data: contour_data,
    cellSize: cell_size,
    contours: [
    	{threshold: [1], color: [255, 0, 0, 255] }
      //{threshold: [10], color: [0, 255, 0, 255] }
    	//{threshold: [6], color: [0, 0, 255, 128] }
    ],
    getPosition: d => d.geometry.geometry.coordinates
  });
  md_update_layer( map_id, 'contour-'+layer_id, contourLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function add_contour_polyline( map_id, contour_data, layer_id, cell_size ) {

  const contourLayer = new deck.ContourLayer({
    map_id: map_id,
    id: 'grid-'+layer_id,
    data: contour_data,
    cellSize: cell_size,
    getPosition: d => decode_polyline( d.polyline )[0]
  });
  md_update_layer( map_id, 'contour-'+layer_id, contourLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

