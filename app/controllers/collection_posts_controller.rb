class CollectionPostsController < ApplicationController
  def index
    posts = Article.where(collection_id: params[:id]).where('published_at > ?', Time.zone.at(params[:published_at].to_i)).live.published.chronological

    if posts.empty?
      render json: {}, status: 404
    else
      render json: { published_at: Time.now.utc.to_i, posts: posts }
    end
  end
end
