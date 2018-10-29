class BooksController < ApplicationController
  before_action :set_book, only: [:show, :extras]

  def index
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'books'
    @title   = title_for :books

    @bullet_books = []
    published_bullet_book_slugs.each do |slug|
      @bullet_books << Book.find_by(slug: slug)
    end

    @letters_books = []
    published_letters_book_slugs.each do |slug|
      @letters_books << Book.find_by(slug: slug)
    end
  end

  def show
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'books'
    @editable = @book
    @title    = title_for :books, @book.slug.tr('-', '_')
  end

  def extras
    @html_id = 'page'
    @body_id = 'products'
    @title   = title_for :books, @book.slug.tr('-', '_'), :extras
  end

  def lit_kit
    @html_id = 'page'
    @body_id = 'products'
    @title   = title_for :books, :lit_kit
  end

  def into_libraries
    @html_id = 'page'
    @body_id = 'products'
    @title   = title_for :books, :into_libraries
  end

  private

  def published_bullet_book_slugs
    %w[no-wall-they-can-build
       from-democracy-to-freedom
       contradictionary
       work
       expect-resistance
       recipes-for-disaster
       days-of-war-nights-of-love]
  end

  def published_letters_book_slugs
    %w[off-the-map]
  end

  def published_book_slugs
    published_bullet_book_slugs + published_letters_book_slugs
  end

  def set_book
    @book = Book.find_by(slug: params[:slug])
    return redirect_to [:books] if @book.blank? || !published_book_slugs.include?(@book.slug)
  end
end
