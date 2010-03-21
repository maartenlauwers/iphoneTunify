<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  xmlns:v="urn:schemas-microsoft-com:vml">
  <head>
    <title>Google Maps JavaScript API Example: Simple Directions</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <script src="http://maps.google.com/maps?file=api&v=2.x&key=ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA"
      type="text/javascript"></script>
    <script type="text/javascript"> 
	// Create a directions object and register a map and DIV to hold the 
    // resulting computed directions

    var map;
    var directionsPanel;
    var directions;
	
	var polyline;

    function initialize() {
      map = new GMap2(document.getElementById("map_canvas"));
      map.setCenter(new GLatLng(50.861096,2.731533 ), 15);
      directionsPanel = document.getElementById("route");
      directions = new GDirections(map, directionsPanel);
	  GEvent.addListener(directions, "load", directioninfo); 
	  GEvent.addListener(directions, "error", handleErrors); 

      directions.load("from: Veurnestraat 150 8970 Poperinge to: Ieperstraat 100 8970 Poperinge",{getPolyLine: true});
	}
	
	function directioninfo() {
		polyline = directions.getPolyline(); 
	
	  var count = polyline.getVertexCount();
	  var i=0;
		while (i < count) {
			var vertex = polyline.getVertex(i);
			var lat = vertex.lat();
			var lon = vertex.lng();
			document.write(lat + "," + lon);
			document.write("<br/>");
			i++;
		}

	}
	
	function handleErrors() {
		alert("error");
	}
	
    </script>
  </head>

  <body onload="initialize()">
    <div id="map_canvas" style="width: 70%; height: 480px; float:left; border: 1px solid black;"></div>
    <div id="route" style="width: 25%; height:480px; float:right; border; 1px solid black;"></div>
    <br/>
  </body>
</html>