
//https://stackoverflow.com/a/40475362/5977215
function md_colour_domain( x, colour_range, map_id, map_type, layer_id, legend  ) {
	if( legend.legend ) {

		var cd = md_make_legend_range(x[0], x[1], colour_range.length, legend.digits );

		var ledge = {
  	fill_colour: {
  		colour: colour_range,
  		variable: cd,
  		colourType: ["fill_colour"],
  		type: ["gradient"],
  		title: legend.title,        // TODO: the 'colour' argument, or if not supplied simply 'value' ?
  		css: legend.css
  	}
  };
  md_add_legend( map_id, map_type, layer_id, ledge );
	}

}

function md_make_legend_range(startValue, stopValue, cardinality, digits ) {

  var arr = [];
  var currValue = startValue;
  var step = (stopValue - startValue) / (cardinality - 1);
  for (var i = 0; i < cardinality; i++) {
    //arr.push(currValue + (step * i));
    arr.push(parseFloat((currValue + (step * i)).toFixed( digits )));
  }
  return arr;
}


function md_add_legend(map_id, map_type, layer_id, legendValues) {

  if( !md_div_exists( 'legendContainer'+map_id ) ) {
  	md_setup_legend( map_id );
  }

  'use strict';

    var this_legend;
    Object.keys( legendValues ).forEach( function(key) {

        this_legend = legendValues[ key ];

        if ( this_legend.colour !== undefined ) {
            if ( this_legend.type[0] === "category" || this_legend.colour.length == 1 ) {
                md_add_legend_category( map_id, map_type, layer_id, this_legend );
            } else {
                md_add_legend_gradient( map_id, map_type, layer_id, this_legend);
            }
        }
    });

}

function md_add_legend_gradient(map_id, map_type, layer_id, legendValues) {
    // fill gradient
    // numeric values; format numbers according to legendValues.digits

    //console.log( "legend digits" );
    //console.log( legendValues );

    'use strict';
    var legendContent,
        legendTitle,
        tickContainer,
        labelContainer = document.createElement("div"),
        legendColours = document.createElement('div'),
        jsColours = [],
        colours = '',
        i = 0,
        legendTextColour = '#828282',
        style = '',
        isUpdating = false;

    if (window[map_id + 'legend' + layer_id + legendValues.colourType] == null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType] = document.createElement("div");
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('id', map_id + 'legend' + layer_id + legendValues.colourType);
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('class', 'legend');
    }  else {
        isUpdating = true;

        while ( window[map_id + 'legend' + layer_id + legendValues.colourType].hasChildNodes() ) {
            window[map_id + 'legend' + layer_id + legendValues.colourType].removeChild(
            	window[map_id + 'legend' + layer_id + legendValues.colourType].lastChild
            );
        }
    }

    legendContent = document.createElement("div"),
    legendTitle = document.createElement("div"),
    tickContainer = document.createElement("div"),
    labelContainer = document.createElement("div"),
    legendColours = document.createElement('div'),

    legendContent.setAttribute('class', 'legendContent');
    legendTitle.setAttribute('class', 'legendTitle');
    legendTitle.innerHTML = legendValues.title;

    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild( legendTitle );

    tickContainer.setAttribute('class', 'tickContainer');
    labelContainer.setAttribute('class', 'labelContainer');

    if (legendValues.css !== null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('style', legendValues.css);
    }

    for (i = 0; i < legendValues.colour.length; i++) {
      jsColours.push( legendValues.colour[i].substring(0,7) );
    }

    colours = '(' + jsColours.join() + ')';

    style = 'display: inline-block; height: ' + jsColours.length * 20 + 'px; width: 15px;';
    style += 'background: ' + jsColours[1] + ';';
    style += 'background: -webkit-linear-gradient' + colours + ';';
    style += 'background: -o-linear-gradient' + colours + ';';
    style += 'background: -moz-linear-gradient' + colours + ';';
    style += 'background: linear-gradient' + colours + ';';

    legendColours.setAttribute('style', style);
    legendContent.appendChild(legendColours);

    for (i = 0; i < legendValues.colour.length; i++) {

        var legendValue = 'text-align: left; color: ' + legendTextColour + '; font-size: 12px; height: 20px;',
            divTicks = document.createElement('div'),
            divVal = document.createElement('div');

        divTicks.setAttribute('style', legendValue);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', legendValue);
        divVal.innerHTML = legendValues.variable[i];
        labelContainer.appendChild(divVal);
    }

    legendContent.appendChild(tickContainer);
    legendContent.appendChild(labelContainer);

    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendContent);

    if (isUpdating === false) {
        md_placeControl(map_id, map_type, window[map_id + 'legend' + layer_id + legendValues.colourType] );
    }
}

function md_generateColourBox(colourType, colour) {
    'use strict';

    if (colourType[0] === "fill_colour") {
        return ('height: 20px; width: 15px; background: ' + colour);
    } else {
        // http://jsfiddle.net/UES6U/2/
        return ('height: 20px; width: 15px; background: linear-gradient(to bottom, white 25%, ' + colour + ' 25%, ' + colour + ' 45%, ' + 'white 45%)');
    }
}

