# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('question-id')
    $('form#edit_question_' + question_id).show()

  channel = '/index'
  PrivatePub.subscribe channel, (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append(JST["templates/question/create"]({question: question}))


$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update