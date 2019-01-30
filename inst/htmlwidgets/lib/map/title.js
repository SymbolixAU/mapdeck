function add_title(map_id, layer_id, title) {

    'use strict';
    var title,
        style = '',
        isUpdating = false;

    if (window[map_id + 'mapTitle' + layer_id] == null) {
        window[map_id + 'mapTitle' + layer_id] = document.createElement("div");
        window[map_id + 'mapTitle' + layer_id].setAttribute('id', map_id + 'mapTitle' + layer_id);
        window[map_id + 'mapTitle' + layer_id].setAttribute('class', 'mapTitle');
    }  else {
        isUpdating = true;

        while ( window[map_id + 'mapTitle' + layer_id].hasChildNodes() ) {
            window[map_id + 'mapTitle' + layer_id].removeChild(
            	window[map_id + 'mapTitle' + layer_id].lastChild
            	);
        }
    }

    title = document.createElement("div");
    title.setAttribute('class', 'mapTitle');
    title.innerHTML = title.title;

    window[map_id + 'mapTitle' + layer_id].appendChild( title );

    if (title.css !== null) {
        window[map_id + 'mapTitle' + layer_id].setAttribute('style', title.css);
    }

    if (isUpdating === false) {
        placeControl(map_id, window[map_id + 'mapTitle' + layer_id], title.position);
    }
}

function md_find_by_id( source, id, returnType ) {
    var i = 0;
    for (i = 0; i < source.length; i++) {
        if (source[i].id === id) {
            if (returnType === "object") {
                return source[i];
            } else {
                return i;
            }
        }
    }
    return;
}

function md_clear_title( map_id, layer_id ) {
	// find reference to this layer in the legends
	var id = map_id + 'mapTitle' + layer_id;
	var objIndex = md_find_by_id( window[map_id + 'mapTitle'], id, "index" );

	if( objIndex !== undefined ) {
		md_removeControl( map_id, id, window[map_id + 'mapTitle'][objIndex].position );
		window[map_id + 'mapTitle'].splice(objIndex, 1);
	  window[id] = null;
	}
}


function placeControl( map_id, object, position ) {

    //var mapbox_ctrl = document.getElementsByClassName("mapdeckmap");
    //var mapbox_ctrl = document.getElementsByClassName("legendContainer"+map_id);
    var mapbox_ctrl = document.getElementById( "legendContainer"+map_id);

    //mapbox_ctrl[0].appendChild( object );
    mapbox_ctrl.appendChild( object );
    var ledge = {};
    var position = "BOTTOM_RIGHT";
/*
    switch (position) {
    case 'TOP_LEFT':
        window[map_id + 'map'].controls["TOP_LEFT"].push( object );
        break;
    case 'TOP_RIGHT':
        window[map_id + 'map'].controls["TOP_RIGHT"].push( object );
        break;
    case 'BOTTOM_LEFT':
        window[map_id + 'map'].controls["BOTTOM_LEFT"].push( object );
        break;
    case 'BOTTOM_RIGHT':
        window[map_id + 'map'].controls["BOTTOM_RIGHT"].push( object );
        break;
    default:
        position = "BOTTOM_LEFT"
        window[map_id + 'map'].controls["BOTTOM_LEFT"].push( object );
        break;
    }
*/
    ledge = {
        id: object.getAttribute('id'),
        position: position
    };

    window[map_id + 'legendPositions'].push( ledge );
}


function md_removeControl( map_id, legend_id, position ) {

    var element = document.getElementById( legend_id );
    element.parentNode.removeChild( element );

/*
    switch (position) {
    case 'TOP_LEFT':
        clearControl(window[map_id + 'map'].controls["TOP_LEFT"], legend_id);
        break;
    case 'TOP_RIGHT':
        clearControl(window[map_id + 'map'].controls["TOP_RIGHT"], legend_id);
        break;
    case 'BOTTOM_LEFT':
        clearControl(window[map_id + 'map'].controls["BOTTOM_LEFT"], legend_id);
        break;
    case 'BOTTOM_RIGHT':
        clearControl(window[map_id + 'map'].controls["BOTTOM_RIGHT"], legend_id);
        break;
    default:
        position = "BOTTOM_LEFT";
        clearControl(window[map_id + 'map'].controls["LEFT_BOTTOM"], legend_id);
        break;
    }
*/
}

/*
function clearControl(control, legend_id) {

  if (control !== undefined ) {
    control.forEach(function (item, index) {
      if (item !== undefined ) {
        if (item.getAttribute('id') === legend_id) {
          control.removeAt(index);
        }
      }
    });
  }
}
*/
