module StealSomethingFromWorkDayHelper
  def card_tag options
    card_options = {
      download_button: t('steal_something_from_work_day.outreach_materials.download_button')
    }.merge options

    card = OpenStruct.new card_options

    tag.div class: 'card' do
      card_image(card: card) + card_body(card: card)
    end
  end

  def card_image card:
    image_tag card.preview_url, class: 'card-img-top'
  end

  def card_body card:
    tag.div class: 'card-body' do
      card_title(card: card) + card_text(card: card) + card_download_button(card: card)
    end
  end

  def card_text card:
    tag.div class: 'card-text' do
      render_markdown card.description
    end
  end

  def card_title card:
    tag.h5 card.name, class: 'card-title'
  end

  def card_download_button card:
    link_to card.download_button, card.download_url, class: 'btn btn-primary'
  end
end
