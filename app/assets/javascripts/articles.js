App.articleQueue.onIncoming = function(data) {
  var alertDiv = document.querySelectorAll('#floating-alert');

  if (alertDiv.length === 0) {
    alertDiv = document.createElement('div');
    alertDiv.id = 'floating-alert';
    alertDiv.className = 'alert alert-floating alert-notice';
    
    document.body.prepend(alertDiv);
  }

  var postPlural = data.length > 1 ? 'posts' : 'post';
  
  var closeLink = document.createElement('a');
  closeLink.className = 'close';
  closeLink.innerHTML = '&#10006;';
  closeLink.addEventListener('click', function() { alertDiv.remove() });
  
  alertDiv.innerHTML = 'Psst! Refresh for ' + data.length + ' new ' + postPlural;
  alertDiv.appendChild(closeLink);
};
