
/*
var tripsFragment =  `\
#define SHADER_NAME trips-layer-fragment-shader
precision highp float;
varying float vTime;
varying vec4 vColor;
void main(void) {
  if (vTime > 1.0 || vTime < 0.0) {
    discard;
  }
  gl_FragColor = vec4(vColor.rgb, vColor.a * vTime);
}
`;

var tripsVertex = `\
#define SHADER_NAME trips-layer-vertex-shader
attribute vec3 positions;
attribute vec3 colors;
uniform float opacity;
uniform float currentTime;
uniform float trailLength;
varying float vTime;
varying vec4 vColor;
void main(void) {
  vec2 p = project_position(positions.xy);
  // the magic de-flickering factor
  vec4 shift = vec4(0., 0., mod(positions.z, trailLength) * 1e-4, 0.);
  gl_Position = project_to_clipspace(vec4(p, 1., 1.)) + shift;
  vColor = vec4(colors / 255.0, opacity);
  vTime = 1.0 - (currentTime - positions.z) / trailLength;
}
`;

function add_trips_geo( map_id, trips_data, layer_id, trail_length, loop_length, animation_speed, legend ) {

  const defaultProps = {
	  trailLength: {type: 'number', value: trail_length, min: 0},
	  currentTime: {type: 'number', value: 0, min: 0},
	  getPath: {type: 'accessor', value: d => d.geometry.geometry.coordinates},
	  getColor: {type: 'accessor', value: d => md_hexToRGBA( d.properties.stroke_colour )}
	};

	class TripsLayer extends Layer {
	  initializeState() {
	    const {gl} = this.context;
	    const attributeManager = this.getAttributeManager();

	    const model = this.getModel(gl);

	    attributeManager.add({
	      indices: {size: 1, update: this.calculateIndices, isIndexed: true},
	      positions: {size: 3, update: this.calculatePositions},
	      colors: {size: 3, accessor: 'getColor', update: this.calculateColors}
	    });

	    //console.log( attributeManager );

	    gl.getExtension('OES_element_index_uint');
	    this.setState({model});
	  }

	  updateState({props, changeFlags: {dataChanged}}) {
	    if (dataChanged) {
	      this.countVertices(props.data);
	      this.state.attributeManager.invalidateAll();
	    }
	  }

	  getModel(gl) {
	    return new luma.Model(gl, {
	      id: this.props.id,
	      vs: tripsVertex,
	      fs: tripsFragment,
	      geometry: new luma.Geometry({
	        id: this.props.id,
	        drawMode: gl.LINES
	      }),
	      vertexCount: 0,
	      isIndexed: true,
	      // TODO-state-management: onBeforeRender can go to settings, onAfterRender, we should
	      // move this settings of corresponding draw.
	      onBeforeRender: () => {
	        gl.enable(gl.BLEND);
	        gl.enable(gl.POLYGON_OFFSET_FILL);
	        gl.polygonOffset(2.0, 1.0);
	        gl.blendFunc(gl.SRC_ALPHA, gl.ONE);
	        gl.blendEquation(gl.FUNC_ADD);
	      },
	      onAfterRender: () => {
	        gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
	        gl.disable(gl.POLYGON_OFFSET_FILL);
	      }
	    });
	  }

	  countVertices(data) {
	    if (!data) {
	      return;
	    }

	    const {getPath} = this.props;
	    let vertexCount = 0;
	    const pathLengths = data.reduce((acc, d) => {
	      const l = getPath(d).length;
	      vertexCount += l;
	      return [...acc, l];
	    }, []);
	    this.setState({pathLengths, vertexCount});
	  }

	  draw({uniforms}) {
	    const {trailLength, currentTime} = this.props;
	    this.state.model.render(
	      Object.assign({}, uniforms, {
	        trailLength,
	        currentTime
	      })
	    );
	  }

	  calculateIndices(attribute) {
	    const {pathLengths, vertexCount} = this.state;

	    const indicesCount = (vertexCount - pathLengths.length) * 2;
	    const indices = new Uint32Array(indicesCount);

	    let offset = 0;
	    let index = 0;
	    for (let i = 0; i < pathLengths.length; i++) {
	      const l = pathLengths[i];
	      indices[index++] = offset;
	      for (let j = 1; j < l - 1; j++) {
	        indices[index++] = j + offset;
	        indices[index++] = j + offset;
	      }
	      indices[index++] = offset + l - 1;
	      offset += l;
	    }
	    attribute.value = indices;
	    this.state.model.setVertexCount(indicesCount);
	  }

	  calculatePositions(attribute) {
	    const {data, getPath} = this.props;
	    const {vertexCount} = this.state;
	    const positions = new Float32Array(vertexCount * 3);

	    let index = 0;
	    for (let i = 0; i < data.length; i++) {
	      const path = getPath(data[i]);
	      for (let j = 0; j < path.length; j++) {
	        const pt = path[j];
	        positions[index++] = pt[0];
	        positions[index++] = pt[1];
	        positions[index++] = pt[2];
	      }
	    }
	    attribute.value = positions;
	  }

	  calculateColors(attribute) {
	    const {data, getColor} = this.props;
	    const {pathLengths, vertexCount} = this.state;
	    const colors = new Float32Array(vertexCount * 3);

	    let index = 0;
	    for (let i = 0; i < data.length; i++) {
	      const color = getColor(data[i]);
	      const l = pathLengths[i];
	      for (let j = 0; j < l; j++) {
	        colors[index++] = color[0];
	        colors[index++] = color[1];
	        colors[index++] = color[2];
	      }
	    }
	    attribute.value = colors;
	  }
	}

	TripsLayer.layerName = 'TripsLayer';
	TripsLayer.defaultProps = defaultProps;
*/


