$(document).ready(function() {
	var p  = new Raphael(0,0,960,600);
	var r = p.rect(0,0,960,600);
	r.attr(  
        {  
            gradient: '90-#E80000-#780000',  
            stroke: '#3b4449',  
            'stroke-width': 10,  
            'stroke-linejoin': 'round',  
            rotation: -90  
        });
	var prev = p.rect(0,0,280,600).attr({opacity: '0', fill: "#000"});
	var next = p.rect(680, 0, 280, 600).attr({opacity: '0', fill:"#000"});
	prev.node.setAttribute("class", "prev arrow");
	next.node.setAttribute("class", "next arrow");
	var slides = $(document).find(".slide");
	var first = slides.first();
	first.addClass("current");
	displayBullets(first);

	$('.arrow').hover(function(){
		$(this).animate({opacity: 0.1}, 300);
		}, function(){
		$(this).animate({opacity: 0}, 300);
	});
	$('.prev').click(function(){
		var	other = slides.filter(".current").prev();
		switchSlide(other);
	});
	$('.next').click(function(){
		var	other = slides.filter(".current").next();
		switchSlide(other);
	});
	
	function switchSlide(other){
		if (other.length){
			slides.filter(".current").removeClass("current");
			$(".bullet_point").each(function(){
				$(this).remove();
			});
			displayBullets(other.first());
			other.first().addClass("current");
		} else {
			alert('no more slides');
		}
	}

	function displayBullets(current_slide){
		var title = p.text( 480, 50, current_slide.find('.title').text()).attr({"font-size": "50px"});
		var top_y = 100;
		var increment = 30;
		//one bullet point
		current_slide.find('li').each(function(){
			var prev_text = p.text(50,top_y,"");
			$(this).contents().each(function(){
				if ($(this).is('span')) {
					//figure out type of text
					var t = p.text(prev_text.getBBox().width + prev_text.getBBox().x + 1, top_y, "").attr('text-anchor', 'start');
					t.node.setAttribute("class", "bullet_point ");
					var c = $(this).attr('class') || "";
					if (c.indexOf('bold') >=0){
						t.attr({"font-weight": "700"});
					}
					if (c.indexOf('italic') >= 0){
						t.attr("font-style", "italic");
					}
					if (c.indexOf('underline') >= 0){
						t.attr("text-decoration", "underline");
					}
					if (c.indexOf('code') >= 0) {
						t.attr("font-family", "monospace");
					}
					var width = 860 - prev_text.getBBox().width;
					textWrap(t, width, $(this).html());
					prev_text = t;
				} else {
					var t = p.text(prev_text.getBBox().width + prev_text.getBBox().x + 1, top_y, "").attr('text-anchor', 'start');
					t.node.setAttribute("class", "bullet_point ");
					var width = 860 - prev_text.getBBox().width;
					textWrap(t, width, $(this).text());
					prev_text = t;
				}
			});
	 		top_y = prev_text.getBBox().y + prev_text.getBBox().height + 90;
		});
	}

	function textWrap(t, width, words) {
		var content = t.attr("text");
		//to determine average letter length
		var abc = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		t.attr({
			"text" : abc,
			"font-size" : "30px"
		});
		var letterWidth = t.getBBox().width / abc.length;

		t.attr({
			"text" : content
		});

		var words = words.split(" ");
		var x = 0, s = [], i = 0;
		for (i; i < words.length; i++) {
			var l = words[i].length;
			if (x + (l * letterWidth) > width ) {
				s.push("\n");
				x = 0;
			}
			x += l * letterWidth;
			s.push(words[i] + " ");
		}
		t.attr({
			"text" : s.join("")
		});
	}
});