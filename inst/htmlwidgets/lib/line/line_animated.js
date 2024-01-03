function add_line_animated_geo( map_id, map_type, line_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, brush_radius, animation_speed, trail_length ) {

	var extensions = [];

	if ( brush_radius > 0 ) {
		extensions.push( new deck.BrushingExtension() );
	}

	vsDeclaration = `
	attribute float instanceFrequency;
	varying float vLineLength;
	varying float vFrequency;
	`

	vsMain = `
	vLineLength = distance(source, target);
	vFrequency = instanceFrequency;
	`

	fsDeclaration = `
	uniform float tailLength;
	uniform float timestamp;
	uniform float animationSpeed;

	varying float vLineLength;
	varying float vFrequency;
	`

	fsColorFilter = `
	float tripDuration = vLineLength / animationSpeed;
	float flightInterval = 1.0 / vFrequency;
	float r = mod(geometry.uv.x, flightInterval);

	// Head of the trip (alpha = 1.0)
	float rMax = mod(fract(timestamp / tripDuration), flightInterval);
	// Tail of the trip (alpha = 0.0)
	float rMin = rMax - tailLength / vLineLength;
	// Two consecutive trips can overlap
	float alpha = (r > rMax ? 0.0 : smoothstep(rMin, rMax, r)) + smoothstep(rMin + flightInterval, rMax + flightInterval, r);
	if (alpha == 0.0) {
		discard;
	}
	color.a *= alpha;
	`

	fsColorFilter = `
	float tripDuration = vLineLength / animationSpeed;
	float flightInterval = 1.0 / vFrequency;
	float r = mod(geometry.uv.x, flightInterval);

	// Head of the trip (alpha = 1.0)
	float rMax = mod(fract(timestamp / tripDuration), flightInterval);
	// Tail of the trip (alpha = 0.0)
	float rMin = rMax - tailLength / vLineLength;
	// Two consecutive trips can overlap
	float alpha = (r > rMax ? 0.0 : smoothstep(rMin, rMax, r)) + smoothstep(rMin + flightInterval, rMax + flightInterval, r);
	if (alpha == 0.0) {
		discard;
	}
	color.a *= alpha;
	`

	class AnimatedLineLayer extends deck.LineLayer {

		getShaders() {
			const shaders = super.getShaders();
			shaders.inject = {
				'vs:#decl': vsDeclaration,
				'vs:#main-end': vsMain,
				'fs:#decl': fsDeclaration,
				'fs:DECKGL_FILTER_COLOR': fsColorFilter
			};
			return shaders;
		}

		initializeState(params) {
			super.initializeState(params);

			this.getAttributeManager().addInstanced({
				instanceFrequency: {
					size: 1,
					accessor: 'getFrequency',
					defaultValue: 1
				}
			});
		}

		draw(opts) {
			this.state.model.setUniforms({
				tailLength: this.props.tailLength,
				animationSpeed: this.props.animationSpeed,
				timestamp: (Date.now() / 1000) % 86400
			});
			super.draw(opts);
			// By default, the needsRedraw flag is cleared at each render. We want the layer to continue
			// refreshing.
			this.setNeedsRedraw();
		}
	}


	const defaultProps = {
		// Frequency of the running light
		getFrequency: {type: 'accessor', value: 1},
		// Speed of the running light
		animationSpeed: {type: 'number', min: 0, value: 1},
		// Size of the blob
		tailLength: {type: 'number', min: 0, value: 1}
	};

	AnimatedLineLayer.layerName = 'AnimatedLineLayer';
	AnimatedLineLayer.defaultProps = defaultProps;

	const lineLayer = new AnimatedLineLayer({
  	map_id: map_id,
    id: 'animated_line-'+layer_id,
    data: line_data,
    pickable: true,
    parameters: {
	    depthTest: false
	  },
    getWidth: d => d.properties.stroke_width,
    getSourcePosition: d => md_get_origin_coordinates( d ),
    getTargetPosition: d => md_get_destination_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),

    getFrequency: d => d.properties.frequency, //d.properties.frequency,

    animationSpeed: animation_speed,
    tailLength: trail_length,

    onClick: info => md_layer_click( map_id, "animated_line", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  //console.log( lineLayer );

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'animated_line-'+layer_id, lineLayer );
	} else {
	  md_update_layer( map_id, 'animated_line-'+layer_id, lineLayer );
	}

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
