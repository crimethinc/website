SELECT
  searchable_id, searchable_type, title, subtitle, content,
  tag_names AS tag,
  category_names AS category,

  setweight(title, 'A') ||
  setweight(subtitle, 'B') ||
  setweight(content, 'C') ||
  setweight(array_to_tsvector(tag_names), 'D') ||
  setweight(array_to_tsvector(category_names), 'D') AS document

  FROM (
    SELECT
      articles.id AS searchable_id,
      'Article' AS searchable_type,
      to_tsvector(coalesce(articles.title, '')) AS title,
      to_tsvector(coalesce(articles.subtitle, '')) AS subtitle,
      to_tsvector(coalesce(articles.content, '')) AS content,
      CASE WHEN COUNT(tags) = 0 THEN ARRAY[]::text[] ELSE array_remove(array_agg(tags.name), NULL) END AS tag_names,
      CASE WHEN COUNT(categories) = 0 THEN ARRAY[]::text[] ELSE array_remove(array_agg(categories.name), NULL) END AS category_names

    FROM articles
    LEFT JOIN taggings ON taggings.taggable_id = articles.id AND taggings.taggable_type = 'Article'
    LEFT JOIN tags ON tags.id = taggings.tag_id
    LEFT JOIN categorizations ON categorizations.article_id = articles.id
    LEFT JOIN categories ON categories.id = categorizations.category_id
    WHERE articles.published_at < now() AND articles.publication_status = 1
    GROUP BY searchable_id, searchable_type

    UNION

    SELECT
      pages.id AS searchable_id,
      'Page' AS searchable_type,
      to_tsvector(coalesce(pages.title, '')) AS title,
      to_tsvector(coalesce(pages.subtitle, '')) AS subtitle,
      to_tsvector(coalesce(pages.content, '')) AS content,
      CASE WHEN COUNT(tags) = 0 THEN ARRAY[]::text[] ELSE array_agg(tags.name) END AS tag_names,
      ARRAY[]::text[] AS category_names
    FROM pages
    LEFT JOIN taggings ON taggings.taggable_id = pages.id AND taggings.taggable_type = 'Page'
    LEFT JOIN tags ON tags.id = taggings.tag_id
    WHERE pages.published_at < now() AND pages.publication_status = 1
    GROUP BY searchable_id, searchable_type

    UNION

    SELECT
      episodes.id AS searchable_id,
      'Episode' AS searchable_type,
      to_tsvector(coalesce(episodes.title, '')) AS title,
      to_tsvector(coalesce(episodes.subtitle, '')) AS subtitle,
      to_tsvector(coalesce(episodes.content, '')) AS content,
      ARRAY[]::text[] AS tag_names,
      ARRAY[]::text[] AS category_names
    FROM episodes
    GROUP BY searchable_id, searchable_type
  ) AS a;
