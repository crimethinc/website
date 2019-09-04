App.articleQueue.onIncoming = function(data) {
  var alertDiv = document.getElementById('#floating-alert');
  var body = document.querySelectorAll('body');

  if (alertDiv.length === 0) {
    alertDiv = document.querySelectorAll('<div id="floating-alert" class="alert alert-floating alert-notice">');
    
    body.insertBefore(alertDiv, body.firstChild); 
  }

  var postPlural = data.length > 1 ? 'posts' : 'post';
  closeLink = document.querySelectorAll('<a class="close">&#10006;</a>');
  closeLink.onclick = alertDivRemove();
  function alertDivRemove() { 
    alertDiv.remove()
  };
  
  var refreshPost = `Psst! Refresh for ${data.length} new ${postPlural}`;
  alertDiv.innerHTML(refreshPost).appendChild(closeLink);
};
