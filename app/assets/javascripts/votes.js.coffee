addVote = ->
  $('.question').bind 'ajax:success', (e) ->
    $('p.rating').html(e.detail[0].rating)
  $('.question').bind 'ajax:error', (e) ->
    $('.errors').html(e.detail[0].error_message)

$(document).ready(addVote)
$(document).on('turbolinks:load', addVote)