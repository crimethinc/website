function getArticles(articleId, publishedAt) {
  if (!publishedAt || !articleId) {
    throw new Error('No article ID or published at date found');
  }

  var url = '/articles/' + articleId + '/collection_posts?published_at=' + publishedAt;

  return fetch(url).then(function(response) {
    if (!response.ok) {
      throw response;
    }

    return response.json();
  });
};

function handleUpdatedPost(collectionPost, data) {
  var i,
      posts = data.posts;

  collectionPost.dataset.publishedAt = data.published_at;

  for (i = 0; i < posts.length; i++) {
    App.articleQueue.push(posts[i]);
  }
}

function handleErrorOrNoResults(err) {
  if (!err.status) {
    throw err;
  }
  return;
}

function startPoller(articles) {
  // Poll every 1 minute (milliseconds * seconds * minutes)
  var refreshInterval = 1000 * 60 * 1;

  var articleId = articles[0].dataset.id;
  var collectionPost = articles[0];

  setInterval(function() {
    var articlePublishedAt = collectionPost.dataset.publishedAt;

    getArticles(articleId, articlePublishedAt).then(function(data) {
      handleUpdatedPost(collectionPost, data);
    }).catch(handleErrorOrNoResults);

  }, refreshInterval)
}

document.addEventListener('DOMContentLoaded', function() {
  var listeningArticles = document.querySelectorAll('article.h-entry[data-listen=true]');

  // Return early if no listening article is found
  if (listeningArticles.length === 0 ||
      !listeningArticles[0].dataset.listen) { return }
  
  startPoller(listeningArticles);
});

