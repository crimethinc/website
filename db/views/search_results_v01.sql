SELECT
  searchable_id, searchable_type, title, subtitle, content,
  to_tsvector(array_to_string(tag_names, ' ')) AS tag_names,
  to_tsvector(array_to_string(category_names, ' ')) AS category_names,
  to_tsvector(array_to_string(contributor_names, ' ')) AS contributor_names,

  setweight(title, 'A') ||
  setweight(subtitle, 'B') ||
  setweight(content, 'B') ||
  setweight(array_to_tsvector(tag_names), 'C') ||
  setweight(array_to_tsvector(category_names), 'C') ||
  setweight(array_to_tsvector(contributor_names), 'D') AS document

  FROM (
    SELECT
      articles.id AS searchable_id,
      'Article' AS searchable_type,
      to_tsvector(coalesce(articles.title, '')) AS title,
      to_tsvector(coalesce(articles.subtitle, '')) AS subtitle,
      to_tsvector(coalesce(articles.content, '')) AS content,
      CASE WHEN COUNT(tags) = 0 THEN ARRAY[]::text[] ELSE array_agg(tags.name) END AS tag_names,
      CASE WHEN COUNT(categories) = 0 THEN ARRAY[]::text[] ELSE array_agg(categories.name) END AS category_names,
      CASE WHEN COUNT(contributors) = 0 THEN ARRAY[]::text[] ELSE array_agg(contributors.name) END AS contributor_names
    FROM articles
    INNER JOIN statuses ON statuses.id = articles.status_id AND statuses.name='published'
    LEFT JOIN taggings ON taggings.taggable_id = articles.id AND taggings.taggable_type = 'Article'
    LEFT JOIN tags ON tags.id = taggings.tag_id
    LEFT JOIN categorizations ON categorizations.article_id = articles.id
    LEFT JOIN categories ON categories.id = categorizations.category_id
    LEFT JOIN contributions ON contributions.article_id = articles.id
    LEFT JOIN contributors ON contributors.id = contributions.contributor_id
    WHERE articles.published_at < now()
    GROUP BY searchable_id, searchable_type

    UNION

    SELECT
      pages.id AS searchable_id,
      'Page' AS searchable_type,
      to_tsvector(coalesce(pages.title, '')) AS title,
      to_tsvector(coalesce(pages.subtitle, '')) AS subtitle,
      to_tsvector(coalesce(pages.content, '')) AS content,
      CASE WHEN COUNT(tags) = 0 THEN ARRAY[]::text[] ELSE array_agg(tags.name) END AS tag_names,
      ARRAY[]::text[] AS category_names,
      ARRAY[]::text[] AS contributor_names
    FROM pages
    INNER JOIN statuses ON statuses.id = pages.status_id AND statuses.name='published'
    LEFT JOIN taggings ON taggings.taggable_id = pages.id AND taggings.taggable_type = 'Page'
    LEFT JOIN tags ON tags.id = taggings.tag_id
    WHERE pages.published_at < now()
    GROUP BY searchable_id, searchable_type

    UNION

    SELECT
      podcasts.id AS searchable_id,
      'Podcast' AS searchable_type,
      to_tsvector(coalesce(podcasts.title, '')) AS title,
      to_tsvector(coalesce(podcasts.subtitle, '')) AS subtitle,
      to_tsvector(coalesce(podcasts.content, '')) AS content,
      ARRAY[]::text[] AS tag_names,
      ARRAY[]::text[] AS category_names,
      ARRAY[]::text[] AS contributor_names
    FROM podcasts
    GROUP BY searchable_id, searchable_type
  ) AS a;
