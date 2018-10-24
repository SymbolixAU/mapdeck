function add_hexagon( map_id, hexagon_data, layer_id, radius, elevation_scale, colour_range ) {
    
	const hexagonLayer = new deck.HexagonLayer({
		id: 'hexagon-'+layer_id,
		data: hexagon_data,
    pickable: true,
    extruded: true,
    //elevationRange: [0, 100],
        colorRange: to_rgba( colour_range ),
    elevationScale: elevation_scale,
    radius: radius,
    getPosition: d => decode_polyline( d.polyline )[0],
    //centroid: [0, 52]
    onClick: info => layer_click( map_id, "hexagon", info ),
    onHover: updateTooltip,
	});
	update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
}

function clear_hexagon( map_id, layer_id ) {
  clear_layer( map_id, 'hexagon-'+layer_id );
  clear_legend( map_id, layer_id );
}
