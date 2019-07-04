# Journal
rolling_thunder_journal = Journal.find_by(title: 'Rolling Thunder')

# These summaries and descriptions are in squiggly <<~HEREDOCS to preserve their Markdown formatting
summary_rolling_thunder_12 = <<-SUMMARY
  The centerpiece of this issue is a 64-page feature on the uprising against police and white supremacy that spread from Ferguson, Missouri across the United States. We urge everyone to read the debrief discussion in which Missouri anarchists reflect on their role in predominantly black struggles and the ramifications of joining confrontations that include arson and gunfire. This is filled out with raw and inspiring accounts from the streets of Ferguson, Oakland, and beyond—critiques of political cooptation and the politics of demands—narratives about destroying surveillance cameras—a discussion about the function of _biopower_ in jails and cancer wards—anarchist analyses of sex work—interviews with Turkish anarchists who participated in the resistance to ISIS in Kobanê—poetry of the Egyptian revolution—comics about the celebrated riot dog [Loukanikos](http://roarmag.org/2014/10/loukanikos-riot-dog-dies/)—the life of [Biófilo Panclasta](http://theanarchistlibrary.org/library/ritmomaquia-biofilo-panclasta-timeline)—history vs. mythology—tactics vs. strategy—peace vs. justice—and much, much more. All this, plus our regular features, gorgeous artwork and photographs, and 16 pages in full color. Fully 154 pages!
SUMMARY

description_rolling_thunder_12 = <<~DESCRIPTION
  [Download Table of Contents PDF](https://cloudfront.crimethinc.com/assets/journals/rolling-thunder-12-spring-2015/rolling-thunder-12-spring-2015_table_of_contents.pdf) (224 kb).
DESCRIPTION

summary_rolling_thunder_11 = <<-SUMMARY_ROLLING_THUNDER_11
  This one goes to eleven! The second series of _Rolling Thunder_ opens with an issue full of adventure and analysis. Whether you’re a committed revolutionary looking for the latest strategic reflections from the front lines, or you simply enjoy the gripping tales of suspense and subversion, you can’t get this stuff anywhere else. An epic account of prisoner resistance from Sean Swain—an exploration of the waning phase of social movements, including case studies of Occupy Oakland and the 2012 student strike in Québec—a narrative from the epicenter of the uprising that rocked Turkey in June 2013—devastating critiques of ally politics and the ideology coded into digital technology—a tell-all history of anarchism in Israel—a new look at gentrification, through the frame of one neighborhood’s struggle against development—a review of the forgotten insurrectionist text that taught Nietzsche, Borges, and Walter Benjamin about infinity. All this, plus our regular features, gorgeous artwork, 16 pages in full color, and [a completely new and improved format!](/blog/2014/04/05/presenting-rolling-thunder-11/) At 128 pages, this is our thickest issue yet.
SUMMARY_ROLLING_THUNDER_11

description_rolling_thunder_11 = <<~DESCRIPTION_ROLLING_THUNDER_11
  [Download Table of Contents PDF](https://cloudfront.crimethinc.com/assets/journals/rolling-thunder-11-spring-2014/rolling-thunder-11-spring-2014_table_of_contents.pdf) (267 kb).
DESCRIPTION_ROLLING_THUNDER_11

summary_rolling_thunder_8 = <<~SUMMARY_ROLLING_THUNDER_8
  Balancing out the previous issue’s focus on breaking news, _Rolling Thunder_ #8 steps back to reflect on the priorities and relationships that can make resistance effective and infectious. The centerpiece of this issue is a critical examination of the strengths and shortcomings of contemporary insurrectionist theory and practice, spanning 24 pages and a wide range of lines of inquiry. Elsewhere herein, one can find a guide to crafting constructive accountability processes, a survey of the past four decades of anarchist activity in Chile, and a report from San Francisco exploring the broader context of anarchist organizing leading up to and following the [Oakland riots](http://issuu.com/unfinishedacts/docs/unfinished_acts) covered in _Rolling Thunder_ #7. We’ve also turned up a retrospective by a member of the legendary clandestine anti-prison group [Os Cangaceiros](http://basseintensite.internetdown.org/spip.php?rubrique200/), distilling the lessons of years of underground struggle. All this is rounded out by inspiring accounts, entertaining anecdotes, magical realist fiction, and much more. No advertisements; 16 full-color pages.
SUMMARY_ROLLING_THUNDER_8

description_rolling_thunder_8 = <<~DESCRIPTION_ROLLING_THUNDER_8
  [Download Table of Contents PDF](https://cloudfront.crimethinc.com/assets/journals/rolling-thunder-8-fall-2009/rolling-thunder-8-fall-2009_table_of_contents.pdf) (822 kb).
DESCRIPTION_ROLLING_THUNDER_8

[
  {
    title:                'Rolling Thunder #12',
    subtitle:             'Spring 2015',
    buy_url:              'https://store.crimethinc.com/x/AddToCart?Item=rt12&amp;Dest=journal',
    price_in_cents:       800,
    gallery_images_count: 6,
    pages:                154,
    summary:              summary_rolling_thunder_12,
    description:          description_rolling_thunder_12
  },

  {
    title:                'Rolling Thunder #11',
    subtitle:             'Spring 2014',
    buy_url:              'https://store.crimethinc.com/x/AddToCart?Item=rt11&amp;Dest=journal',
    price_in_cents:       500,
    gallery_images_count: 6,
    pages:                128,
    summary:              summary_rolling_thunder_11,
    description:          description_rolling_thunder_11
  },

  {
    title:                'Rolling Thunder #8',
    subtitle:             'Fall 2009',
    buy_url:              'https://store.crimethinc.com/x/AddToCart?Item=rt8&amp;Dest=journal',
    price_in_cents:       500,
    pages:                106,
    gallery_images_count: 3,
    summary:              summary_rolling_thunder_8,
    description:          description_rolling_thunder_8
  }

].each do |rt|
  issue = Issue.new rt

  season, year = rt[:subtitle].split
  month = case season
          when 'Spring'
            '04'
          when 'Summer'
            '07'
          when 'Fall'
            '10'
          when 'Winter'
            '1'
          end

  issue.journal_id         = rolling_thunder_journal.id
  issue.published_at       = Time.parse("#{year}-#{month}-01T12:00 -0800")
  issue.publication_status = 'published'
  issue.ink                = 'Soy'
  issue.issue              = issue.title.split('#').last
  issue.description        = [issue.summary, issue.description].join("\n\n")

  if issue.issue.to_i == 8
    issue.height    = '11"'
    issue.width     = '8.5"'
  else
    issue.height    = '10"'
    issue.width     = '7"'
  end

  puts "    ==> Saving Issue: #{issue.name}"
  issue.save!
end