var pathVertex = `\
#define SHADER_NAME path-layer-vertex-shader-64
attribute vec4 positions;
attribute vec4 instanceStartPositions;
attribute vec4 instanceEndPositions;
attribute vec4 instanceStartEndPositions64xyLow;
attribute vec4 instanceLeftDeltas;
attribute vec4 instanceRightDeltas;
attribute float instanceStrokeWidths;
attribute vec4 instanceColors;
attribute vec3 instancePickingColors;
attribute vec2 instanceDashArrays;
uniform float widthScale;
uniform float widthMinPixels;
uniform float widthMaxPixels;
uniform float jointType;
uniform float miterLimit;
uniform float opacity;
varying vec4 vColor;
varying vec2 vCornerOffset;
varying float vMiterLength;
varying vec2 vDashArray;
varying vec2 vPathPosition;
varying float vPathLength;
const float EPSILON = 0.001;
float flipIfTrue(bool flag) {
  return -(float(flag) * 2. - 1.);
}
// calculate line join positions
vec4 lineJoin(
  vec4 prevPoint, vec4 currPoint, vec4 nextPoint,
  float relativePosition, bool isEnd, bool isJoint,
  float width
) {
  vec2 deltaA = currPoint.xy - prevPoint.xy;
  vec2 deltaB = nextPoint.xy - currPoint.xy;
  float lenA = length(deltaA);
  float lenB = length(deltaB);
  // when two points are closer than PIXEL_EPSILON in pixels,
  // assume they are the same point to avoid precision issue
  lenA = lenA / width > EPSILON ? lenA : 0.0;
  lenB = lenB / width > EPSILON ? lenB : 0.0;
  vec2 dirA = lenA > 0. ? normalize(deltaA) : vec2(0.0, 0.0);
  vec2 dirB = lenB > 0. ? normalize(deltaB) : vec2(0.0, 0.0);
  vec2 perpA = vec2(-dirA.y, dirA.x);
  vec2 perpB = vec2(-dirB.y, dirB.x);
  // tangent of the corner
  vec2 tangent = vec2(dirA + dirB);
  tangent = length(tangent) > 0. ? normalize(tangent) : perpA;
  // direction of the corner
  vec2 miterVec = vec2(-tangent.y, tangent.x);
  // width offset from current position
  vec2 perp = isEnd ? perpA : perpB;
  float L = isEnd ? lenA : lenB;
  // cap super sharp angles
  float sinHalfA = abs(dot(miterVec, perp));
  float cosHalfA = abs(dot(dirA, miterVec));
  bool turnsRight = dirA.x * dirB.y > dirA.y * dirB.x;
  float offsetScale = 1.0 / max(sinHalfA, EPSILON);
  float cornerPosition = isJoint ?
    0.0 :
    flipIfTrue(turnsRight == (relativePosition > 0.0));
  // do not bevel if line segment is too short
  cornerPosition *=
    float(cornerPosition <= 0.0 || sinHalfA < min(lenA, lenB) / width * cosHalfA);
  // trim if inside corner extends further than the line segment
  if (cornerPosition < 0.0) {
    offsetScale = min(offsetScale, L / width / max(cosHalfA, EPSILON));
  }
  vMiterLength = cornerPosition >= 0.0 ?
    mix(offsetScale, 0.0, cornerPosition) :
    offsetScale * cornerPosition;
  vMiterLength -= sinHalfA * jointType;
  float offsetDirection = mix(
    positions.y,
    mix(
      flipIfTrue(turnsRight),
      positions.y * flipIfTrue(turnsRight == (positions.x == 1.)),
      cornerPosition
    ),
    step(0.0, cornerPosition)
  );
  vec2 offsetVec = mix(miterVec, -tangent, step(0.5, cornerPosition));
  offsetScale = mix(offsetScale, 1.0 / max(cosHalfA, 0.001), step(0.5, cornerPosition));
  // special treatment for start cap and end cap
  // TODO - This has an issue. len is always positive because it is length.
  // Step returns zero if -lenA<0, so practically this is a comparison of
  // lenA with zero, with lots of problems because of the -lenA. Can we use EPSILON?
  bool isStartCap = step(0.0, -lenA) > 0.5;
  bool isEndCap = step(0.0, -lenB) > 0.5;
  bool isCap = isStartCap || isEndCap;
  // 0: center, 1: side
  cornerPosition = isCap ? (1.0 - positions.z) : 0.;
  // start of path: use next - curr
  if (isStartCap) {
    offsetVec = mix(dirB, perpB, cornerPosition);
  }
  // end of path: use curr - prev
  if (isEndCap) {
    offsetVec = mix(dirA, perpA, cornerPosition);
  }
  // extend out a triangle to envelope the round cap
  if (isCap) {
    offsetScale = mix(4.0 * jointType, 1.0, cornerPosition);
    vMiterLength = 1.0 - cornerPosition;
    offsetDirection = mix(flipIfTrue(isStartCap), positions.y, cornerPosition);
  }
  vCornerOffset = offsetVec * offsetDirection * offsetScale;
  // Generate variables for dash calculation
  vDashArray = instanceDashArrays;
  vPathLength = L / width;
  // vec2 offsetFromStartOfPath = isEnd ? vCornerOffset + deltaA / width : vCornerOffset;
  vec2 offsetFromStartOfPath = vCornerOffset;
  if (isEnd) {
    offsetFromStartOfPath += deltaA / width;
  }
  vec2 dir = isEnd ? dirA : dirB;
  vPathPosition = vec2(
    positions.y + positions.z * offsetDirection,
    dot(offsetFromStartOfPath, dir)
  );
  return currPoint + vec4(vCornerOffset * width, 0.0, 0.0);
}
// calculate line join positions
// extract params from attributes and uniforms
vec4 lineJoin(vec4 prevPoint, vec4 currPoint, vec4 nextPoint) {
  // relative position to the corner:
  // -1: inside (smaller side of the angle)
  // 0: center
  // 1: outside (bigger side of the angle)
  float relativePosition = positions.y;
  bool isEnd = positions.x > EPSILON;
  bool isJoint = positions.z > EPSILON;
  float width = clamp(project_scale(instanceStrokeWidths * widthScale),
    widthMinPixels, widthMaxPixels) / 2.0;
  return lineJoin(
    prevPoint, currPoint, nextPoint,
    relativePosition, isEnd, isJoint,
    width
  );
}
void main() {
  vColor = vec4(instanceColors.rgb, instanceColors.a * opacity) / 255.;
  // Set color to be rendered to picking fbo (also used to check for selection highlight).
  picking_setPickingColor(instancePickingColors);
  float isEnd = positions.x;
  vec4 prevPosition = instanceStartPositions;
  vec2 prevPosition64xyLow = instanceStartEndPositions64xyLow.xy;
  if (project_uCoordinateSystem == COORDINATE_SYSTEM_LNGLAT_AUTO_OFFSET) {
    // In auto offset mode, add delta to low part of the positions for better precision
    prevPosition64xyLow += mix(-instanceLeftDeltas, vec4(0.0), isEnd).xy;
  } else {
    prevPosition += mix(-instanceLeftDeltas, vec4(0.0), isEnd);
  }
  prevPosition = project_position(prevPosition, prevPosition64xyLow);
  vec4 currPosition = mix(instanceStartPositions, instanceEndPositions, isEnd);
  vec2 currPosition64xyLow = mix(instanceStartEndPositions64xyLow.xy, instanceStartEndPositions64xyLow.zw, isEnd);
  currPosition = project_position(currPosition, currPosition64xyLow);
  vec4 nextPosition = instanceEndPositions;
  vec2 nextPosition64xyLow = instanceStartEndPositions64xyLow.zw;
  if (project_uCoordinateSystem == COORDINATE_SYSTEM_LNGLAT_AUTO_OFFSET) {
    // In auto offset mode, add delta to low part of the positions for better precision
    nextPosition64xyLow += mix(vec4(0.0), instanceRightDeltas, isEnd).xy;
  } else {
    nextPosition += mix(vec4(0.0), instanceRightDeltas, isEnd);
  }
  nextPosition = project_position(nextPosition, nextPosition64xyLow);
  vec4 pos = lineJoin(prevPosition, currPosition, nextPosition);
  gl_Position = project_to_clipspace(pos);
}
`;


