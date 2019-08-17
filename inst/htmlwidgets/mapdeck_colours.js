function md_hexToRGBA( hex ) {

	//console.log( hex );

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
    //return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};


/**
 * Converts a 'vector' of hex colours (with alpha) into an array
 */
function md_to_rgba( colour_range ) {

	console.log( "md_to_rgba" );

	var arr = [],
	i,
	n = colour_range.length;

	for (i = 0; i < n; i++) {
		arr.push( md_hexToRGBA( colour_range[i]) );
	}
	console.log( arr );
  return arr;
}
