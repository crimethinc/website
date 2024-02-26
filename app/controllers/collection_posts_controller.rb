class CollectionPostsController < ApplicationController
  def index
    posts = if collection_params[:published_since].present?
              published_since_posts
            else
              published_at_posts
            end

    if posts.nil?
      render json: {}, status: :not_found
    else
      render json: { published_at: Time.now.utc.to_i, posts: posts }
    end
  end

  private

  def collection_params
    params.permit(:id_or_slug, :published_at, :published_since)
  end

  def published_at_posts
    Article.where(collection_id: collection_params[:id_or_slug])
           .where('published_at > ?', Time.zone.at(collection_params[:published_at].to_i))
           .live
           .published
           .chronological
  end

  def published_since_posts
    published_since = Time.at(collection_params[:published_since]&.to_i).utc.to_datetime
    Article.find_by(slug: collection_params[:id_or_slug])
           .collection_posts
           .live
           .published
           .where('published_at >= :published_since', published_since: published_since)
  end
end
