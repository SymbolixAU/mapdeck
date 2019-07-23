
var scatterplotFragment = `\
#define SHADER_NAME scatterplot-layer-fragment-shader
precision highp float;
uniform bool filled;
varying vec4 vFillColor;
varying vec4 vLineColor;
varying vec2 unitPosition;
varying float innerUnitRadius;
void main(void) {
  float distToCenter = length(unitPosition);
  if (distToCenter > 1.0) {
    discard;
  }
  if (distToCenter > innerUnitRadius) {
    gl_FragColor = vLineColor;
  } else if (filled) {
    gl_FragColor = vFillColor;
  } else {
    discard;
  }
  gl_FragColor = picking_filterPickingColor(gl_FragColor);
}
`;

var scatterplotVertex = `\
#define SHADER_NAME scatterplot-brushing-ayer-vertex-shader
const float R_EARTH = 6371000.; // earth radius in km
attribute vec3 positions;
attribute vec3 instancePositions;
attribute vec3 instanceTargetPositions;
attribute float instanceRadius;
attribute float instanceLineWidths;
attribute vec4 instanceFillColors;
attribute vec4 instanceLineColors;
attribute vec3 instancePickingColors;
uniform float opacity;
uniform float radiusScale;
uniform float radiusMinPixels;
uniform float radiusMaxPixels;
uniform float lineWidthScale;
uniform float lineWidthMinPixels;
uniform float lineWidthMaxPixels;
uniform float stroked;
uniform bool filled;
// uniform for brushing
uniform vec2 mousePos;
uniform float brushRadius;
uniform bool enableBrushing;
uniform float brushTarget;
varying vec4 vFillColor;
varying vec4 vLineColor;
varying vec2 unitPosition;
varying float innerUnitRadius;
// approximate distance between lng lat in meters
float distanceBetweenLatLng(vec2 source, vec2 target) {
  vec2 delta = (source - target) * PI / 180.;
  float a =
    sin(delta.y / 2.) * sin(delta.y / 2.) +
    cos(source.y * PI / 180.) * cos(target.y * PI / 180.) *
    sin(delta.x / 2.) * sin(delta.x / 2.);
  float c = 2. * atan(sqrt(a), sqrt(1. - a));
  return R_EARTH * c;
}
// range is km
float isPointInRange(vec2 ptLatLng, vec2 mouseLatLng, float range, bool enabled) {
  return float(!enabled || distanceBetweenLatLng(ptLatLng, mouseLatLng) <= range);
}
void main(void) {
  // if enableBrushing is truthy calculate whether instancePosition is in range
  float isPtInBrush = isPointInRange(instancePositions.xy, mousePos, brushRadius, enableBrushing);
  // for use with arc layer, if brushTarget is truthy
  // calculate whether instanceTargetPositions is in range
  float isTargetInBrush = isPointInRange(instanceTargetPositions.xy, mousePos, brushRadius, true);
  // if brushTarget is falsy, when pt is in brush return true
  // if brushTarget is truthy and target is in brush return true
  // if brushTarget is truthy and pt is in brush return false
  float isInBrush = float(float(isPtInBrush > 0. && brushTarget <= 0.) > 0. ||
  float(brushTarget > 0. && isTargetInBrush > 0.) > 0.);
  float finalRadius = mix(0., instanceRadius, isInBrush);
  // Multiply out radius and clamp to limits
  float outerRadiusPixels = clamp(
    project_size(radiusScale * finalRadius),
    radiusMinPixels, radiusMaxPixels
  );

  // multiply out line width and clamp to limits
  float lineWidth = clamp(
    project_size(lineWidthScale * instanceLineWidths),
    lineWidthMinPixels, lineWidthMaxPixels
  );

  // outer radius needs to offset by half stroke width
  outerRadiusPixels += stroked * mix(0., lineWidth, isInBrush) / 2.;
  // position on the containing square in [-1, 1] space
  unitPosition = positions.xy;

  // 0 - solid circle, 1 - stroke with lineWidth=0
  innerUnitRadius = 1. - stroked * lineWidth / outerRadiusPixels;
  // Find the center of the point and add the current vertex
  vec3 center = project_position(instancePositions);
  vec3 vertex = positions * outerRadiusPixels;
  gl_Position = project_common_position_to_clipspace(vec4(center + vertex, 1.));
  // Apply opacity to instance color
  vFillColor = vec4(instanceFillColors.rgb, instanceFillColors.a * opacity) / 255.;
  vLineColor = vec4(instanceLineColors.rgb, instanceLineColors.a * opacity) / 255.;
  // Set picking color
  picking_setPickingColor(instancePickingColors);
}
`;


