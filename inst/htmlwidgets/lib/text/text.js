

function add_text( map_id, text_data, layer_id ) {

  console.log(text_data);
		const textLayer = new TextLayer({
			id: 'text-'+layer_id,  // TODO
			data: text_data,
			pickable: true,
			getPosition: d => decode_points( d.polyline ),
			getColor: d => hexToRGBA( d.fill_colour, d.fill_opacity ),
			getText: d => d.text,
			getSize: d => d.size,
			getAngle: d => d.angle,
			getTextAnchor: d => d.anchor,
			getAlignmentBaseline: d => d.alignment_baseline,
			onClick: info => layer_click( map_id, "text", info ),
			//onHover: ({object}) => setTooltip(`${object.origin} to ${object.destination}`)
		});

		update_layer( map_id, 'text-'+layer_id, textLayer );
}
