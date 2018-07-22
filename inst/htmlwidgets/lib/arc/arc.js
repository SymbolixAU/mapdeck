
function add_arc( map_id, arc_data, layer_id ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/arc-layer

  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,  // TODO
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => [d.lon_from, d.lat_from],
    getTargetPosition: d => [d.lon_to, d.lat_to],
    getSourceColor: d => hexToRgb( d.stroke_from ),
    getTargetColor: d => hexToRgb( d.stroke_to ),
    //onHover: ({object}) => setTooltip(`${object.from.name} to ${object.to.name}`)
    //onHover: info => console.log('Hovered:', info),
    //onClick: info => console.log('Clicked:', info)
    onClick: info => layer_click( map_id, "arc", info ),
    //updateTriggers: {
    //	getSourceColor:
    //}
  });

  window[map_id + 'layers'].push( arcLayer );
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });

}

function update_arc( map_id, arc_data, layer_id ) {
/*
	if ( !arcLayer ) {
		return;
	}
*/

	//arcLayer.props.getSourceColor = [255, 255, 255];
	//window[map_id + 'layers'][ 'arc-'+layer_id] = arcLayer;

	console.log(" arc layer: ");
	console.log( window[map_id + 'map'].props );

	var elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', 'arc-arc_layer');

	//if ( elem ) {
		console.log(" elem found ");
		// TODO(test is this elem is valid/ null/works)
		console.log( "before update: " );
		console.log( window[map_id + 'map'].props.layers[elem].props );
		window[map_id + 'map'].props.layers[elem].props.data = arc_data;
		console.log( "after update: " );
		console.log( window[map_id + 'map'].props.layers[elem].props );
	//}
	//window[map_id + 'map'].setProps({ layers: window[map_id + 'layers']['arc-'+layer_id] });
}


function updateLayerData(  ) {

}

function findObjectElementByKey(array, key, value, layer_data ) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return null;
}
