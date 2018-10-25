
function add_geojson( map_id, geojson, layer_id, lineColor, fillColor, radius, lineWidth, elevation, light_settings, auto_highlight, highlight_colour ) {

  const geojsonLayer = new deck.GeoJsonLayer({
    map_id: map_id,
    id: 'geojson-'+layer_id,
    data: geojson,
    pickable: true,
    stroked: true,
    filled: true,
    extruded: true,
    pointRadiusScale: 1,
    pointRadiusMinPixels: 0.5,
    lineWidthScale: 1,
    lineWidthMinPixels: 1,
    lineJointRounded: true,
    getFillColor: g => geojson_fillColor( g, fillColor ),
    getLineColor: g => geojson_lineColor( g, lineColor ),
    getRadius: g => geojson_radius( g, radius ),
    getLineWidth: g => geojson_lineWidth( g, lineWidth ),
    getElevation: d => d.properties.elevation || elevation,
    lightSettings: light_settings,
    onClick: info => layer_click( map_id, "geojson", info ),
    autoHighlight: auto_highlight,
    highlightColor: hexToRGBA2( highlight_colour )
    //onHover: updateTooltip
  });

  update_layer( map_id, 'geojson-'+layer_id, geojsonLayer );
}

function geojson_radius( g, radius ) {
  if (g.properties === undefined) {
    return radius;
  }
  if (g.properties.radius === undefined) {
    return radius;
  }
  return g.properties.radius;
}

function geojson_fillColor( g, fillColor ) {
  if ( g.properties === undefined) {
    return hexToRGBA( fillColor, 255 );
  }
  if (g.properties.fillColor === undefined) {
    return hexToRGBA( fillColor, 255 );
  }
  return hexToRGBA( g.properties.fillColor, g.properties.fillOpacity || 255 );
}

function geojson_lineColor( g, lineColor ) {
  if (g.properties === undefined) {
    return hexToRGBA( lineColor, 255 );
  }
  if (g.properties.lineColor === undefined) {
    return hexToRGBA( lineColor, 255 );
  }
  return hexToRGBA( g.properties.lineColor, g.properties.lineOpacity || 255 );
}

function geojson_lineWidth( g, lineWidth ) {
  if ( g.properties === undefined ) {
    return lineWidth;
  }
  if ( g.properties.lineWidth === undefined ) {
    return lineWidth;
  }
  return g.properties.lineWidth;
}

function clear_geojson( map_id, layer_id ) {
  clear_layer( map_id, 'geojson-'+layer_id );
  clear_legend( map_id, layer_id );
}
