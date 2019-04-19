// following: https://codepen.io/vis-gl/pen/pLLQpN
// and: https://beta.observablehq.com/@pessimistress/deck-gl-geojsonlayer-example
function md_update_tooltip({x, y, object, layer, index}) {
    // object is the data object sent to the layer function

  const tooltip = document.getElementById('mapdecktooltip'+layer.props.map_id);
  var tt;

  //console.log( tooltip );
  //console.log( object );
  //console.log( x, ", ", y );

  if (object) {
  	//if(object.tooltip === undefined && object.properties.tooltip === undefined ) {
  	//	return;
  	//}
  	if ( object.properties.tooltip !== undefined ) {
	  	tt = object.properties.tooltip;
	  } else if ( object.tooltip !== undefined ) {
	  	tt = object.tooltip;
	  } else {
	  	return;
	  }

    tooltip.style.display = 'block';
    tooltip.style.top = `${y}px`;
    tooltip.style.left = `${x}px`;
    tooltip.innerHTML = `<div>${tt}</div>`;
  } else {
  	tooltip.style.display = 'none';
    tooltip.innerHTML = '';
  }
}


function md_initialise_map(el, x) {

	// call initial layers
  if (x.calls !== undefined) {

    for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

      //push the map_id into the call.args
      x.calls[layerCalls].args.unshift(el.id);

      if (window[x.calls[layerCalls].functions]) {

        window[x.calls[layerCalls].functions].apply(window[el.id + 'map'], x.calls[layerCalls].args);

      } else {
        //console.log("Unknown function " + x.calls[layerCalls]);
      }
    }
  }
}


function md_findObjectElementByKey(array, key, value ) {
    for ( var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}






function md_layer_clear( map_id, map_type, layer_id, layer ) {

  if( map_type == "mapdeck" ) {
		md_clear_layer( map_id, layer+'-'+layer_id );
	  md_clear_legend( map_id, layer_id );
	  md_remove_from_bounds( map_id, layer_id );
	  md_update_location( map_id );
  } else if ( map_type == "google_map" ) {
  	md_clear_overlay( map_id, layer+'-'+layer_id );
  }

}



function md_update_layer( map_id, layer_id, layer ) {

  var elem = md_findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id );
  if ( elem != -1 ) {
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}

function md_update_overlay( map_id, layer_id, layer ) {

  if ( window[ map_id + 'layers' ] == null ) {
  	window[ map_id + 'layers' ] = [];
  }

  if ( window[ map_id + 'GoogleMapsOverlay'] == null ) {
  	window[ map_id + 'GoogleMapsOverlay'] = new GoogleMapsOverlay();
  }

	var elem = md_findObjectElementByKey( window[map_id + 'layers'], 'id', layer_id );

  if ( elem != -1 ) {
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }

  window[ map_id + 'GoogleMapsOverlay'].setProps({ layers: [ ...window[map_id + 'layers'] ] });
  const overlay = window[ map_id + 'GoogleMapsOverlay'];
  overlay.setMap( window[map_id + 'map'] );
}


function md_clear_overlay( map_id, layer_id ) {
	var elem = md_findObjectElementByKey( window[map_id + 'layers'], 'id', layer_id );
	if( elem != -1 ) {
		window[ map_id + 'layers'].splice( elem, 1 );
	}

	window[ map_id + 'GoogleMapsOverlay'].setProps({ layers: [ ...window[map_id + 'layers'] ] });
  const overlay = window[ map_id + 'GoogleMapsOverlay'];
  overlay.setMap( window[map_id + 'map'] );

}

function md_clear_layer( map_id, layer_id ) {

  var elem = md_findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id);
  if ( elem != -1 ) {
  	window[ map_id + 'layers'].splice( elem, 1 );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}


function md_layer_click( map_id, layer, info ) {

  if ( !HTMLWidgets.shinyMode ) {
    return;
  }

  var eventInfo = {
  	index: info.index,
  	color: info.color,
  	object: info.object,
  	layerId: info.layer_id,
  	lat: info.lngLat[1],
  	lon: info.lngLat[0]
  };

  eventInfo = JSON.stringify( eventInfo );
  Shiny.onInputChange(map_id + "_" + layer + "_click", eventInfo);
}





