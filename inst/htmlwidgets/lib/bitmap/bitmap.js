

function add_bitmap(map_id, layer_id, image, bounds, desaturate, transparent_colour, tint_colour, bbox, focus_layer, update_view) {

  const bitmapLayer = new deck.BitmapLayer({
  	map_id: map_id,
  	id: "bitmap-"+layer_id,
  	image: image,
  	bounds: bounds,
  	desaturate: desaturate,
  	transparentColor: transparent_colour,
  	tintColor: tint_colour
  });

  md_update_layer( map_id, 'bitmap-'+layer_id, bitmapLayer );
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}
