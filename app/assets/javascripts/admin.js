//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require cocoon

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

// pad 0s (or whatever) on the left of strings
$(function() {
  function rjust(str, width, padding) {
    padding = padding || " ";
    padding = padding.substr(0, 1);

    if (str.length < width) {
      return padding.repeat(width - str.length) + str;
    } else {
      return str;
    }
  }

  $("#admin-article #publish-now").click(function() {
    var now    = new Date();
    var year   = now.getUTCFullYear();
    var month  = now.getUTCMonth() + 1;
    var day    = now.getUTCDate();
    var hour   = rjust(now.getUTCHours().toString(),   2, "0");
    var minute = rjust(now.getUTCMinutes().toString(), 2, "0");

    // set published_at date to utc.now
    $("#article_published_at_1i").val(year);
    $("#article_published_at_2i").val(month);
    $("#article_published_at_3i").val(day);
    $("#article_published_at_4i").val(hour);
    $("#article_published_at_5i").val(minute);

    // set publication status to published
    $("#article_status_id").val($("#article_status_id option").last().val());

    // submit form to publish article
    $("#article-form").submit();
    return false;
  });
});
