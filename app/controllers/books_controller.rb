class BooksController < ApplicationController
  before_action :set_book, only: %i[show extras]

  BOOK_SLUGS = %w[
    no-wall-they-can-build
    from-democracy-to-freedom
    contradictionary
    work
    expect-resistance
    recipes-for-disaster
    days-of-war-nights-of-love
    off-the-map
    no-habra-muro-que-nos-pare
  ].map(&:freeze).freeze

  def index
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'books'
    @title   = title_for :books

    @bullet_books = BOOK_SLUGS.map { |slug| Book.find_by(slug: slug) }
  end

  def show
    @html_id  = 'page'
    @body_id  = 'tools'
    @type     = 'books'
    @editable = @book
    @title    = title_for :books, @book.slug.underscore
    @tool     = @book
  end

  def extras
    @html_id = 'page'
    @body_id = 'tools'
    @title   = title_for :books, @book.slug.underscore, :extras
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

  def set_book
    @book = Book.find_by(slug: params[:slug])
    return redirect_to [:books] if @book.blank? || !BOOK_SLUGS.include?(@book.slug)
  end
end