function md_add_legend_category(map_id, map_type, layer_id, legendValues) {

    'use strict';

    var legendContent,
        legendTitle,
        colourContainer,
        tickContainer,
        labelContainer,
        legendColours,
        colourBox = '',
        //colourAttribute = '',
        i = 0,
        legendTextColour = '#828282',
        isUpdating = false;

    // catch undefined OR null
    // https://stackoverflow.com/questions/2647867/how-to-determine-if-variable-is-undefined-or-null
    if (window[map_id + 'legend' + layer_id + legendValues.colourType] == null) {

        window[map_id + 'legend' + layer_id + legendValues.colourType] = document.createElement("div");
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('id', map_id + 'legend' + layer_id + legendValues.colourType);
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('class', 'legend');

    } else {
        isUpdating = true;

        while (window[map_id + 'legend' + layer_id + legendValues.colourType].hasChildNodes()) {
            window[map_id + 'legend' + layer_id + legendValues.colourType].removeChild(window[map_id + 'legend' + layer_id + legendValues.colourType].lastChild);
        }
    }

    legendContent = document.createElement("div");
    legendTitle = document.createElement("div");
    colourContainer = document.createElement("div");
    tickContainer = document.createElement("div");
    labelContainer = document.createElement("div");
    legendColours = document.createElement('div');

    legendContent.setAttribute('class', 'legendContent');
    legendContent.setAttribute('id', 'legendContentId' + map_id + layer_id);

    legendTitle.setAttribute('class', 'legendTitle');
    legendTitle.innerHTML = legendValues.title;
    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendTitle);

    colourContainer.setAttribute('class', 'labelContainer');
    colourContainer.setAttribute('id', 'colourContainerId' + map_id + layer_id);

    tickContainer.setAttribute('class', 'tickContainer');
    tickContainer.setAttribute('id', 'tickContainerId' + map_id + layer_id);

    labelContainer.setAttribute('class', 'labelContainer');
    labelContainer.setAttribute('id', 'labelContainerId' + map_id + layer_id);

    if (legendValues.css !== null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('style', legendValues.css);
    }

    for (i = 0; i < legendValues.colour.length; i++) {

        var tickVal = 'text-left: center; color: ' + legendTextColour + '; font-size: 12px; height: 20px;',
            divCol = document.createElement('div'),
            divTicks = document.createElement('div'),
            divVal = document.createElement('div');

        //colourBox = 'height: 20px; width: 15px; background: ' + legendValues.legend.colour[i];
        colourBox = md_generateColourBox(legendValues.colourType, legendValues.colour[i].substring(0,7) );
        divCol.setAttribute('style', colourBox);
        colourContainer.appendChild(divCol);

        divTicks.setAttribute('style', tickVal);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', tickVal);
        divVal.innerHTML = legendValues.variable[i];
        labelContainer.appendChild(divVal);
    }

    legendContent.appendChild(colourContainer);
    legendContent.appendChild(tickContainer);
    legendContent.appendChild(labelContainer);

    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendContent);

    if (isUpdating === false) {
        md_placeControl(map_id, map_type, window[map_id + 'legend' + layer_id + legendValues.colourType] );
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

function md_try_remove_legend( map_id, map_type, layer_id, colour_type ) {
	// find reference to this layer in the legends
	var id = map_id + 'legend' + layer_id + colour_type;
	var objIndex = md_find_by_id( window[map_id + 'legendPositions'], id, "index" );

	if( objIndex !== undefined ) {
		md_removeControl( map_id, map_type, id, window[map_id + 'legendPositions'][objIndex].position );
		window[map_id + 'legendPositions'].splice(objIndex, 1);
	  window[id] = null;
	}
}

function md_clear_legend( map_id, map_type, layer_id ) {

	md_try_remove_legend( map_id, map_type, layer_id, "fill_colour");
	md_try_remove_legend( map_id, map_type, layer_id, "stroke_colour");
	md_try_remove_legend( map_id, map_type, layer_id, "stroke_from");
	md_try_remove_legend( map_id, map_type, layer_id, "stroke_to");
}


function md_placeControl( map_id, map_type, object ) {

    var mapbox_ctrl = document.getElementById( "legendContainer"+map_id);
    mapbox_ctrl.appendChild( object );

    var ledge = {};
    var position = "BOTTOM_RIGHT";

    if( map_type == "google_map" ) {
    	window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_LEFT].push( object );
    }

    ledge = {
        id: object.getAttribute('id'),
        position: position
    };

    window[map_id + 'legendPositions'].push( ledge );
}


function md_removeControl( map_id, map_type, legend_id, position ) {

	var element = document.getElementById( legend_id );
	element.parentNode.removeChild( element );

	if( map_type == "google_map") {
	  md_clear_control( window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_LEFT], legend_id );
	}

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

function md_clear_control(control, legend_id) {

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
