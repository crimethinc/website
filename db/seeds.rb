if Rails.env.development?
  test_user = User.new(username: "tester",
               name: "A Tester Account",
               email: "test@example.com",
               password: "a long passphrase to meet the minimum length",
               password_confirmation: "a long passphrase to meet the minimum length")
  test_user.save!(validate: false)

  Article.create!(
    title: "Published Article for Testing",
    subtitle: "Some Articles Have a Subtitle - That's OK!",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 6.days.ago,
    slug: "first-things-first",
    image: "https://http.cat/301.jpg"
  )

  article_with_css = Article.create!(
    title: "The Next Published Article for Testing",
    subtitle: "",
    content: "Notice, there's <b>no</b> subtitle. That's OK too. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 5.days.ago,
    slug: "next-things-next",
    image: "https://http.cat/302.jpg"
  )
  article_with_css.css = "#article-#{article_with_css.id} b { background: red; }"
  article_with_css.save!

  Article.create!(
    title: "Another Article for Testing",
    subtitle: "This Time with a Subtitle Again",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 4.days.ago,
    image: "https://http.cat/303.jpg"
  )

  Article.create!(
    title: "Who Can Even Think of Article Titles Anymore",
    subtitle: "Subtiles Are Another Thing Altogether",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 3.days.ago,
    image: "https://http.cat/304.jpg"
  )

  Article.create!(
    title: "Some Recently Published Article",
    subtitle: "Just for the Sake of Testing",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 2.days.ago,
    image: "https://http.cat/305.jpg"
  )

  Article.create!(
    title: "This Article Should Not Be on the Homepage",
    subtitle: "Because It's the Sixth Most Recent",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 7.days.ago,
    image: "https://http.cat/401.jpg"
  )

  top_pinned_article = Article.create!(
    title: "BREAKING NEWS",
    subtitle: "This article is pinned",
    content: "Technically, there's nothing stopping more than one article from being pinned. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 2.days.ago,
    slug: "breaking-news",
    pinned_to_top: true
  )

  bottom_pinned_article = Article.create!(
    title: "Featured Project",
    subtitle: "Underneath The Feed",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "published",
    published_at: 1.days.ago,
    slug: "featured-project",
    pinned_to_bottom: true
  )

  unpublished_article = Article.create!(
    title: "Something for the Future",
    subtitle: "Still Being Written, Edited, etc",
    content: "Only after an article is dated and marked published does it go out. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    status: "draft",
    published_at: 2.days.ago,
    slug: "unpublished-article",
    image: "https://http.cat/404.jpg"
  )

  page = Article.create!(
    title: "About Us",
    content: "This should NOT show up in the articles feed.",
    status: "published",
    published_at: 10.days.ago,
    page: true,
    page_path: "about/us",
    image: "https://http.cat/502.jpg"
  )
end
