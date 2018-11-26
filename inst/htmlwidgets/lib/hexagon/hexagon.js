function add_hexagon_geo( map_id, hexagon_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range ) {

	const hexagonLayer = new deck.HexagonLayer({
        map_id: map_id,
        id: 'hexagon-'+layer_id,
        data: hexagon_data,
        pickable: true,
        extruded: true,
        //elevationRange: [0, 100],
        colorRange: to_rgba( colour_range ),
        elevationScale: elevation_scale,
        radius: radius,
        getPosition: d => get_point_coordinates( d ),
        autoHighlight: auto_highlight,
        highlightColor: hexToRGBA2( highlight_colour ),
        onClick: info => layer_click( map_id, "hexagon", info ),
        onHover: updateTooltip
	});
	update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
}

function add_hexagon_polyline( map_id, hexagon_data, layer_id, radius, elevation_scale, auto_highlight, highlight_colour, colour_range ) {

	const hexagonLayer = new deck.HexagonLayer({
        map_id: map_id,
        id: 'hexagon-'+layer_id,
        data: hexagon_data,
        pickable: true,
        extruded: true,
        //elevationRange: [0, 100],
        colorRange: to_rgba( colour_range ),
        elevationScale: elevation_scale,
        radius: radius,
        getPosition: d => decode_points( d.polyline ),
        autoHighlight: auto_highlight,
        highlightColor: hexToRGBA2( highlight_colour ),
        onClick: info => layer_click( map_id, "hexagon", info ),
        onHover: updateTooltip
	});
	update_layer( map_id, 'hexagon-'+layer_id, hexagonLayer );
}

function clear_hexagon( map_id, layer_id ) {
  clear_layer( map_id, 'hexagon-'+layer_id );
  clear_legend( map_id, layer_id );
}
