module Tool
  extend ActiveSupport::Concern
  include Name

  included do
    has_many :taggings, dependent: :destroy, as: :taggable
    has_many :tags, through: :taggings

    default_scope { order(slug: :asc) }
  end

  ASSET_BASE_URL = 'https://cloudfront.crimethinc.com/assets'.freeze

  IMAGE_FORMATS = %w[jpg png pdf svg tif].freeze

  EBOOK_FORMATS = {
    screen_single_page_view:  ['Screen Single Page View', 'Is there a one page wide <code>PDF</code> for on-screen reading uploaded?'],
    screen_two_page_view:     ['Screen Two Page View',    'Is there a two page wide <code>PDF</code> for on-screen reading uploaded?'],
    print_color:              ['Print Color',             'Is there a color <code>PDF</code> for printing uploaded?'],
    print_black_and_white:    ['Print B/W',               'Is there a B/W <code>PDF</code> for printing uploaded?'],
    print_color_a4:           ['Print Color A4',          'Is there an A4 sized color <code>PDF</code> for printing uploaded?'],
    print_black_and_white_a4: ['Print B/W A4',            'Is there an A4 sized B/W <code>PDF</code> for printing uploaded?'],
    epub:                     ['ePub',                    'Is there a <code>.epub</code> file uploaded?'],
    mobi:                     ['Mobi',                    'Is there a <code>.mobi</code> file uploaded?'],
    lite:                     ['Lo Res',                  'Is there a low resolution or single page view PDF uploaded?']
  }.freeze

  def path
    [nil, namespace, slug].join('/')
  end

  def ask_for_donation?
    false
  end

  def namespace
    self.class.to_s.downcase.pluralize
  end

  def asset_base_url_prefix
    [ASSET_BASE_URL, namespace, slug].join('/')
  end
end
