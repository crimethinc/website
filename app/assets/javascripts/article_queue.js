App.articleQueue = (function(exports) {
  var queue = [];
  exports.state = 'empty';

  exports.push = function(data) {
    queue.push(data);

    exports.onIncoming(queue);
    exports.state = 'incoming';
  };

  exports.popAll = function() {
    exports.state = 'empty';

    data = queue.slice();

    queue = [];
    exports.onEmpty(data);

    return data;
  }

  exports.isEmpty = function() { exports.state === 'empty' };
  exports.hasIncoming = function() { exports.state === 'incoming' };

  exports.onEmpty = function(data) {};
  exports.onIncoming = function(data) {};

  return exports;
})({});
