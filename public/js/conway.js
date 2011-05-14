$(document).ready(function(){
    var name = 'steven';
    var domain = 'stevenklise.com';
    $('.email_sk').html('<a href="mailto:'+name+'@'+domain+'">'+name+'@'+domain+'</a>');

	// LI element for debugging.
	$('#debug').append();
	
	$('body').append('<div id="ajax-status"></div>');
	
	app.init();
	app.buttonHandlers();
	app.selectCategory();
	app.getPatternJSON();
	app.setupAjaxCallbacks();
	app.positionPatternSelect($(window).width(),$(window).height());
});

var app = {
	init: function(){
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
	},
	/* BUTTONS FOR THE SKETCH */
	buttonHandlers: function(){
		/* CLEAR */
		$('#conway_clear').click(function(){
			window.cleargrid = true;
		});
		/* PLAY PAUSE */
		$('#conway_running').click(function(){
			window.running = !window.running;
			var state = '';
			if(window.running) {
				state = 'PAUSE';
			}
			else {
				state = 'RUN';
			}
			$('#conway_running').val(state);
		});
		/* EDGES */
		$('#conway_edges').click(function(){
			window.edges = !window.edges;
			if(window.edges) {
				$(this).val('EDGES ON');
			}
			else {
				$(this).val('EDGES OFF');
			}
		});
		/* PATTERN BOX */
		$('input[id=conway_pattern]').click(function(){
			$('#patternselect').toggle();
		});
		/* SPEED */
		window.speed = $('input[name=conway_speed]').val();
		$('#conway_speed').html(window.speed);
		$('input[name=conway_speed]').mousemove(function(){
			window.speed = $(this).val();
			$('#conway_speed').html(window.speed);
		});
	},
	/* SELECT A CATEGORY, RETRIEVE PATTERN LIST */
	selectCategory: function(){
		$('.select-category').click(function() {
			category = $(this).attr('href');
			if($(this).hasClass('current')){
				$(category+' .patternlist').html('');
				$(this).removeClass('current');
			}
			else {
				$.get('/category/'+category.substring(1), function(data){
					$(category+' .patternlist').append(data);
				});
				$(this).addClass('current');
			}
			return false;
		});
	},
	/* SET VARIABLES WITH CHOSEN PATTERN */
	getPatternJSON: function(){
		// Take chosen pattern and save in a global variable
		$('.pattern').click(function(){
			$('#patternselect').fadeOut(200);
			// alert();
			$.getJSON('/pattern/'+$(this).attr('name'), function(data) {
				window.patternName = data.name;
				window.patternWidth = data.width;
				window.patternHeight = data.height;
				window.patternShape = data.shape;
			});
		});
	},
	/* POSITION MODAL */
	positionPatternSelect: function(w,h){
		divwidth = $('#patternselect').width();
		$('#patternselect').css({
			'left': w/2-divwidth/2+'px',
			'top': '150px'
		});
	},
	setupAjaxCallbacks: function(){
		$('body').ajaxStart(function(){
			$('#ajax-status').show().text("Loading...");
		});
		$('body').ajaxStop(function(){
			$('#ajax-status').fadeOut();
		});
		$('body').ajaxError(function(event, xhr, ajaxOptions, thrownError){
			if(xhr.status === 401) {
				if($("#login").is(":hidden")){
					app.showLoginForm();
				}
				alert("Sorry, "+xhr.responseText.toLowerCase());
				$("#login input[type='text']:first").focus();
			}
			console.log("XHR Response: "+JSON.stringify(xhr));
		});
	}
}
