

function add_bitmap(map_id, url, layer_id, bounds, desaturate, transparent_colour, tint_colour) {

  console.log( url );
  console.log( bounds );

  const bitmapLayer = new BitmapLayer({
  	map_id: map_id,
  	id: "bitmap-"+layer_id,
  	bitmap: 'https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif',
  	bounds: [
      [-71.516, 37.936],
      [-80.425, 37.936],
      [-80.425, 46.437],
      [-71.516, 46.437]
    ],
  	desaturate: 0,
  	transparentColor: [0,0,0,0],
  	tintColor: [255,255,255]
  });

  console.log( bitmapLayer );

  md_update_layer( map_id, 'bitmap-'+layer_id, bitmapLayer );
  //md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );

}
