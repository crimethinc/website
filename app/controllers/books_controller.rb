class BooksController < ApplicationController
  before_action :set_book, only: [:show, :extras]

  def index
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'books'
    @title   = title_for prefix: :books, keys: [:index]

    @bullet_books = []
    %w[no-wall-they-can-build
       from-democracy-to-freedom
       contradictionary
       work
       expect-resistance
       recipes-for-disaster
       days-of-war-nights-of-love].each do |slug|
      @bullet_books << Book.find_by(slug: slug)
    end

    @letters_books = []
    %w[off-the-map].each do |slug|
      @letters_books << Book.find_by(slug: slug)
    end
  end

  def show
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'books'
    @editable = @book
    @title    = title_for prefix: :books, keys: [:index, @book.slug.tr('-', '_')]
  end

  def extras
    @html_id = 'page'
    @body_id = 'products'
    @title   = title_for prefix: :books, keys: [:index, @book.slug.tr('-', '_'), :extras]
  end

  def lit_kit
    @html_id = 'page'
    @body_id = 'products'
    @title   = title_for prefix: :books, keys: [:index, :lit_kit]
  end

  def into_libraries
    @html_id = 'page'
    @body_id = 'products'
    @title   = title_for prefix: :books, keys: [:index, :into_libraries]
  end

  private

  def set_book
    @book = Book.where(slug: params[:slug])
    return redirect_to [:books] if @book.blank?

    @book = @book.first
  end
end
