App.articleQueue.onIncoming = function(data) {
  var alertDiv = $('#floating-alert');

  if (alertDiv.length === 0) {
    alertDiv = $('<div id="floating-alert" class="alert alert-floating alert-notice">)');
    $('body').prepend(alertDiv);
  }

  var postPlural = data.length > 1 ? 'posts' : 'post';
  var closeLink = $('<a class="close">&#10006;</a>').click(function() { alertDiv.remove() });

  alertDiv.html('Psst! Refresh for ' + data.length + ' new ' + postPlural).append(closeLink);
};
