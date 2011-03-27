$(document).ready(function(){
	window.edges = true;
	window.running = false;
	
	// Sketch Size
	window.sketchWidth = $(window).width()-20;
	window.sketchHeight = $(window).height()-10;
	$('canvas').css('width',window.sketchWidth+'px').css('height',window.sketchHeight+'px');

	// stretch control panel to full width.
	$('#controlpanel').css('width',$(window).width()+'px');
	
	// clear grid.
	$('#conway_clear').click(function(){
		window.cclear = true;
	});
	
	// LI element for debugging.
	$('#debug').append();
	
	// Pausing and playing the simulation.
	$('#conway_running').click(function(){
		window.running = !window.running;
		if(window.running)
		{
			$(this).val('PAUSE');
		}
		else
		{
			$(this).val('RUN');
		}
	});
	
	// EDGES
	$('#conway_edges').click(function(){
		window.edges = !window.edges;
		if(window.edges)
		{
			$(this).val('EDGES ON');
		}
		else
		{
			$(this).val('EDGES OFF');
		}
	});
	
	// Speed adjustments through a slider
	window.speed = $('input[name=conway_speed]').val();
	$('#conway_speed').html(window.speed);
	$('input[name=conway_speed]').mousemove(function(){
		window.speed = $(this).val();
		$('#conway_speed').html(window.speed);
	});
	
	// Take select value and save in a global variable
	$('select[name=conway_forms]').change(function(){
		window.cforms = $(this).val();
	});
});