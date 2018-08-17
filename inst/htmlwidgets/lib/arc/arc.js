
function add_arc( map_id, arc_data, layer_id ) {

	var arcFragment = `\
#define SHADER_NAME arc-layer-fragment-shader
precision highp float;
varying vec4 vColor;
void main(void) {
  gl_FragColor = vColor;
  gl_FragColor = picking_filterPickingColor(gl_FragColor);
}
`;


	var arcVertex = "";

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

  console.log(defaultProps);

/*
  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRGBA( d.stroke_from, d.stroke_from_opacity ),
    getTargetColor: d => hexToRGBA( d.stroke_to, d.stroke_to_opacity ),
    onClick: info => layer_click( map_id, "arc", info ),
    onHover: updateTooltip
  });

  console.log("arcLayer.getShaders()");
  console.log(arcLayer.getShaders);

*/
  var ArcBrushingLayer = Object.assign({  }, ArcLayer );
  ArcBrushingLayer.defaultProps = defaultProps;
  console.log( ArcBrushingLayer );

  var gs = Object.assign({}, ArcLayer.getShaders );

  //gs.vs = arcVertex;
  gs.fs = arcFragment;

  const arcLayer = new ArcBrushingLayer({
    id: 'arc-'+layer_id,
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRGBA( d.stroke_from, d.stroke_from_opacity ),
    getTargetColor: d => hexToRGBA( d.stroke_to, d.stroke_to_opacity ),
    onClick: info => layer_click( map_id, "arc", info ),
    onHover: updateTooltip
  });


  update_layer( map_id, 'arc-'+layer_id, arcLayer );
}
