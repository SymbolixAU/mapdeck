
var triggerCounter = 0;

// hover notes
// https://github.com/uber/deck.gl/blob/master/examples/website/plot/app.js
// https://github.com/uber/deck.gl/blob/4.1-release/examples/brushing/app.js
// https://github.com/uber/deck.gl/issues/1128
// https://github.com/uber/deck.gl/blob/master/docs/get-started/interactivity.md

function add_arc( map_id, arc_data, layer_id ) {
  // reference: http://deck.gl/#/documentation/deckgl-api-reference/layers/arc-layer
  const arcLayer = new ArcLayer({
    id: 'arc-'+layer_id,  // TODO
    data: arc_data,
    pickable: true,
    getStrokeWidth: d => d.stroke_width,
    getSourcePosition: d => decode_points( d.origin ),
    getTargetPosition: d => decode_points( d.destination ),
    getSourceColor: d => hexToRgb( d.stroke_from ),
    getTargetColor: d => hexToRgb( d.stroke_to ),
    onClick: info => layer_click( map_id, "arc", info ),
    //onHover: info => console.log( 'hovered', info )
    onHover: info => setTooltip( map_id )
    //onHover: ({d}) => setTooltip(`${d.origin} to ${d.destination}`)
  });

  update_layer( map_id, 'arc-'+layer_id, arcLayer );

  // do I add the onHover to the window obj?
  console.log( window[ map_id + 'map'] );

}


const tooltipStyle = {
  position: 'absolute',
  padding: '4px',
  background: 'rgba(0, 0, 0, 0.8)',
  color: '#fff',
  maxWidth: '300px',
  fontSize: '10px',
  zIndex: 9,
  pointerEvents: 'none'
};

function setTooltip( map_id ) {

	//console.log("setting tooltip");
	var div = document.createElement('div');
	//div.setAttribute('style',...tooltipStyle);

	div.class = 'tooltip';
	div.innerHTML = '<span class="tooltiptext">'+'message'+'</span>';
	console.log(div);
	//document.body.appendChild(div);

	//return(div);
	window[map_id + 'map'].setProps({ onHover: { div } });
}

