//= require jquery
//= require jquery_ujs
//= require tether
//= require bootstrap
//= require cocoon

$(function() {
  return $("textarea[data-max-length]").keyup(function(e) {
    e.preventDefault();

    var text_length = e.currentTarget.value.length;
    var text_max, id_to_update;

    id_to_update = $(this).data("feedback-box");
    text_max = $(this).data("max-length");

    var text_remaining = text_max - text_length;
    return $('#'+id_to_update).html(text_remaining);
  });
});
