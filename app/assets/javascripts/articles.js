App.articleQueue.onIncoming = function(data) {
  var alertDiv = document.getElementById('floating-alert');
  var body = document.getElementsByTagName("body")[0];

  if (alertDiv.length === 0) {
    alertDiv = document.createElement('div');
    alertDiv.classList.add('alert', 'alert-floating', 'alert-notice');
    alertDiv.setAttribute('id','floating-alert');
    document.body.prepend(alertDiv);
  }

  var postPlural = data.length > 1 ? 'posts' : 'post';
  function alertDivRemove() {alertDiv.remove()};
  var closeLink = document.createElement('a');
  closeLink.className = 'close';
  closeLink.innerHTML = '&#10006;';
  closeLink.onclick = alertDivRemove();
  
  var refreshPost = `Psst! Refresh for ${data.length} new ${postPlural}`;
  alertDiv.innerHTML(refreshPost).appendChild(closeLink);
};
