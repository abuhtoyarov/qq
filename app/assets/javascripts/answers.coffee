# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answer-id')
    $('form#edit_answer_' + answer_id).show()
  $('.btn').popover()

#createAnswerSuccess = (e, data, status, xhr) ->
#  answer = $.parseJSON(xhr.responseText)
#
#  $('.answers').append(JST["templates/answer/create"]({answer: answer}))

  questionId = $('.answers').data('questionId');
  channel = '/questions/' + questionId + '/answers'
  PrivatePub.subscribe channel, (data, channel) ->
    answer = $.parseJSON(data['answer'])
    $('.answers').append(JST["templates/answer/create"]({answer: answer}))


editAnswerSuccess = (e, data, status, xhr) ->
  answer = $.parseJSON(xhr.responseText)
  $('#answer'+answer.id).replaceWith(JST["templates/answer/update"]({answer: answer}))

errorAnswer = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.answer-errors').append(value)


$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update

#$(document).on 'ajax:success', 'form.new_answer', createAnswerSuccess
$(document).on 'ajax:error', 'form.new_answer', errorAnswer

$(document).on 'ajax:success', 'form.edit_answer', editAnswerSuccess
$(document).on 'ajax:error', 'form.edit_answer', errorAnswer