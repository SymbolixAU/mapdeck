function add_view_state( map_id, viewState ) {
	'use strict';

  //console.log( "add_view_state" );

	if( !md_div_exists( 'mapViewStateContainer'+map_id) ) {
		md_setup_view_state( map_id );
	}

  var vs = JSON.stringify( viewState );
  //window[map_id + 'mapViewState'].innerHTML = vs;

	 var title,
        style = '',
        isUpdating = false;

    if (window[map_id + 'mapViewState'] == null) {
        window[map_id + 'mapViewState'] = document.createElement("div");
    }
    window[map_id + 'mapViewState'].setAttribute('id', map_id + 'mapViewState');
    window[map_id + 'mapViewState'].setAttribute('class', 'mapViewState');
    //window[map_id + 'mapViewState'].innerHTML = vs;

    if (isUpdating === false) {
        md_placeViewState(map_id, window[map_id + 'mapViewState'] );
    }

}

function md_placeViewState( map_id, object ) {

    var mapbox_ctrl = document.getElementById( "mapViewStateContainer"+map_id);
    mapbox_ctrl.appendChild( object );
}


function clear_view_state( map_id ) {

	var element = document.getElementById( map_id + 'mapViewState' );

	if( element !== null ) {
	  element.parentNode.removeChild( element );
	}

}

