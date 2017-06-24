class BooksController < ApplicationController
  before_action :set_book, only: [:show, :extras]

  def index
    @html_id = "page"
    @body_id = "products"
    @title   = "Books"

    @bullet_books = []
    %w(no-wall-they-can-build
       from-democracy-to-freedom
       contradictionary
       work
       expect-resistance
       recipes-for-disaster
       days-of-war-nights-of-love).each do |slug|
      @bullet_books << Book.find_by(slug: slug)
    end

    @letters_books = []
    %w(off-the-map).each do |slug|
      @letters_books << Book.find_by(slug: slug)
    end
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @title   = "Books : #{@book.title}"
  end

  def extras
    @html_id = "page"
    @body_id = "products"
    @title   = "Books : #{@book.title} : Extras"
  end

  def lit_kit
    @html_id = "page"
    @body_id = "products"
    @title   = "Books : Literature Distribution Kit"
  end

  def into_libraries
    @html_id = "page"
    @body_id = "products"
    @title   = "Books : CrimethInc. Into Libraries"
  end

  private

  def set_book
    @book = Book.find_by(slug: params[:slug])
  end
end