function add_trips_geo( map_id, trips_data, layer_id, trail_length, loop_length, animation_speed, legend ) {

	console.log( trips_data );

	class PathTimeLayer extends PathLayer {
  	getShaders() {
  		return Object.assign({}, super.getShaders(), {
  			vs: pathVertex
  		})
  	}
  }

	const defaultProps = {
		//...PathLayer.defaultProps,
	  trailLength: {type: 'number', value: 120, min: 0},
	  currentTime: {type: 'number', value: 0, min: 0}
	};

  // TODO
  // extend PathTimeLayer, but, need to also update tesselator to use vec4 objects
  class TripsLayer extends PathLayer {
	  getShaders() {
	    const shaders = super.getShaders();
	    shaders.inject = {
	      // Timestamp of the vertex
	      'vs:#decl': `\
				uniform float trailLength;
				varying float vTime;
				`,
	      // Remove the z component (timestamp) from position
	      'vec3 pos = lineJoin(prevPosition, currPosition, nextPosition);': 'pos.z = 0.0;',
	      // Apply a small shift to battle z-fighting
	      'vs:#main-end': `\
				float shiftZ = mod(instanceEndPositions.z, trailLength) * 1e-4;
				gl_Position.z += shiftZ;
				vTime = instanceStartPositions.z + (instanceEndPositions.z - instanceStartPositions.z) * vPathPosition.y / vPathLength;
				`,
	      'fs:#decl': `\
				uniform float trailLength;
				uniform float currentTime;
				varying float vTime;
				`,
	      // Drop the segments outside of the time window
	      'fs:#main-start': `\
				if(vTime > currentTime || vTime < currentTime - trailLength) {
				  discard;
				}
				`,
	      // Fade the color (currentTime - 100%, end of trail - 0%)
	      'gl_FragColor = vColor;': 'gl_FragColor.a *= 1.0 - (currentTime - vTime) / trailLength					;'
	    };
	    return shaders;
	  }

	  draw(params) {
	  	//console.log( "drawing" );
	    const {trailLength, currentTime} = this.props;

	    params.uniforms = Object.assign({}, params.uniforms, {
	      trailLength,
	      currentTime
	    });

	    super.draw(params);
	  }

	}

	TripsLayer.layerName = 'TripsLayer';
	TripsLayer.defaultProps = defaultProps;


  var tripsLayer = new TripsLayer({
    id: 'trips-'+layer_id,
    data: trips_data,
    getPath: d => d.geometry.geometry.coordinates,
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    opacity: 0.3,
    widthMinPixels: 2,
    rounded: true,
    //trailLength: trail_length,
    time: 0,
    currentTime: 0
  });

  console.log( tripsLayer );

  md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );

  if (legend !== false) {
    add_legend( map_id, layer_id, legend );
  }

  animate_trips( map_id, trips_data, layer_id, loop_length, animation_speed );

  //function animate_trips( tripsLayer ) {
function animate_trips( map_id, trips_data, layer_id, loop_length, animation_speed ) {

	 //console.log( loop_length );
	 //console.log( animation_speed );

  	var loopLength = loop_length; // unit corresponds to the timestamp in source data
    var animationSpeed = animation_speed; // unit time per second

    const timestamp = Date.now() / 1000;
    const loopTime = loopLength / animationSpeed;

    var time = ((timestamp % loopTime) / loopTime) * loopLength;

		var tripsLayer = new TripsLayer({
		    id: 'trips-'+layer_id,
		    data: trips_data,
		    getPath: d => d.geometry.geometry.coordinates,
		    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
		    opacity: 0.3,
		    widthMinPixels: 2,
		    rounded: true,
		    currentTime: time
		  });

   md_update_layer( map_id, 'trips-'+layer_id, tripsLayer );

   window.requestAnimationFrame( function() {
   	  animate_trips( map_id, trips_data, layer_id, loop_length, animation_speed );
   });

  }
}



