//= require popper
//= require bootstrap
//= require dom_ready
//= require rails-ujs

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

ready(() => {
  // Add the callback needed to update the textarea character counters (e.g. for tweets)
  document.querySelectorAll("textarea[data-max-length]").forEach(textArea => { textArea.addEventListener("keyup", updateCounter) });
});
