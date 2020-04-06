
function add_mesh( map_id, map_type, polygon_data, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, is_extruded, brush_radius ) {


  	/*
  class MeshLayer extends PolygonLayer({
		calculateFillColors(attribute) {
     // value is a Uint8ClampedArray
     const {value} = attribute;
     const {data, getPolygon} = this.props;

		 let i = 0;
	     for (const object of data) {
	       const polygon = getPolygon(object);

	       //console.log( "const polygon " );
	       //console.log( polygon );

	       // iterate through vertices
	       polygon.forEach(ring => {
	         ring.forEach(vertex => {

	           const color = ...
	           value[i++] = color[0]; // R
	           value[i++] = color[1]; // G
	           value[i++] = color[2]; // B
	           value[i++] = color[3]; // A
	         });
	       });
	     }
  	}
  });

  MeshLayer.layerName = 'MeshLayer';
  */

  //console.log( polygon_data );

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  const meshLayer = new deck.PolygonLayer({
  	map_id: map_id,
    id: 'polygon-'+layer_id,
    data: polygon_data,
    pickable: true,
    stroked: true,
    filled: true,
    wireframe: false,
    extruded: is_extruded,
    lineWidthMinPixels: 0,
    getPolygon: d => md_get_polygon_coordinates( d ),
    // getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    //getLineWidth: d => d.properties.stroke_width,
    getElevation: d => d.properties.elevation,
    lightSettings: light_settings,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onHover: md_update_tooltip,
    onClick: info => md_layer_click( map_id, "mesh", info ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  //console.log( meshLayer );

  if( map_type == "google_map") {
    md_update_overlay( map_id, 'mesh-'+layer_id, meshLayer );
  } else {

	  md_update_layer( map_id, 'mesh-'+layer_id, meshLayer );
  }

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
