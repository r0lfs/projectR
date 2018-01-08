# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

set_stars = () ->
	if $('#this_rating').val() > 0
		$("#stars").find('li').each (index, element) =>
			if $(element).find('i.fa-star').data('rating') <= $('#this_rating').val()
				$(element).find('i.fa-star-o').hide()
				$(element).find('i.fa-star').show()
	else if $('#user_projected_rating').val() != null
		$("#stars").find('li').each (index, element) =>
			if $(element).find('i.fa-star').data('rating') <= $('#user_projected_rating').val()
				$(element).find('i.fa-star-o').hide()
				$(element).find('i.fa-star').show()		

$(document).on 'click', '.fa', ->
	value = $(this).data('rating')
	$(this).hide()
	$('#this_rating').val(value)
	$('.wait_rate').show()
	$(this).closest('li').find('i.fa-star').show()
	$(this).closest('li').siblings().each (index, element) =>
		if $(element).find('i.fa-star-o').data('rating') < value
			$(element).find('i.fa-star-o').hide()
			$(element).find('i.fa-star').show()
		else
			$(element).find('i.fa-star-o').show()
			$(element).find('i.fa-star').hide()
$(document).on 'turbolinks:load', ->
	set_stars()
