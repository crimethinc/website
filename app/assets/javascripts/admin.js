//= require jquery3
//= require jquery-ui/widgets/datepicker
//= require timepicker
//= require modernizr
//= require jquery_ujs
//= require popper
//= require bootstrap

// character counter on textareas
$(function() {
  return $("textarea[data-max-length]").keyup(function(e) {
    e.preventDefault();

    var text_length = e.currentTarget.value.length;
    var text_max, id_to_update;

    id_to_update = $(this).data("feedback-box");
    text_max = $(this).data("max-length");

    var text_remaining = text_max - text_length;
    return $("#"+id_to_update).html(text_remaining);
  });
});

$(function() {
  var date_and_time_supported = (Modernizr.inputtypes.time && Modernizr.inputtypes.date);
  // not-supported, so polyfill
  if (!date_and_time_supported) {
    // use jquery for date picker
    $("#publication_date").datepicker({ dateFormat: "yy-mm-dd" });

    // use jquery for time picker
    $("input.timepicker").timepicker({
      timeFormat: "h:mm p",
      interval: 30,
      startTime: "10:00",
      dynamic: false,
      dropdown: true,
      scrollbar: true
    });
  }
});
