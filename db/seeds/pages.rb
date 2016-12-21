Page.create!(
  title: "About Us",
  content: "This should NOT show up in the articles feed.",
  status: Status.find_by(name: "published"),
  published_at: 10.days.ago,
  slug: "about/us",
  image: "https://http.cat/502.jpg",
)
