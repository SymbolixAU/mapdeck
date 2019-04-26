function md_decode_points( polyline ) {
	var coordinates = md_decode_polyline( polyline ) ;
	return coordinates[0];
}

function md_decode_polyline(str, precision) {
  var index = 0,
      lat = 0,
      lng = 0,
      coordinates = [],
      shift = 0,
      result = 0,
      byte = null,
      latitude_change,
      longitude_change,
      factor = Math.pow(10, precision || 5);

  // Coordinates have variable length when encoded, so just keep
  // track of whether we've hit the end of the string. In each
  // loop iteration, a single coordinate is decoded.
  while (index < str.length) {

    // Reset shift, result, and byte
    byte = null;
    shift = 0;
    result = 0;

    do {
      byte = str.charCodeAt(index++) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20);

    latitude_change = ((result & 1) ? ~(result >> 1) : (result >> 1));

    shift = result = 0;

    do {
      byte = str.charCodeAt(index++) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20);

    longitude_change = ((result & 1) ? ~(result >> 1) : (result >> 1));

    lat += latitude_change;
    lng += longitude_change;

    coordinates.push([lng / factor, lat / factor]);
  }
  return coordinates;
}

function md_get_point_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.geometry.coordinates;
}

function md_get_origin_coordinates ( obj ) {
	if ( obj.geometry.origin === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.origin.coordinates;
}

function md_get_destination_coordinates ( obj ) {
	if ( obj.geometry.destination === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.destination.coordinates;
}


function md_get_line_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [[-179.999,-89.999],[-179.999,-89.999]];
	}
	return obj.geometry.geometry.coordinates;
}

function md_get_polygon_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [[-179.999,-89.999],[-179.999,-89.999],[-179.999,-89.999]];
	}
	return obj.geometry.geometry.coordinates;
}
