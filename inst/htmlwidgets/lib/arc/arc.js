
function add_arc( map_id, arc_data, layer_id ) {


	var arcFragment = `\
#define SHADER_NAME arc-layer-fragment-shader2
precision highp float;
varying vec4 vColor;
void main(void) {
  gl_FragColor = vColor;
  gl_FragColor = picking_filterPickingColor(gl_FragColor);
}
`;

var arcVertex = `\
#define SHADER_NAME arc-brushing-layer-vertex-shader
const float R_EARTH = 6371000.0; // earth radius in km
const float N = 49.0;
attribute vec3 positions;
attribute vec4 instanceSourceColors;
attribute vec4 instanceTargetColors;
attribute vec4 instancePositions;
attribute vec3 instancePickingColors;
attribute float instanceWidths;
uniform float numSegments;
uniform float opacity;
// uniform for brushing
uniform vec2 mousePos;
uniform float brushRadius;
uniform bool enableBrushing;
uniform float brushSource;
uniform float brushTarget;
varying vec4 vColor;
// approximate distance between lng lat in meters
float distanceBetweenLatLng(vec2 source, vec2 target) {
  vec2 delta = (source - target) * PI / 180.0;
  float a =
    sin(delta.y / 2.0) * sin(delta.y / 2.0) +
    cos(source.y * PI / 180.0) * cos(target.y * PI / 180.0) *
    sin(delta.x / 2.0) * sin(delta.x / 2.0);
  float c = 2.0 * atan(sqrt(a), sqrt(1.0 - a));
  return R_EARTH * c;
}
// range is km
float isPointInRange(vec2 ptLatLng, vec2 mouseLatLng, float range, float enabled) {
  return float(enabled <= 0.0 || distanceBetweenLatLng(ptLatLng, mouseLatLng) <= range);
}
float paraboloid(vec2 source, vec2 target, float ratio) {
  vec2 x = mix(source, target, ratio);
  vec2 center = mix(source, target, 0.5);
  float dSourceCenter = distance(source, center);
  float dXCenter = distance(x, center);
  return (dSourceCenter + dXCenter) * (dSourceCenter - dXCenter);
}
// offset vector by instanceWidths pixels
// offset_direction is -1 (left) or 1 (right)
vec2 getExtrusionOffset(vec2 line_clipspace, float offset_direction, float strokeWidth) {
  // normalized direction of the line
  vec2 dir_screenspace = normalize(line_clipspace * project_uViewportSize);
  // rotate by 90 degrees
  dir_screenspace = vec2(-dir_screenspace.y, dir_screenspace.x);
  vec2 offset_screenspace = dir_screenspace * offset_direction * strokeWidth / 2.0;
  vec2 offset_clipspace = project_pixel_to_clipspace(offset_screenspace).xy;
  return offset_clipspace;
}
float getSegmentRatio(float index) {
  return smoothstep(0.0, 1.0, index / (numSegments - 1.0));
}
vec3 getPos(vec2 source, vec2 target, float segmentRatio) {
  float vertex_height = paraboloid(source, target, segmentRatio);
  return vec3(
    mix(source, target, segmentRatio),
    sqrt(max(0.0, vertex_height))
  );
}
void main(void) {
  vec2 source = project_position(instancePositions.xy);
  vec2 target = project_position(instancePositions.zw);
  // if not enabled isPointInRange will always return true
  float isSourceInBrush = isPointInRange(instancePositions.xy, mousePos, brushRadius, brushSource);
  float isTargetInBrush = isPointInRange(instancePositions.zw, mousePos, brushRadius, brushTarget);
  float isInBrush = float(!enableBrushing ||
  (brushSource * isSourceInBrush > 0. || brushTarget * isTargetInBrush > 0.));
  float segmentIndex = positions.x;
  float segmentRatio = getSegmentRatio(segmentIndex);
  // if it's the first point, use next - current as direction
  // otherwise use current - prev
  float indexDir = mix(-1.0, 1.0, step(segmentIndex, 0.0));
  float nextSegmentRatio = getSegmentRatio(segmentIndex + indexDir);
  vec3 currPos = getPos(source, target, segmentRatio);
  vec3 nextPos = getPos(source, target, nextSegmentRatio);
  vec4 curr = project_to_clipspace(vec4(currPos, 1.0));
  vec4 next = project_to_clipspace(vec4(nextPos, 1.0));
  // mix instanceWidths with brush, if not in brush, return 0
  float finalWidth = mix(0.0, instanceWidths, isInBrush);
  // extrude
  vec2 offset = getExtrusionOffset((next.xy - curr.xy) * indexDir, positions.y, finalWidth);
  gl_Position = curr + vec4(offset, 0.0, 0.0);
  vec4 color = mix(instanceSourceColors, instanceTargetColors, segmentRatio) / 255.;
  picking_setPickingColor(instancePickingColors);
  vColor = vec4(color.rgb, color.a * opacity);
}
`;

  const defaultProps = {
    ...ArcLayer.defaultProps,
    // show arc if source is in brush
    brushSource: true,
    // show arc if target is in brush
    brushTarget: true,
    enableBrushing: true,
    getStrokeWidth: d => d.strokeWidth,
    // brush radius in meters
    brushRadius: 100000,
    mousePosition: [0, 0]
  };

  //console.log(defaultProps);

  var arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRGBA( d.stroke_from, d.stroke_from_opacity ),
    getTargetColor: d => hexToRGBA( d.stroke_to, d.stroke_to_opacity ),
    onClick: info => layer_click( map_id, "arc", info ),
    onHover: updateTooltip,
    brushSource: true,
    // show arc if target is in brush
    brushTarget: true,
    enableBrushing: true,
    //getStrokeWidth: d => d.strokeWidth,
    // brush radius in meters
    brushRadius: 100000,
    mousePosition: [0, 0]
  });

  // can I update the layer after it's been created?
  //console.log( arcLayer );

  // how do I acess (and modify) the 'fs' of the getShader() function?
  //console.log( arcLayer.getShaders );
  //console.log( arcLayer.getShaders() );

   var av = arcLayer.getShaders().vs;
   var af = arcLayer.getShaders().fs;
   var m = arcLayer.getShaders().modules;

  //arcLayer.getShaders = function() {
  ArcLayer.prototype.getShaders = function() {

  	//const shaders = Object.assign({}, arcLayer.getShaders(), {
  	//  fs: arcFragment
    //});
    console.log(" -- modifying shader -- ");

    return {
    	modules: m,
    	vs: arcVertex,
    	fs: arcFragment
    }
  }

  //console.log(' -- updated getShaders -- ');
  //console.log( arcLayer.getShaders() );

  // overriding the draw method
  //console.log( arcLayer.draw().uniforms );
  //console.log( ArcLayer.prototype.draw );

  ArcLayer.prototype.draw = function( opts ) {
  	//console.log(' -- draw opts --');
  	//console.log(opts);

  	//return opts;
  	//console.log( '-- opts --');
  	//console.log( opts );
  	const uniforms = Object.assign({}, opts.uniforms, {
      brushSource: this.props.brushSource,
      brushTarget: this.props.brushTarget,
      brushRadius: this.props.brushRadius,
      mousePos: this.props.mousePosition
        ? new Float32Array(this.unproject(this.props.mousePosition))
        : defaultProps.mousePosition,
      enableBrushing: this.props.enableBrushing
    });
    const newOpts = Object.assign({}, opts, {uniforms});

    //console.log( newOpts );

  	for(const e of this.getModels()) e.draw( newOpts );
  }

  //console.log(' -- this.getModels() -- ');
  //console.log(ArcLayer.prototype.getModels );


  //ArcLayer.prototype.draw = function(opts) {

  //	return opts;
  //}

  update_layer( map_id, 'arc-'+layer_id, arcLayer );
}
