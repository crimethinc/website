//= require jquery3
//= require jquery-ui/widgets/datepicker
//= require timepicker
//= require modernizr
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require dom_ready

// character counter on textareas
function updateCounter(e) {
  e.preventDefault();

  var text_length = e.currentTarget.value.length;
  var text_max, id_to_update;

  id_to_update = this.dataset.feedbackBox;
  text_max = this.dataset.maxLength;

  var text_remaining = text_max - text_length;
  var counter = document.getElementById(id_to_update)
  counter.textContent = text_remaining;
  return counter;
}

function polyfillDateAndTime() {
  // Check if the browser supports the native date/time input types
  // This should be all browsers besides IE11 and the desktop version
  // of safari If the browser doesn't support it, we polyfill the
  // widgets (this uses JQuery)
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
}

ready(() => {
  // Add the callback needed to update the text area character counters (e.g. for tweets)
  document.querySelectorAll("textarea[data-max-length]").forEach(textArea => { textArea.addEventListener("keyup", updateCounter) });
  polyfillDateAndTime();
});
