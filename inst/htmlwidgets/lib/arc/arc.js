
var triggerCounter = 0;

function add_arc( map_id, data, layer_id ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/arc-layer
  var elem = -1;

  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,  // TODO
    data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => [d.lon_from, d.lat_from],
    getTargetPosition: d => [d.lon_to, d.lat_to],
    getSourceColor: d => hexToRgb( d.stroke_from ),
    getTargetColor: d => hexToRgb( d.stroke_to ),
    onClick: info => layer_click( map_id, "arc", info ),
    //updateTriggers: {
    //	getStrokeWidth: triggerCounter
    //}
  });

  //window[map_id + 'layers'].push( arcLayer );
  //window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });

  //var elem = -1;
  //elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', 'arc-arc_layer');
  //console.log("elem: " + elem);

  //if (elem === -1) {

  console.log( 'before adding' );
  console.log( window[map_id + 'map'].props.layers );
  console.log( 'arc layer' );
  console.log( arcLayer );

  remove_layer( map_id, layer_id );
  window[map_id + 'layers'].push( arcLayer );

  deckgl.setProps({ layers: window[map_id + 'layers'] });
  //window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });

}

function remove_layer( map_id, layer_id ) {

  var elem = -1;
  var elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', 'arc-arc_layer');

  if ( elem != -1 ) {
    window[map_id + 'map'].props.layers.splice( elem, 1 );
    //window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
  }
}

Shiny.addCustomMessageHandler("handler", triggerButton );

function triggerButton( message ) {
	console.log("triggered counter: " + message );
	triggerCounter = triggerCounter + 1;
	return triggerCounter;
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

  console.log("elem: " + elem);


	//if ( elem ) {
		console.log(" elem found ");
		// TODO(test is this elem is valid/ null/works)
		console.log( "before update: " );
		console.log( window[map_id + 'map'].props.layers[elem].props );
		add_arc( map_id, arc_data, layer_id );
		//window[map_id + 'map'].props.layers[elem].props.data = arc_data;
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
    return -1;
}
