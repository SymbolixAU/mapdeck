// deckgl example
// https://deck.gl/showcases/gallery/highway

// reference for multiple controls
// https://stackoverflow.com/questions/14853779/adding-input-elements-dynamically-to-form

function md_add_control( map_id, map_type, layer_id, layer ) {

  if( !md_div_exists( 'controlContainer'+map_id ) ) {
  	md_setup_controls( map_id );
  }

  'use strict';

  // TODO
  // add the controls to the container

  var slider_input = document.createElement("input");
  slider_input.setAttribute('type', 'range');
  slider_input.setAttribute('id', 'myRange');
  slider_input.setAttribute('name', 'width');
  slider_input.setAttribute('step', '10');
  slider_input.setAttribute('min', '100');
  slider_input.setAttribute('max', '1000');
  slider_input.setAttribute('value', '100');
  slider_input.on('input', () => {
    myRadius = value;
  });


  var mapbox_ctrl = document.getElementById( "controlContainer"+map_id );
  mapbox_ctrl.appendChild(slider_input);

  /*
  // need to add an observer for the control added
  // querySelector is a css selector
  // so use # for id, and . for class
  let rangeListener = document.querySelector("#myRange");
  rangeListener.addEventListener('input', function(evt) {
    // need to hook this up with the updateTrigger{}
    myRadius = rangeListener.value;

    // need to re-draw the layer when this value changes
    //md_update_layer( map_id, layer_id, layer );
    // https://github.com/uber/deck.gl/issues/2123#issuecomment-407687152
    //add_scatterplot_geo();
  });
  */

}
