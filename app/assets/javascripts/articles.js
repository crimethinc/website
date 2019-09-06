App.articleQueue.onIncoming = function(data) {
  var alertDiv = document.querySelector('#floating-alert');

  if (alertDiv === null) {
    alertDiv = document.createElement('div');
    alertDiv.setAttribute('id', 'floating-alert');
    alertDiv.classList.add('alert', 'alert-floating', 'alert-notice');
    
    document.body.prepend(alertDiv);
  }

  var postPlural = data.length > 1 ? 'posts' : 'post';
  
  var closeLink = document.createElement('a');
  closeLink.classList.add('close');
  closeLink.insertAdjacentHTML('afterbegin', '&#10006;');
  closeLink.addEventListener('click', function() { alertDiv.remove() });
  
  alertDiv.insertAdjacentHTML('afterbegin', `Psst! Refresh for ${data.length} new ${postPlural}`);
  alertDiv.appendChild(closeLink);
};
