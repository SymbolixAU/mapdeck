
function add_triangle( map_id, map_type, triangles, polygon_data, start_indices, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, is_extruded, elevation_scale, brush_radius ) {

	console.log( triangles );
	console.log( polygon_data );
	console.log( start_indices );
	//console.log( polygon_data.data.fill_colour );

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

	// location / position coordinates will come in already in Triangles

	//let fill_colour = polygon_data.data.fill_colour;

	const binaryLocation = new Float32Array( triangles.coordinates );
 	//const binaryFill = new Float32Array( fill_colour.length );
 	//for( var i = 0; i < fill_colour.length; i++ ) {
 	//	binaryFill[ i ] = fill_colour[ i ] / 255;
 	//}
 	const binaryFill = new Float32Array( polygon_data.data.fill_colour );
 	const binaryElevation = new Float32Array( polygon_data.data.elevation );

 	const binaryStartIndices = new Uint16Array( start_indices );

/*
	const binaryLocation = new Float32Array([
		-76.98069, 36.23024,
		-76.74506, 36.23392,
		-76.7075, 36.26613,
		-76.7075, 36.26613,
		-76.74135, 36.31517,
		-76.92408, 36.39244,
		-76.94577, 36.45896,
		-76.90842, 36.50428,
		-76.92413, 36.55415,
		-76.92413, 36.55415,
		-77.17735, 36.55629,
		-77.15442, 36.52625,
		-77.08327, 36.4701,
		-77.12733, 36.47071,
		-77.13932, 36.45648,
		-77.14196, 36.41706,
		-77.21767, 36.24098,
		-77.13007, 36.23346,
		-76.99475, 36.23558,
		-76.98069, 36.23024,
		-76.7075, 36.26613,
		-76.7075, 36.26613,
		-76.92408, 36.39244,
		-76.94351, 36.40173,
		-76.92413, 36.55415,
		-77.15442, 36.52625,
		-77.09213, 36.50752,
		-77.08327, 36.4701,
		-77.13932, 36.45648,
		-77.14196, 36.41706,
		-77.14196, 36.41706,
		-77.13007, 36.23346,
		-76.99475, 36.23558,
		-76.99475, 36.23558,
		-76.7075, 36.26613,
		-76.94351, 36.40173,
		-76.94577, 36.45896,
		-76.92413, 36.55415,
		-77.09213, 36.50752,
		-77.08327, 36.4701,
		-77.14196, 36.41706,
		-76.99475, 36.23558,
		-76.99475, 36.23558,
		-76.94351, 36.40173,
		-76.95367, 36.41923,
		-76.95367, 36.41923,
		-76.94577, 36.45896,
		-77.09213, 36.50752,
		-77.07531, 36.48352,
		-77.08327, 36.4701,
		-76.99475, 36.23558,
		-76.95367, 36.41923,
		-77.09213, 36.50752,
		-77.07531, 36.48352,
		-77.07531, 36.48352,
		-76.99475, 36.23558,
		-76.95367, 36.41923
	]);
*/

/*
	const binaryFill = new Float32Array([
		0.2666667, 0.003921569, 0.3294118, 1,
		0.2745098, 0.02745098, 0.3568627, 1,
		0.2784314, 0.05882353, 0.3803922, 1,
		0.2823529, 0.08235294, 0.4039216, 1,
		0.2823529, 0.1058824, 0.427451, 1,
		0.2823529, 0.1294118, 0.4470588, 1,
		0.2823529, 0.1529412, 0.4666667, 1,
		0.2784314, 0.1764706, 0.4823529, 1,
		0.2745098, 0.1960784, 0.4980392, 1,
		0.2705882, 0.2196078, 0.5098039, 1,
		0.2627451, 0.2392157, 0.5215686, 1,
		0.254902, 0.2627451, 0.5294118, 1,
		0.2470588, 0.2823529, 0.5372549, 1,
		0.2392157, 0.3019608, 0.5411765, 1,
		0.2313725, 0.3215686, 0.545098, 1,
		0.2196078, 0.3411765, 0.5490196, 1,
		0.2117647, 0.3607843, 0.5529412, 1,
		0.2039216, 0.3764706, 0.5529412, 1,
		0.1960784, 0.3960784, 0.5568627, 1,
		0.1882353, 0.4117647, 0.5568627, 1,
		0.1803922, 0.4313725, 0.5568627, 1,
		0.172549, 0.4470588, 0.5568627, 1,
		0.1647059, 0.4627451, 0.5568627, 1,
		0.1607843, 0.4823529, 0.5568627, 1,
		0.1529412, 0.4980392, 0.5568627, 1,
		0.145098, 0.5137255, 0.5568627, 1,
		0.1411765, 0.5333333, 0.5568627, 1,
		0.1333333, 0.5490196, 0.5529412, 1,
		0.1294118, 0.5647059, 0.5490196, 1,
		0.1215686, 0.5803922, 0.5490196, 1,
		0.1215686, 0.6, 0.5411765, 1,
		0.1176471, 0.6156863, 0.5372549, 1,
		0.1215686, 0.6313725, 0.5294118, 1,
		0.1294118, 0.6470588, 0.5215686, 1,
		0.1411765, 0.6666667, 0.5137255, 1,
		0.1568627, 0.6823529, 0.5019608, 1,
		0.1764706, 0.6980392, 0.4901961, 1,
		0.2, 0.7137255, 0.4784314, 1,
		0.227451, 0.7294118, 0.4627451, 1,
		0.2588235, 0.745098, 0.4470588, 1,
		0.2901961, 0.7607843, 0.427451, 1,
		0.3254902, 0.772549, 0.4078431, 1,
		0.3647059, 0.7882353, 0.3882353, 1,
		0.4039216, 0.8, 0.3647059, 1,
		0.4431373, 0.8117647, 0.3372549, 1,
		0.4862745, 0.8235294, 0.3137255, 1,
		0.5294118, 0.8352941, 0.2862745, 1,
		0.5764706, 0.8431373, 0.254902, 1,
		0.6235294, 0.854902, 0.227451, 1,
		0.6705882, 0.8627451, 0.1960784, 1,
		0.7176471, 0.8705882, 0.1647059, 1,
		0.7647059, 0.8784314, 0.1372549, 1,
		0.8117647, 0.8823529, 0.1098039, 1,
		0.8588235, 0.8901961, 0.09803922, 1,
		0.9058824, 0.8941176, 0.09803922, 1,
		0.9490196, 0.9019608, 0.1137255, 1,
		0.9921569, 0.9058824, 0.145098, 1
	]);
*/


	// this defines where the shapes startIndices
	// so if it's every 3, then each triangle is separate (for picking)
	/*
	const binaryStartIndices = new Uint16Array([
		0,  3,  6,  9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60,
		63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99, 102, 105, 108, 111,
		114, 117
	]);
	*/

	/*
	const binaryIndices = new Uint16Array([
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
		16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
		31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
		46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
		61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
		76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
		91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105,
		106, 107, 108, 109, 110, 111, 112, 113
	]);
	*/

/*
	const binaryElevation = new Uint16Array([
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
			16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
			31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
			46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
			61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
			76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
			91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105,
			106, 107, 108, 109, 110, 111, 112, 113
		]);
*/

	/*
	const binaryLocation = new Float32Array([
		0,0,0,
		0,5,0,
		5,5,0
	]);

	const binaryFill = new Float32Array([
		0.7,0.2,0,1,
		0.8,0.6,0,1,
		0.3,0.5,0,1
	]);

	const binaryIndices = new Uint16Array([
		0,1,2
	]);

	const binaryStartIndices = new Uint16Array([
		0
	]);
	*/

	console.log( binaryLocation.length );

	//const stride = 2;
	const stride = triangles.stride[ 0 ] ;
	const n_points = binaryLocation.length / stride;
	const n_points_per_tri = 3;

	// the number of triangles is the number of pairs of coordinates / stride
	// which is binaryLocation.count / stride / 3;

	//const len = binaryIndices.count;
	const len = n_points / n_points_per_tri;  // the number of triangles
	//console.log( 'len: ' + len );

	const binaryIndices = new Uint16Array( binaryLocation.length );
	//const binaryIndices = new Uint16Array( n_points );
	for( var i = 0; i < binaryLocation.length; i++ ) {
		binaryIndices[i] = i; //* stride;
	}

	//console.log( binaryIndices );

/*
	const binaryFill = new Float32Array([
		0.2666667, 0.003921569, 0.3294118, 0.1,
		0.2745098, 0.02745098, 0.3568627, 0.3,
		0.972549, 0.9019608, 0.1294118, 0.8,
		0.2705882, 0.01568627, 0.3411765, 0.9,
		0.9490196, 0.9019608, 0.1137255, 0.6,
		0.9921569, 0.9058824, 0.145098, 0.3
		]);
*/

  const polygonLayer = new deck.SolidPolygonLayer({
  	map_id: map_id,
    id: 'polygon-'+layer_id,
    //data: polygon_data,
    //stroked: true,
    //filled: true,
    //parameters: {
	  //  depthTest: true
	  //},
    wireframe: true,
    extruded: is_extruded,
    //lineWidthMinPixels: 0,
    elevationScale: elevation_scale,

    data: {
    	length: len, // number of triangles (length( res$coordinates ) )
    	startIndices: binaryStartIndices,
    	attributes: {
    		indices: binaryIndices, // seq(0, length( res$coordinates ) )
    		getPolygon: {value: binaryLocation, size: stride},
    		getFillColor: {value: binaryFill, size: 4},
    		getElevation: {value: binaryElevation, size: 1}
    	}
    },
    _normalize: false, // skip normalization for ear-cut polygons
    pickable: true,
    autoHighlight: true,

		/*
    getPolygon: d => md_get_polygon_coordinates( d ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineWidth: d => d.properties.stroke_width,
    getElevation: d => d.properties.elevation,
    */


    //lightSettings: light_settings,
    //autoHighlight: auto_highlight,
    //highlightColor: md_hexToRGBA( highlight_colour ),
    //highlightColor: md_hexToRGBA( "#AAFFFF80")
    //onHover: md_update_tooltip,
    //onHover: test_hover
    //onClick: info => md_layer_click( map_id, "polygon", info ),
    //transitions: js_transition || {},
    //brushingRadius: brush_radius,
    //extensions: extensions
  });

  if( map_type == "google_map") {
    md_update_overlay( map_id, 'polygon-'+layer_id, polygonLayer );
  } else {

	  md_update_layer( map_id, 'polygon-'+layer_id, polygonLayer );
  }

	if (legend !== false) {
	  md_add_legend(map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function test_hover({x,y,object,layer,index}) {
	console.log("hovering");
}


