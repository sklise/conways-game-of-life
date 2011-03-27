<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="conway.css"/>
<script src="conway.js"></script>
</head>

<body>
<div id="controlpanel">
	<ul>
		<li><input id="conway_running" type="button" value="RUN"/></li>
		<li><input id="conway_edges" type="button" value="EDGES ON"></li>
		<li><input id="conway_clear" type="button" value="CLEAR GRID"/></li>
		<li>SPEED:<input name="conway_speed" type="range" min="1" max="60" step="1" value="12">  <span id="conway_speed"></span></li>
		<li>FORMS:
			<select name="conway_forms">
				<option></option>
				<optgroup label="Movers">
					<option>GLIDER</option>
				</optgroup>
				<optgroup label="Oscillators">
					<option>BLINKER</option>
					<option>BEACON</option>
					<option>TOAD</option>
				</optgroup>
				<optgroup label="Methusalehs">
					<option>R-PENTOMINO</option>
				</optgroup>
			</select>
		</li>
		<li>
			<a href="http://www.conwaylife.com/wiki/index.php?title=Main_Page">MORE INFO</a>
		</li>
		<li>
			Processing Code based on &lsquo;Conway's Game of Life,&rsquo; by Mike Davis.
		</li>
		<li id="debug"></li>
	</ul>
	<div class="breaker">&nbsp;</div>
</div>
<script src="processing-1.1.0.js"></script>
<canvas datasrc="conways.pjs"></canvas>

</body>
</html>