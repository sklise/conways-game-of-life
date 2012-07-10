$(document).ready(function(){
    // Email address insertion.
    var name = 'steven';
    var domain = 'stevenklise.com';
    $('.email-sk').html('<a href="mailto:'+name+'@'+domain+'">'+name+'@'+domain+'</a>');

    // LI element for debugging.
    // $('#debug').append();
    
    $('body').append('<div id="ajax-status"></div>');
    App.init();
    App.buttonHandlers();
    App.selectCategory();
    Pattern.getJSON();
    App.setupAjaxCallbacks();
    App.positionPatternSelect($(window).width(),$(window).height());
    Pattern.draw();
    
    $('#pattern-rotate').click(function(){
        if(Pattern.shape.length >= 1){
            Pattern.rotate();
            self.currentPattern();
        }
    });
});

Pattern = {
    width: 1,
    height: 1,
    shape: "1",

    currentPattern: function(){
        self = this;
        $('#conway_pattern').addClass('active-button');
        $('#conway_single').removeClass('active-button');
        $('#selected-pattern').html(self.draw() + ' ' + self.name);
        $('#selected-pattern .pattern-drawing').css({
            width: function(){
                console.log(Pattern.width*8)
                return Pattern.width*8+1;
            },
            height: function(){
                return Pattern.height*8+1;
            }
        });
        return false;
    },

    draw: function(){
        self = this;
        output = '';
        output += '<div class="pattern-drawing">';
        shape = self.shape.split(',');
        for(var i=0; i<shape.length; i++){
            var state = 'off';
            if(shape[i] == '1'){
                state = 'on';
            }
            output += '<div class="'+state+'"></div>';
        }
        output += '</div>';
        return output;
    },

    getJSON: function() {
        self = this;
        // Take chosen pattern and save in a global variable
        $('.pattern').click(function() {
            patternid = $(this).attr('id').split('-')[1];
            
            $.getJSON('/pattern/'+patternid, function(data) {
                self.name = data.name;
                self.width = data.width;
                self.height = data.height;
                self.shape = data.shape;
                self.currentPattern();
            });
            $('#patternselect').fadeOut(600);
            return false;
        });
    },

    rotate: function(){
        self = this;
        var pattern = self.shape.split(',');
        var isSquare = (self.width == self.height) ? true : false;
        var rotatedPattern = [];
        for(var i=0; i<self.height; i++){
            for(var j=0; j<self.height; j++){
                var i1 = self.height-j-1;
                var j1 = i;
                rotatedPattern[self.height*i1+j1] = pattern[self.height*i+j];
            }
        }
        self.shape = rotatedPattern.join(',');
    },
}

App = {
    height: 600,
    width: 600,
    init: function(){
        self = this;
        // Initialize a few variables.
        window.edges = true;
        window.running = false;

        // Sketch Size
        var cpheight = $('#controlpanel').height();
        self.width = $(window).width()-20;
        self.height = $(window).height()-cpheight-15;
        $('canvas').css('width',App.width+'px').css('height',App.height+'px');
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
        /* SINGLE CELL*/
        $('input[id=conway_single]').click(function() {
            $(this).addClass('active-button');
            $('#conway_pattern').removeClass('active-button');
            Pattern.name = "single";
            $('#selected-pattern').html('Single Cell');
        });
        /* PATTERN BOX */
        $('input[id=conway_pattern]').click(function() {
            $('#patternselect').toggle();
        });
    },
    /* SELECT A CATEGORY, RETRIEVE PATTERN LIST */
    selectCategory: function(){
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
                $('#ajax-status').text("Sorry, "+xhr.responseText.toLowerCase()).fadeOut(1000);
            }
            console.log("XHR Response: "+JSON.stringify(xhr));
        });
    }
}