function add_scatterplot_brush_geo( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, radius_min_pixels, radius_max_pixels, brush_radius ) {


  //var all_points = scatter_data.geometry.geometry.coordinates;
  var all_points = new Array( scatter_data.length );
  for( i = 0; i < scatter_data.length; i++ ) {
  	all_points[i] = scatter_data[i].geometry.geometry.coordinates;
  }
  //console.log( all_points );

	const defaultProps = {
	  ...ScatterplotLayer.defaultProps,
	  enableBrushing: true,
	  // show point only if source is in brush
	  brushTarget: false,
	  // brush radius in meters
	  brushRadius: brush_radius,
	  mousePosition: [0, 0],
	  getTargetPosition: d => d.target,
	  radiusMinPixels: 0
	};

	class ScatterplotBrushingLayer extends ScatterplotLayer {
	  getShaders() {
	    // get customized shaders
	    return Object.assign({}, super.getShaders(), {
	      vs: scatterplotVertex,
	      fs: scatterplotFragment
	    });
	  }

	  // add instanceSourcePositions as attribute
	  // instanceSourcePositions is used to calculate whether
	  // point source is in range when brushTarget is truthy
	  initializeState() {
	    super.initializeState();

	    this.state.attributeManager.addInstanced({
	      instanceTargetPositions: {
	        size: 3,
	        accessor: 'getTargetPosition',
	        update: this.calculateInstanceTargetPositions
	      }
	    });
	  }


	  draw(opts) {
	    // add uniforms
	    const uniforms = Object.assign({}, opts.uniforms, {
	      brushTarget: this.props.brushTarget,
	      brushRadius: this.props.brushRadius,
	      mousePos: this.state.mousePosition
	        ? new Float32Array(this.unproject(this.state.mousePosition))
	        : defaultProps.mousePosition,
	      enableBrushing: Boolean(this.state.enableBrushing)
	    });
	    const newOpts = Object.assign({}, opts, {uniforms});
	    super.draw(newOpts);
	  }

	  // calculate instanceSourcePositions
	  calculateInstanceTargetPositions(attribute) {
	    const {data, getTargetPosition} = this.props;
	    const {value, size} = attribute;
	    let point;
	    for (let i = 0; i < data.length; i++) {
	      point = data[i];
	      const position = getTargetPosition(point) || [0, 0, 0];
	      value[i * size + 0] = position[0];
	      value[i * size + 1] = position[1];
	      value[i * size + 2] = position[2];
	    }
	  }
	}

	ScatterplotBrushingLayer.layerName = 'ScatterplotBrushingLayer';
	ScatterplotBrushingLayer.defaultProps = defaultProps;

  const scatterLayer = new ScatterplotBrushingLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: radius_min_pixels || 1,
    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
    stroked: true,  // TODO( make conditional IFF stroke provided?)
    filled: true,
    parameters: {
	    depthTest: false
	  },
    getRadius: d => d.properties.radius,
    getPosition: d => md_get_point_coordinates( d ),
    getFillColor: d => d.properties.fill_colour,
    getLineColor: d => d.properties.stroke_colour,
    getLineWidth: d => d.properties.stroke_width,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "scatterplot", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {},
    enableBrushing: false,
    brushRadius: brush_radius,
    mousePosition: null
  });

  var scatterbrushEnterListener = function() {
  	scatterLayer.setState({ enableBrushing: true });
  }

  var scatterbrushMoveListener = function(evt) {
	  scatterLayer.setState({ mousePosition: [evt.offsetX, evt.offsetY] });
	  // TODO
	  // capture coordinates, and number of points, and some data about the points
	  // and return to shiny
	  //console.log( scatterLayer.state );
	  //console.log( scatterLayer.state.attributeManager.attributes.instanceTargetPositions.gl );
	  //console.log( isPointInRange );
	  //console.log( scatterLayer.isPointInRange );

	  //var eventInfo = {
	  //	mousePosition: [ evt.offsetX, evt.offsetY ]
	  //}
	  //Shiny.onInputChange(map_id + "_" + layer_id + "_brush", eventInfo);
	  //for( i = 0; i < all_points.length; i++ ) {
	  //	console.log( is_point_in_range( all_points[1], all_points[0], evt.offsetX, evt.offsetY, 10 ) );
	  //}

  }

  var scatterbrushLeaveListener = function(evt) {
    scatterLayer.setState({ mousePosition: null });
    scatterLayer.setState({ enableBrushing: false });
  }

  document.addEventListener('mouseenter', scatterbrushEnterListener, false);
  document.addEventListener('mousemove', scatterbrushMoveListener, false);
  document.addEventListener('mouseleave', scatterbrushLeaveListener, false);

	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'scatterplot-'+layer_id, scatterLayer );
	} else {
	  md_update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend);
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );

}

//https://stackoverflow.com/a/21623206/5977215
function distance_between_coordinates(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;    // Math.PI / 180
  var c = Math.cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;

  return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
}

// range is km
function is_point_in_range(point_lat, point_lon, mouse_lat, mouse_lon, range) {
  return (distance_between_coordinates(point_lat, point_lon, mouse_lat, mouse_lon) <= range);
}








