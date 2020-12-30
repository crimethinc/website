class BooksController < ApplicationController
  before_action :set_book, only: %i[show extras]

  def index
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'books'
    @title   = PageTitle.new title_for(:books)

    @books = Book.for_index

    render "#{Current.theme}/books/index"
  end

  def show
    @html_id  = 'page'
    @body_id  = 'tools'
    @type     = 'books'
    @editable = @book
    @title    = PageTitle.new title_for(:books, @book.slug.underscore)
    @tool     = @book

    render "#{Current.theme}/books/show"
  end

  def extras
    @html_id = 'page'
    @body_id = 'tools'
    @title   = PageTitle.new title_for(:books, @book.slug.underscore, :extras)

    render "#{Current.theme}/books/extras"
  end

  def lit_kit
    @html_id = 'page'
    @body_id = 'tools'
    @title   = PageTitle.new title_for(:books, :lit_kit)

    render "#{Current.theme}/books/lit_kit"
  end

  def into_libraries
    @html_id = 'page'
    @body_id = 'tools'
    @title   = PageTitle.new title_for(:books, :into_libraries)

    render "#{Current.theme}/books/into_libraries"
  end

  private

  def set_book
    @book = Book.find_by(slug: params[:slug])
    return redirect_to [:books] if @book.blank?
  end
end
