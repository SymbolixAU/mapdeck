function add_title(map_id, map_type, layer_id, title_data) {

    // test
    'use strict';

  if( !md_div_exists( 'mapTitleContainer'+map_id ) ) {
  	md_setup_title( map_id );

  	if( map_type == "google_map" ) {
  		var mapbox_ctrl = document.getElementById( "mapTitleContainer"+map_id);
    	// if the titleContainer already exists on the element, we don't need to push it to the map
    	window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER].push( mapbox_ctrl );
     }

  }

    var title,
        style = '',
        isUpdating = false;

    if (window[map_id + 'mapTitle' + layer_id] == null) {
        window[map_id + 'mapTitle' + layer_id] = document.createElement("div");
    }
    window[map_id + 'mapTitle' + layer_id].setAttribute('id', map_id + 'mapTitle' + layer_id);
    window[map_id + 'mapTitle' + layer_id].setAttribute('class', 'mapTitle');
    window[map_id + 'mapTitle' + layer_id].innerHTML = title_data.title;


    if (title_data.css !== null) {
        window[map_id + 'mapTitle' + layer_id].setAttribute('style', title_data.css);
    }

    if (isUpdating === false) {
        md_placeTitle(map_id, map_type, window[map_id + 'mapTitle' + layer_id], title_data.position);
    }
}


function clear_title( map_id, map_type, layer_id ) {
	/*
	// find reference to this layer in the legends
	var id = map_id + 'mapTitle' + layer_id;
	var objIndex = md_find_by_id( window[map_id + 'mapTitle'], id, "index" );

	if( objIndex !== undefined ) {
		md_removeControl( map_id, id, window[map_id + 'mapTitle' + layer_id][objIndex].position );
		window[map_id + 'mapTitle' + layer_id].splice(objIndex, 1);
	  window[id] = null;
	}
	*/
  console.log( "clering title element" );

	var element = document.getElementById( map_id + 'mapTitle' + layer_id );
	console.log( element );

	if( element !== null ) {
	  element.parentNode.removeChild( element );
	}


	if( map_type == "google_map") {
	  md_clear_title_control( window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER], layer_id );
	}
}


function md_placeTitle( map_id, map_type, object, position ) {

    var mapbox_ctrl = document.getElementById( "mapTitleContainer"+map_id);
    mapbox_ctrl.appendChild( object );

/*
    console.log("md_placeTitle");
    console.log(map_type);
    console.log(mapbox_ctrl);
*/

/*
    if( map_type == "google_map" ) {
    	// if the titleContainer already exists on the element, we don't need to push it to the map
    	window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER].push( mapbox_ctrl );
    }
*?

/*
    var title = {};
    var position = "TOP_LEFT";

    title = {
        id: object.getAttribute('id'),
        position: position
    };

    window[map_id + 'mapTitlePositions'].push( title );
*/
}


function md_clear_title_control(control, layer_id) {

  console.log("clearing title control");
  console.log( control );

  if (control !== undefined ) {
    control.forEach(function (item, index) {
      if (item !== undefined ) {
        if (item.getAttribute('id') === layer_id) {
        	console.log( "removing control at index: " + index);
          control.removeAt(index);
        }
      }
    });
  }
}
