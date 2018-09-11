$(function() {
  $('#amount').on('change', function(e) {
    if (this.value != "") {
      $(".js-button-update").prop("disabled", false)
    } else {
      $(".js-button-update").prop("disabled", true)
    }
  });
});
