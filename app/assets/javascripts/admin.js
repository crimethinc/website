//= require jquery3
//= require jquery-ui/widgets/datepicker
//= require timepicker
//= require modernizr
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
    var month  = rjust((now.getUTCMonth() + 1).toString(),   2, "0");
    var day    = rjust(now.getUTCDate().toString(),   2, "0");
    var hour   = rjust(now.getUTCHours().toString(),   2, "0");
    var minute = rjust(now.getUTCMinutes().toString(), 2, "0");

    // set published_at date to utc.now
    $("#article_published_at_tz").val('UTC');
    $("#publication_date").val(year + "-" + month + "-" + day);
    $("#publication_time").val(hour+":"+minute);

    // set publication status to published
    $("#article_status_id_published").attr("checked", "checked");

    // submit form to publish article
    $("#article-form").submit();
    return false;
  });
});

$(function() {
  var date_and_time_supported = (Modernizr.inputtypes.time && Modernizr.inputtypes.date);
  // not-supported, so polyfill
  if (!date_and_time_supported) {
    // use jquery for date picker
    $('#publication_date').datepicker({ dateFormat: 'yy-mm-dd' });

    // use jquery for time picker
    $('input.timepicker').timepicker({
      timeFormat: 'h:mm p',
      interval: 30,
      startTime: '10:00',
      dynamic: false,
      dropdown: true,
      scrollbar: true
    });
  }
});
