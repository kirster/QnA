addVote = ->
  $('.vote').bind 'ajax:success', (e) ->
    $(this).parent().find('.rating').html(e.detail[0].rating)
  $('.vote').bind 'ajax:error', (e) ->
    if e.detail[0].type == 'Question'
     $(this).parent().find('.question-errors').html(e.detail[0].error_message)
    else
      $(this).parent().find('.answer-errors').html(e.detail[0].error_message)

$(document).ready(addVote)
$(document).on('turbolinks:load', addVote)