

function add_path_geo( map_id, path_data, layer_id, auto_highlight, highlight_colour, legend, bbox ) {

  const pathLayer = new PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => get_line_coordinates( d ),
    getColor: d => hexToRGBA2( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
    // transitions: {
    //    getColor: 100,
    //    getWidth: 300
    //}
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );

  if ( legend !== false ) {
      add_legend( map_id, layer_id, legend );
  }

  add_to_bounds( map_id, bbox, layer_id );
  console.log( window[ map_id + 'currentZoomLevel'] );
  // TODO( change location )
  var loc = center_location( window[ map_id + 'globalBox'] );
  console.log("path loc: " );
  console.log( loc );
  change_location( map_id, loc, 0, "linear", window[ map_id + 'currentZoomLevel'] );

}



function add_path_polyline( map_id, path_data, layer_id, auto_highlight, highlight_colour, legend ) {

  const pathLayer = new PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 20,
    widthMinPixels: 1,
    rounded: true,
    getPath: d => decode_polyline( d.polyline ),  // needs to be one row per polyline
    getColor: d => hexToRGBA2( d.stroke_colour ),
    getWidth: d => d.stroke_width,
    onClick: info => layer_click( map_id, "path", info ),
    onHover: updateTooltip,
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour ),
  });
  update_layer( map_id, 'path-'+layer_id, pathLayer );

  if ( legend !== false ) {
      add_legend( map_id, layer_id, legend );
  }
}

function clear_path( map_id, layer_id ) {
  clear_layer( map_id, 'path-'+layer_id );
  clear_legend( map_id, layer_id );
}


/*
// https://playcode.io/166371?tabs=console&script.js&output

var mapdeckBounds = [];
var globalBox

function findObjectElementByKey(array, key, value ) {
    for ( var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}

function add_to_bounds( bbox, layer_id ) {
  var thisBox = {
    id: layer_id,
    bbox: bbox
  }

  var elem = findObjectElementByKey( mapdeckBounds, "id", layer_id);
  //console.log( "elem: " + elem );

  if (elem != -1 ) {
    mapdeckBounds[elem] = thisBox;
  } else {
    mapdeckBounds.push( thisBox );
  }
  //console.log( mapdeckBounds );
}

function remove_from_bounds( layer_id ) {
  var elem = findObjectElementByKey( mapdeckBounds, "id", layer_id );
  if ( elem != -1 ) {
    mapdeckBounds.splice( elem, 1);
  }
  //console.log( mapdeckBounds );
}

function calculate_bounds( mapdeckBounds ) {

  var ymin, xmin, ymax, xmax, thisBox;
  //var gymin = 0, gxmin = 0, gymax = 0, gxmax = 0;
  for( var i = 0; i < mapdeckBounds.length; i++ ) {
    //console.log( mapdeckBounds[i].bbox[0][0]);
    thisBox = mapdeckBounds[i].bbox;
    console.log( thisBox );
    if ( i === 0 ) {
      xmin = thisBox[0][0];
      ymin = thisBox[0][1];
      xmax = thisBox[1][0];
      ymax = thisBox[1][1];
    } else {
      xmin = Math.min( xmin, thisBox[0][0] );
      ymin = Math.min( ymin, thisBox[0][1] );
      xmax = Math.max( xmax, thisBox[1][0] );
      ymax = Math.max( ymax, thisBox[1][1] );
    }
  }
  globalBox = [[xmin, ymin],[xmax,ymax]];
  console.log( "globalBox: " + globalBox );
}

function lon_diff( mapBounds ) {
  xmin = mapBounds[0][0];
  xmax = mapBounds[1][0];
  xdiff = Math.abs( xmax - xmin );
  console.log( "londiff: " + xdiff );
  //return get_zoom_level( xdiff );
  return xdiff;
}

function get_zoom_level( mapdeckBounds ) {

  var londiff = lon_diff( mapdeckBounds );
  console.log( "londiff: " + londiff );

  var zoomLevel = [
    360, 180, 90, 45, 22.5, 11.25, 5.65,2.813, 1.406,
    0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005
  ];

  if ( londiff >= zoomLevel[0] ) {
    return 0;
  }
  var maxIndex = zoomLevel.length - 2;
  var currentValue = zoomLevel[0];
  var i;
  var thisZoom, nextZoom;
  for ( i = 0; i < maxIndex; i++ ) {
    thisZoom = zoomLevel[i];
    nextZoom = zoomLevel[(i+1)];
    console.log( "thisZoom: " + thisZoom );
    console.log( "londiff: " + londiff );
    if ( thisZoom >= londiff && londiff > nextZoom ) {
      return i;
    }
  }
  console.log( "zoom level: " + i );
  return i;

}

//add_to_bounds( [[-1,-1],[2,2]], "thisLayer" );
//add_to_bounds( [[23,-1],[23.5,2]], "anotherLayer" );
//add_to_bounds( [[-3,-1],[2,2]], "anotherLayer" );
//add_to_bounds( [[99,99],[99,99]], "thisLayer" );
add_to_bounds( [[145.5, -37],[145.5, -36.5]], "thisLayer" );
//add_to_bounds( [[145.5, -37],[145.6, -36.5]], "anotherLayer" );

calculate_bounds( mapdeckBounds );
//remove_from_bounds( "thisLayer" );
//calculate_bounds( mapdeckBounds );
//remove_from_bounds( "anotherLayer" );
//var zl = zoom_level( globalBox );
var zoom = get_zoom_level( globalBox );
console.log( "zoom: " + zoom );

*/
