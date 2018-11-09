module AdminHelper
  VIEW_COUNTER_GENESIS_DATE = '2017-08-23'.freeze

  def admin_form_date(post)
    tz = post&.published_at_tz
    return '' if tz.nil? || post.published_at.nil?

    post.published_at.in_time_zone(tz).strftime('%F')
  end

  def admin_form_time(post)
    tz = post&.published_at_tz
    return '' if tz.nil? || post.published_at.nil?

    post.published_at.in_time_zone(tz).strftime('%T')
  end

  def nav_to(text, path, *options)
    classes = ['nav-link']

    if options.present?
      options = options.first

      if options[:no_css]
        classes = [options[:class]]
      else
        classes << [options[:class]]
      end
    end

    target = nil
    target = '_blank' if text =~ /View Site/

    classes << 'active' if current_page?(path)

    content_tag :li, class: 'nav-item' do
      link_to text, path, class: classes.join(' '), target: target
    end
  end

  def class_for_article_counter_genesis article
    # View counts started on 2017-08-23.
    # Border on this article (2017-08-23) indicates when the view counter started.
    # Everything below it was published pre-counter.

    return if article.published_at.blank? ||
              article.published_at.strftime('%Y-%m-%d') != VIEW_COUNTER_GENESIS_DATE

    'article-counter-genesis'
  end

  def class_for_being_edited article
    # When an article is being edited by another person, let others know,
    # so they don’t overwrite each others’ edit.

    return if article.user.blank?

    'bg-warning'
  end

  def class_for_article_precounter_views article
    # View counts started on 2017-08-23.

    return if article.published_at.blank? ||
              article.published_at.strftime('%Y-%m-%d') > VIEW_COUNTER_GENESIS_DATE

    'text-muted'
  end

  def admin_articles_table_row_classes article
    [class_for_being_edited(article), class_for_article_counter_genesis(article)].join(' ')
  end

  def category_check_box form:, category:
    form.check_box :category_ids,
                   {
                     id: "article_category_ids_#{category.id}",
                     name: 'article[category_ids][]',
                     class: 'form-check-input'
                   },
                   category.id,
                   nil
  end
end
