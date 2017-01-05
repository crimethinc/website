books = []

books << {
  title:          "Work",
  subtitle:       "capitalism . economics . resistance",
  slug:           "work",
  download_url:   "",
  tweet:          "",
  series:         "bullet",
  summary:        "After so much technological progress, why do we have to work more than ever before? How is it that the harder we work, the poorer we end up compared to our bosses? Starting from the vantage point of our daily lives, _Work_ offers an overview of 21st century capitalism and how to fight it.",
  pages:          "378 + cover",
  words:          "66,507",
  width:          '4.75"',
  height:         '7.5"',
  depth:          '.8125"',
  weight:         "13.7 ounces",
  illustrations:  "106",
  photographs:    "52",
  cover_style:    "",
  ink:            "",
  price_in_cents: 1000,
  has_index:      false,
}

books << {
  title:          "Days of War, Nights of Love",
  subtitle:       "Crimethink for Beginners",
  slug:           "days-of-war-nights-of-love",
  download_url:   "",
  tweet:          "",
  series:         "bullet",
  summary:        "Your ticket to a world free of charge. Our flagship book, _Days of War, Nights of Love_, is the perfect starting place for anyone seeking a life of passionate revolt. It is a visionary manifesto, a daring challenge to everything we take for granted, a riotous explosive experiment of a book.",
  pages:          "292 + cover",
  words:          "68,361",
  width:          '5.5"',
  height:         '8.5"',
  depth:          '.75"',
  weight:         ".9 pounds",
  illustrations:  "127",
  photographs:    "52",
  cover_style:    "",
  ink:            "Full-color on cover and black w/ full bleeds throughout.",
  price_in_cents: 1000,
  has_index:      true,
}

books << {
  title:          "Contradictionary",
  subtitle:       "",
  slug:           "contradictionary",
  download_url:   "",
  tweet:          "",
  series:         "bullet",
  summary:        "_Contradictionary_ is a glossary of capitalist cant and anarchist argot—a field operations manual for the war within every word. In the tradition of The Devil’s Dictionary, it concentrates a wealth of ideas and history into aphorisms and anecdotes, alternately scathing and sublime.",
  pages:          "320 + cover",
  words:          "45,478",
  width:          '4.25"',
  height:         '5.5"',
  depth:          '.735"',
  weight:         "7.7 ounces",
  illustrations:  "64",
  photographs:    "20",
  definitions:    "519",
  cover_style:    "Faux-black-leather vinyl cover with gold foil stamp, and two colors (black & sepia) with full bleeds throughout.",
  ink:            "",
  price_in_cents: 800,
  has_index:      false,
}

books << {
  title:          "Recipes for Disaster",
  subtitle:       "an anarchist cookbook",
  slug:           "recipes-for-disaster",
  download_url:   "",
  tweet:          "",
  series:         "bullet",
  summary:        "_Recipes for Disaster_ is a tactical handbook for direct action, extensively illustrated with technical diagrams and firsthand accounts. It combines decades of hard-won knowledge about everything from collective organizing and antifascist action to squatting, graffiti, and sabotage.",
  pages:          "400 + cover",
  words:          "212,594",
  recipes:        "62",
  width:          '7"',
  height:         '10"',
  depth:          '.9"',
  weight:         "1.6 pounds",
  illustrations:  "82",
  photographs:    "91",
  cover_style:    "",
  ink:            "Full-color on cover and inside cover, two colors throughout text (black + rust)",
  price_in_cents: 1200,
  has_index:      true,
}

books << {
  title:          "Expect Resistance",
  subtitle:       "a crimethink field manual",
  slug:           "expect-resistance",
  download_url:   "",
  tweet:          "",
  series:         "bullet",
  summary:        "A hybrid field manual and tragic novel, _Expect Resistance_ picks up where _Days of War, Nights of Love_ leaves off, extending the analysis and recounting the adventures of those who staked everything on their wildest dreams. An epic of personal secession and collective resistance.",
  pages:          "346 + cover",
  words:          "84,639",
  width:          '5.5"',
  height:         '8.5"',
  depth:          '.79"',
  weight:         "1.1 pounds",
  illustrations:  "67",
  photographs:    "39",
  cover_style:    "French Flaps",
  ink:            "Five colors on cover and two colors (black and red) w/ full bleeds throughout.",
  price_in_cents: 1000,
  has_index:      false,
}



books.each do |book_params|
  slug = book_params[:slug]

  filepath    = File.expand_path("../db/seeds/books/#{slug}/", __FILE__)

  book_params[:description]        = File.read(filepath + "/description.md")
  book_params[:content]            = File.read(filepath + "/content.md")
  book_params[:table_of_contents]  = File.read(filepath + "/table_of_contents.md")
  book_params[:binding_style]      = File.read(filepath + "/binding_style.md")

  Book.create! book_params
end
