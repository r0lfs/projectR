# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'click', '.fa', ->
	console.log($(this).data('rating'))
	value = $(this).data('rating')
	$(this).hide()
	$('#this_rating').val(value)
	$('.wait_rate').show()
	console.log('the value of usernmae is ' + $('#this_rating').val())
	$(this).closest('li').find('i.fa-star').show()
	$(this).closest('li').siblings().each (index, element) =>
		console.log($(element).find('i').data('rating'))
		if $(element).find('i.fa-star-o').data('rating') < value
			$(element).find('i.fa-star-o').hide()
			$(element).find('i.fa-star').show()
		else
			$(element).find('i.fa-star-o').show()
			$(element).find('i.fa-star').hide()
$(document).on 'click', '.wait_rate', ->
	$(this).hide()
	$('.next_film').val('Next Film')
$(document).on 'turbolinks:load', ->
