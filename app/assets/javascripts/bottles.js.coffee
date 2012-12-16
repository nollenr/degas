# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#bottle_grape_name').autocomplete
    source: $('#bottle_grape_name').data('autocomplete-source')

jQuery ->
  $('#bottle_winery_name').autocomplete
    source: $('#bottle_winery_name').data('autocomplete-winery-source')
