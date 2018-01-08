# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@set_stars = () ->
	if $('#this_rating').val() > 0
		$("#stars").find('li').each (index, element) =>
			if $(element).find('i.fa-star').data('rating') <= $('#this_rating').val()
				$(element).find('i.fa-star-o').hide()
				$(element).find('i.fa-star').show()
	else if $('#user_projected_rating').val() != null && !isNaN( $('#user_projected_rating').val())
		proj = Math.round($('#user_projected_rating').val())
		$("#stars").find('li').each (index, element) =>
			if $(element).find('i.fa-star').data('rating') <= proj
				$(element).find('i.fa-star-o').hide()
				$(element).find('i.fa-star').show()	
			if $(element).find('i.fa-star-half-o').data('rating') == proj
				$(element).find('i.fa-star-half-o').show()
				$(element).find('i.fa-star-o').hide()

$(document).on 'click', '.fa', ->
	value = $(this).data('rating')
	$(this).hide()
	$('#this_rating').val(value)
	$('.wait_rate').show()
	$(this).closest('li').find('i.fa-star').show()
	$(this).closest('li').siblings().each (index, element) =>
		if $(element).find('i.fa-star-o').data('rating') < value
			$(element).find('i.fa-star-o').hide()
			$(element).find('i.fa-star-half-o').hide()
			$(element).find('i.fa-star').show()
		else
			$(element).find('i.fa-star-o').show()
			$(element).find('i.fa-star').hide()
			$(element).find('i.fa-star-half-o').hide()

$(document).on 'turbolinks:load', ->
	set_stars()

$(document).on 'ajax:success', '.button_to', ->
	setTimeout(set_stars, 350)