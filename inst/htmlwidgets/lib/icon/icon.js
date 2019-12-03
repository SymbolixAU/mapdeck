

function add_icon_geo( map_id, map_type, icon_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, size_min_pixels, size_max_pixels, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new BrushingExtension() );
  }

  const iconLayer = new IconLayer({
    map_id: map_id,
    id: 'icon-'+layer_id,
    data: icon_data,
    sizeScale: 1,
    sizeMinPixels: size_min_pixels || 1,
    sizeMaxPixels: size_max_pixels || Number.MAX_SAFE_INTEGER,

    getSize: d => d.properties.size,
    getPosition: d => md_get_point_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getIcon: d => ({
      url: d.properties.icon,
      height: d.properties.icon_height,
      width: d.properties.icon_width,
      anchorX: d.properties.icon_anchorX || d.properties.icon_width / 2,
      anchorY: d.properties.icon_anchorY || d.properties.icon_height / 2
    }),

    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "icon", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'icon-'+layer_id, iconLayer );
	} else {
	  md_update_layer( map_id, 'icon-'+layer_id, iconLayer );
	}

	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
