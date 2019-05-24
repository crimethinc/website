class BooksController < ApplicationController
  before_action :set_book, only: [:show, :extras]

  PUBLISHED_BULLET_BOOK_SLUGS = %w[
    no-wall-they-can-build
    from-democracy-to-freedom
    contradictionary
    work
    expect-resistance
    recipes-for-disaster
    days-of-war-nights-of-love
    no-habra-muro-que-nos-pare
  ].map(&:freeze).freeze

  PUBLISHED_LETTERS_BOOK_SLUGS = %w[off-the-map].map(&:freeze).freeze

  def index
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'books'
    @title   = title_for :books

    @bullet_books = []
    PUBLISHED_BULLET_BOOK_SLUGS.each do |slug|
      @bullet_books << Book.find_by(slug: slug)
    end

    @letters_books = []
    PUBLISHED_LETTERS_BOOK_SLUGS.each do |slug|
      @letters_books << Book.find_by(slug: slug)
    end
  end

  def show
    @html_id  = 'page'
    @body_id  = 'tools'
    @type     = 'books'
    @editable = @book
    @title    = title_for :books, @book.slug.tr('-', '_')
    @tool     = @book
  end

  def extras
    @html_id = 'page'
    @body_id = 'tools'
    @title   = title_for :books, @book.slug.tr('-', '_'), :extras
  end

  def lit_kit
    @html_id = 'page'
    @body_id = 'tools'
    @title   = title_for :books, :lit_kit
  end

  def into_libraries
    @html_id = 'page'
    @body_id = 'tools'
    @title   = title_for :books, :into_libraries
  end

  private

  def published_book_slugs
    PUBLISHED_BULLET_BOOK_SLUGS + PUBLISHED_LETTERS_BOOK_SLUGS
  end

  def set_book
    @book = Book.find_by(slug: params[:slug])
    return redirect_to [:books] if @book.blank? || !published_book_slugs.include?(@book.slug)
  end
end
