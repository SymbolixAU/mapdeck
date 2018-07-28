
var triggerCounter = 0;

function add_arc( map_id, data, layer_id ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/arc-layer
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
  });

//  remove_layer( map_id, layer_id );
  update_layer( map_id, layer_id, arcLayer );
}

function update_layer( map_id, layer_id, layer ) {
	var elem = -1;
  var elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', 'arc-arc_layer');
  if ( elem != -1 ) {
  	console.log( "logging window elem" );
  	console.log( window[ map_id + 'layers'][elem] );
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }
  window[map_id + 'map'].setProps({ layers: window[map_id + 'layers'] });
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

function findObjectElementByKey(array, key, value, layer_data ) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}
