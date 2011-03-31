$(document).ready(function(){
    var name = 'steven';
    var domain = 'stevenklise.com';
    $('.email_sk').html('<a href="mailto:'+name+'@'+domain+'">'+name+'@'+domain+'</a>');
	
	// Initialize a few variables.
	window.edges = true;
	window.running = false;
	
	// Sketch Size
	var cpheight = $('#controlpanel').height();
	window.sketchWidth = $(window).width()-20;
	window.sketchHeight = $(window).height()-cpheight-15;
	$('canvas').css('width',window.sketchWidth+'px').css('height',window.sketchHeight+'px');
	$('#info').css('height',$(window).height());
	// stretch control panel to full width.
	$('#controlpanel').css('width',$(window).width()+'px');
	
	// clear grid.
	$('#conway_clear').click(function(){
		window.cleargrid = true;
	});
	
	// LI element for debugging.
	$('#debug').append();
	
	// Pausing and playing the simulation.
	$('#conway_running').click(function(){
		window.running = !window.running;
		var state = '';
		if(window.running)
		{
			state = 'PAUSE';
		}
		else
		{
			state = 'RUN';
		}
		$('#conway_running').val(state);
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
	$('select[name=conway_patterns]').change(function(){
		window.patterns = $(this).val();
	});
});
