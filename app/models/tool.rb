class Tool
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
end
