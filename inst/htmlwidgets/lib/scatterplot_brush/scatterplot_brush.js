
var fs = `\
uniform bool brushing_enabled;
  varying float brushing_hidden;

  vec4 brushing_filterBrushingColor(vec4 color) {
    if (brushing_enabled && brushing_hidden > 0.5) {
      discard;
    }
    return color;
  }
`;

var vs = `\
const float R_EARTH = 6371000.; // earth radius in km
  uniform bool brushing_enabled;
  uniform vec2 brushing_mousePos;
  uniform float brushing_radius;
  varying float brushing_hidden;
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
  bool brushing_isPointInRange(vec2 position) {
    if (!brushing_enabled) {
      return true;
    }
    return distanceBetweenLatLng(position, brushing_mousePos) <= brushing_radius;
  }
  void brushing_setVisible(bool visible) {
    brushing_hidden = float(!visible);
  }
`;


function add_scatterplot_brush_geo( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, brush_radius ) {

const INITIAL_MODULE_OPTIONS = {};

	const brushingShaderModule = {
	  name: 'brushing',
	  dependencies: ['project'],
	  vs,
	  fs,
	  getUniforms: (opts = INITIAL_MODULE_OPTIONS) => {
	    if (opts.viewport) {
	      return {
	        brushing_enabled: opts.enableBrushing,
	        brushing_radius: opts.brushRadius,
	        brushing_mousePos: opts.mousePosition ? opts.viewport.unproject(opts.mousePosition) : [0, 0]
	      };
	    }
	    return {};
	  }
	};

	const defaultProps = {
	  enableBrushing: true,
	  // show point only if source is in brush
	  brushTarget: false,
	  // brush radius in meters
	  brushRadius: brush_radius,
	  mousePosition: [0, 0],
	  radiusMinPixels: 0
	};

	class ScatterplotBrushingLayer extends ScatterplotLayer {
	  getShaders() {
	    // get customized shaders

      /*
	    const shaders =  Object.assign({}, super.getShaders(), {
	      vs: vs,
	      fs: fs
	    });
	    */

      const shaders = super.getShaders();
	    shaders.modules.push(brushingShaderModule);


	    shaders.inject = {
	    	'vs:#decl': `
					//attribute vec3 instanceTargetPositions;
					//uniform bool brushTarget;
					`,
	      'vs:#main-end': `
				  brushing_setVisible( brushing_isPointInRange(instancePositions.xy) );
				`,
	      'fs:#main-end': `
				 gl_FragColor = brushing_filterBrushingColor( gl_FragColor );
				`
	    };

	    return shaders;
	  }

	  draw(opts) {
	    // add uniforms
	    const uniforms = Object.assign({}, opts.uniforms, {
	      brushTarget: this.props.brushTarget
	      /*
	      brushRadius: this.props.brushRadius,
	      mousePos: this.state.mousePosition
	        ? new Float32Array(this.unproject(this.state.mousePosition))
	        : defaultProps.mousePosition,
	      enableBrushing: Boolean(this.state.enableBrushing)
	      */
	    });
	    const newOpts = Object.assign({}, opts, {uniforms});
	    super.draw(newOpts);
	  }
	}

	ScatterplotBrushingLayer.layerName = 'ScatterplotBrushingLayer';
	ScatterplotBrushingLayer.defaultProps = defaultProps;

  const scatterLayer = new ScatterplotBrushingLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    //radiusMinPixels: 1,
    stroked: true,  // TODO( make conditional IFF stroke provided?)
    filled: true,
    getRadius: d => d.properties.radius,
    getPosition: d => md_get_point_coordinates( d ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
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







