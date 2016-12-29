Page.create!(
  title: "If This Is Your First Time Here&hellip;",
  content: %q{
- [Who we are and what we do](/about)
- [A basic introduction to anarchist values](/tce)
- [Frequently asked questions about anarchism](/begin#fa)
- [More introductory resources](/begin#fr)
- [What you can do](/begin#gs)
- [For more coverage of anarchist activity in North America](https://itsgoingdown.org)
  },
  status: Status.find_by(name: "published"),
  published_at: Time.parse("2017-01-01"),
  slug: "start",
  image: "https://http.cat/502.jpg",
)
