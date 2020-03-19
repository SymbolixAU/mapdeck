function md_hexToRGBA( hex ) {

  let parseString = hex;
  if (hex.startsWith('#')) { parseString = hex.slice(1, 9); }

  if ( parseString.length === 6 ) {
  	parseString = parseString + "FF";
  } else if ( parseString.length === 3 ) {
  	parseString = parseString + "F";
  } else if (parseString.length !== 8) {
  	return null;
  }
  const r = parseInt(parseString.slice(0, 2), 16);
  const g = parseInt(parseString.slice(2, 4), 16);
  const b = parseInt(parseString.slice(4, 6), 16);
  const a = parseInt(parseString.slice(6, 8), 16);
  if (isNaN(r) || isNaN(g) || isNaN(b)) {return null;}
  return [r, g, b, a];
};


/**
 * Converts a 'vector' of hex colours (with alpha) into an array
 */
function md_to_rgba( colour_range ) {

	var arr = [],
	i,
	n = colour_range.length;

	for (i = 0; i < n; i++) {
		arr.push( md_hexToRGBA( colour_range[i]) );
	}
  return arr;
}

/*
 * converts a [R, G, B, A] array
 * to hex string
 */
function md_RGBToHex( rgba ) {
	r = rgba[0];
	g = rgba[1];
	b = rgba[2];
	//a = rgba[3];

	r = r.toString(16);
	g = g.toString(16);
	b = b.toString(16);
	//a = a.toString(16);

	if (r.length == 1) {
    r = "0" + r;
	}
  if (g.length == 1) {
    g = "0" + g;
  }
  if (b.length == 1) {
    b = "0" + b;
  }
  //if (a.length == 1) {
  //  a = "0" + a;
  //}

  return "#" + r + g + b;

}
