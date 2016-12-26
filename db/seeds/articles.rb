require "nokogiri"

# Clear out all testing Articles first
Article.destroy_all

# Find the "published" Status
published_status = Status.find_by(name: "published")



# These timestamps were pulled from the cwc.im admin site since
# the Feature HTML doesn't have any publishication datetime
features_timestamps          = {
  "agitators"                => Time.parse("2014-08-20 09:30:00 -0700"),
  "battle"                   => Time.parse("2016-11-01 09:19:00 -0700"),
  "begin"                    => Time.parse("2016-09-28 08:11:00 -0700"),
  "bluefuse"                 => Time.parse("2014-11-25 12:00:00 -0800"),
  "bosnia"                   => Time.parse("2016-05-13 09:10:00 -0700"),
  "demands"                  => Time.parse("2015-05-05 10:52:00 -0700"),
  "democracy"                => Time.parse("2012-04-29 12:20:00 -0700"),
  "destination"              => Time.parse("2016-04-07 09:49:00 -0700"),
  "digital-utopia"           => Time.parse("2013-10-04 06:45:00 -0700"),
  "empezar"                  => Time.parse("2016-09-28 08:10:00 -0700"),
  "ferguson"                 => Time.parse("2014-08-18 10:32:00 -0700"),
  "ferguson-reflections"     => Time.parse("2015-08-10 10:23:00 -0700"),
  "french911"                => Time.parse("2015-12-14 00:22:00 -0800"),
  "from-ferguson-to-the-bay" => Time.parse("2014-12-12 11:31:00 -0800"),
  "kobane"                   => Time.parse("2015-02-03 16:47:00 -0800"),
  "kurdish"                  => Time.parse("2015-09-23 14:07:00 -0700"),
  "next-time-it-explodes"    => Time.parse("2015-08-13 11:59:00 -0700"),
  "partys-over"              => Time.parse("2016-03-16 08:06:00 -0700"),
  "podemos"                  => Time.parse("2016-04-05 09:37:00 -0700"),
  "policemyths"              => Time.parse("2015-08-22 21:04:00 -0700"),
  "protect"                  => Time.parse("2015-11-17 01:52:00 -0800"),
  "reaction"                 => Time.parse("2016-10-24 09:10:00 -0700"),
  "slovenia"                 => Time.parse("2016-05-11 09:09:00 -0700"),
  "syriza"                   => Time.parse("2015-01-28 01:12:00 -0800"),
  "trump"                    => Time.parse("2016-12-13 10:45:00 -0800"),
  "ukraine"                  => Time.parse("2014-03-16 20:37:00 -0700"),
  "worldcupbrazil"           => Time.parse("2014-06-12 05:16:00 -0700"),
}


# Features as Articles
filepath = File.expand_path("../db/seeds/articles/features/", __FILE__)

# Create the Category for Features
category = Category.find_or_create_by name: "Features"

Dir.glob("#{filepath}/*/").each do |f|
  path_pieces = f.strip.split("/")
  filename    = path_pieces.last

  unless filename =~ /.DS_Store/
    doc   = File.open(f + "/index.html") { |f| Nokogiri::HTML(f) }

    slug         = path_pieces[-1]
    title        = doc.css("title").text.gsub(" / CrimethInc. Ex-Workers' Collective", "")
    published_at = features_timestamps[slug]
    content      = File.read(f + "/index.html")
    image        = doc.css("meta[name='twitter:image:src']").attribute("content").value

    # Save the Article
    article = Article.create!(
      title:          title,
      content:        content,
      published_at:   published_at,
      image:          image,
      status_id:      published_status.id,
      content_format: "html",
      hide_layout:    true
    )

    # Add the Article to its Category and Theme
    category.articles << article

    # Redirect from old site Feature URLs to new site Article URLs
    if slug == "ukraine"
      namespace = "ux"
    elsif slug == "worldcupbrazil"
      namespace = "fx"
    elsif slug == "digital-utopia"
      namespace = "ex"
    else
      namespace = "r"
    end

    ["/texts/#{namespace}/#{slug}", "/texts/#{namespace}/#{slug}/", "/texts/#{namespace}/#{slug}/.index.html"].each do |source_path|
      Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    end
 end
end



# Wordpress posts
filepath = File.expand_path("../db/seeds/articles/posts/", __FILE__)

Dir.glob("#{filepath}/*").each do |f|
  filename = f.strip.split("/").last

  unless filename =~ /.DS_Store/
    doc = File.open(f) { |f| Nokogiri::XML(f) }

    title   = doc.css("title").text
    content = doc.css("content_encoded").text

    # Published At timestamps
    published_at = Time.parse(doc.css("wp_post_date_gmt").text) # GMT
    published_at = Time.parse(doc.css("wp_post_date").text)     # PST # Seems to map to URLs more accurately


    # Old permalinks to support by creating Redirects to the new Article path
    redirect_paths = []
    redirect_paths << doc.css("link").text
    redirect_paths << doc.css("guid").text
    redirect_paths << "http://www.crimethinc.com/blog/?p=#{doc.css("wp_post_id").text}"

    # Short URL
    doc.css("wp_postmeta").each do |wp_postmeta|
      if wp_postmeta.css("wp_meta_key").text == "shorturl"
        redirect_paths << wp_postmeta.css("wp_meta_value").text
      end

      # Old permalinks to support by creating Redirects to the new Article path
      if wp_postmeta.css("wp_meta_key").text == "_wp_old_slug" && wp_postmeta.css("wp_meta_value").text.present?
        redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day}/#{wp_postmeta.css("wp_meta_value").text}"
      end
    end

    # Remove duplicate Redirects
    redirect_paths = redirect_paths.uniq


    # Image and Header color
    image = ""
    header_background_color = ""
    doc.css("wp_postmeta").each do |wp_postmeta|
      if wp_postmeta.css("wp_meta_key").text == "jumbo"
        image = wp_postmeta.css("wp_meta_value").text
      end
    end

    if image.blank?
      header_background_color = "#444444"
    end

    # Find existing or create a new Contributor of words
    author_name = doc.css("dc_creator").text

    # Article slug
    slug = doc.css("wp_post_name").text

    # Category aka Desk
    category_name = doc.css("category[domain=category]").text


    # Save the Article
    article = Article.create!(
      title: title,
      content: content,
      published_at: published_at,
      slug: slug,
      header_background_color: header_background_color,
      image: image,
      status_id: published_status.id,
      content_format: "html"
    )

    # Add the Article to its Category and Theme
    category = Category.find_or_create_by name: category_name
    category.articles << article

    redirect_paths.each do |source_path|
      Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    end
  end
end



# Site News Archive from pre- 3.0 of the site (pre Wordpress?)
filepath = File.expand_path("../db/seeds/articles/site-news-archive.html", __FILE__)
html_doc = File.open(filepath) { |f| Nokogiri::HTML(f) }

# And create a new Category for "Site News Archive"
category = Category.find_or_create_by! name: "Site News Archive"

# Find the "published" Status
published_status = Status.find_by(name: "published")

html_doc.css(".h-entry").each do |entry|
  title        = entry.css(".p-name").text

  published_at = Time.parse(entry.css(".dt-published").text)
  content      = entry.css(".e-content").inner_html
  content      = content.gsub("\n", "").gsub(/\s{2,}/, " ").gsub("<p>", "").gsub("</p>", "\n\n").gsub(" \n\n ", "\n\n")
  status_id    = published_status.id

  # Save the Article
  article = Article.create!(title:        title,
                            published_at: published_at,
                            content:      content,
                            status_id:    status_id,
                            header_background_color: "#444")

  # Add the Article to its Category and Theme
  category.articles << article
end













# New feature style Articles
# TODO
theme = Theme.create!(name: "Field Reports")

# Collect the articles together
articles = []

articles << {
  url: "http://www.crimethinc.com/texts/r/demands/",
  category: "Arts",
  theme: theme,
  title: %q{
    Why We Don't Make Demands
  },
  subtitle: %q{
  },
  image: "http://crimethinc.com/texts/r/demands/images/header2560.jpg",
  content: %q{
    <p>From Occupy to Ferguson, whenever a new grassroots movement arises, pundits charge that it <a href="http://www.possible-futures.org/2012/01/03/a-movement-without-demands">lacks clear demands</a>. Why won’t protesters summarize their goals as a coherent program? Why aren’t there representatives who can negotiate with the authorities to advance a concrete agenda through institutional channels? Why can’t these movements express themselves in familiar language, with proper etiquette?</p>

    <p>
      Often, this is simply disingenuous rhetoric from those who prefer for movements to limit themselves to well-behaved appeals. When we pursue an agenda they’d rather not acknowledge, they charge that we are irrational or incoherent. Compare last year’s <a href="http://www.huffingtonpost.com/2014/09/21/peoples-climate-march_n_5857902.html">People’s Climate March</a>, which united 400,000 people behind a simple message while doing so little to protest that it was unnecessary for the authorities to make even a single arrest,
      <sup class="footlink">
        <a href="#1" name="1return">1</a>
      </sup>
      <sup class="refnumber">1</sup>
      <small>
        <span class="fnumber">1.</span> When was the last time 400,000 people were <em>anywhere</em> in New York without the police arresting anyone? That was protest not just as pressure valve, but as active pacification—as a way of diminishing the friction between protesters and the order they oppose.
      </small>
      with the <a href="http://www.slate.com/articles/news_and_politics/crime/2015/05/baltimore_riots_it_wasn_t_thugs_looting_for_profit_it_was_a_protest_against.html">Baltimore uprising</a> of April 2015. Many praised the Climate March while deriding the rioting in Baltimore as irrational, unconscionable, and ineffective; yet the Climate March had little concrete impact, while the Baltimore riots compelled the chief prosecutor to bring <a href="http://crimethinc.com/texts/r/bluefuse/">almost unprecedented</a> charges against police officers. You can bet if 400,000 people responded to climate change the way a couple thousand responded to the murder of Freddie Gray, the politicians would change their priorities.
    </p>

    <p>Even those who <em>demand demands</em> out of the best intentions usually misunderstand demandlessness as an omission rather than a strategic choice. Yet today’s demandless movements are not an expression of political immaturity—they are a pragmatic response to the impasse that characterizes the entire political system. </p>

    <p>If it were so easy for the authorities to grant protesters’ demands, you’d think we’d see more of it. In fact, from Obama to <a href="http://www.telegraph.co.uk/finance/economics/11576465/Greeces-endgame-heres-why-it-could-be-forced-to-capitulate.html">Syriza</a>, not even the most idealistic politicians have been able to follow through on the promises of reform that got them elected. The fact that charges were pressed against Freddie Gray’s killers after the riots in Baltimore suggests that the only way to make any headway is to break off petitioning entirely.</p>

    <p>So the problem is not that today’s movements lack demands; the problem is the politics of demands itself. If we seek structural change, we need to set our agenda outside the discourse of those who hold power, outside the framework of what their institutions can do. We need to stop <em>presenting demands</em> and start <em>setting objectives.</em> Here’s why.</p>

    <h2>Making demands puts you in a weaker bargaining position.</h2>

    <p>Even if your intention is simply to negotiate, you put yourself in a weaker bargaining position by spelling out from the beginning the least it would take to appease you. No shrewd negotiator begins by making concessions. It’s smarter to appear implacable: <em>So you want to come to terms? Make us an offer. In the meantime, we’ll be here blocking the freeway and setting things on fire.</em>
    </p>

    <p>There is no more powerful bargaining chip than being able to implement the changes we desire ourselves, bypassing the official institutions—the true meaning of <em>direct action.</em> Whenever we are able to do this, the authorities scramble to offer us everything we had previously requested in vain. For example, the Roe vs. Wade decision that made abortion legal occurred only after groups like the <a href="http://en.wikipedia.org/wiki/Jane_Collective">Jane Collective</a> set up self-organized networks that provided affordable abortions to tens of thousands of women.</p>

    <p>Of course, those who can implement the changes they desire directly don’t need to make demands of anyone—and the sooner they recognize this, the better. Remember how people in Bosnia burned down government buildings in February 2014, then convened plenums to formulate demands to present to the government. A year later, they’d received nothing for their pains but criminal charges, and the government was once again as stable and corrupt as ever.</p>

    <div class="bigimage">
      <img src="http://www.crimethinc.com/texts/r/demands/images/regime1370.jpg">
      <div class="bigimagecaption">
        <p>Show us, don’t tell us.</p>
      </div>
    </div>

    <h2>Limiting a movement to specific demands stifles diversity, setting it up for failure.</h2>

    <p>The conventional wisdom is that movements need demands to cohere around: without demands, they will be diffuse, ephemeral, ineffectual.</p>

    <p>But people who have different demands, or no demands at all, can still build collective power together. If we understand movements as spaces of dialogue, coordination, and action, it is easy to imagine how a single movement might advance a variety of agendas. The more horizontally structured it is, the more capable it should be of accommodating diverse goals.</p>

    <p>The truth is that practically all movements are wracked by internal conflicts over how to structure themselves and how to prioritize their goals. The <em>demand for demands</em> usually arises as a power play by the factions within a movement that are most invested in the prevailing institutions, as a means of delegitimizing those who want to build up power autonomously rather than simply petitioning the authorities. This misrepresents real political differences as mere disorganization, and real opposition to the structures of governance as political naïveté.</p>

    <p>Forcing a diverse movement to reduce its agenda to a few specific demands inevitably consolidates power in the hands of a minority. For who decides which demands to prioritize? Usually, it is the same sort of people who hold disproportionate power elsewhere in our society: wealthy, predominantly white professionals well versed in the workings of institutional power and the corporate media. The marginalized are marginalized again within their own movements, in the name of efficacy.</p>

    <p>Yet this rarely serves to make a movement more effective. A movement with space for difference can grow; a movement premised on unanimity contracts. A movement that includes a variety of agendas is flexible, unpredictable; it is difficult to buy it off, difficult to trick the participants into relinquishing their autonomy in return for a few concessions. A movement that prizes reductive uniformity is bound to alienate one demographic after another as it subordinates their needs and concerns.</p>

    <p>A movement that incorporates a variety of perspectives and critiques can develop more comprehensive and multifaceted strategies than a single-issue campaign. Forcing everyone to line up behind one set of demands is bad strategy: even when it works, it doesn’t work.</p>

    <h2>Limiting a movement to specific demands undermines its longevity.</h2>

    <p>Nowadays, as history moves faster and faster, demands are often rendered obsolete before a campaign can even get off the ground. In response to the murder of Michael Brown, reformists demanded that police wear body cameras—but before this campaign could get fully underway, a grand jury announced that the officer who murdered Eric Garner would not be tried, either, even though Garner’s murder <em>had</em> been caught on camera.</p>

    <p>Movements premised on specific demands will collapse as soon as those demands are outpaced by events, while the problems that they set out to address persist. Even from a reformist perspective, it makes more sense to build movements around the issues they address, rather than any particular solution.</p>

    <h2>Limiting a movement to specific demands can give the false impression that there are easy solutions to problems that are actually extremely complex.</h2>

    <p>“OK, you have a lot of complaints—who doesn’t? But tell us, what <em>solution</em> do you propose?”</p>

    <p>The demand for concrete particulars is understandable. There’s no use in simply letting off steam; the point is to change the world. But meaningful change will take a lot more than whatever minor adjustments the authorities might readily grant. When we speak as though there are simple solutions for the problems we face, hurrying to present ourselves as no less “practical” than government policy experts, we set the stage for failure whether our demands are granted or not. This will give rise to disappointment and apathy long before we have developed the collective capacity to get to the root of things.</p>

    <p>Especially for those of us who believe that the fundamental problem is the unequal distribution of power and agency in our society, rather than the need for this or that policy adjustment, it is a mistake to promise easy remedies in a vain attempt to legitimize ourselves. It’s not our job to present ready-made solutions that the masses can applaud from the sidelines; leave that to demagogues. Our challenge, rather, is to create spaces where people can discuss and implement solutions directly, on an ongoing and collective basis. Rather than proposing quick fixes, we should be spreading new practices. We don’t need blueprints, but points of departure.</p>

    <aside>
      <blockquote>
        <strong>No corporate initiative is going to halt climate change; no government agency is going to stop spying on the populace; no police force is going to abolish white privilege.</strong>
      </blockquote>
    </aside>

    <h2>Making demands presumes that you want things that your adversary can grant.</h2>

    <p>On the contrary, it’s doubtful whether the prevailing institutions could grant most of the things we want even if our rulers had hearts of gold. No corporate initiative is going to halt climate change; no government agency is going to stop spying on the populace; no police force is going to abolish white privilege. Only NGO organizers still cling to the illusion that these things are possible—probably because their jobs depend on it.</p>

    <p>A strong enough movement could strike blows against industrial pollution, state surveillance, and institutionalized white supremacy, but only if it didn’t limit itself to mere petitioning. Demand-based politics limits the entire scope of change to reforms that can be made within the logic of the existing order, sidelining us and deferring real change forever beyond the horizon.</p>

    <p>There’s no use in asking the authorities for things they can’t grant and wouldn’t grant if they could. Nor should we give them an excuse to acquire even more power than they already have, on the pretext that they need it to be able to fulfill our demands.</p>

    <div class="bigimage">
      <img src="http://www.crimethinc.com/texts/r/demands/images/chair1370.jpg">
      <div class="bigimagecaption">
        <p>Our one demand: don’t mess with us.</p>
      </div>
    </div>


    <h2>Making demands of the authorities legitimizes their power, centralizing agency in their hands.</h2>

    <p>It is a time-honored tradition for nonprofit organizations and leftist coalitions to present demands that they know will never be granted: don’t invade Iraq, stop defunding education, bail out people not banks, make the police stop killing black people. In return for brief audiences with bureaucrats who answer to much shrewder players, they water down their politics and try to get their less complaisant colleagues to behave themselves. This is what they call pragmatism.</p>

    <aside>
      <blockquote>
        <strong>
          Reforms that achieve short-term gains often set the stage for long-term problems.
          <br />
          <br />The same court system that ruled for desegregation imprisons a million black people today; the same National Guard that oversaw integration in the South is mobilized to repress demonstrators in Ferguson and Baltimore.<br />
          <br />Even when such institutions can be compelled to fulfill specific demands, this only legitimizes tools that are more often used against us.
        </strong>
      </blockquote>
    </aside>

    <p>Such efforts may not achieve their express purpose, but they do accomplish something: they frame a narrative in which the existing institutions are the only conceivable protagonists of change. This, in turn, paves the way for additional fruitless campaigns, additional electoral spectacles in which new candidates for office hoodwink young idealists, additional years of paralysis in which the average person can only imagine accessing her own power through the mediation of some <a href="http://crimethinc.com/texts/r/syriza/">political party</a> or organization. Rewind the tape and play it again.</p>

    <p>Real self-determination is not something that any authority can grant us. We have to develop it by acting on our own strength, centering ourselves in the narrative as the protagonists of history.</p>


    <h2>Making demands too early can limit the scope of a movement in advance, shutting down the field of possibility.</h2>

    <p>At the beginning of a movement, when the participants have not yet had a chance to get a sense of their collective power, they may not be able to recognize how thoroughgoing the changes they want really are. To frame demands at this point in the trajectory of a movement can stunt it, limiting the ambitions and imagination of the participants. Likewise, setting a precedent at the beginning for narrowing or watering down its goals only increases the likelihood that this will happen again and again.</p>

    <p>Imagine if the Occupy movement had agreed on concrete demands at the very beginning—would it still have served as an open space in which so many people could meet, develop their analysis, and become radicalized? Or would it have ended up as a single protest encampment concerned only with corporate personhood, budget cuts, and perhaps the Federal Reserve? It is better for the objectives of a movement to develop as the movement itself develops, in proportion to its capacity.</p>

    <h2>Making demands establishes some people as representatives of the movement, establishing an internal hierarchy and giving them an incentive to control the other participants.</h2>

    <p>In practice, unifying a movement behind specific demands usually means designating <a href="http://www.crimethinc.com/books/contra/defs/leadership.html">spokespeople</a> to negotiate on its behalf. Even if these are chosen “democratically,” on the basis of their commitment and experience, they can’t help but develop different interests from the other participants as a consequence of playing this role.</p>

    <p>In order to maintain credibility in their role as negotiators, spokespeople must be able to pacify or isolate anyone that is not willing to go along with the bargains they strike. This gives aspiring leaders an incentive to demonstrate that they can reign in in the movement, in hopes of earning a seat at the negotiating table. The same courageous souls whose uncompromising actions won the movement its leverage in the first place suddenly find career activists who joined afterwards telling them what to do—or denying that they are part of the movement at all. This drama played out in Ferguson in August 2014, where the locals who got the movement off the ground by standing up to the police were slandered by politicians and public figures as outsiders taking advantage of the movement to engage in criminal activity. The exact opposite was true: outsiders were seeking to hijack a movement initiated by honorable illegal activity, in order to re-legitimize the institutions of authority.</p>

    <p>In the long run, this sort of pacification can only contribute to a movement’s demise. That explains the ambiguous relation most leaders have with the movements they represent: to be of use to the authorities, they have to be capable of subduing their comrades, but their services would not be required at all if the movement did not pose some kind of threat. Hence the strange admixture of militant rhetoric and practical obstruction that often characterizes such figures: they must ride the storm, yet hold it at bay.</p>

    <h2>Sometimes the worst thing that can happen to a movement is for its demands to be met.</h2>

    <p>Reform serves to stabilize and preserve the status quo, killing the momentum of social movements, ensuring that more thoroughgoing change does not take place. Granting small demands can serve to divide a powerful movement, persuading the less committed participants to go home or turn a blind eye to the repression of those who will not compromise. Such <a href="http://www.crimethinc.com/books/contra/defs/concessions.html">small victories</a> are only granted because the authorities consider them the best way to avoid bigger changes.</p>

    <p>In times of upheaval, when everything is up for grabs, one way to defuse a burgeoning revolt is to grant its demands before it has time to escalate. Sometimes this looks like a real victory—as in Slovenia in 2013, when two months of protest toppled the presiding government. This put an end to the unrest before it could address the systemic problems that gave rise to it, which ran much deeper than which politicians were in office. Another government came to power while the demonstrators were still dazed at their own success—and business as usual resumed.</p>

    <p>During the buildup to the 2011 revolution in Egypt, Mubarak repeatedly offered what the demonstrators had been demanding a couple days earlier; but as the situation on the streets intensified, the participants became more and more implacable. Had Mubarak offered more, sooner, he might still be in power today. Indeed, the Egyptian revolution ultimately failed not because it asked for too much, but because it didn’t go far enough: in unseating the dictator but leaving the infrastructure of the army and the “deep state” in place, revolutionaries left the door open for <a href="https:/images/tahriricn.wordpress.com/2013/07/09/egypt-goodbye-welcome-my-revolutionegypt-the-military-the-brotherhood-tamarod/">new despots</a> to consolidate power. For the revolution to succeed, they would have had to demolish the architecture of the state itself while everyone was still in the streets and the window of possibility remained open. “The people demand the fall of the regime” offered a convenient platform for much of Egypt to rally around, but did not prepare them to take on the regimes that followed.</p>

    <div class="bigimage">
      <img src="http://www.crimethinc.com/texts/r/demands/images/demand1370.jpg">
      <div class="bigimagecaption">
        <p>It only worked in Egypt because they didn’t just ask.</p>
      </div>
    </div>

    <p>In Brazil in 2013, the MPL (Movimento Passe Livre) helped catalyze <a href="http://www.crimethinc.com/texts/recentfeatures/brazilpt2.php">massive protests</a> against an increase in the cost of public transportation; this is one of the only recent examples of a movement that succeeded in getting its demands met. Millions of people took to the streets, and the twenty-cent fare hike was canceled. Brazilian activists wrote and lectured about the importance of <a href="http://occupywallstreet.net/story/20-cents-everything-else-%E2%80%94-struggle-narrative-brazil">setting concrete and achievable demands</a>, in order to build up momentum by incremental victories. Next, they hoped to force the government to make transportation free.</p>

    <p>Why did their campaign against the fare hike succeed? At the time, Brazil was one of the few nations worldwide with an ascendant economy; it had benefitted from the global economic crisis by drawing investment dollars away from the volatile North American market. Elsewhere—in Greece, Spain, and even the United States—governments had their backs to the wall no less than anti-austerity protesters, and could not have granted their demands even if they wished to. It was not for want of specific demands that no other movement was able to achieve such concessions.</p>

    <p>Scarcely a year and a half later, when the streets had emptied out and the police had reasserted their power, the Brazilian government introduced <a href="http://globalvoicesonline.org/2015/01/16/deja-vu-in-brazil-as-police-crack-down-on-protests-against-public-transportation-fare-hikes/">another series of fare hikes</a>—bigger ones this time. The MPL had to start all over again. It turns out you can’t overthrow capitalism one reform at a time.</p>

    <div class="bigimage">
      <img src="http://www.crimethinc.com/texts/r/demands/images/brazil1370.jpg">
      <div class="bigimagecaption">
        <p>Protesting the transportation fare increase in Brazil: a concrete demand, but a Sisyphean struggle.</p>
      </div>
    </div>

    <h2>If you want to win concessions, aim beyond the target.</h2>

    <p>Even if all you want is to bring about a few minor adjustments in the status quo, it is still a wiser strategy to set out to achieve structural change. Often, to accomplish small concrete objectives, we have to set our sights much higher. Those who refuse to compromise present the authorities with an undesirable alternative to treating with reformists. Someone is always going to be willing to take the position of negotiator—but the more people refuse, the stronger the negotiator’s bargaining position will be. The classic reference point here is the relation between Martin Luther King, Jr. and Malcolm X: if not for the threat implied by Malcolm X, the authorities would not have had such an incentive to parley with Dr. King.</p>

    <p>For those of us who want a truly radical change, there is nothing to be gained by watering down our desires for public consumption. The Overton window—the range of possibilities considered politically viable—is not determined by those at the purported center of the political spectrum, but by the outliers. The broader the distribution of options, the more territory opens up. Others may not immediately join you on the fringes, but knowing that some people are willing to assert that agenda may embolden them to act more ambitiously themselves.</p>

    <p>In purely pragmatic terms, those who embrace a diversity of tactics are stronger, even when it comes to achieving small victories, than those who try to limit themselves and others and to exclude those who refuse to be limited. On the other hand, from the perspective of long-term strategy, the most important thing is not whether we achieve any particular immediate result, but how each engagement positions us for the next round. If we endlessly defer the questions we really want to ask, the right moment will never arrive. We don’t just need to win concessions; we need to develop capabilities.</p>

    <h2>Doing without demands doesn’t mean ceding the space of political discourse.</h2>

    <p>Perhaps the most persuasive argument in favor of making concrete demands is that if we don’t make them, others will—hijacking the momentum of our organizing to advance their own agendas. What if, because we fail to present demands, people end up consolidating around a liberal reformist platform—or, as in many parts of Europe today, a right-wing nationalist agenda?</p>

    <p>Certainly, this illustrates the danger of failing to express our visions of transformation to those with whom we share the streets. It is a mistake to escalate our tactics without communicating about our goals, as if all confrontation necessarily tended in the direction of liberation. In <a href="http://www.crimethinc.com/texts/ux/ukraine.html">Ukraine</a>, where the same tensions and momentum that had given rise to the Arab Spring and Occupy produced a nationalist revolution and civil war, we see how even fascists can appropriate our organizational and tactical models for their own purposes.</p>

    <p>But this is hardly an argument to address demands to the authorities. On the contrary, if we always conceal our radical desires within a common reformist front for fear of alienating the general public, those who are impatient for real change will be all the more likely to run into the arms of nationalists and fascists, as the only ones openly seeking to challenge the status quo. We need to be explicit about what we want and how we intend to go about getting it. Not in order to force our methodology on everyone, as authoritarian organizers do, but to offer an opportunity and example to everyone else who is looking for a way forward. Not to present a demand, but because this is the opposite of a demand: we want self-determination, something no one can give us.</p>


    <div class="bigimage">
      <img src="http://www.crimethinc.com/texts/r/demands/images/graffiti1370.jpg">
      <div class="bigimagecaption">
        <p>Graffiti in London, 2012, reprising a slogan from the May 1968 uprising in Paris.</p>
      </div>
    </div>


    <h2>If not demands, then what?</h2>

    <p>The way we analyze, the way we organize, the way we fight—these should speak for themselves. They should serve as an invitation to join us in a different way of doing politics, based in direct action rather than petitioning. The people in Ferguson and Baltimore who responded to the murders of Michael Brown and Freddie Gray by physically confronting the police did more to force the issue of police violence than decades of pleading for community oversight. Seizing spaces and redistributing resources, we sidestep the senselessly circuitous machinery of representation. If we must send a message to the authorities, let it be this single, simple demand: <em>Don’t mess with us.</em>
    </p>

    <p>Instead of making demands, let’s start setting objectives. The difference is that we set objectives on our own terms, at our own pace, as opportunities arise. They need not be framed within the logic of the ruling powers, and their realization does not depend upon the goodwill of the authorities. The essence of reformism is that even when you win something, you don’t retain control over it. We should be developing the power to act on our own terms, independent of the institutions we are taking on. This is a long-term project, and an urgent one.</p>

    <p>In pursuing and achieving objectives, we develop the capacity to seek more and more ambitious goals. This stands in stark contrast to the way reformist movements tend to collapse when their demands are realized or shown to be unrealistic. Our movements will be stronger if they can accommodate a variety of objectives, so long as those do not openly conflict. When we understand each other’s objectives, it is possible to identify where it makes sense to cooperate, and where it doesn’t—a kind of clarity that does not result from lining up behind a lowest-common-denominator demand.</p>

    <p>From this vantage point, we can see that choosing not to make demands is not necessarily a sign of political immaturity. On the contrary, it can be a savvy refusal to fall into the traps that disabled the previous generation. Let’s learn our own strength, outside the cages and queues of representational politics—beyond the politics of demands.</p>

    <aside class="bottompull">
      <blockquote>
        <strong>“Perhaps, however, the moral of the story (and the hope of the world) lies in what one demands, not of others, but of oneself.”<br />–James Baldwin,<br />
          <em>No Name in the Street</em>
        </strong>
      </blockquote>
    </aside>

    <div class="smallimage">
      <img class="bottomsmall" src="http://www.crimethinc.com/texts/r/demands/images/taksim1370.jpg" />
    </div>

    <div class="footnote">
      <p>
        <a name="1">
        </a>
        <span class="footref">1. </span>When was the last time 400,000 people were <em>anywhere</em> in New York without the police arresting anyone? That was protest not just as pressure valve, but as active pacification—as a way of diminishing the friction between protesters and the order they oppose. <span class="footreturn">
          <a href="#1return">↩</a>
        </span>
      </p>
    </div>
  }
}

articles << {
  url: "http://www.crimethinc.com/texts/r/democracy/",
  category: "Literature",
  theme: theme,
  title: %q{
    From Democracy to Freedom
  },
  subtitle: %q{
  },
  image: "http://crimethinc.com/texts/r/democracy/images/header2000.jpg",
  content: %q{
    <p>
      <em>This is part of a series expressing <a href="http://www.crimethinc.com/blog/2016/03/16/series-the-anarchist-critique-of-democracy/">an anarchist critique of democracy.</a>
      </em>
      <br />
      <br />
    </p>

    <p style="text-indent: 0px">Democracy is the most universal political ideal of our day. George Bush invoked it to justify invading Iraq; Obama congratulated the rebels of Tahrir Square for bringing it to Egypt; Occupy Wall Street claimed to have distilled its pure form. From the Democratic People’s Republic of North Korea to the autonomous region of Rojava, practically every government and popular movement calls itself democratic. </p>

    <p>And what’s the cure for <a href="http://www.economist.com/news/essays/21596796-democracy-was-most-successful-political-idea-20th-century-why-has-it-run-trouble-and-what-can-be-do">the problems with democracy</a>? Everyone agrees: <a href="http://www.redpepper.org.uk/democracy-is-dead-long-live-democracies/">more democracy.</a> Since the turn of the century, we’ve seen a spate of new movements promising to deliver <em>real</em> democracy, in contrast to ostensibly democratic institutions that they describe as exclusive, coercive, and alienating.
    </p>

    <p>Is there a common thread that links all these different kinds of democracy? Which of them is the <em>real</em> one? Can any of them deliver the inclusivity and freedom we associate with the word?</p>

    <p>Impelled by our own experiences in directly democratic movements, we’ve returned to these questions. Our conclusion is that the dramatic imbalances in economic and political power that have driven people into the streets from New York City to Sarajevo are not incidental defects in specific democracies, but structural features dating back to the origins of democracy itself; they appear in practically every example of democratic government through the ages. Representative democracy preserved all the bureaucratic apparatus that was originally invented to serve kings; direct democracy tends to recreate it on a smaller scale, even outside the formal structures of the state. <em>Democracy is not the same as self-determination.</em>
    </p>

    <p>To be sure, many good things are regularly described as democratic. This is not an argument against discussions, collectives, assemblies, networks, federations, or working with people you don’t always agree with. The argument, rather, is that when we engage in those practices, if we understand what we are doing as <em>democracy</em>—as a form of participatory government rather than a collective practice of freedom—then sooner or later, we will recreate all the problems associated with less democratic forms of government. This goes for representative democracy and direct democracy alike, and even for consensus process.
    </p>

    <p>Rather than championing democratic procedures as an end in themselves, then, let’s return to the values that drew us to democracy in the first place: egalitarianism, inclusivity, the idea that each person should control her own destiny. If democracy is not the most effective way to actualize these, what is?</p>

    <p>As fiercer and fiercer struggles rock today’s democracies, the stakes of this discussion keep getting higher. If we go on trying to replace the prevailing order with a more participatory version of the same thing, we’ll keep ending up right back where we started, and others who share our disillusionment will gravitate towards more authoritarian alternatives. We need a framework that can fulfill the promises democracy has betrayed.
    </p>

    <p>In the following text, we examine the common threads that connect different forms of democracy, trace the development of democracy from its classical origins to its contemporary representative, direct, and consensus-based variants, and evaluate how democratic discourse and procedures serve the social movements that adopt them. Along the way, we outline what it would mean to seek freedom directly rather than through democratic rule.
    </p>

    <p>This project is the result of years of transcontinental dialogue. To complement it, <a href="http://www.crimethinc.com/blog/2016/03/16/series-the-anarchist-critique-of-democracy/">we are publishing</a> case studies from participants in movements that have been promoted as models of direct democracy: 15M in Spain (2011), the occupation of Syntagma Square in Greece (2011), Occupy in the United States (2011&#8211;2012), the Slovenian uprising (2012&#8211;2013), the plenums in Bosnia (2014), and the Rojava revolution (2012&#8211;2016).
    </p>

    <div class="smallimage">
      <img src="http://www.crimethinc.com/texts/r/democracy/images/bridge.gif">
    </div>

    <h2>What Is Democracy?</h2>

    <p>What is democracy, exactly? Most of the <a href="http://www.oxforddictionaries.com/us/definition/american_english/democracy">textbook definitions</a> have to do with majority rule or government by elected representatives. On the other hand, a few radicals <a href="http://www.revolutionbythebook.akpress.org/ak-tactical-media/pamphlet-no-2/">have argued</a> that “real” democracy only takes place outside and against the state’s monopoly on power. Should we understand democracy as a set of decision-making procedures with a specific history, or as a general aspiration to egalitarian, inclusive, and participatory politics?</p>

    <aside>
      <blockquote class="accent">“What is democracy?”<br />
        <br />
        “Well, I was never very clear on it, myself. Like every other kind of government, it’s got something to do with young men killing each other, I believe.”<br />
        <p class="attribution">– <em>Johnny Got His Gun</em> (1971)</p>
      </blockquote>
    </aside>

    <p>To pin down the object of our critique, let’s start with the term itself. The word democracy derives from the ancient Greek <em>dēmokratía,</em> from <em>dêmos</em> “people” and <em>krátos</em> “power.” This formulation of <em>rule by the people,</em> which has resurfaced in Latin America as <a href="http://rosogrimau.blogspot.com/2010/02/concepto-de-poder-popular-para-el.html">
      <em>poder popular,</em>
    </a> begs the question: which people? And what kind of power?</p>

    <p>These root words, <em>demos</em> and <em>kratos,</em> suggest two common denominators of all democracy: a way of determining who participates in the decision-making, and a way of enforcing decisions. Citizenship, in other words, and policing. These are the essentials of democracy; they are what make it a form of government. Anything short of that is more properly described as <em>anarchy</em>—the absence of government, from the Greek <em>an-</em> “without” and <em>arkhos</em> “ruler.”</p>

    <h6>
      Common denominators of democracy:
      <br />
      <br />
      a way of determining who participates in making decisions<br />(<em>demos</em>)<br />
      <br />
      a way of enforcing decisions<br />(<em>kratos</em>)<br />
      <br />
      a space of legitimate decision-making<br />(<em>polis</em>)<br />
      <br />
      and the resources that sustain it<br />(<em>oikos</em>)
    </h6>

    <p>Who qualifies as <em>demos?</em> <a href="http://theanarchistlibrary.org/library/coordination-of-anarchist-groups-against-democracy#toc5">Some have argued</a> that etymologically, <em>demos</em> never meant <em>all</em> people, but only particular social classes. Even as its partisans have trumpeted its supposed inclusivity, in practice democracy has always demanded <a href="http://polisci.berkeley.edu/sites/default/files/people/u3868/Song%20-%20Boundary%20Problem%20in%20Democratic%20Theory.pdf">a way of distinguishing between included and excluded.</a> That could be status in the legislature, voting rights, citizenship, membership, race, gender, age, or participation in street assemblies; but in every form of democracy, for there to be legitimate decisions, there have to be formal conditions of legitimacy, and a defined group of people who meet them.
    </p>

    <p>In this regard, democracy institutionalizes the provincial, chauvinist character of its Greek origins, at the same time as it seemingly offers a model that could involve all the world. This is why democracy has proven so compatible with nationalism and the state; it presupposes the Other, who is not accorded the same rights or political agency.
    </p>

    <p>The focus on inclusion and exclusion is clear enough at the dawn of modern democracy in Rousseau’s influential <em>Of the Social Contract,</em> in which he emphasizes that there is no contradiction between democracy and slavery. The more “evildoers” are in chains, he suggests, the more perfect the freedom of the citizens. Freedom for the wolf is death for the lamb, as Isaiah Berlin later put it. The zero-sum conception of freedom expressed in this metaphor is the foundation of the discourse of rights granted and protected by the state. In other words: for citizens to be free, the state must possess ultimate authority and the capacity to exercise total control. The state seeks to produce sheep, reserving the position of wolf for itself.
    </p>

    <p>By contrast, if we understand <a href="http://www.crimethinc.com/tce/#reconciling">freedom as cumulative,</a> the freedom of one person becomes the freedom of all: it is not simply a question of being protected by the authorities, but of intersecting with each other in a way that maximizes the possibilities for everyone. In this framework, the more that coercive force is centralized, the less freedom there can be. This way of conceiving freedom is social rather than individualistic: it approaches liberty as a collectively produced relationship to our potential, not a static bubble of private rights.<sup class="footlink">
      <a href="#1" name="1return">1</a>
    </sup>
    <sup class="refnumber">1</sup>
    <small>
      <span class="fnumber">1.</span> “I am truly free only when all human beings, men and women, are equally free. The freedom of others, far from negating or limiting my freedom, is, on the contrary, its necessary premise and confirmation.” –Mikhail Bakunin</small>
    </p>

    <p>Let’s turn to the other root, <em>kratos.</em> Democracy shares this suffix with aristocracy, autocracy, bureaucracy, plutocracy, and technocracy. Each of these terms describes government by some subset of society, but they all share a common logic. That common thread is <em>kratos,</em> power. </p>

    <p>What kind of power? Let’s consult the ancient Greeks once more.
    </p>

    <p>In classical Greece, every abstract concept was personified by a divine being. <a href="http://www.theoi.com/Daimon/Kratos.html">Kratos</a> was an implacable Titan embodying the kind of coercive force associated with state power. One of the oldest sources in which Kratos appears is the play <em>Prometheus Bound,</em> composed by Aeschylus in the early days of Athenian democracy. The play opens with Kratos forcibly escorting the shackled Prometheus, who is being punished for stealing fire from the gods to give to humanity. Kratos appears as a jailer unthinkingly carrying out Zeus’s orders—a brute <a href="https://books.google.com/books?id=6DoBAAAAMAAJ&amp;pg=PA9&amp;lpg=PA9&amp;dq=%E2%80%9Cmade+for+any+tyrant%E2%80%99s+acts%E2%80%9D&amp;source=bl&amp;ots=j7NtRwRrhn&amp;sig=z0UMob5UjQXxkTHSsqBY2idFNek&amp;hl=en&amp;sa=X&amp;ved=0ahUKEwi_hprLybjKAhUX3GMKHcOiAgQQ6AEIJjAD#v=onepage&amp;q=%E2%80%9Cmade%20for%20any%20tyrant%E2%80%99s%20acts%E2%80%9D&amp;f=false">“made for any tyrant’s acts.”</a>
    </p>

    <p>The sort of force personified by Kratos is what democracy has in common with autocracy and every other form of rule. They share the institutions of coercion: the legal apparatus, the police, and the military, all of which preceded democracy and have repeatedly outlived it. These are the tools “made for any tyrant’s acts,” whether the tyrant at the helm is a king, a class of bureaucrats, or “the people” themselves. “Democracy means simply the bludgeoning of the people by the people for the people,” as Oscar Wilde put it. <a href="http://www.mathaba.net/gci/theory/gb1.htm">Mu’ammer al Gaddafi</a> echoed this approvingly a century later, without irony: <em>“Democracy is the supervision of the people by the people.”</em>
    </p>

    <p>In modern-day Greek, <em>kratos</em> is simply the word for state. To understand democracy, we have to look closer at government itself. </p>

    <aside>
      <blockquote class="accent">“There is no contradiction between exercising democracy and legitimate central administrative control according to the well-known balance between centralization and democracy… Democracy consolidates relations among people, and its main strength is respect. The strength that stems from democracy assumes a higher degree of adherence in carrying out orders with great accuracy and zeal.”<br />
        <p class="attribution">– Saddam Hussein, <a href="https://www.brainpickings.org/2012/10/02/saddam-hussein-speeches-on-democracy-1977-1978/">“Democracy: A Source of Strength for the Individual and Society”</a>
        </p>
      </blockquote>
    </aside>

    <div class="smallimage">
      <img src="http://www.crimethinc.com/texts/r/democracy/images/declarewar.gif">
    </div>

    <h2>Monopolizing Legitimacy</h2>

    <aside>
      <blockquote class="accent">
        “As in absolute governments the King is law, so in free countries the law ought to be King.”<br />
        <p class="attribution">
          – Thomas Paine, <a href="http://www.ushistory.org/paine/commonsense/singlehtml.htm">
            <em>Common Sense</em>
          </a>
        </p>
      </blockquote>
    </aside>


    <p style="text-indent: 0px">As a form of government, democracy offers a way to produce a single order out of a cacophony of desires, absorbing the resources and activities of the minority into policies dictated by the majority. In any democracy, there is a legitimate space of decision-making, distinct from the rest of life. It could be a congress in a parliament building, or a general assembly on a sidewalk, or an app soliciting votes via iPhone. In every case, it is not our immediate needs and desires that are the ultimate source of legitimacy, but a particular decision-making process and protocol. In a state, this is called <a href="http://democracyweb.org/node/63">“the rule of law,”</a> though the principle does not necessarily require a formal legal system.
    </p>

    <p>This is the essence of government: decisions made in one space determine what can take place in all other spaces. The result is alienation—the friction between what is decided and what is lived.
    </p>

    <p>Democracy promises to solve this problem by incorporating everyone into the space of decision-making: the rule of all by all. <a href="http://www.ait.org.tw/infousa/zhtw/DOCS/whatsdem/whatdm4.htm">“The citizens of a democracy submit to the law because they recognize that, however indirectly, they are submitting to themselves as makers of the law.”</a> But if all those decisions were actually made by the people they impact, there would be no need for a means of enforcing them. </p>

    <aside>
      <blockquote class="accent">
        “The great difficulty lies in this: you must first enable the government to control the governed; and in the next place oblige it to control itself.”<br />
        <p class="attribution">
          – James Madison, <a href="http://www.constitution.org/fed/federa51.htm">
            <em>The Federalist</em>
          </a>
        </p>
      </blockquote>
    </aside>

    <p>What protects the minorities in this winner-take-all system? Advocates of democracy explain that minorities will be protected by institutional provisions—“checks and balances.” In other words, the same structure that holds power over them is supposed to protect them from itself.<sup class="footlink">
      <a href="#2" name="2return">2</a>
    </sup>
    <sup class="refnumber">2</sup>
    <small>
      <span class="fnumber">2.</span> This seeming paradox didn’t trouble the framers of the US Constitution because the minority whose rights they were chiefly concerned with protecting was the class of property owners—who already had plenty of leverage on state institutions. As James Madison <a href="http://avalon.law.yale.edu/18th_century/yates.asp">said in 1787,</a> “Our government ought to secure the permanent interests of the country against innovation. Landholders ought to have a share in the government, to support these invaluable interests, and to balance and check the other. They ought to be so constituted as to protect the minority of the opulent against the majority.”</small> In this approach, <a href="http://econfaculty.gmu.edu/wew/articles/fee/democracy.htm">democracy and personal freedom are conceived as fundamentally at odds:</a> to preserve freedom for individuals, a government must be able to take freedom away from everyone. Yet it is optimistic indeed to trust that institutions will always be better than the people who maintain them. The more power we vest in government in hopes of protecting the marginalized, the more dangerous it can be when it is turned against them.
    </p>

    <p>How much do you buy into the idea that the democratic process should trump your own conscience and values? Let’s try a quick exercise. Imagine yourself in a democratic republic with slaves—say, ancient Athens, or ancient Rome, or the United States of America until the end of 1865. Would you obey the law and treat people as property while endeavoring to change the laws, knowing full well that whole generations might live and die in chains in the meantime? Or would you act according to your conscience in defiance of the law, like <a href="http://www.biography.com/people/harriet-tubman-9511430">Harriet Tubman</a> and <a href="http://www.theatlantic.com/magazine/archive/2005/05/the-man-who-ended-slavery/303915/">John Brown</a>?</p>

    <p>If you would follow in the footsteps of Harriet Tubman, then you, too, believe that there is something more important than the rule of law. This is a problem for anyone who wants to make conformity with the law or with the will of the majority into the final arbiter of legitimacy.
    </p>

    <aside>
      <blockquote class="accent">“Can there not be a government in which majorities do not virtually decide right and wrong, but conscience?”<br />
        <p class="attribution">– Henry David Thoreau, <em>Civil Disobedience</em>
        </p>
      </blockquote>
    </aside>

    <div class="smallimage">
      <img src="http://www.crimethinc.com/texts/r/democracy/images/jury.gif">
      <div class="smallimagecaption longcaption" style="background-color: black;">
        <p>“This is a democracy not an anarchy. We have a system in the country to change rules. When you are on the Supreme Court, you can make that decision.” –<a href="https://drugs-forum.com/forum/showthread.php?t=17053">Robert Stutman</a>
        </p>
      </div>
    </div>

    <h2>The Original Democracy</h2>



    <p>In ancient Athens, the much-touted “birthplace of democracy,” we already see the exclusion and coercion that have been essential features of democratic government ever since. Only adult male citizens with military training could vote; women, slaves, debtors, and all who lacked Athenian blood were excluded. At the very most, democracy involved less than a fifth of the population.
    </p>

    <p>Indeed, slavery was <a href="https://books.google.co.uk/books?id=ATq5_6h2AT0C&amp;pg=PA313">more prevalent</a> in ancient Athens than in other Greek city states, and women <a href="https://books.google.co.uk/books?id=-U6IAgAAQBAJ&amp;pg=PA15">had fewer rights</a> relative to men. Greater equality among male citizens apparently meant greater solidarity against women and foreigners. The space of participatory politics was a gated community.
    </p>

    <p>We can map the boundaries of this gated community in the Athenian opposition between public and private—between <a href="http://www.minorcompositions.info/wp-content/uploads/2012/10/contractandcontagion-web.pdf">
      <em>polis</em> and <em>oikos.</em>
    </a> The <em>polis,</em> the Greek city-state, was a space of public discourse where citizens interacted as equals. By contrast, the <em>oikos,</em> the household, was a hierarchical space in which male property owners ruled supreme—a zone outside the purview of the political, yet serving as its foundation. In this dichotomy, the <em>oikos</em> represents everything that provides the resources that sustain politics, yet is taken for granted as preceding and therefore outside it.
    </p>

    <p>These categories remain with us today. The words “politics” (“the affairs of the city”) and “police” (“the administration of the city”) come from <em>polis,</em> while “economy” (“the management of the household”) and “ecology” (“the study of the household”) derive from <em>oikos.</em>
    </p>

    <p>Democracy is still premised on this division. As long as there is a political distinction between public and private, everything from the household (the gendered space of intimacy that sustains the prevailing order with invisible and unpaid labor<sup class="footlink">
    <a href="#3" name="3return">3</a>
    </sup>
    <sup class="refnumber">3</sup>
    <small>
    <span class="fnumber">3.</span> In this context, arguing that “the personal is political” constitutes a feminist rejection of the dichotomy between <em>oikos</em> and <em>polis.</em> But if this argument is understood to mean that the personal, too, should be subject to democratic decision-making, it only extends the logic of government into additional aspects of life. The real alternative is to affirm <em>multiple sites of power,</em> arguing that legitimacy should not be confined to any one space, so decisions made in the household are not subordinated to those made in the sites of formal politics.</small>) to entire continents and peoples (like <a href="https://en.wikipedia.org/wiki/Congo_Free_State#Mutilation">Africa during the colonial period</a>—or even <a href="http://www.socialjusticejournal.org/archive/92_30_2/92_04Wilderson.pdf">blackness itself</a>) may be relegated outside the sphere of politics. Likewise, the institution of property and the market economy it produces, which have served as the substructure of democracy since its origins, are placed beyond question at the same time as they are enforced and defended by the political apparatus.
    </p>

    <div class="smallimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/theslaves.gif">
    </div>

    <p>Fortunately, ancient Athens is not the only reference point for egalitarian decision-making. A cursory survey of other societies reveals plenty of other examples, many of which are not predicated on exclusivity or coercion. But should we understand these as <em>democracies,</em> too?</p>

    <aside>
    <blockquote class="accent">“Are we supposed to believe that before the Athenians, it never really occurred to anyone, anywhere, to gather all the members of their community in order to make joint decisions in a way that gave everyone equal say?”<br />
      <p class="attribution">– David Graeber, <a href="http://www.eleuthera.it/files/materiali/David_Graeber_Fragments_%20Anarchist_Anthropology.pdf">
        <em>Fragments of an Anarchist Anthropology</em>
      </a>
    </p>
    </blockquote>
    </aside>

    <p>In his <a href="http://www.eleuthera.it/files/materiali/David_Graeber_Fragments_%20Anarchist_Anthropology.pdf">
    <em>Fragments of an Anarchist Anthropology,</em>
    </a> David Graeber takes his colleagues to task for identifying Athens as the origin of democracy; he surmises that the Iroquois, Berber, Sulawezi, or Tallensi models do not receive as much attention simply because none of them center around voting. On one hand, Graeber is right to direct our attention to societies that focus on building consensus rather than practicing coercion: many of these embody the best values associated with democracy much more than ancient Athens did. On the other hand, it doesn’t make sense for us to label these examples truly democratic while questioning the democratic credentials of the Greeks who invented the term. This is still ethnocentricism: affirming the value of non-Western examples by granting them honorary status in our own admittedly inferior Western paradigm. Instead, let’s concede that democracy, as a specific historical practice dating from <a href="http://www.rangevoting.org/SpartaBury.html">Sparta</a> and Athens and emulated worldwide, has not lived up to the standard set by many of these other societies, and it does not make sense to describe them as democratic. It would be more responsible, and more precise, to describe and honor them in their own terms. </p>

    <p>That leaves us with Athens as the original democracy, after all. What if Athens became so influential not because of how free it was, but because of how it harnessed participatory politics to the power of the state? At the time, most societies throughout human history had been stateless; some were hierarchical, others were horizontal, but no stateless society had the centralized power of <em>kratos.</em> The states that existed, by contrast, were hardly egalitarian. The Athenians innovated a hybrid format in which horizontality coincided with exclusion and coercion. If you take it for granted that the state is desirable or at least inevitable, this sounds appealing. But if the state is the root of the problem, then the slavery and patriarchy of ancient Athens were not early irregularities in the democratic model, but indications of the power imbalances coded into its DNA from the beginning.
    </p>

    <div class="bigimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/trojan1370.jpg">
    <div class="bigimagecaption">
    <p>Democracy is a Trojan horse bearing the power imbalances inherent in the state into the <em>polis</em> in the guise of self-determination.
    </p>
    </div>
    </div>

    <h2>Representative Democracy—A Market for Power</h2>

    <p>The US government has more in common with the republic of ancient Rome than with Athens. Rather than governing directly, Roman citizens elected representatives to head up a complex bureaucracy. As Roman territory expanded and wealth flooded in, small farmers lost their footing and massive numbers of the dispossessed flooded the capital; unrest forced the Republic to extend voting rights to wider and wider segments of the population, yet political inclusion did little to counteract the economic stratification of Roman society. All this sounds eerily familiar.
    </p>

    <p>The Roman Republic came to an end when Julius Caesar seized power; from then on, Rome was ruled by emperors. Yet very little changed for the average Roman. The bureaucracy, the military, the economy, and the courts continued to function the same as before.
    </p>

    <aside>
    <blockquote class="accent">“Those persons who believe in the sharpest distinction between democracy and monarchy can scarcely appreciate how a political institution may go through so many transformations and yet remain the same. Yet a swift glance must show us that in all the evolution of the English monarchy, with all its broadenings and its revolutions, and even with its jump across the sea into a colony which became an independent nation and then a powerful State, the same State functions and attitudes have been preserved essentially unchanged.”
    <p class="attribution">– Randolph Bourne, <a href="http://fair-use.org/randolph-bourne/the-state/">
      <em>The State</em>
    </a>
    </p>
    </blockquote>
    </aside>


    <p>Fast-forward eighteen centuries to the American Revolution. Outraged about “taxation without representation,” North American subjects of the British Empire rebelled and established a representative democracy of their own,<sup class="footlink">
    <a href="#4" name="4return">4</a>
    </sup>
    <sup class="refnumber">4</sup>
    <small>
    <span class="fnumber">4.</span> This is a fundamental paradox of democratic governments: established by a crime, they sanctify law—legitimizing a new ruling order as the fulfillment and continuation of a revolt.</small> soon complete with a Roman-style Senate. Yet once again, the function of the state remained unchanged. Those who had fought to throw off the king discovered that taxation <em>with</em> representation was little different. The result was a series of uprisings—<a href="https://books.google.com/books?id=ScXpRj6su8EC&amp;pg=PA104#v=onepage&amp;q&amp;f=false">Shay’s Rebellion,</a> the <a href="http://www.gilderlehrman.org/history-by-era/early-republic/resources/whiskey-rebellion-1794">Whisky Rebellion</a>, <a href="https://books.google.com/books?id=sGM4-0mWII8C&amp;pg=PA94">Fries&#8217;s Rebellion</a>, and more—all of which were brutally suppressed. The new democratic government succeeded in pacifying the population where the British Empire had failed, thanks to the loyalty of many who had revolted against the king: for didn’t this new government <em>represent</em> them?<sup class="footlink">
    <a href="#5" name="5return">5</a>
    </sup>
    <sup class="refnumber">5</sup>
    <small>
    <span class="fnumber">5.</span> “Obedience to the law is true liberty,” reads <a href="http://www.jstor.org/stable/2563945?seq=1#page_scan_tab_contents">one memorial</a> to the soldiers who suppressed Shay’s Rebellion.</small>
    </p>

    <p>This story has been repeated time and time again. In the French revolution of 1848, the provisional government’s prefect of police entered the office vacated by the king’s prefect of police and took up the same papers his predecessor had just set down. In the 20th century transitions from dictatorship to democracy in <a href="https://www.youtube.com/watch?v=DH08njM1Aw0">Greece</a>, <a href="https://books.google.com/books?id=CrOS_8S4QDcC&amp;pg=PA6#v=onepage&amp;q&amp;f=false">Spain</a>, and <a href="http://crimethinc.com/movies/chicago.html">Chile,</a> and more recently in <a href="http://www.france24.com/en/20160121-tunisia-police-riots-clash-job-protests?">Tunisia</a> and <a href="https://tahriricn.wordpress.com/2013/07/09/egypt-goodbye-welcome-my-revolutionegypt-the-military-the-brotherhood-tamarod/">Egypt,</a> social movements that overthrew dictators had to go on fighting against the very same police under the democratic regime. This is <em>kratos,</em> what some have called the <a href="http://billmoyers.com/2014/02/21/anatomy-of-the-deep-state/">Deep State</a>, carrying over from one regime to the next.
    </p>

    <p>Laws, courts, prisons, intelligence agencies, tax collectors, armies, police—most of the instruments of coercive power that we consider oppressive in a monarchy or a dictatorship operate the same way in a democracy. Yet when we’re permitted to cast ballots about who supervises them, we’re supposed to regard them as <em>ours,</em> even when they’re used against us. This is the great achievement of two and a half centuries of democratic revolutions: instead of abolishing the means by which kings governed, they rendered those means <em>popular.</em>
    </p>

    <aside>
    <blockquote class="accent">“A Constituent Assembly is the means used by the privileged classes, when a dictatorship is not possible, either to prevent a revolution, or, when a revolution has already broken out, to stop its progress with the excuse of legalizing it, and to take back as much as possible of the gains that the people had made during the insurrectional period.”<br />
    <p class="attribution">– Errico Malatesta, <a href="http://dwardmac.pitzer.edu/Anarchist_Archives/malatesta/against.html">“Against the Constituent Assembly as against the Dictatorship”</a>
    </p>
    </blockquote>
    </aside>

    <p>The transfer of power from rulers to assemblies has served to prematurely halt revolutionary movements ever since the American Revolution. Rather than making the changes they sought via direct action, the rebels entrusted that task to their new representatives at the helm of the state—only to see <a href="https://www.ohio.edu/chastain/ip/junedays.htm">their dreams betrayed.</a>
    </p>

    <p>The state is powerful indeed, but one thing it cannot do is deliver freedom to its subjects. It cannot, because it derives its very being from their subjection. It can subject others, it can commandeer and concentrate resources, it can impose dues and duties, it can dole out rights and concessions—the consolation prizes of the governed—but it cannot offer self-determination. <em>Kratos</em> can dominate, but it cannot liberate.
    </p>

    <p>Instead, representative democracy promises the opportunity to rule each other on a rotating basis: a distributed and temporary kingship as diffuse, dynamic, and yet hierarchical as the stock market. In practice, since this rule is delegated, there are still rulers who wield tremendous power relative to everyone else. Usually, like the Bushes and Clintons, they hail from a de facto ruling class. This ruling class tends to occupy the upper echelons of all the other hierarchies of our society, both formal and informal. Even if a politician grew up among the plebs, the more he exercises authority, the more his interests diverge from those of the governed. Yet the real problem is not the intentions of politicians; it is the apparatus of the state itself.
    </p>

    <p>Competing for the right to direct the coercive power of the state, the contestants never question the value of the state itself, even if in practice they only find themselves on the receiving end of its force. Representative democracy offers a pressure valve: when people are dissatisfied, they set their sights on the next elections, taking the state itself for granted. Indeed, if you want to put a stop to corporate profiteering or environmental devastation, isn’t the state the only instrument powerful enough to accomplish that? Never mind that it was state that established the conditions in which those are possible in the first place.
    </p>



    <div class="bigimage" style="background-color: white;">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/fightingfor2000.gif">
    </div>


    <aside>
    <blockquote class="accent">“Free election of masters does not abolish the masters or the slaves. Free choice among a wide variety of goods and services does not signify freedom if these goods and services sustain social controls over a life of toil and fear—that is, if they sustain alienation. And the spontaneous reproduction of superimposed needs by the individual does not establish autonomy; it only testifies to the efficacy of the controls.”<br />
    <p class="attribution">– Herbert Marcuse, <em>One-Dimensional Man</em>
    </p>
    </blockquote>
    </aside>

    <p>So much for democracy and political inequality. What about the economic inequality that has attended democracy since the beginning? You would think that a system based on majority rule would tend to reduce the disparities between rich and poor, seeing as the poor constitute the majority. Yet, just as in ancient Rome, the current ascendancy of democracy is matched by enormous gulfs between the haves and the have-nots. How can this be?</p>

    <p>Just as capitalism succeeded feudalism in Europe, representative democracy proved more sustainable than monarchy because it offered mobility within the hierarchies of the state. The dollar and the ballot are both mechanisms for distributing power hierarchically in a way that takes pressure off the hierarchies themselves. In contrast to the political and economic stasis of the feudal era, capitalism and democracy ceaselessly reapportion power. Thanks to this dynamic flexibility, the potential rebel has better odds of improving his status within the prevailing order than of toppling it. Consequently, opposition tends to reenergize the political system from within rather than threatening it.
    </p>

    <p>Representative democracy is to politics what capitalism is to economics. The desires of the consumer and the voter are represented by currencies that promise individual empowerment yet relentlessly concentrate power at the top of the social pyramid. As long as power is concentrated there, it is easy enough to block, buy off, or destroy anyone who threatens the pyramid itself.
    </p>

    <p>This explains why, when the wealthy and powerful have seen their interests challenged through the institutions of democracy, they have been able to suspend the law to deal with the problem—witness the gruesome fates of <a href="http://penelope.uchicago.edu/Thayer/E/Roman/Texts/Appian/Civil_Wars/1*.html#18">the brothers Gracchi</a> in ancient Rome and <a href="http://nsarchive.gwu.edu/NSAEBB/NSAEBB8/nsaebb8i.htm">Salvador Allende</a> in modern Chile. Within the framework of the state, property has always trumped democracy.<sup class="footlink">
    <a href="#6" name="6return">6</a>
    </sup>
    <sup class="refnumber">6</sup>
    <small>
    <span class="fnumber">6.</span> Just as the “libertarian” capitalist suspects that the activities of even the most democratic government interfere with the pure functioning of the free market, the partisan of pure democracy can be sure that as long as there are economic inequalities, the wealthy will always wield disproportionate influence over even the most carefully constructed democratic process. Yet government and economy are inseparable. The market relies upon the state to enforce property rights, while at bottom, democracy is a means of transferring, amalgamating, and investing political power: it is a market for agency itself.</small>
    </p>

    <aside>
    <blockquote class="accent">“In representative democracy as in capitalist competition, everyone supposedly gets a chance but only a few come out on top. If you didn&#8217;t win, you must not have tried hard enough! This is the same rationalization used to justify the injustices of sexism and racism: look, you lazy bums, you could have been Bill Cosby or Hillary Clinton if you&#8217;d just worked harder. But there&#8217;s not enough space at the top for all of us, no matter how hard we work.<br />
    <br />

    When reality is generated via the media and media access is determined by wealth, elections are simply advertising campaigns. Market competition dictates which lobbyists gain the resources to determine the grounds upon which voters make their decisions. Under these circumstances, a political party is essentially a business offering investment opportunities in legislation. It&#8217;s foolish to expect political representatives to oppose the interests of their clientele when they depend directly upon them for power.”<br />
    <p class="attribution">– <a href="http://www.crimethinc.com/books/work.html">
      <em>Work</em>
    </a>
    </p>
    </blockquote>
    </aside>




    <div class="smallimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/fiftyone.gif">
    <div class="smallimagecaption longcaption" style="background-color: black;">
    <p>“Democracy means 100% of the population cooperating to secure 51% of the electorate the right to choose who gets to tell everyone what to do. In practice, of course, that means—me.”</p>
    </div>
    </div>


    <h2>Direct Democracy: Government without the State?</h2>



    <p>That brings us to the present. <a href="http://www.crimethinc.com/blog/2011/02/02/egypt-today-tomorrow-the-world/">Africa</a> and <a href="https://www.amnesty.org/en/latest/news/2015/09/remembering-occupy-hong-kong/">Asia</a> are witnessing new movements in favor of democracy; meanwhile, many people in Europe and the Americas who are disillusioned by the failures of representative democracy have pinned their hopes on direct democracy, shifting from the model of the Roman Republic back to its Athenian predecessor. If the problem is that government is unresponsive to our needs, isn’t the solution to make it more participatory, so we wield power directly rather than delegating it to politicians?</p>

    <p>But what does that mean, exactly? Does it mean <a href="http://www.usnews.com/news/articles/2016-01-25/direct-democracy-may-be-key-to-a-happier-american-democracy">voting on laws</a> rather than legislators? Or toppling the prevailing government and instituting a <a href="https://roarmag.org/magazine/biehl-bookchins-revolutionary-program/">government of federated assemblies</a> in its place? Or something else?</p>

    <aside>
    <blockquote class="accent">“True democracy exists only through the direct participation of the people, and not through the activity of their representatives. Parliaments have been a legal barrier between the people and the exercise of authority, excluding the masses from meaningful politics and monopolizing sovereignty in their place. People are left with only a façade of democracy, manifested in long queues to cast their election ballots.”<br />
    <p class="attribution">– Mu’ammer al Gaddafi, <a href="http://www.mathaba.net/gci/theory/gb1.htm">
    <em>The Green Book</em>
    </a>
    </p>
    </blockquote>
    </aside>

    <p>On one hand, if direct democracy is just a more participatory and time-consuming way to pilot the state, it might offer us more say in the details of government, but it will preserve the centralization of power that is inherent in it. There is a problem of scale here: can we imagine 219 million eligible voters directly conducting the activities of the US government? The conventional answer is that local assemblies would send representatives to regional assemblies, which in turn would send representatives to a national assembly—but there, already, we are speaking about representative democracy again. At best, in place of periodically electing representatives, we can picture a ceaseless series of referendums decreed from on high.
    </p>




    <p>One of the most robust versions of that vision is digital democracy, or <a href="https://en.wikipedia.org/wiki/E-democracy">e-democracy</a>, promoted by groups like the <a href="http://www.pp-international.net/">Pirate Party</a>. The Pirate Party has already been incorporated into the existing political system; but in theory, we can imagine a population linked through digital technology, making all the decisions regarding their society via majority vote in real time. In such an order, majoritarian government would gain a practically irresistible legitimacy; yet the greatest power would likely be concentrated in the hands of the technocrats who <a href="http://www.crimethinc.com/texts/ex/digital-utopia.html">administered the system.</a> Coding the algorithms that determined which information and which questions came to the fore, they would shape the conceptual frameworks of the participants a thousand times more invasively than election-year advertising does today.
    </p>

    <div class="bigimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/electronic1370.jpg">
    <div class="bigimagecaption">
    <p>Electronic democracy.
    </p>
    </div>
    </div>

    <aside>
    <blockquote class="accent">“The digital project of reducing the world to representation converges with the program of electoral democracy, in which only representatives acting through the prescribed channels may exercise power. Both set themselves against all that is incomputable and irreducible, fitting humanity to a Procrustean bed. Fused as electronic democracy, they would present the opportunity to vote on a vast array of minutia, while rendering the infrastructure itself unquestionable—<em>the more participatory a system is, the more ‘legitimate.’”</em>
    <br />
    <p class="attribution">– <a href="http://www.crimethinc.com/texts/ex/digital-utopia.html">
    <em>Deserting the Digital Utopia</em>
    </a>
    </p>
    </blockquote>
    </aside>

    <p>But even if such a system could be made to work perfectly—do we want to retain centralized majoritarian rule in the first place? The mere fact of being participatory does not make a political process any less coercive. As long as the majority has the capacity to force its decisions on the minority, we are talking about a system identical in spirit with the one that governs the US today—a system that would also require prisons, police, and tax collectors, or else other ways to perform the same functions.
    </p>

    <p>Real freedom is not a question of how participatory the process of answering questions is, but of the extent to which we can frame the questions ourselves—and whether we can stop others from imposing their answers on us. The institutions that operate under a dictatorship or an elected government are no less oppressive when they are employed directly by a majority without the mediation of representatives. In the final analysis, even the most directly democratic state is better at concentrating power than maximizing freedom.
    </p>

    <p>On the other hand, not everyone believes that democracy is a means of state governance. Some proponents of democracy have attempted to transform the discourse, arguing that true democracy only takes place outside the state and against its monopoly on power. For opponents of the state, this appears to be a strategic move, in that it appropriates all the legitimacy that has been invested in democracy across three centuries of popular movements and self-congratulatory state propaganda. Yet there are three fundamental problems with this approach.
    </p>

    <aside>
    <blockquote class="accent">“Democracy is not, to begin with, a form of State. It is, in the first place, the reality of the power of the people that can never coincide with the form of a State. There will always be tension between democracy as the exercise of a shared power of thinking and acting, and the State, whose very principle is to appropriate this power… The power of citizens is, above all, the power for them to act for themselves, to constitute themselves into an autonomous force. Citizenship is not a prerogative linked to the fact of being registered as an inhabitant and voter in a country; it is, above all, an exercise that cannot be delegated.”<br />
    <p class="attribution">– <a href="https://hiredknaves.wordpress.com/2012/01/21/jacques-ranciere-interview-democracy-is-not-t/">Jacques Rancière</a>
    </p>
    </blockquote>
    </aside>


    <p>First, it’s ahistorical. Democracy originated as a form of state government; practically all the familiar historical examples of democracy were carried out via the state or at least by people who aspired to govern. The positive associations we have with democracy as a set of abstract aspirations came later.
    </p>

    <p>Second, it fosters confusion. Those who promote democracy as an alternative to the state rarely draw a meaningful distinction between the two. If you dispense with representation, coercive enforcement, and the rule of law, yet keep all the other hallmarks that make democracy a means of governing—citizenship, voting, and the centralization of legitimacy in a single decision-making structure—you end up retaining the procedures of government without the mechanisms that make them <em>effective.</em> This combines the worst of both worlds. It ensures that those who approach anti-state democracy expecting it to perform the same function as the state will inevitably be disappointed, while creating a situation in which anti-state democracy tends to reproduce the dynamics associated with state democracy on a smaller scale.
    </p>

    <p>Finally, it’s a losing battle. If what you mean to denote by the word democracy can only occur outside the framework of the state, it creates considerable ambiguity to use a term that has been associated with state politics for 2500 years.<sup class="footlink">
    <a href="#7" name="7return">7</a>
    </sup>
    <sup class="refnumber">7</sup>
    <small>
    <span class="fnumber">7.</span> The objection that the democracies that govern the world today aren’t <a href="http://www.crimethinc.com/texts/recentfeatures/barc.php">
    <em>real</em> democracies</a> is a variant of the classic <a href="http://www.logicallyfallacious.com/index.php/logical-fallacies/136-no-true-scotsman">“No true Scotsman” fallacy.</a> If, upon investigation, it turns out that not a single existing democracy lives up to what you mean by the word, you might need a different expression for what you are trying to describe. This is like communists who, confronted with all the repressive communist regimes of the 20th century, protest that not a single one of them was properly communist. When an idea is so difficult to implement that millions of people equipped with a considerable portion of the resources of humanity and doing their best across a period of centuries can’t produce a single working model, it’s time to go back to the drawing board. Give anarchists a tenth of the opportunities Marxists and democrats have had, and then we may speak about whether <a href="https://theanarchistlibrary.org/library/peter-gelderloos-anarchy-works">anarchy works!</a>
    </small> Most people will assume that what you mean by democracy is reconcilable with the state after all. This sets the stage for statist parties and strategies to regain legitimacy in the public eye, even after having been completely discredited. The political parties Podemos and <a href="http://www.crimethinc.com/texts/r/syriza/">Syriza</a> gained traction in the occupied squares of Barcelona and Athens thanks to their rhetoric about direct democracy, only to make their way into the halls of government where they are now behaving like any other political party. They’re still doing democracy, just more <em>efficiently</em> and <em>effectively.</em> Without a language that differentiates what they are doing in parliament from what people were doing in the squares, this process will recur again and again.
    </p>

    <aside>
    <blockquote class="accent">“We must all be both rulers and ruled simultaneously, or a system of rulers and subjects is the only alternative… Freedom, in other words, can only be maintained through a sharing of political power, and this sharing happens through political institutions.”<br />
    <p class="attribution">– Cindy Milstein, <a href="http://www.revolutionbythebook.akpress.org/ak-tactical-media/pamphlet-no-2/">“Democracy Is Direct”</a>
    </blockquote>
    </aside>

    <p>When we identify what we are doing when we oppose the state as the practice of <em>democracy,</em> we set the stage for our efforts to be reabsorbed into larger representational structures. Democracy is not just a way of managing the apparatus of government, but also of regenerating and legitimizing it. Candidates, parties, regimes, and even the form of government can be swapped out from time to time when it becomes clear that they cannot solve the problems of their constituents. In this way, government itself—the source of at least some of those problems—is able to persist. Direct democracy is just the latest way to rebrand it.
    </p>

    <p>Even without the familiar trappings of the state, any form of government requires some way of determining who can participate in decision-making and on what terms—once again, who counts as the <em>demos.</em> Such stipulations may be vague at first, but they will get more concrete the older an institution grows and the higher the stakes get. And if there is no way of enforcing decisions—no <em>kratos</em>—the decision-making processes of government will have no more weight than decisions people make autonomously.<sup class="footlink">
    <a href="#8" name="8return">8</a>
    </sup>
    <sup class="refnumber">8</sup>
    <small>
    <span class="fnumber">8.</span> Without formal institutions, democratic organizations often enforce decisions by delegitimizing actions initiated outside their structures and encouraging the use of force against them. Hence the classic scene in which protest marshals attack demonstrators for doing something that wasn’t agreed upon in advance via a centralized democratic process.</small> This is the paradox of a project that seeks <em>government</em> without the state.
    </p>

    <p>These contradictions are stark enough in Murray Bookchin’s formulation of <a href="http://social-ecology.org/1999/08/thoughts-on-libertarian-municipalism/">libertarian municipalism</a> as an alternative to state governance. In libertarian municipalism, Bookchin explained, an exclusive and avowedly vanguardist organization governed by laws and a Constitution would make decisions by majority vote. They would run candidates in city council elections, with the long-term goal of establishing a confederation that could replace the state. Once such a confederation got underway, membership was to be binding even if participating municipalities wanted to withdraw. Those who try to retain government without the state are likely to end up with something like the state by another name.
    </p>

    <p>The important distinction is not between democracy and the state, then, but between government and self-determination. Government is the exercise of authority over a given space or polity: whether the process is dictatorial or participatory, the end result is the imposition of control. By contrast, self-determination means disposing of one’s potential on one’s own terms: when people engage in it together, they are not ruling each other, but fostering cumulative autonomy. Freely made agreements require no enforcement; systems that concentrate legitimacy in a single institution or decision-making process always do. </p>

    <p>It is strange to use the word <em>democracy</em> for the idea that the state is inherently undesirable. The proper word for that idea is <em>anarchism.</em> Anarchism opposes all exclusion and domination in favor of the radical decentralization of power structures, decision-making processes, and notions of legitimacy. It is not a matter of governing in a completely participatory manner, but of making it impossible to impose any form of rule.
    </p>

    <div class="bigimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/plaza1370.jpg">
    <div class="bigimagecaption">
    <p>From the plaza to the parliament: democracy as crowd-sourced state power.
    </p>
    </div>
    </div>

    <h2>Consensus and the Fantasy of Unanimous Rule</h2>

    <p>If the common denominators of democratic government are citizenship and policing—<em>demos</em> and <em>kratos</em>—the most radical democracy would expand those categories to include the whole world: universal citizenship, community policing. In the ideal democratic society, every person would be a citizen,<sup class="footlink">
    <a href="#9" name="9return">9</a>
    </sup>
    <sup class="refnumber">9</sup>
    <small>
    <span class="fnumber">9.</span> In theory, categories that are defined by exclusion, like citizenship, break down when we expand them to include the whole world. But if we wish to break them down, why not reject them outright, rather than promising to do so while further legitimizing them? When we use the word citizenship to describe something desirable, that can’t help but reinforce the legitimacy of that institution as it exists today.<br />
    <br />
    <span class="fnumber" style="margin-left: -1.5em;">10.</span> In fact, the English word “police” is derived from <em>polis</em> by way of the ancient Greek word for citizen.</small> and every citizen would be a policeman.<sup class="footlink">
    <a href="#10" name="10return">10</a>
    </sup>
    <sup class="refnumber">10</sup>
    </p>

    <p>At the furthest extreme of this logic, majority rule would mean rule by consensus: not the rule of the majority, but unanimous rule. The closer we get to unanimity, the more legitimate government is perceived to be—so wouldn’t rule by consensus be the most legitimate government of all? Then, finally, there would be no need for anyone to play the role of the police.
    </p>

    <aside>
    <blockquote class="accent">“In the strict sense of the term, there has never been a true democracy, and there never will be… One can hardly imagine that all the people would sit permanently in an assembly to deal with public affairs.”<br />
    <p class="attribution">– Jean-Jacques Rousseau, <em>Of the Social Contract</em>
    </p>
    </blockquote>
    </aside>

    <p>Obviously, this is impossible. But it’s worth reflecting on what sort of utopia is implied by idealizing direct democracy as a form of government. Imagine the kind of totalitarianism it would take to produce enough cohesion to <em>govern</em> a society via consensus process—to get <em>everyone</em> to agree. Talk about reducing things to the lowest common denominator! If the alternative to coercion is to abolish disagreement, surely there must be a third path.
    </p>

    <p>This problem came to the fore during the Occupy movement. Some participants understood the general assemblies as the <em>governing bodies</em> of the movement; from their perspective, it was undemocratic for people to act without unanimous authorization. Others approached the assemblies as <em>spaces of encounter</em> without prescriptive authority, in which people might exchange influence and ideas, forming fluid constellations around shared goals to take action. The former felt betrayed when their fellow Occupiers engaged in tactics that hadn’t been agreed on in the general assembly; the latter countered that it didn’t make sense to grant veto power to an arbitrarily convened mass including literally anyone who happened by on the street.
    </p>

    <div class="bigimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/assembly1370.jpg">
    <div class="bigimagecaption">
    <p>A disagreement about the role of the general assembly during Occupy Oakland.
    </p>
    </div>
    </div>


    <p>Perhaps the answer is that the structures of decision-making must be decentralized as well as consensus-based, so that universal agreement is unnecessary. This is a step in the right direction, but it introduces new questions. How should people be divided into polities? What dictates the jurisdiction of an assembly or the scope of the decisions it can make? Who determines which assemblies a person may participate in, or who is most affected by a given decision? How are conflicts between assemblies resolved? The answers to these questions will either institutionalize a set of rules governing legitimacy, or prioritize voluntary forms of association. In the former case, the rules will likely ossify over time, as people refer to protocol to resolve disputes. In the latter case, the structures of decision-making will continuously shift, fracture, clash, and re-emerge in organic processes that can hardly be described as <em>government.</em> When the participants in a decision-making process are free to withdraw from it or engage in activity that contradicts the decisions, then what is taking place is not government—it is simply conversation.<sup class="footlink">
    <a href="#11" name="11return">11</a>
    </sup>
    <sup class="refnumber">11</sup>
    <small>
    <span class="fnumber">11.</span> See <a href="https://korpora.zim.uni-duisburg-essen.de/kant/aa07/330.html">Kant’s argument</a> that a republic is “violence with freedom and law,” whereas anarchy is “freedom and law without violence”—so the law becomes a mere recommendation that cannot be enforced.</small>
    </p>

    <aside>
    <blockquote class="accent">“Democracy means government by discussion, but it is only effective if you can stop people talking.”<br />
    <p class="attribution">– Clement Attlee, UK Prime Minister, 1957</p>
    </blockquote>
    </aside>

    <p>From one perspective, this is a question of emphasis. Is our goal to produce the ideal institutions, rendering them as horizontal and participatory as possible but deferring to them as the ultimate foundation of authority? Or is our goal to maximize freedom, in which case any particular institution we create is subordinate to liberty and therefore dispensable? Once more—what is legitimate, the institutions or our needs and desires?</p>

    <p>Even at their best, institutions are just a means to an end; they have no value in and of themselves. No one should be obliged to adhere to the protocol of any institution that suppresses her freedom or fails to meet her needs. If everyone were free to organize with others on a purely voluntary basis, that would be the best way to generate social forms that are truly in the interests of the participants: for as soon as a structure was not working for everyone involved, they would have to refine or replace it. This approach won’t bring all of society into consensus, but it is the only way to guarantee that consensus is meaningful and desirable when it <em>does</em> arise.
    </p>


    <div class="smallimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/decentral1300.gif">
    <div class="smallimagecaption" style="background-color: black;">
    <p>“Decentralization? In theory, it’s a good idea, but I doubt we’ll reach consensus to implement it.”</p>
    </div>
    </div>

    <h2>The Excluded: Race, Gender, and Democracy</h2>

    <p>We often hear arguments for democracy on the grounds that, as the most inclusive form of government, it is the best suited to combat the racism and sexism of our society. Yet as long as the categories of rulers/ruled and included/excluded are built into the structure of politics, coded as “majorities” and “minorities” even when the minorities outnumber the majorities, imbalances of power along race and gender lines will always be reflected as disparities in political power. This is why women, black people, and other groups still lack political leverage proportionate to their numbers, despite having ostensibly possessed voting rights for a century or more.
    </p>

    <aside>
    <blockquote class="accent">“We haven’t benefitted from America’s democracy. We’ve only suffered from America’s hypocrisy.”<br />
    <p class="attribution">– Malcolm X, <a href="https://books.google.com/books?id=392G-SgEL-YC&amp;pg=PA79&amp;lpg=PA79&amp;dq=We%E2%80%99ve+never+seen+democracy.+All+we%E2%80%99ve+seen+is+hypocrisy.%22+%22We+don%E2%80%99t+see+the+American+Dream.+All+we+see+is+the+American+nightmare%E2%80%9D&amp;source=bl&amp;ots=i3j88wGndX&amp;sig=niYopCowAeU6iQkU2wTrlwwsdyo&amp;hl=en&amp;sa=X&amp;ved=0ahUKEwi_8Maelc_KAhVJ2GMKHZtEAxEQ6AEIOzAF#v=onepage&amp;q=We%E2%80%99ve%20never%20seen%20democracy.%20All%20we%E2%80%99ve%20seen%20is%20hypocrisy.%22%20%22We%20don%E2%80%99t%20see%20the%20American%20Dream.%20All%20we%20see%20is%20the%20American%20nightmare%E2%80%9D&amp;f=false">“The Ballot or the Bullet”</a>
    </p>
    </blockquote>
    </aside>

    <p>In <em>The Abolition of White Democracy,</em> the late Joel Olson presents a compelling critique of what he calls <a href="https://libcom.org/library/white-supremacy-joel-olson">“white democracy”</a>—the concentration of democratic political power in white hands by means of a cross-class alliance among those granted white privilege. But he takes for granted that democracy is the most desirable system, assuming that white supremacy is an incidental obstacle to its functioning rather than a natural consequence thereof. If democracy is the ideal form of egalitarian relations, why has it <a href="https://www.polity.co.uk/minoritypol/african/pdf/KING_CH2.pdf">been implicated in structural racism</a> for practically its entire existence?</p>

    <p>Where politics is constructed as a zero-sum competition, those who hold power will be loath to share it with others. Consider the men who opposed universal suffrage and the white people who opposed the extension of voting rights to people of color: the structures of democracy did not discourage their bigotry, but gave them an incentive to institutionalize it.
    </p>

    <p>Olson traces the way that the ruling class fostered white supremacy in order to divide the working class, but he neglects the ways that democratic structures lent themselves to this process. He argues that we should promote class solidarity as a response to these divisions, but (as <a href="https://www.marxists.org/reference/archive/bakunin/works/1873/statism-anarchy.htm">Bakunin argued contra Marx</a>) the difference between the governing and the governed is itself a class difference—think of ancient Athens. Racialized exclusion has always been the flip side of citizenship.
    </p>

    <aside>
    <blockquote class="accent">“By erecting a slave society, America created the economic foundation for its great experiment in democracy… America’s indispensable working class existed as property beyond the realm of politics, leaving white Americans free to trumpet their love of freedom and democratic values.”<br />
    <p class="attribution">– Ta-Nehisi Coates, <a href="http://www.theatlantic.com/magazine/archive/2014/06/the-case-for-reparations/361631/">“The Case for Reparations”</a>
    </p>
    </blockquote>
    </aside>

    <p>So the political dimension of white supremacy isn’t just a consequence of racial disparities in economic power—it also produces them. Ethnic and racial divisions were ingrained in our society long before the dawn of capitalism; the <a href="http://sefarad.org/sefarad/sefarad.php/id/13/">confiscation of Jewish property</a> under the Inquisition financed the original colonization of the Americas, and the looting of the Americas and enslavement of Africans provided the original startup capital to jumpstart capitalism in Europe and later North America. It is possible that racial divisions could outlast the next massive economic and political shift, too—for example, as exclusive assemblies of predominantly <a href="https://medium.com/@rossstephens/about-schmidt-how-a-white-nationalist-seduced-anarchists-around-the-world-chapter-1-1a6fa255b528#.j723h8oyv">white</a> (or <a href="https://electronicintifada.net/content/israels-choice-jewish-only-or-democratic/6878">Jewish</a>, or even <a href="https://libcom.org/library/our-attitude-towards-rojava-must-be-critical-solidarity">Kurdish</a>) citizens.
    </p>

    <p>There are no easy fixes for this problem. Reformers often speak about making our political system more “democratic,” by which they mean more inclusive and egalitarian. Yet when their reforms are realized in a way that legitimizes and strengthens the institutions of government, this only puts more weight behind those institutions when they strike at the targeted and marginalized—witness <a href="http://sentencingproject.org/doc/publications/inc_Trends_in_Corrections_Fact_sheet.pdf">the mass incarceration of black people</a> since the civil rights movement. Malcolm X and other advocates of black separatism were right that a white-founded democracy would never offer freedom to black people—not because white and black people can never coexist, but because in rendering politics a competition for centralized political power, democratic governance creates conflicts that preclude coexistence. If today’s racial conflicts can ever be resolved, it will be through the establishment of new relations on the basis of decentralization, not by integrating the excluded into the political order of the included.<sup class="footlink">
    <a href="#12" name="12return">12</a>
    </sup>
    <sup class="refnumber">12</sup>
    <small>
    <span class="fnumber">12.</span> This far, at least, we can agree with Booker T. Washington when he said, “The Reconstruction experiment in racial democracy failed because it began at the wrong end, emphasizing political means and civil rights acts rather than economic means and self-determination.”</small>
    </p>

    <aside>
    <blockquote class="accent">“As long as there are police, who do you think they will harass? As long as there are prisons, who do you think will fill them? As long as there is poverty, who do you think will be poor? It is naïve to believe we could achieve equality in a society based on hierarchy. You can shuffle the cards, but it’s still the same deck.”<br />
    <p class="attribution">– <a href="http://www.crimethinc.com/tce/">
    <em>To Change Everything</em>
    </a>
    </p>
    </blockquote>
    </aside>

    <p>As long as we understand what we are doing together politically as <em>democracy</em>—as government by a legitimate decision-making process—we will see that legitimacy invoked to justify programs that are functionally white supremacist, whether they are the policies of a state or the decisions of a spokescouncil. (Recall, for example, the tensions between the decision-making processes of the predominantly white general assemblies and the less white encampments <a href="https://researchanddestroy.wordpress.com/2014/06/14/the-wreck-of-the-plaza/">within many Occupy groups</a>.) Only when we dispense with the idea that any political process is inherently legitimate will we be able to strip away the final alibi of the racial disparities that have always characterized democratic governance.
    </p>

    <p>Turning to gender, this gives us a new perspective on why Lucy Parsons, Emma Goldman, and other women argued that the demand for women’s suffrage was missing the point. Why would anyone reject the option to participate in electoral politics, imperfect as it is? The short answer is that they wanted to abolish government entirely, not to make it more participatory. But looking closer, we can find some more specific reasons why people concerned with women’s liberation might be suspicious of the franchise.
    </p>

    <aside>
    <blockquote class="accent">“The history of the political activities of men proves that they have given him absolutely nothing that he could not have achieved in a more direct, less costly, and more lasting manner. As a matter of fact, every inch of ground he has gained has been through a constant fight, a ceaseless struggle for self-assertion, and not through suffrage. There is no reason whatever to assume that woman, in her climb to emancipation, has been, or will be, helped by the ballot.”<br />
    <p class="attribution">– Emma Goldman, <a href="http://womenshistory.about.com/library/etext/bl_eg_an9_woman_suffrage.htm">“Women Suffrage”</a>
    </p>
    </blockquote>
    </aside>

    <p>Let’s go back to <em>polis</em> and <em>oikos</em>—the city and the household. Democratic systems rely on a formal distinction between public and private spheres; the public sphere is the site of all legitimate decision-making, while the private sphere is excluded or discounted. Throughout a wide range of societies and eras, this division has been profoundly gendered, with men dominating public spheres—ownership, paid labor, government, management, and street corners—while women and those outside the gender binary have been relegated to private spheres: the household, the kitchen, the family, child-rearing, sex work, <a href="http://www.crimethinc.com/texts/atoz/selfcare.php">care work</a>, other forms of invisible and unpaid labor.
    </p>

    <p>Insofar as democratic systems centralize decision-making power and authority in the public sphere, this reproduces patriarchal patterns of power. This is most obvious when women are formally excluded from voting and politics—but even where they are not, they often face informal obstacles in the public sphere while bearing <a href="http://www.unc.edu/~kleinman/handouts/second%20shift.pdf">disproportionate responsibility</a> in the private sphere.
    </p>

    <p>The inclusion of more participants in the public sphere serves to further legitimize a space where women and those who do not conform to gender norms operate at a disadvantage. If “democratization” means a shift in decision-making power from informal and private sites towards more public political spaces, the result could even erode <a href="http://www.nomadsed.de/fileadmin/user_upload/redakteure/Dateien_Intern/Archiv_AG_1/Scott_1985_Chap_2.pdf">some forms</a> of women’s power. Recall how grassroots women’s shelters founded in the 1970s were professionalized through state funding to such an extent that by the 1990s, the women who had founded them could never have qualified for entry-level positions in them.
    </p>

    <p>So we cannot rely on the degree of women’s formal participation in the public sphere as an index of liberation. Instead, we can deconstruct the gendered distinction between public and private, validating what takes place in relationships, families, households, neighborhoods, social networks, and other spaces that are not recognized as part of the political sphere. This wouldn’t mean formalizing these spaces or integrating them into a supposedly gender-neutral political practice, but rather legitimizing multiple ways of making decisions, recognizing multiple sites of power within society.
    </p>

    <p>There are two ways to respond to male domination of the political sphere. The first is to try to make the formal public space as accessible and inclusive as possible—for example, by registering women to vote, providing child care, setting quotas of who must participate in decisions, weighting who is permitted to speak in discussions, or even, as in <a href="http://www.crimethinc.com/texts/r/kurdish/">Rojava</a>, establishing women-only assemblies with veto power. This strategy seeks to implement equality, but it still assumes that all power should be vested in the public sphere. The alternative is to identify sites and practices of decision-making that already empower people who do not benefit from male privilege, and grant them greater influence. This approach draws on <a href="http://plato.stanford.edu/entries/feminist-social-epistemology/">longstanding feminist traditions</a> that prioritize people’s lives and experiences over formal structures and ideologies, recognizing the importance of diversity and valuing dimensions of life that are usually invisible.
    </p>

    <p>These two approaches can coincide and complement each other, but only if we dispense with the idea that all legitimacy should be concentrated in a single institutional structure.
    </p>


    <div class="bigimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/parsons1370.jpg">
    <div class="bigimagecaption">
    <p>“Of all the modern delusions, the ballot has certainly been the greatest… The principle of rulership is in itself wrong: no man has any right to rule another.” –Lucy Parsons, <a href="http://americawakiewakie.com/post/31013898595/of-all-the-modern-delusions-the-ballot-has">“The Ballot Humbug”</a>
    </p>
    </div>
    </div>

    <h2>Arguments Against Autonomy</h2>

    <p>There are several objections to the idea that decision-making structures should be voluntary rather than obligatory, decentralized rather than monolithic. We’re told that without a central mechanism for deciding conflicts, society will degrade into civil war; that it is impossible to defend against centralized aggressors without a central authority; that we need the apparatus of central government to deal with oppression and injustice.
    </p>

    <p>In fact, the centralization of power is as likely to provoke strife as to resolve it. When everyone has to gain leverage on the structures of the state to obtain any control over the conditions of her own life, this is bound to generate friction. In Israel/Palestine, India/Pakistan, and other places where people of a variety of religions and ethnicities had coexisted autonomously in relative peace, the colonially imposed imperative to contend for political power within the framework of a single state produced protracted ethnic violence. Such conflicts were common in 19th century US politics, as well—consider the <a href="http://www.streetsofwashington.com/2015/12/the-election-day-riot-of-1857-driven-by.html">early gang warfare</a> around elections in Washington and Baltimore, or the fight for <a href="http://www.history.com/topics/bleeding-kansas">Bleeding Kansas</a>. If these struggles are no longer common in the US, that’s not evidence that the state has <em>resolved</em> all the conflicts it generated.
    </p>

    <p>Centralized government, touted as a way to conclude disputes, just consolidates power so the victors can maintain their position through force of arms. And when centralized structures collapse, as Yugoslavia did during the introduction of democracy in the 1990s, the consequences can be bloody indeed. At best, centralization only postpones strife—like a debt accumulating interest.
    </p>

    <p>But can decentralized networks stand a chance against centralized power structures? If they can’t, then the whole discussion is moot, as any attempt to experiment with decentralization will be crushed by more centralized rivals.
    </p>

    <p>The answer remains to be seen, but today’s centralized powers are by no means sure of their own invulnerability. Already, in 2001, <a href="http://www.rand.org/pubs/monograph_reports/MR1382.html">the RAND Corporation was arguing</a> that decentralized networks, rather than centralized hierarchies, will be the power players of the 21st century. Over the past two decades, from the so-called anti-globalization movement to Occupy and the <a href="http://www.crimethinc.com/texts/r/kurdish/">Kurdish experiment with autonomy in Rojava</a>, the initiatives that have succeeded in opening up space for new experiments (both democratic and anarchistic) have been decentralized, while more centralized efforts like Syriza <a href="http://autonomies.org/es/2015/07/the-kratia-against-the-demos-lessons-from-greece/">have been co-opted almost immediately.</a> A wide range of scholars <a href="http://ictlogy.net/20160115-are-assembly-based-parties-network-parties/">are now theorizing</a> the distinguishing features and advantages of network-based organizing.
    </p>

    <div class="bigimage" style="background-color: white;">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/chart1370.gif">
    <div class="bigimagecaption" style="background-color: black;">
    <p>
    <em>A <a href="http://ictlogy.net/review/?p=4384">diagram illustrating</a> the advantages of decentralized and autonomous network-based organizing over both representative democracy and assembly-based direct democracy.</em>
    </p>
    </div>
    </div>

    <p>Finally, there is the question of whether a society needs a centralized political apparatus to be able to put a stop to oppression and injustice. Abraham Lincoln’s <a href="http://bartleby.com/124/pres31.html">first inaugural address,</a> delivered in 1861 on the eve of the Civil War, is one of the strongest expressions of this argument. It’s worth quoting at length:</p>

    <p class="inlinequotation">Plainly the central idea of secession is the essence of anarchy. A majority held in restraint by constitutional checks and limitations, and always changing easily with deliberate changes of popular opinions and sentiments, is the only true sovereign of a free people. Whoever rejects it does of necessity fly to anarchy or to despotism. Unanimity is impossible. The rule of a minority, as a permanent arrangement, is wholly inadmissible; so that, rejecting the majority principle, anarchy or despotism in some form is all that is left…</p>
    <p class="inlinequotation">Physically speaking, we cannot separate. We cannot remove our respective sections from each other nor build an impassable wall between them. A husband and wife may be divorced and go out of the presence and beyond the reach of each other, but the different parts of our country cannot do this. They cannot but remain face to face, and intercourse, either amicable or hostile, must continue between them. Is it possible, then, to make that intercourse more advantageous or more satisfactory after separation than before? Can aliens make treaties easier than friends can make laws? Can treaties be more faithfully enforced between aliens than laws can among friends? Suppose you go to war, you cannot fight always; and when, after much loss on both sides and no gain on either, you cease fighting, the identical old questions, as to terms of intercourse, are again upon you.
    </p>
    <p class="inlinequotation">This country, with its institutions, belongs to the people who inhabit it. Whenever they shall grow weary of the existing Government, they can exercise their constitutional right of amending it or their revolutionary right to dismember or overthrow it.
    </p>

    <p>Follow this logic far enough in today’s globalized world and you arrive at the idea of world government: majority rule on the scale of the entire planet. Lincoln is right, <em>contra</em> partisans of consensus, that unanimous rule is impossible and that those who do not wish to be ruled by majorities must choose between despotism and anarchy. His argument that aliens cannot make treaties more easily than friends make laws sounds convincing at first. But <em>friends</em> don’t enforce laws on each other—laws are made to be imposed on weaker parties, whereas treaties are made between equals. <em>Government</em> is not something that takes place between friends, any more than <em>a free people</em> need a <em>sovereign.</em> If we have to choose between despotism, majority rule, and anarchy, anarchy is the closest thing to freedom—what Lincoln calls our “revolutionary right” to overthrow governments.
    </p>

    <p>Yet, in associating anarchy with the secession of the Southern states, Lincoln was mounting a critique of autonomy that echoes to this day. If it weren’t for the Federal government, the argument goes, slavery would never have been abolished, nor would the South have desegregated or granted civil rights to people of color. These measures against injustice had to be introduced at gunpoint by the armies of the Union and, a century later, the National Guard. In this context, advocating decentralization seems to mean accepting slavery, segregation, and the Ku Klux Klan. Without a legitimate central governing body, what mechanism could stop people from acting oppressively?</p>

    <p>There are several errors here. The first mistake is obvious: of Lincoln’s three options—despotism, majority rule, and anarchy—the secessionists represented despotism, not anarchy. Likewise, it is naïve to imagine that the apparatus of central government will be employed solely on the side of freedom. The same National Guard that oversaw integration in the South used live ammunition to put down black uprisings around the country; today, there are nearly as many black people in US prisons as there once were slaves in the US. Finally, one need not vest all legitimacy in a single governing body in order to act against oppression. One may still act—one must simply do so without the pretext of enforcing law.
    </p>

    <p>Opposing the centralization of power and legitimacy does not mean withdrawing into quietism. Some conflicts must take place; there is no getting around them. They follow from truly irreconcilable differences, and the imposition of a false unity only defers them. In his inaugural address, Lincoln was pleading in the name of the state to suspend the conflict between abolitionists and partisans of slavery—a conflict that was inevitable and necessary, which had already been delayed through decades of intolerable compromise. Meanwhile, abolitionists like Nat Turner and John Brown were able to act decisively without need of a central political authority—indeed, they were able to act thus only because they did not recognize one. Were it not for the pressure generated by autonomous actions like theirs, the federal government would never have intervened in the South; had more people taken the initiative the way they did, slavery would not have been possible and the Civil War would not have been necessary.
    </p>

    <p>In other words, the problem was not too much anarchy, but too little. It was autonomous action that forced the issue of slavery, not democratic deliberation. What’s more, had there been more partisans of anarchy, rather than majority rule, it would not have been possible for Southern whites to regain political supremacy in the South after Reconstruction.
    </p>

    <p>One more anecdote bears mention. A year after his inaugural speech, Lincoln addressed a committee of free men of color <a href="http://quod.lib.umich.edu/l/lincoln/lincoln5/1:812?rgn=div1;view=fulltext">to argue that they should emigrate</a> to found another colony like Liberia in hopes that the rest of black America would follow. Regarding the relation between emancipated black people and white American citizens, he argued,</p>

    <p class="inlinequotation">It is better for us both to be separated… There is an unwillingness on the part of our people, harsh as it may be, for you free colored people to remain with us.
    </p>

    <p>So, in Lincoln’s political cosmology, the <em>polis</em> of white citizens cannot separate, but as soon as the black slaves of the <em>oikos</em> no longer occupy their economic role, it is better that they depart. This dramatizes things clearly enough: the nation is indivisible, but the excluded are disposable. Had the slaves freed after the Civil War emigrated to Africa, they would have arrived just in time to experience the horrors of European colonization, with a death toll of <a href="https://books.google.com/books?id=VLuKAAAAMAAJ&amp;focus=searchwithinvolume&amp;q=ten+million+people">ten million</a> in Belgian Congo alone. The proper solution to such catastrophes is not to integrate all the world into a single republic governed by majority rule, but to combat all institutions that divide people into majorities and minorities—rulers and ruled—however democratic they might be.
    </p>


    <div class="smallimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/isfreedom1370.gif">
    </div>


    <h2>Democratic Obstacles to Liberation</h2>

    <p>Barring war or miracle, the legitimacy of every constituted government is always eroding; it can only erode. Whatever the state promises, nothing can compensate for having to cede control of our lives. Every specific grievance underscores this systemic problem, though we rarely see the forest for the trees.
    </p>

    <p>This is where democracy comes in: another election, another government, another cycle of optimism and disappointment.
    </p>

    <aside>
    <blockquote class="accent">“Democracy is a great way of assuring the legitimacy of the government, even when it does a bad job of delivering what the public wants. In a functioning democracy, mass protests challenge the rulers. They don’t challenge the fundamental nature of the state’s political system.”<br />
    <p class="attribution">– Noah Feldman, <a href="http://www.bloombergview.com/articles/2016-01-31/tunisia-s-protests-are-different-this-time">“Tunisia&#8217;s Protests Are Different This Time”</a>
    </p>
    </blockquote>
    </aside>

    <p>But this does not always pacify the population. The past decade has seen movements and uprisings all around the world—from Oaxaca to Tunis, Istanbul to Rio de Janeiro, Kiev to Hong Kong—in which the disillusioned and disaffected attempt to take matters into their own hands. Most of these have rallied around the standard of more and better democracy, though that has hardly been unanimous.
    </p>

    <p>Considering how much power the market and the government wield over us, it’s tempting indeed to imagine that we could somehow turn the tables and govern <em>them.</em> Even those who do not believe that it is possible for <em>the people to rule the government</em> usually end up governing the one thing that is left to them—their resistance to it. Approaching protest movements as experiments in direct democracy, they set out to <a href="http://berkeleyjournal.org/2014/11/prefiguration-or-actualization-radical-democracy-and-counter-institution-in-the-occupy-movement/">prefigure</a> the structures of a more democratic world.
    </p>

    <p>But what if prefiguring democracy is part of the problem? That would explain why so few of these movements have been able to mount an irreconcilable opposition to the structures that they formed to oppose. With the arguable exceptions of Chiapas and Rojava, all of them have been defeated (<a href="http://www.crimethinc.com/texts/recentfeatures/atc-oak.php">Occupy</a>), reintegrated into the functioning of the prevailing government (<a href="http://www.crimethinc.com/texts/r/syriza/">Syriza</a>, <a href="http://www.historymatters.group.shef.ac.uk/podemos-break-familiar-face-popularism/">Podemos</a>), or, worse still, have overthrown and replaced that government without achieving any real change in society (<a href="http://www.bloombergview.com/articles/2016-01-31/tunisia-s-protests-are-different-this-time">Tunisia</a>, <a href="https://tahriricn.wordpress.com/2014/04/28/egypt-cracking-down-on-dissent-the-fascist-state-and-persecution-of-political-opponents/">Egypt</a>, <a href="http://www.huffingtonpost.com/entry/us-isis-libya_us_56be5310e4b08ffac1255c07">Libya</a>, <a href="http://www.crimethinc.com/texts/ux/ukraine.html">Ukraine</a>).
    </p>

    <p>When a movement seeks to legitimize itself on the basis of the same principles as state democracy, it ends up trying to beat the state at its own game. Even if it succeeds, the reward for victory is to be coopted and institutionalized—whether within the existing structures of government or by reinventing them anew. Thus movements that begin as revolts against the state end up recreating it.
    </p>

    <aside>
    <blockquote class="accent">“Occasionally you rebel, but it’s only ever just to start doing the same thing again from scratch.”<br />
    <p class="attribution">– Albert Libertad, <a href="http://anticoncept.phpnet.us/albertlibertad.html">“Voters: You Are the Real Criminals”</a>
    </p>
    </blockquote>
    </aside>

    <p>This can play out in many different ways. There are movements that hamstring themselves by claiming to be more democratic, more transparent, or more representative than the authorities; movements that come to power through electoral politics, only to betray their original goals; movements that promote directly democratic tactics that turn out to be just as useful to those who seek state power; and movements that topple governments, only to replace them. Let’s consider each in turn.
    </p>

    <p>If we limit our movements <a href="http://www.crimethinc.com/texts/recentfeatures/breakwith.php">to what the majority of participants can agree on in advance,</a> we may not be able to get them off the ground in the first place. When much of the population has accepted the legitimacy of the government and its laws, most people <a href="http://www.crimethinc.com/texts/recentfeatures/violence.php">don’t feel entitled to do anything that could challenge the existing power structure,</a> no matter how badly it treats them. Consequently, a movement that makes decisions by majority vote or consensus may have difficulty agreeing to utilize any but the most symbolic tactics. Can you imagine the residents of <a href="https://antistatestl.noblogs.org/post/2014/09/18/a-timeline-of-the-ferguson-uprising/">Ferguson, Missouri</a> holding a consensus meeting to decide whether to burn the QuikTrip store and fight off the police? And yet those were the actions that sparked what came to be known as the Black Lives Matter movement. People usually have to experience something new to be open to it; it is a mistake to confine an entire movement to what is already familiar to the majority of participants.
    </p>

    <p>By the same token, if we insist on our movements being completely transparent, that means letting the authorities dictate which tactics we can use. In conditions of widespread infiltration and surveillance, conducting all decision-making in public with complete transparency invites repression on anyone who is perceived as a threat to the status quo. The more public and transparent a decision-making body is, the more conservative its actions are likely to be, even when this contradicts its express reason for being—think of all the environmental coalitions that have never taken a single step to halt the activities that cause climate change. Within democratic logic, it makes sense to demand transparency from the government, as it is supposed to represent and answer to the people. But outside that logic, rather than demanding that participants in social movements represent and answer to each other, we should seek to maximize the autonomy with which they may act.
    </p>

    <p>If we claim legitimacy on the grounds that we represent the public, we offer the authorities an easy way to outmaneuver us, while opening the way for others to coopt our efforts. Before the introduction of universal suffrage, it was possible to maintain that a movement represented the will of the people; but nowadays an election can draw more people to the polls than even the most massive movement can mobilize into the streets. The winners of elections will always be able to claim to represent more people than can participate in movements.<sup class="footlink">
    <a href="#13" name="13return">13</a>
    </sup>
    <sup class="refnumber">13</sup>
    <small>
    <span class="fnumber">13.</span> At the end of May 1968, the announcement of snap elections <a href="http://www.jstor.org/stable/1600894?seq=1#page_scan_tab_contents">broke the wave of wildcat strikes and occupations</a> that had swept across France; the spectacle of the majority of French citizens voting for President de Gaulle’s party was enough to dispel all hope of revolution. This illustrates how elections serve as a pageantry that <em>represents</em> citizens to each other as willing participants in the prevailing order.</small> Likewise, movements purporting to represent the most oppressed sectors of society can be outflanked by the inclusion of token representatives of those sectors in the halls of power. And as long as we validate the idea of representation, some new politician or party can use our rhetoric to come to power. We should not claim that we represent the people—we should assert that no one has the right to rule us.
    </p>

    <p>What happens when a movement comes to power through electoral politics? <a href="http://www.redpepper.org.uk/from-greece-to-brazil-the-challenge-of-forging-a-socialist-alternative/">The victory of Lula and his Workers’ Party in Brazil</a> seemed to present a best-case scenario in which a party based in grassroots radical organizing took the helm of the state. At the time, Brazil hosted some of the world’s most powerful social movements, including the 1.5-million-strong land reform campaign MST (Landless Workers’ Movement); many of these were interconnected with the Workers’ Party. Yet after Lula took office in 2002, social movements entered a precipitous decline that lasted until 2013. Members of the Workers’ Party dropped out of local organizing to take positions in the government, while the necessities of realpolitik prevented Lula from granting concessions to the movements he had previously supported. The MST had forced the conservative government that preceded Lula to legalize many land occupations, but it <a href="http://www.crimethinc.com/texts/atoz/brazilpt1.php">made no headway whatsoever under Lula.</a> This pattern recurred all around Latin America as supposedly radical politicians betrayed the social movements that had put them in office. Today, the most powerful social movements in Brazil are <a href="http://www.theguardian.com/world/2016/mar/18/brazil-protests-rousseff-lula-supporters-rally-amid-corruption-claims">right-wing protests against the Workers’ Party.</a> There are no electoral shortcuts to freedom.
    </p>

    <div class="bigimage" style="background-color: white;">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/nazi2000.gif">
    <div class="bigimagecaption" style="background-color: black;">
    <p>Hitler himself came to power in a democratic election.
    </p>
    </div>
    </div>


    <p>What if instead of seeking state power, we focus on promoting directly democratic models such as neighborhood assemblies? Unfortunately, such practices can be appropriated to serve a wide range of agendas. After the Slovenian uprising of 2012, while self-organized neighborhood assemblies continued to meet in Ljubljana, an NGO financed by the city authorities began organizing assemblies in a “neglected” neighborhood as a pilot project towards “revitalizing” the area, with the explicit intention of drawing disaffected citizens back into dialogue with the government. During the Ukrainian revolution of 2014, the fascist parties Svoboda and Right Sector came to prominence via the democratic assemblies in the occupied Maidan. In 2009, members of the Greek fascist party Golden Dawn joined locals in the Athenian neighborhood of Agios Panteleimonas in organizing an assembly that coordinated attacks on immigrants and anarchists. If we want to foster inclusivity and self-determination, it is not enough to propagate the rhetoric and procedures of participatory democracy.<sup class="footlink">
    <a href="#14" name="14return">14</a>
    </sup>
    <sup class="refnumber">14</sup>
    <small>
    <span class="fnumber">14.</span> As economic crises intensify alongside widespread disillusionment with representational politics, we see governments offering more direct participation in decision-making to pacify the public. Just as the dictatorships in Greece, Spain, and Chile were forced to transition into democratic governments to neutralize protest movements, the state is opening up new roles for those who might otherwise lead the opposition to it. If we are directly responsible for making the political system work, we will blame ourselves when it fails—not the format itself. This explains the new experiments with “participatory” budgets from Pôrto Alegre <a href="http://www.obserwatorfinansowy.pl/tematyka/finanse-publiczne/participatory-budgeting-or-pocket-money-for-voters/">to Poznań.</a> In practice, the participants rarely have any leverage on town officials; at most, they can act as consultants, or vote on a measly 0.1% of city funds. The real purpose of participatory budgeting is to redirect popular attention from the failures of government to the project of making it <em>more democratic.</em>.</small> We need to spread a framework that opposes the state and other forms of hierarchical power in and of themselves.
    </p>

    <p>Even explicitly revolutionary strategies can be turned to the advantage of world powers in the name of democracy. From <a href="http://www.portaloaca.com/opinion/8663-venezuela-ahora-mas-que-nunca-autonomia-autogestion-accion-directa-y-solidaridad.html">Venezuela</a> to <a href="http://www.bbc.com/news/world-europe-32610951">Macedonia</a>, we have seen state actors and vested interests channel genuine popular dissent into ersatz social movements in order to shorten the electoral cycle. Usually, the goal is to force the ruling party to resign in order to replace it with a more “democratic” government—i.e., a government more amenable to US or EU objectives. Such movements usually focus on “corruption,” implying that the system would work just fine if only the right people were in power. When we enter the streets, rather than risk being the dupes of some foreign policy initiative, we should not mobilize against any particular government, but against government per se.
    </p>

    <div class="smallimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/manipulare1370.gif">
    </div>

    <p>
    <a href="https://libcom.org/news/fear-everyday-state-egypt-revolution-11022016">The Egyptian revolution</a> dramatically illustrates the dead end of democratic revolution. After hundreds had given their lives to overthrow dictator Hosni Mubarak and institute democracy, popular elections brought another autocrat to power in the person of Mohamed Morsi. A year later, in 2013, nothing had improved, and the people who had initiated the revolution took to the streets once more to reject the results of democracy, forcing the Egyptian military to depose Morsi. Today, the military remains <a href="https://www.washingtonpost.com/news/monkey-cage/wp/2016/01/27/what-was-the-egyptian-military-thinking-after-the-revolution/">the de facto ruler of Egypt,</a> and the same oppression and injustice that inspired two revolutions continues. The options represented by the military, Morsi, and the people in revolt are the same ones that Lincoln described in his inaugural speech: tyranny, majority rule, and anarchy.
    </p>

    <p>Here, at the furthest limit of the struggle against poverty and oppression, we always come up against the state itself. As long as we submit to being governed, the state will shift back and forth as needed between majority rule and tyranny—two expressions of the same basic principle. The state can assume many shapes; like vegetation, it can die back, then regrow from the roots. It can take the form of a monarchy or a parliamentary democracy, a revolutionary dictatorship or a provisional council; when the authorities have fled and the military has mutinied, the state can linger as a germ carried by the <a href="http://theanarchistlibrary.org/library/alexander-berkman-the-bolshevik-myth-diary-1920-22">partisans of order and protocol</a> in an apparently horizontal general assembly. All of these forms, however democratic, can regenerate into a regime capable of crushing freedom and self-determination.
    </p>

    <p>The one sure way to avoid cooptation, manipulation, and opportunism is to refuse to legitimize any form of rule. When people solve their problems and meet their needs directly through flexible, horizontal, decentralized structures, there are no leaders to corrupt, no formal structures to ossify, no single process to hijack. Do away with the concentrations of power and those who wish to seize power can get no purchase on society. An ungovernable people will likely have to defend itself against would-be tyrants, but it will never put its own strength behind their efforts to rule.
    </p>

    <div class="specialquote bigimage first">
    <h5>
    If nominated,<br />I will not run;<br />if elected, I will not serve.<br />
    <br />
    That goes if somebody else is elected, too.
    </h5>
    <img src="http://www.crimethinc.com/texts/r/democracy/images/notrun1370.jpg" />
    </div>

    <h2 id="towardsfreedom:pointsofdeparture">Towards Freedom:<br />Points of Departure</h2>

    <p>The classic defense of democracy is that it is the worst form of government—except for all the others. But if <em>government</em> itself is the problem, we have to go back to the drawing board.
    </p>

    <p>Reimagining humanity without government is an ambitious project; two centuries of anarchist theory only scratch the surface. For the purposes of this analysis, we’ll conclude with a few basic values that could guide us beyond democracy, and a few general proposals for how to understand what we might do instead of <em>governing.</em> Most of the work remains to be done.
    </p>

    <aside>
    <blockquote class="accent">“Anarchism represents not the most radical form of democracy, but an altogether different paradigm of collective action.”
    <p class="attribution">– <a href="https://books.google.com/books?id=p5t0R0ckDMAC&amp;pg=PA58&amp;lpg=PA58&amp;dq=%E2%80%9CAnarchism,+then,+represents+not+the+most+radical+form+of+democracy,+but+an+altogether+different+paradigm+of+collective+action.%E2%80%9D&amp;source=bl&amp;ots=Bj9Wi1BhHM&amp;sig=7jehllpfPRAlIjGrHpgwST5xCdA&amp;hl=en&amp;sa=X&amp;ved=0ahUKEwjblt3IjorLAhWHWh4KHeWRCWgQ6AEIHDAA#v=onepage&amp;q=%E2%80%9CAnarchism%2C%20then%2C%20represents%20not%20the%20most%20radical%20form%20of%20democracy%2C%20but%20an%20altogether%20different%20paradigm%20of%20collective%20action.%E2%80%9D&amp;f=false">Uri Gordon</a>, <em>Anarchy Alive!</em>
    </p>
    </blockquote>
    </aside>

    <h3 id="horizontalitydecentralizationautonomyanarchy">Horizontality, Decentralization, Autonomy, Anarchy</h3>

    <p>Under scrutiny, democracy does not live up to the values that drew us to it in the first place—<em>egalitarianism, inclusivity, self-determination.</em> Alongside these values, we must add <em>horizontality, decentralization,</em> and <em>autonomy</em> as their indispensible counterparts.
    </p>

    <p>Horizontality has gained a lot of currency since the late 20th century. Starting with the <a href="https://roarmag.org/essays/zapatistas-latin-american-movements/">Zapatista uprising</a> and gaining momentum through the anti-globalization movement and the <a href="https://theanarchistlibrary.org/library/various-authors-que-se-vayan-todos-out-with-them-all-argentina-s-popular-rebellion">rebellion in Argentina</a>, the idea of leaderless structures has spread even into <a href="http://www.holacracy.org/how-it-works/">the business world.</a>
    </p>

    <p>But decentralization is just as important as horizontality if we do not wish to be trapped in a tyranny of equals, in which everyone has to be able to agree on something for anyone to be able to do it. Rather than a single process through which all agency must pass, decentralization means multiple sites of decision-making and multiple forms of legitimacy. That way, when power is distributed unevenly in one context, this can be counterbalanced elsewhere. Decentralization means preserving difference—strategic and ideological diversity is a source of strength for movements and communities, just as biodiversity is in the natural world. We should neither segregate ourselves into homogenous groups on the pretext of affinity nor reduce our politics to lowest common denominators.
    </p>

    <p>Decentralization implies autonomy—<a href="http://www.theatlantic.com/health/archive/2016/03/people-want-power-because-they-want-autonomy/474669">the ability to act freely</a> on one’s own initiative. Autonomy can apply at any level of scale—a single person, a neighborhood, a movement, <a href="http://www.crimethinc.com/texts/r/kurdish/">an entire region.</a> To be free, you need control over your immediate surroundings and the details of your daily life; the more self-sufficient you are, the more secure your autonomy is. This needn’t mean meeting all your needs independently; it could also mean the kind of interdependence that gives you leverage on the people you depend on. No single institution should be able to monopolize access to resources or social relations. A society that promotes autonomy requires what an engineer would call redundancy: a wide range of options and possibilities in every aspect of life.
    </p>

    <p>If we wish to foster freedom, it’s not enough to affirm autonomy alone.<sup class="footlink">
    <a href="#15" name="1return">15</a>
    </sup>
    <sup class="refnumber">15</sup>
    <small>
    <span class="fnumber">15.</span> “Autonomy” is derived from the ancient Greek prefix <em>auto-,</em> self, and <em>nomos,</em> law—giving oneself one’s own law. This suggests an understanding of personal freedom in which one aspect of the self—say, the superego—permanently controls the others and dictates all behavior. Kant defined autonomy as self-legislation, in which the individual compels himself to comply with the universal laws of objective morality rather than acting according his desires. By contrast, an anarchist might counter that we owe our freedom to the spontaneous interplay of myriad forces within us, not to our capacity to force a single order upon ourselves. Which of those conceptions of freedom we embrace will have repercussions on everything from how we picture freedom on a planetary scale to <a href="http://thebaffler.com/salvos/whats-the-point-if-we-cant-have-fun">how we understand the movements of subatomic particles.</a>
    </small> A nation-state or political party can assert autonomy; so can nationalists and racists. The fact that a person or group is autonomous tells us little about whether the relations they cultivate with others are egalitarian or hierarchical, inclusive or exclusive. If we wish to maximize autonomy for everyone rather than simply seeking it for ourselves, we have to create a social context in which no one is able to accumulate institutional power over anyone else. </p>

    <p>We have to create <a href="http://www.crimethinc.com/texts/r/begin/#faq">
    <em>anarchy.</em>
    </a>
    </p>

    <h3 id="demystifyinginstitutions">Demystifying Institutions</h3>

    <p>Institutions exist to serve us, not the other way around. They have no inherent claim on our obedience. We should never invest them with more legitimacy than our own needs and desires. When our wishes conflict with others’ wishes, we can see if an institutional process can produce a solution that satisfies everyone; but as soon as we accord an institution the right to adjudicate our conflicts or dictate our decisions, we have abdicated our freedom.
    </p>

    <p>This is not a critique of a particular organizational model, or an argument for “informal” structures over “formal” ones. Rather, it demands that we treat all models as provisional—that we ceaselessly reappraise and reinvent them. Where <a href="http://www.ushistory.org/paine/commonsense/singlehtml.htm">Thomas Paine</a> wanted to enthrone the law as king, where Rousseau theorized the social contract and more recent enthusiasts of capitalism <em>über alles</em> dream of a society based on contracts alone, we counter that when relations are truly in the best interests of all participants, there is no need for laws or contracts.
    </p>

    <p>Likewise, this is not an argument in favor of mere individualism, nor of treating relationships as expendable, nor of organizing only with those who share one’s preferences. In a crowded, interdependent world, we can’t afford to refuse to coexist or coordinate with others. The point is simply that we must not seek to <em>legislate</em> relations.
    </p>

    <p>Instead of deferring to a blueprint or protocol, we can evaluate institutions on an ongoing basis: Do they reward cooperation—or contention? Do they distribute agency—or create bottlenecks of power? Do they offer each participant the opportunity to fulfill her potential on her own terms—or impose external imperatives? Do they facilitate the resolution of conflict on mutually agreeable terms—or punish all who run afoul of a codified system?</p>

    <aside>
    <blockquote class="accent">“He expressed himself to us that we should never allow ourselves to be tempted by any consideration to acknowledge laws and institutions to exist as of right if our conscience and reason condemned them. He admonished us not to care whether a majority, no matter how large, opposed our principles and opinions; the largest majorities were sometimes only organized mobs.”
    <p class="attribution">– <a href="http://www.wvculture.org/history/jbexhibit/bondisalenaherald.html">August Bondi,</a> writing about John Brown</p>
    </blockquote>
    </aside>

    <h3 id="creatingspacesofencounter">Creating Spaces of Encounter</h3>

    <p>In place of formal sites of centralized decision-making, we propose a variety of <em>spaces of encounter</em> where people may open themselves to each other’s influence and find others who share their priorities. Encounter means mutual transformation: establishing common points of reference, common concerns. The space of encounter is not a representative body vested with the authority to make decisions for others, nor a governing body employing majority rule or consensus. It is an opportunity for people to experiment with acting in different configurations on a voluntary basis.
    </p>

    <p>The spokescouncil immediately preceding the demonstrations against the 2001 Free Trade Area of the Americas summit in Quebec City was a classic space of encounter. This meeting brought together a wide range of autonomous groups that had converged from around the world to protest the FTAA. Rather than attempting to make binding decisions, the participants introduced the initiatives that their groups had prepared and coordinated for mutual benefit wherever possible. Much of the decision-making occurred afterwards in informal intergroup discussions. By this means, thousands of people were able to synchronize their actions without need of central leadership, without giving the police much insight into the wide array of plans that were to unfold. Had the spokescouncil employed an organizational model intended to produce unity and centralization, the participants could have spent the entire night fruitlessly arguing about goals, strategy, and which tactics to allow.
    </p>

    <p>Most of the social movements of the past two decades have been hybrid models juxtaposing spaces of encounter with some form of democracy. In Occupy, for example, the encampments served as open-ended spaces of encounter, while the general assemblies were formally intended to function as directly democratic decision-making bodies. Most of those movements achieved their greatest effects because the encounters they facilitated opened up opportunities for autonomous action, not because they centralized group activity through direct democracy.<sup class="footlink">
    <a href="#16" name="16return">16</a>
    </sup>
    <sup class="refnumber">16</sup>
    <small>
    <span class="fnumber">16.</span> Many of the decisions that gave <a href="http://www.crimethinc.com/texts/atoz/atc-oak.php">Occupy Oakland</a> a greater impact than other Occupy encampments, including the refusal to negotiate with the city government and the militant reaction to the first eviction, were the result of autonomous initiatives, not consensus process. Meanwhile, some occupiers interpreted consensus process as a sort of decentralized legal framework in which any action undertaken by any participant in the occupation should require the consent of every other participant. As one participant recalls, “One of the first times the police tried to enter the camp at Occupy Oakland, they were immediately surrounded and shouted at by a group of about twenty people. Some other people weren’t happy about this. The most vocal of these pacifists placed himself in front of those confronting the police, crossed his forearms in the X that symbolizes strong disagreement in the sign language of consensus process, and said ‘You can’t do this! I block you!’ For him, consensus was a tool of horizontal control, giving everyone the right to suppress whichever of others’ actions they found disagreeable.”</small> If we approach the <em>encounter</em> as the driving force of these movements, rather than as a raw material to be shaped through democratic process, it might help us to prioritize what we do best.
    </p>

    <p>Anarchists frustrated by the contradictions of democratic discourse have sometimes withdrawn to organize themselves according to preexisting affinity alone. Yet segregation breeds stagnation and fractiousness. It is better to organize on the basis of our conditions and needs so we come into contact with all the others who share them. Only when we understand ourselves as nodes within dynamic collectivities, rather than discrete entities possessed of static interests, can we make sense of the rapid metamorphoses that people undergo in the course of experiences like the Occupy movement—and the tremendous power of the <em>encounter</em> to transform us if we open ourselves to it.
    </p>

    <h3 id="cultivatingcollectivitypreservingdifference">Cultivating Collectivity, Preserving Difference</h3>

    <p>If no institution, contract, or law should be able to dictate our decisions, how do we agree on what responsibilities we have towards each other?</p>

    <p>Some have suggested a distinction between “closed” groups, in which the participants agree to answer to each other for their actions, and “open” groups that need not reach consensus. But this begs the question: how do we draw a line between the two? If we are accountable to our fellows in a closed group only until we choose to leave it, and we may leave at any time, that is little different from participating in an open group. At the same time, we are all involved, like it or not, in one closed group sharing a single inescapable space: earth. So it is not a question of distinguishing the spaces in which we must be accountable to each other from the spaces in which we may act freely. The question is how to foster both responsibility and autonomy at every order of scale.
    </p>

    <p>Towards this end, we set out to create mutually fulfilling collectivities at each level of society—spaces in which people identify with each other and have cause to do right by each other. These can take many forms, from housing cooperatives and neighborhood assemblies to international networks. At the same time, we recognize that we will have to reconfigure them continuously according to how much intimacy and interdependence proves beneficial for the participants. When a configuration must change, this need not be a sign of failure: on the contrary, it shows that the participants are not competing for hegemony. Instead of treating group decision-making as a pursuit of unanimity, we can approach it as a space for differences to arise, conflicts to play out, and transformations to occur as different social constellations converge and diverge. Disagreeing and dissociating can be just as desirable as reaching agreement, provided they occur for the right reasons; the advantages of organizing in larger numbers should suffice to discourage people from fracturing gratuitously.
    </p>

    <p>Our institutions should help us to tease out differences, not suppress or submerge them. Some witnesses <a href="http://rudaw.net/english/kurdistan/23122015">returning from Rojava</a> report that when an assembly there cannot reach consensus, it splits into two bodies, dividing its resources between them. If this is true, it offers a model of voluntary association that is a vast improvement on the Procrustean unity of democracy.
    </p>

    <h3 id="resolvingconflicts">Resolving conflicts</h3>

    <p>Sometimes dividing into separate groups isn’t enough to resolve conflicts. To dispense with centralized coercion, we have to come up with new ways of addressing strife. Conflicts between those who oppose the state are one of the chief assets that preserve its supremacy.<sup class="footlink">
    <a href="#17" name="17return">17</a>
    </sup>
    <sup class="refnumber">17</sup>
    <small>
    <span class="fnumber">17.</span> Witness the Mexican <a href="https://news.vice.com/article/where-mexicos-drug-war-was-born-a-timeline-of-the-security-crisis-in-michoacan">
    <em>autodefensas</em>
    </a> who set out to defend themselves against the cartels that are functionally identical with the government in some parts of Mexico, only to end up in gang warfare against each other.</small> If we want to create spaces of freedom, we must not become so fractured that we can’t defend those spaces, and we must not resolve conflicts in a way that creates new power imbalances.
    </p>

    <p>One of the most basic functions of democracy is to offer a way of concluding disputes. Voting, courts, and police all serve to <em>decide</em> conflicts without necessarily <em>resolving</em> them; the rule of law effectively imposes a winner-take-all model for addressing differences. By centralizing force, a strong state is able to compel feuding parties to suspend hostilities even on mutually unacceptable terms. This enables it to suppress forms of strife that interfere with its control, such as class warfare, while fostering forms of conflict that undermine horizontal and autonomous resistance, such as gang warfare. We cannot understand the religious and ethnic violence of our time without factoring in <a href="http://crimethinc.com/texts/r/protect/">the ways that state structures provoke and exacerbate it.</a>
    </p>

    <p>When we accord institutions inherent legitimacy, this offers us an excuse not to resolve conflicts, relying instead on the intercession of the state. It gives us an alibi to conclude disputes by force and to exclude those who are structurally disadvantaged. Rather than taking the initiative to work things out directly, we end up jockeying for power.
    </p>

    <p>If we don’t recognize the authority of the state, we have no such excuses: we must find mutually satisfying resolutions or else suffer the consequences of ongoing strife. This gives us an incentive to take all parties’ needs and perceptions seriously, to develop skills with which to defuse tension. It isn’t necessary to get everyone to agree, but we have to find ways to differ that do not produce hierarchies, oppression, pointless antagonism. The first step down this road is to remove the incentives that the state offers <em>not</em> to resolve conflict.
    </p>

    <p>Unfortunately, many of the models of conflict resolution that once served human communities are now lost to us, forcibly replaced by the court systems of ancient Athens and Rome. We can look to experimental models of <a href="https://niastories.files.wordpress.com/2013/08/tjcurriculum_design_small-finalrev.pdf">transformative justice</a> for a glimpse of the alternatives we will have to develop.
    </p>

    <h3 id="refusingtoberuled">Refusing to Be Ruled</h3>

    <p>Envisioning what a horizontal and decentralized society might look like, we can imagine overlapping networks of collectives and assemblies in which people organize to meet their daily needs—food, shelter, medical care, work, recreation, discussion, companionship. Being interdependent, they would have good reason to settle disputes amicably, but no one could force anyone else to remain in an arrangement that was unhealthy or unfulfilling. In response to threats, they would mobilize in larger ad hoc formations, drawing on connections with other communities around the world.
    </p>

    <p>In fact, a great many stateless societies have looked something like this in the course of human history. Today. models like this continue to appear at the intersections of <a href="https://unsettlingamerica.wordpress.com/2011/09/02/indigenism-anarchism-feminism/">indigenous, feminist, and anarchist traditions.</a>
    </p>

    <aside>
    <blockquote class="accent">“The principle that the majority have a right to rule the minority, practically resolves all government into a mere contest between two bodies of men, as to which of them shall be masters, and which of them slaves; a contest, that—however bloody—can, in the nature of things, never be finally closed, so long as man refuses to be a slave.”
    <p class="attribution">– Lysander Spooner, <a href="https://en.wikisource.org/wiki/No_Treason/1">
    <em>No Treason</em>
    </a>
    </p>
    </blockquote>
    </aside>

    <p>That brings us back to our starting place—to modern-day <a href="http://www.aljazeera.com/indepth/features/2015/11/anarchy-future-greece-151122113214286.html">Athens, Greece.</a> In the city where democracy first came of age, thousands of people now organize themselves under anarchist banners in horizontal, decentralized networks. In place of the exclusivity of ancient Athenian citizenship, their structures are extensive and open-ended; they welcome migrants fleeing the war in Syria, for they know that their experiment in freedom must grow or perish. In place of the coercive apparatus of government, they seek to maintain a decentralized distribution of power reinforced by a collective commitment to solidarity. Rather than uniting to impose majority rule, they cooperate to prevent the possibility of rule itself.
    </p>

    <p>This is not an outdated way of life, but the end of a long error. </p>

    <div class="bigimage">
    <img src="http://www.crimethinc.com/texts/r/democracy/images/greece1370.jpg">
    <div class="bigimagecaption">
    <p>Anarchists assembling in 21st-century Athens, Greece.
    </p>
    </div>
    </div>


    <h3 id="fromdemocracytofreedom">From Democracy to Freedom</h3>

    <p>Let’s return to the high point of the uprisings. Thousands of us flood into the streets, finding each other in new formations that offer an unfamiliar and exhilarating sense of agency. Suddenly everything intersects: words and deeds, ideas and sensations, personal stories and world events. Certainty—finally, we feel at home—and uncertainty: finally, an open horizon. Together, we discover ourselves capable of things we never imagined.
    </p>

    <p>What is beautiful about such moments transcends any political system. The conflicts are as essential as the flashes of unexpected consensus. This is not the functioning of democracy, but the experience of freedom—of collectively taking our destinies in our hands. No set of procedures could institutionalize this. It is a prize we must wrest from the jaws of <a href="https://sites.google.com/site/anarchyinitaly/diavolo-in-corpo/the-ferocious-jaws-of-habit">habit</a> and history again and again.
    </p>

    <p>Next time a window of opportunity opens, rather than reinventing “real democracy” yet again, let our goal be freedom, freedom itself.
    </p>

    <p>&nbsp;</p>


    <div class="footnote">
    <p>
    <a name="1">
    </a>
    <span class="footref">1. </span>“I am truly free only when all human beings, men and women, are equally free. The freedom of others, far from negating or limiting my freedom, is, on the contrary, its necessary premise and confirmation.” –Mikhail Bakunin <span class="footreturn">
    <a href="#1return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="2">
    </a>
    <span class="footref">2. </span>This seeming paradox didn’t trouble the framers of the US Constitution because the minority whose rights they were chiefly concerned with protecting was the class of property owners—who already had plenty of leverage on state institutions. As James Madison <a href="http://avalon.law.yale.edu/18th_century/yates.asp">said in 1787,</a> “Our government ought to secure the permanent interests of the country against innovation. Landholders ought to have a share in the government, to support these invaluable interests, and to balance and check the other. They ought to be so constituted as to protect the minority of the opulent against the majority.” <span class="footreturn">
    <a href="#2return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="3">
    </a>
    <span class="footref">3. </span>In this context, arguing that “the personal is political” constitutes a feminist rejection of the dichotomy between <em>oikos</em> and <em>polis.</em> But if this argument is understood to mean that the personal, too, should be subject to democratic decision-making, it only extends the logic of government into additional aspects of life. The real alternative is to affirm <em>multiple sites of power,</em> arguing that legitimacy should not be confined to any one space, so decisions made in the household are not subordinated to those made in the sites of formal politics. <span class="footreturn">
    <a href="#3return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="4">
    </a>
    <span class="footref">4. </span>This is a fundamental paradox of democratic governments: established by a crime, they sanctify law—legitimizing a new ruling order as the fulfillment and continuation of a revolt. <span class="footreturn">
    <a href="#4return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="5">
    </a>
    <span class="footref">5. </span>“Obedience to the law is true liberty,” reads <a href="http://www.jstor.org/stable/2563945?seq=1#page_scan_tab_contents">one memorial</a> to the soldiers who suppressed Shay’s Rebellion. <span class="footreturn">
    <a href="#5return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="6">
    </a>
    <span class="footref">6. </span>Just as the “libertarian” capitalist suspects that the activities of even the most democratic government interfere with the pure functioning of the free market, the partisan of pure democracy can be sure that as long as there are economic inequalities, the wealthy will always wield disproportionate influence over even the most carefully constructed democratic process. Yet government and economy are inseparable. The market relies upon the state to enforce property rights, while at bottom, democracy is a means of transferring, amalgamating, and investing political power: it is a market for agency itself. <span class="footreturn">
    <a href="#6return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="7">
    </a>
    <span class="footref">7. </span>The objection that the democracies that govern the world today aren’t <a href="http://www.crimethinc.com/texts/recentfeatures/barc.php">
    <em>real</em> democracies</a> is a variant of the classic <a href="http://www.logicallyfallacious.com/index.php/logical-fallacies/136-no-true-scotsman">“No true Scotsman” fallacy.</a> If, upon investigation, it turns out that not a single existing democracy lives up to what you mean by the word, you might need a different expression for what you are trying to describe. This is like communists who, confronted with all the repressive communist regimes of the 20th century, protest that not a single one of them was properly communist. When an idea is so difficult to implement that millions of people equipped with a considerable portion of the resources of humanity and doing their best across a period of centuries can’t produce a single working model, it’s time to go back to the drawing board. Give anarchists a tenth of the opportunities Marxists and democrats have had, and then we may speak about whether <a href="https://theanarchistlibrary.org/library/peter-gelderloos-anarchy-works">anarchy works!</a> <span class="footreturn">
    <a href="#7return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="8">
    </a>
    <span class="footref">8. </span>Without formal institutions, democratic organizations often enforce decisions by delegitimizing actions initiated outside their structures and encouraging the use of force against them. Hence the classic scene in which protest marshals attack demonstrators for doing something that wasn’t agreed upon in advance via a centralized democratic process. <span class="footreturn">
    <a href="#8return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="9">
    </a>
    <span class="footref">9. </span>In theory, categories that are defined by exclusion, like citizenship, break down when we expand them to include the whole world. But if we wish to break them down, why not reject them outright, rather than promising to do so while further legitimizing them? When we use the word citizenship to describe something desirable, that can’t help but reinforce the legitimacy of that institution as it exists today. <span class="footreturn">
    <a href="#9return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="10">
    </a>
    <span class="footref">10. </span>In fact, the English word “police” is derived from <em>polis</em> by way of the ancient Greek word for citizen. <span class="footreturn">
    <a href="#10return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="11">
    </a>
    <span class="footref">11. </span>See <a href="https://korpora.zim.uni-duisburg-essen.de/kant/aa07/330.html">Kant’s argument</a> that a republic is “violence with freedom and law,” whereas anarchy is “freedom and law without violence”—so the law becomes a mere recommendation that cannot be enforced. <span class="footreturn">
    <a href="#11return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="12">
    </a>
    <span class="footref">12. </span>This far, at least, we can agree with Booker T. Washington when he said, “The Reconstruction experiment in racial democracy failed because it began at the wrong end, emphasizing political means and civil rights acts rather than economic means and self-determination.” <span class="footreturn">
    <a href="#12return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="13">
    </a>
    <span class="footref">13. </span>At the end of May 1968, the announcement of snap elections <a href="http://www.jstor.org/stable/1600894?seq=1#page_scan_tab_contents">broke the wave of wildcat strikes and occupations</a> that had swept across France; the spectacle of the majority of French citizens voting for President de Gaulle’s party was enough to dispel all hope of revolution. This illustrates how elections serve as a pageantry that <em>represents</em> citizens to each other as willing participants in the prevailing order. <span class="footreturn">
    <a href="#13return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="14">
    </a>
    <span class="footref">14. </span>As economic crises intensify alongside widespread disillusionment with representational politics, we see governments offering more direct participation in decision-making to pacify the public. Just as the dictatorships in Greece, Spain, and Chile were forced to transition into democratic governments to neutralize protest movements, the state is opening up new roles for those who might otherwise lead the opposition to it. If we are directly responsible for making the political system work, we will blame ourselves when it fails—not the format itself. This explains the new experiments with “participatory” budgets from Pôrto Alegre <a href="http://www.obserwatorfinansowy.pl/tematyka/finanse-publiczne/participatory-budgeting-or-pocket-money-for-voters/">to Poznań.</a> In practice, the participants rarely have any leverage on town officials; at most, they can act as consultants, or vote on a measly 0.1% of city funds. The real purpose of participatory budgeting is to redirect popular attention from the failures of government to the project of making it <em>more democratic.</em> <span class="footreturn">
    <a href="#14return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="15">
    </a>
    <span class="footref">15. </span>“Autonomy” is derived from the ancient Greek prefix <em>auto-,</em> self, and <em>nomos,</em> law—giving oneself one’s own law. This suggests an understanding of personal freedom in which one aspect of the self—say, the superego—permanently controls the others and dictates all behavior. Kant defined autonomy as self-legislation, in which the individual compels himself to comply with the universal laws of objective morality rather than acting according his desires. By contrast, an anarchist might counter that we owe our freedom to the spontaneous interplay of myriad forces within us, not to our capacity to force a single order upon ourselves. Which of those conceptions of freedom we embrace will have repercussions on everything from how we picture freedom on a planetary scale to <a href="http://thebaffler.com/salvos/whats-the-point-if-we-cant-have-fun">how we understand the movements of subatomic particles.</a> <span class="footreturn">
    <a href="#15return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="16">
    </a>
    <span class="footref">16. </span>Many of the decisions that gave <a href="http://www.crimethinc.com/texts/atoz/atc-oak.php">Occupy Oakland</a> a greater impact than other Occupy encampments, including the refusal to negotiate with the city government and the militant reaction to the first eviction, were the result of autonomous initiatives, not consensus process. Meanwhile, some occupiers interpreted consensus process as a sort of decentralized legal framework in which any action undertaken by any participant in the occupation should require the consent of every other participant. As one participant recalls, “One of the first times the police tried to enter the camp at Occupy Oakland, they were immediately surrounded and shouted at by a group of about twenty people. Some other people weren’t happy about this. The most vocal of these pacifists placed himself in front of those confronting the police, crossed his forearms in the X that symbolizes strong disagreement in the sign language of consensus process, and said ‘You can’t do this! I block you!’ For him, consensus was a tool of horizontal control, giving everyone the right to suppress whichever of others’ actions they found disagreeable.” <span class="footreturn">
    <a href="#16return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
    <br />
    <p>
    <a name="17">
    </a>
    <span class="footref">17. </span>Witness the Mexican <a href="https://news.vice.com/article/where-mexicos-drug-war-was-born-a-timeline-of-the-security-crisis-in-michoacan">
    <em>autodefensas</em>
    </a> who set out to defend themselves against the cartels that are functionally identical with the government in some parts of Mexico, only to end up in gang warfare against each other. <span class="footreturn">
    <a href="#17return">&#x21A9;&#xFE0E;</a>
    </span>
    </p>
  }
}

articles << {
  url: "http://www.crimethinc.com/texts/r/kurdish/",
  category: "Technology",
  title: %q{
    Understanding the Kurdish Resistance
  },
  subtitle: %q{
    Historical Overview & Eyewitness Report
  },
  image: "http://crimethinc.com/texts/r/kurdish/images/header2000.jpg",
  content: %q{
    <p>Until recently, few in the Western world had heard of the Kurds, let alone their revolutionary history. Brought into the spotlight by their fight against the Islamic State of Iraq and Syria (ISIS), they have received a great deal of attention both from the mainstream mass media and from radicals and revolutionaries around the world. </p>

    <p>Romanticized and often summarized superficially as a population fighting Islamists, the Kurds have a tradition of self-defense extending across several national borders. They have been fighting for their liberation since the dissolution of the Ottoman Empire, if not prior; the religious revolts led by Sheikh Said in 1925 and the uprising against assimilation in Dersim in 1937 are only two examples out of a long legacy of Kurdish resistance. But without a doubt, the most long-lasting and effective Kurdish rebellion has been the one launched by the PKK (Partiye Karkerên Kurdistanê—Kurdish Workers Party) 40 years ago. The resistance to ISIS in Northern Syria (western Kurdistan—Rojava)<sup class="footlink"><a href="#1" name="1return">1</a></sup><sup class="refnumber">1</sup><small><span class="fnumber">1.</span> Geographically, Kurdistan is defined by cardinal directions. So western Kurdistan, which is in northern Syria, is called <em>Rojava</em> (West); northern Kurdistan, which is in southeastern Turkey, is <em>Bakur</em> (North); southern Kurdistan, in northern Iraq, is <em>Bashur</em> (South); and eastern Kurdistan, in southwestern Iran, is <em>Rojhelat</em> (East).</small> and the fight for the autonomy of Kurds in Turkey (northern Kurdistan—Bakur) are the culmination of the PKK’s decades-long struggle. Yet the PKK looks very different today than it did during its formation, and its aspirations have evolved alongside its political context. </p>

    <p>What follows is my attempt to share what I have learned and observed during my visits to Kurdistan, in both Bakur and Rojava. It is a long and complex story filled with difficult contradictions, some of which will be presented below. In the face of incredible odds, the resilient Kurds have been able to put theory into practice alongside a well-crafted strategy. To understand their movement today, lets start by looking at how it emerged.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/ydgh1370.jpg">
      <div class="bigimagecaption"><p>A member of the PKK youth group at a border encampment on the second anniversary of the Rojava Revolution. Two hours later, hundreds of Kurdish youth stormed the border to join the YPG.</p></div>
    </div>

    <h2>The Early Days of the PKK</h2>

    <p>The PKK is the product of two different historical processes. The first and more fundamental one is the formation of the Turkish nation-state, a project based upon the elimination of all non-Muslims and the assimilation of all non-Turkish ethnicities. The second and more immediate accelerant is the powerful youth and student movement of the late 1960s and ’70s in Turkey. </p>

    <p>To understand contemporary Turkish politics, be it the official denial of the Armenian Genocide or the repression of the Kurdish movement, we must recognize how deeply ultra-nationalism is woven into the fabric of society. It is analogous to the Baathist regimes elsewhere in the region, which are now meeting their expiration dates. All the ingredients are there: a formidable and charismatic leader, Mustafa Kemal;<sup class="footlink"><a href="#2" name="2return">2</a></sup><sup class="refnumber">2</sup><small><span class="fnumber">2.</span> Known as Atatürk—the great Turk—after 1934.</small> the creation of a national identity, Turkishness; and assimilation into a hegemonic yet constructed culture. In Turkey, the formal creation of the nation-state in 1923 was a modernizing project in its own right. Various vernacular languages (e.g., Kurdish, Arabic, Armenian, Greek) as well as the Arabic alphabet (modified and used in written Ottoman, Kurdish, and Persian in addition to Arabic) were scrapped in favor of the Latin alphabet; a language called Turkish was re-invented, by modernizing vernacular Turkish with a heavy dose of European influence. Forms of religious expression, from public gatherings to clothing, were repressed in the name of modern secularism. At the same time, Islam became regulated by the state, kept in reserve to mobilize against leftists or minorities. As a nation-building project, Kemalism essentially sowed the seeds of its own destruction; ironically, it is responsible for both the neoliberal Islam of Recep Tayyip Erdoğan and the AKP, and the Democratic Confederalism of Öcalan and the PKK. </p>

    <p>The degree to which this ultra-nationalism is hammered into those who live within the borders of Turkey is difficult for a Western audience to grasp. Every morning of her official schooling, a Kurdish schoolchild has to take an oath that begins “I am Turkish, I am right, I work hard,” only to file into a classroom with a portrait of Atatürk staring down from the wall, where she will hear teachers present the history of the Ottoman Empire and emphasize that Turkey is surrounded by enemies on all sides. She must go through the motions of patriotic holidays several times a year: the anniversary of the declaration of the republic (OK), the anniversary of the death of Atatürk (well . . . fine), the Youth and Sports holiday (seriously?), the Sovereignty and Children’s Holiday (give me a break). For men, compulsory military service<sup class="footlink"><a href="#3" name="3return">3</a></sup><sup class="refnumber">3</sup><small><span class="fnumber">3.</span> Although Turkey has universal conscription, it also has laws which permit one to pay nearly $10,000 to be exempt from it. In addition, those with higher-level education are often able to land safer positions. Thus those who actually fight the wars are predominantly poor.</small> is a rite of passage into manhood and a precondition of employment. It’s common to see rowdy street rituals in which young men are sent off to do their military service by crowds of their closest male friends.</p>

    <p>Nationalism comes not only from the Right but also from the Left, and the 1968 generation was no exception. In contrast to their counterparts in other countries, this generation resembled the old Left more than the new. Many of the most revered veterans and martyrs of the leftist student movement saw themselves as continuing Atatürk’s project of national liberation from imperialist powers. It’s telling that the most promising move on the part of the leftist student movement involved launching a failed coup of their own with dissident members of the military. This powerful youth movement occupied many universities and organized large marches, including an infamous march in which members of the US Navy’s 6th Fleet were <a href="http://www.turksolu.com.tr/245/konuksever245.htm">“dumped in the sea”</a>—playing on the mythical imagery of Atatürk’s national liberation army dumping the Greeks into the Aegean Sea, a fairytale often repeated to Turkish schoolchildren. Though it was eventually crushed by the military coup of March 12, 1971, this student movement left a legacy of armed groups, including Deniz Gezmiş’s THKO (Turkish People’s Liberation Army) and Mahir Çayan’s THKP (Turkish People’s Liberation Party).<sup class="footlink"><a href="#4" name="4return">4</a></sup><sup class="refnumber">4</sup><small><span class="fnumber">4.</span> Mahir was killed in a military raid during the kidnapping of NATO technicians with the demand of freeing Deniz and two others who would also be executed, Hüseyin Inan and Yusuf Küpeli. Deniz was hung by military rule.</small></p>

    <p>One of the students active in the post-coup second wave of the student movement in Turkey was Abdullah Öcalan. Born in 1949 in the Kurdish territories of southeastern Turkey, Öcalan came to the Turkish capital of Ankara in 1971 to study. He was impressed by the student movement, which had gone as far as torching the vehicle of the American ambassador. Alongside the Turkish student movement, which left little space to talk about the Kurds, there was a new incarnation of Kurdish socialism on the rise, especially in the form of the Eastern Revolutionary Cultural Houses (DDKO). Other Kurdish groups had even started to <a href="http://bianet.org/biamag/siyaset/151883-dr-sivan-belgeselinden-bugune-ipuclari">organize guerillas in Kurdistan</a>. Öcalan entered this milieu and advanced his idea of Kurdistan as an internal colony of Turkey, quickly gaining adherents. Comprising a nucleus of political militants, this dozen or so people came to be known as <em>Apocular (Apoers)</em>, a term used for the followers of Öcalan’s thought to this day. Not all the members of this initial cadre were Kurds, but they all believed in Kurdish liberation from the Turkish state. </p>

    <p>This core group left Ankara to foment revolution in Kurdistan. The ideological flavor of the day, especially with Turkey in NATO, was Marxism-Leninism; founded in 1978 at a meeting in the village of Fis, the PKK (Partiye Karkerên Kurdistanê—Kurdish Workers Party) modeled itself on those principles. The first manifesto written by Öcalan that year closes by professing that the Kurdish Revolution was a part of the global proletarian revolution that started with the Russian October Revolution and was growing stronger through national liberation movements. The group acquired its first AK&#8211;47 from Syria and started carrying out small actions and agitating in towns in Northern Kurdistan. Öcalan traveled constantly, presenting lengthy lectures, sometimes day-long sessions, which were a major component of these initial efforts. This form is still seen in the political education sessions that all participants in the Kurdish movement are expected to complete, guerrillas and politicians alike.</p>

    <p>This initial phase was cut short by another military coup only ten years later, in 1980—much bloodier in its consequences, with at least 650,000 arrested, more than 10,000 tortured, and fifty people hanged by the state. Öcalan had fled the country shortly before, and many of the initial cadre followed in his footsteps. Their destination: Syria. In fact, Öcalan crossed from Suruç in Turkey into Kobanê in Syria—two towns that have become symbols of the Kurdish resistance, and a crossing hundreds if not thousands of Kurds have made this past year to join the fight against ISIS. From Syria, Öcalan started his project in earnest and began to make contact with the Kurdish leadership in the region, arranging meetings with Barzani and Talabani, tribal leaders with a bourgeois nationalist line. He arranged for the first trainings of Kurdish guerrillas in Palestinian camps, and later in more independently run camps in Lebanon. The trained members of the PKK crossed back into Turkey to begin the armed struggle announced by their first large-scale action in August of 1984, the raids on the towns of Eruh and Şemdinli. </p>

    <p>The PKK entered the 1990s with a guerrilla army of more than 10,000 and started launching attacks on Turkish military positions and other state interests such as government buildings and large-scale engineering projects. At the same time, what had begun as a concentrated effort by a core group of militants began to take hold within the entire Kurdish population in the region. Newroz 1992 was a turning point in popularizing the Kurdish liberation struggle. </p>

    <p>Newroz, celebrated until recently mostly across Iran and Northern Iraq, represents the new year and the welcoming of spring. Although this celebration was even observed in central Asian Turkic communities, Turkey rejected it; the PKK advanced the idea of Newroz as a national holiday of resistance for Northern Kurdistan. Since the late ’80s, March 21 has been a day of mass gatherings, often culminating in epic clashes with the police. Newroz of 1992 was especially brutal, as the ruthless police state that was to devastate Northern Kurdistan began to show its face; <a href="https://www.youtube.com/watch?v=ROqnwlymgEc">the killing of fifty people during Newroz 1992 in the town of Cizre was the opening act</a>. The ’90s in Kurdistan saw the dirtiest of civil wars, with the state employing paramilitary groups culled from both ultra-nationalists and Islamic fundamentalists. To dry out “the sea in which the guerrilla swam,” 4500 villages were evacuated or burned to the ground. Most of the 40,000 who have died in the war in Northern Kurdistan perished in the 1990s. </p>


    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/cizre1370.jpg">
      <div class="bigimagecaption"><p>Children in Cizre.</p></div>
    </div>

    <h2>Öcalan’s Prison Years and the Peace Process</h2>

    <p>Öcalan’s eventual capture on February 15, 1999 is a tale to be told, referred to by the Kurdish movement as “The Great Conspiracy.” Threatened by Turkish military action, the Syrian government finally told Öcalan that his welcome was over and he had to leave. The international cadre of the PKK scrambled to find him a new refuge, but no country would touch him. Shuttled between Greece and Russia, Öcalan finally found himself under house arrest in Italy. Since members of the European Union are not allowed to extradite prisoners to countries where capital punishment exists, one early morning Öcalan was shuttled to Kenya, where he was picked up by Turkish commandos. Drugged and tied up, Öcalan was flown back to Turkey; <a href="https://www.youtube.com/watch?v=YBBmvB4z-cU">the video</a> of this had a chilling effect across Kurdistan. </p>

    <p>A new phase of the Kurdish Struggle was at the door. The PKK had to reinvent itself with its leader behind bars and sentenced to death, the only prisoner in an island prison about 50 miles from Istanbul. In the end, Turkey abolished capital punishment in its quest to join the European Union, and Öcalan’s sentence was commuted to life in prison; this also meant that the Turkish state could utilize him in the future. Between 1999 and 2004, the PKK declared a ceasefire, although the Turkish state massacred closed to 800 fighters as they were attempting to leave the country to reach their main base in Iraq. This was the closest the PKK ever came to decomposition, and Öcalan’s supreme authority was challenged. But as he himself has pointed out, “The history of the PKK is a history of purges”—the PKK cadre centered around Öcalan survived its challengers, including his own brother. </p>

    <p>In prison, Öcalan found time to read and write as he immersed himself in a panoply of thinkers and subjects. Many have referenced how he studied Murray Bookchin;<sup class="footlink"><a href="#5" name="5return">5</a></sup><sup class="refnumber">5</sup><small><span class="fnumber">5.</span> Although Western leftists are fascinated by the Bookchin-Öcalan connection, it is not as if Kurdish militants are walking around with Bookchin under their arms in the region. Sure, Democratic Confederalism resembles libertarian municipalities, but pointing to Bookchin as the ideological forefather reeks of Eurocentrism.</small> he also studied Immanuel Wallerstein and his World Systems Analysis, as well as texts on the history of civilization and Mesopotamia. Under the guise of formulating his defense for the Turkish courts as well as to the European Human Rights Court and providing a <a href="http://gomanweb.org/GOMANWEB2/Yeni-Dosyalar/A.Ocalan_Yol_haritasi/ocalanin_yol_haritasi.pdf">roadmap for peace in Turkey</a>, he penned several manifestos in which he broke with his traditional views on national liberation, with all its historical Marxist-Leninist baggage, and formulated more palatable ideas under his conditions of imprisonment. These ideas were Democratic Autonomy and Confederalism.</p>

    <p>A further development shifted the context of the Kurdish question. In late 2002, the Justice and Development Party (AKP), headed to this day by the despotic Recep Tayyip Erdoğan, won the general elections and came to power, ending more than a decade of dysfunctional coalition governments. Modeling itself as what can be termed Islamic neoliberalism, the AKP set about integrating Turkey further into the global financial system by means of privatization, enclosure, and incurring debt. In effect, the debt once owed to the IMF is now held by the private sector. At the same time, Turkey was subjected to desecularization by a creeping fundamentalist morality<sup class="footlink"><a href="#6" name="6return">6</a></sup><sup class="refnumber">6</sup><small><span class="fnumber">6.</span> There is no question that Muslims were subjected to a conservative secularism in Turkey prior to the AKP. Erdogan’s electoral successes capitalized on the resulting frustration.</small> and the authoritarian rule of Erdoğan. Erdoğan presented this project as returning Turkey to its rightful historical place by reincarnating its Ottoman heritage and emphasizing economic growth for the nation.</p>

    <p>In May 2004, the PKK once again began a phase of armed struggle, ending the ceasefire that had held since 1999. Kurds endured increasing repression by the Turkish State and cross-border operations into PKK positions in Northern Iraq. As he consolidated power, Erdogan came to realize that peace with the Kurds would facilitate his plans for regional domination that included petroleum reserves in Northern Iraq and a number of oil pipelines running through the region. By allying himself with the large Kurdish population, he hoped to pass a number of constitutional changes cementing his power. To put the plans into place, in 2009, the Turkish Intelligence Agency started to act as an intermediary in negotiations between the AKP and PKK representatives in a meeting in Oslo. </p>

    <p>Despite the renewed dialogue and various other overtures, the Turkish State continued its repression against Kurds. Starting in April 2009, the KCK (Group of Communities in Kurdistan) trials <a href="http://bianet.org/konu/kck-davasi">sent thousands of people to jail</a>. Militarily, one of the most horrific attacks was the bombing of 34 Kurdısh peasants on December 28, 2011 in Roboski, Şırnak. The Turkish state claimed they were members of the PKK crossing the border, but then had to admit that they were common villagers involved in cross-border commerce. To this day, no one has been brought in front of a judge for those murders, and the victims of Roboski <a href="http://www.dailymotion.com/video/xnmujd_roboski-katliami-imc-ozel_news">remain fresh in many people’s minds</a>. </p>

    <p>The ceasefires came and went with increasing frequency through those years; by the summer of 2012, the PKK had gained considerable territorial power. In this situation, compelled by his territorial ambitions, Erdoğan announced that meetings had been taking place with Öcalan. Three months later, during 2013’s Newroz, a letter from Öcalan was read in which he announced another ceasefire. This ceasefire was relatively long-lasting, remaining in place until July 24, 2015. But just when it seemed like stability was returning to Turkey, a chasm opened in Turkish reality on May 31, 2013. This was the Gezi Resistance.</p>


    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/yazilama1370.jpg">
      <div class="bigimagecaption"><p>Graffiti on the streets of Cizre: “Barricades are our will! Take Hold of It! - YDGK-H” (The women’s faction of the PKK youth movement YDG-H.)</p></div>
    </div>

    <h2>Gezi</h2>

    <p>The Gezi Resistance was the largest and fiercest social movement the Turkish Republic has seen <a href="https://www.indybay.org/newsitems/2014/03/03/18751818.php">enacted by its non-Kurdish population</a>. A movement sparked by <a href="http://www.crimethinc.com/blog/2013/06/19/postcards-from-the-turkish-uprising/">a struggle against the development of a park in central Istanbul</a> grew to an all-out national revolt against Erdoğan and his neoliberal policies. Kurds were present in the Gezi Resistance, too, especially after it matured into a non-nationalist and pro-revolutionary event. But for the first time in Turkish history, the Kurds were not the main protagonists of an insurrection. </p>

    <p>The participation of the Kurdish movement in the Gezi Resistance is still a controversial topic. A subtle bitterness can be felt on both ends. Many in western Turkey felt like the Kurds were at best too late to join the uprising and at worst did not even want to, for fear of jeopardizing their negotiations and peace process. In response, Kurds in the region pointed to the lack of meaningful solidarity from ethnic Turks during massacre after massacre committed against them over the preceding decades. In reality, both of these positions are caricatures. Many Kurds participated in the clashes around Gezi from day one; shortly after the park was taken from the police, the Kurdish political party of that time (BDP) set up a large encampment at its entrance and flew flags with Öcalan’s face over Taksim Square—a <a href="http://www.globaluprisings.org/taksim-commune-gezi-park-and-the-uprising-in-turkey/">surreal sight</a>. Additionally, Kurds were already engaged in their own civil disobedience campaign against the construction of fortress-like military bases in their region.</p>

    <p>In the run-up to the Gezi rebellion, the aboveground wing of the Kurdish movement was in the process of forming the HDP (Peoples’ Democracy Party) after more than a year of consultations as the HDK (Peoples’ Democratic Congress). One of their MPs stood in front of a bulldozer along with only a dozen or so people to block the uprooting of the trees during the first protests in Gezi, well before it became a massive uprising. It is no coincidence then that when it was time to select a logo for the HDP, they chose an image of a tree. </p>

    <p>Regardless of grudges, Gezi forever transformed Turkey—and with it the Kurdish liberation movement’s relationship to Turkish society in general and towards the AKP and the peace process in particular. Many Turks who were on the receiving end of police brutality had the veil lifted from their eyes and were finally able to imagine the suffering taking place in southeastern Turkey. The media blackout of the Gezi Resistance made it clear to the participants that they must have been kept in the dark about what was actually transpiring in Kurdistan. At the tail end of the Gezi resistance, when a Kurdish youth named Medeni Yıldırım was killed protesting the construction of a fortress-like police station in Kurdistan, the movement saw him as one of its own and organized solidarity demonstrations with the Kurds.</p>

    <p>This furious yet joyous rebellion, initiated by a generation that came of age under successive unstable coalition governments only to become adults under Erdoğan’s decade-long iron rule, served to consolidate hatred against Erdoğan. This generation had been defined as apolitical or even anti-political, but in reality they were what Şükrü Argın has identified as <a href="http://agorakitapligi.com/yazarlar-2/yazarlar/sukru-argin/">counter-political</a>. </p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/sahneedit1370.jpg">
      <div class="bigimagecaption"><p>Kurdish activists take shade from the scorching heat under a stage during an encampment on the Turkish-Syrian Border, July 2014.</p></div>
    </div>

    <h2>The Wild Youth of Kurdistan</h2>

    <p>Cizre is the epicenter of a region in Northern Kurdistan called Botan. The towering mountains in this region are the location of many PKK camps, and the towns at their base are some of the most rebellious. Cizre in particular continues to play an important role to this day. Cizre is where the 4th Strategic Struggle Period of the PKK materialized, shifting the point of conflict from mountainous landscapes dotted with guerrilla camps to urban epicenters in which cells of Kurdish militants organized. </p>

    <p>In June 2013, in the town of Cizre, <a href="https://www.youtube.com/watch?v=PuIfo1AyNCo">a group of 100 youth standing ceremonially in formation</a> announced the beginning of the Revolutionary Patriotic Youth Movement (YDG-H).<sup class="footlink"><a href="#7" name="7return">7</a></sup><sup class="refnumber">7</sup><small><span class="fnumber">7.</span> The word for “Patriotic” in YDG-H is <em>yurtsever</em>, which means more accurately “one who loves his or her homeland.”</small> With members ranging from their early teens to well into their twenties, this new organization coordinated urban guerrilla activity within every major metropolitan center inside Turkish borders. Kurdish youth began to employ Molotov cocktails instead of stones. The recent spike of urban combat in Kurdish towns and neighborhoods can be attributed to this new organization. Rebellious Kurdish youth were especially effective October 6&#8211;8, 2014, when it appeared that the city of Kobanê in Rojava was about to fall to ISIS. With the sanction of the official Kurdish leadership, Kurdish youth <a href="http://www.ozgur-gundem.com/haber/129905/koban-serhildani-gercegi-i">went on the offensive</a>, devastating state forces. The implicit demand in the riots was for Turkey to stop providing logistical and material support to ISIS, and to allow Kurdish forces passage across its borders—for example, by allowing some heavier artillery to cross Turkey to reach Kobanê from Iraq. After the deaths of fifty people and the imposition of curfews in six different cities and martial law in the Kurdish capital of Amed, the Turkish government finally permitted the Iraqi Kurdish Peshmerga of the KDP to reach Kobanê with their weapons.</p>


    <div class="bigimage">
      <div class="video-container">
        <iframe width="1370" height="1028" src="https://www.youtube-nocookie.com/embed/PuIfo1AyNCo?rel=0" frameborder="0" allowfullscreen></iframe>
      </div>
      <div class="embedcaption"><p style="text-indent: 0px">Announcing the formation of the YDG-H in Cizre.</p></div>
    </div>

    <p>There are great political differences between the PYD and by extension the PKK and the KDP, the current regime of Kurds in Northern Iraq who have had autonomy since the first Gulf War in 1991. The PKK/PYD are fighting for a social revolution based on self-governance, self-defense, autonomy, and women’s liberation, with an emphasis on ecology and a critique of all hierarchies, most notably state power. The KDP, on the other hand, is cultivating a national Kurdish bourgeoisie and acts as a close ally of Erdoğan. In the 1990s, the KDP fought together with Turkey against the PKK. Tensions remain high.</p>

    <p>The YDG-H is perhaps strongest in Cizre. After the uprising in defense of Kobanê, Cizre entered the national discourse again when youth rose up following the funeral of Ümit Kurt, taking control of the three neighborhoods of Sur, Cudi, and Nur. They were able to create an autonomous zone within these neighborhoods for two months by <a href="http://www.dailymotion.com/video/x2ijq0v">digging a total of 184 ditches around their neighborhoods</a>. The Turkish state effectively lost control of this area as the youth took over, burning down at least five buildings belonging to the state or its associated interests—including a school where many of them were also students. </p>

    <p>On a tour of Cizre, I asked some of the members of YDG-H why they dug ditches rather than building barricades, the traditional revolutionary method of asserting autonomy since time immemorial. My host, Hapo, explained that since the youth are armed with AK&#8211;47s, rocket-propelled grenades, and small arms, the police cannot exit their armored vehicles, but they can still plow through barricades. But again, since they cannot exit their vehicles, they also cannot traverse the ditches. Hapo described how at first they used pickaxes and shovels to excavate these ditches, but then they commandeered construction vehicles. <em>The construction vehicles of the municipal government,</em> he said, sneaking a subtle smile. I realized he meant the municipal government belonging to the aboveground political party of the Kurdish Movement, the HDP.</p>

    <p>The wild youth of Cizre are organized into “teams” of around ten individuals. Hapo told me that once the number of a team grows to more than thirty, they split into smaller groups. The teams take their names form Kurdish martyrs, often recent ones and sometimes from Cizre itself—an eerie reproduction of martyrdom and militancy. Teams claim their territory by tagging their names on walls, much as graffiti crews do elsewhere around the world. During the high point of clashes, each neighborhood establishes a base where explosives, Molotov cocktails, and weapons are stockpiled during the day in preparation for the confrontations that occur at night. The younger children are sometimes on the front lines throwing rocks at armored police vehicles, but they are always the ones who sound the alarm by running through the neighborhood shouting: “The system is coming! The enemy is coming!”</p>

    <p>The division is clear for the Kurdish militants both in the personal and the political. There is the system, and there is struggle. Students leave the system (universities) in order to join the struggle. The system and capitalist social relations inevitably corrupt all forms of romantic love; hence, real love is love for your people, for whom you struggle. Young militants twenty years of age are not allowed to succumb to their carnal desires or fall in love. If they do, and they are honest about it, they will have to provide a self-criticism and hopefully get away with a punishment only involving a further, perhaps collective, self-criticism session <em>on the platform,</em> as they say in the PKK.</p>

    <p>It is clear that the PKK is at a turning point: a new generation of militants is hitting the streets, transforming the character of the movement. Perhaps the formation of the YDG-H was a way for the old guard to assert more control over the rebellious youth of the Kurdish slums. Even if such a strategy was at play, the youth are proving hard to control; the official leadership is acknowledging that there are groups acting outside of their directives. Only Öcalan himself could reign them in. The future of the PKK and the Kurdish movement will be determined by this rebellious youth: will they will follow the party line lockstep, or come up with their own ideas?</p>

    <p>Ultimately, Öcalan had to intervene for the ditches to be closed on March 2, 2015. When I brought this up to Hapo, who consistently expressed skepticism about the official leadership of the HDP and the peace process, he said that Apo is the line they don’t cross, and that their insurrection in Cizre has strengthened his negotiating hand within prison. I was left wondering how much of the leadership cult around Öcalan has to do with his imprisonment, and whether the democratic structures being put in place constitute an attempt to abolish himself as the leader.</p>

    <p>On September 4, the Turkish military and police invaded Cizre and declared a curfew which would last for nine days. They enforced this curfew by placing snipers on the minarettes of mosques to shoot anyone out on the streets. The siege was only broken under the pressure of a march organized by Kurds from surrounding towns, which was joined by the HDP's parliament members. When people finally entered the town, they found 21 civillians dead, 15 of whom died on the spot after being shot; the others died from their wounds or other illnesses because they could not get to the hospital. Among them was a 35-day-old baby and a 71-year-old man who had attempted to get bread during the curfew. The three rebellious neighborhoods of Nur, Sur and Cudi were riddled with bullets and larger ammunition. The state blamed the PKK for the deaths, although not one member of the state forces was injured—giving the lie to the pretense that the neighborhoods were filled with “terrorists.” This latest massacre in Cizre will be remembered for a long time and fuel the Kurdish movement.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/cizre-2-1370.jpg">
      <div class="bigimagecaption"><p>Cizre. The snow-capped mountains in the distance are the mountains of Cudi, where the PKK holds their positions.</p></div>
    </div>

    <h2>The Revolution in Kurdistan</h2>

    <p>Like the movements that preceded it, Gezi took great inspiration from the uprisings in Egypt, Tunisia, and the Arab Spring that were able to topple dictators swiftly. Although Erdoğan still sits on his throne in the palace he built for himself for over a billion dollars, Gezi was not a complete failure, as it opened a new space for joyful revolt in Turkey’s future. Syria, another country that rose up during the Arab Spring, seems to have experienced a similarly bittersweet outcome. Bashar Al Assad crushed the rebellion in the central cities of Syria, while the periphery was thrown into a brutal civil war that opened up the stage for jihadist groups from Iraq and elsewhere to arrive and eventually converge under the banner of ISIS. </p>

    <p>The silver lining in Syria was supplied by the Kurds in Rojava, who had been organizing clandestinely for decades to support the PKK in the north and to establish their own political and military structures. As in Turkey, the Assad regime did not permit the expression of the Kurdish identity or education in the mother tongue, underscoring the similarity between Kemalism and Baathism. A massacre in the city of Qamishlo, in which the Syrian regime killed 52 people after a soccer riot on March 12, 2004, is often cited as the forebear of the Rojava revolution.  The main Kurdish political party, the PYD, is for all intents and purposes the sister organization of the PKK; Öcalan’s portrait is ubiquitous in Rojava.</p>

    <p>The PYD and others organized under the banner of Tev-Dem (Movement for a Democratic Society) took advantage of the approaching instability in Syria to declare autonomy on July 19, 2012. It was a relatively smooth operation, as preparatory meetings had already taken place in mosques throughout the region: more of a takeover than a battle. They organized themselves into three cantons running along the Turkish border, separated from each other by primarily Arab regions. These cantons are Afrin in the west, Kobanê in the center, and Cizire in the East. It was almost unbelievable that after decades of fighting, the Kurds—now in pursuit of Democratic Confederalism—had claimed their own territory.</p>

    <p>Öcalan’s Democratic Autonomy and Confederalism is the vision being implemented in Rojava. Autonomy, ecology, and women’s liberation are the three central points of emphasis. The most basic unit of this new society is the commune. Communes exist from the neighborhood level to workplaces including small petroleum refineries and agricultural cooperatives. There are communes specific to women, such as the Women’s Houses. All these communes are organized into assemblies that go up to the cantonal level. The current economic model in Rojava is mixed: there are private, state, and communal properties. In the <a href="http://www.kurdishinstitute.be/charter-of-the-social-contract/">Rojava Social Contract</a> (something akin to their constitution), private property is not fully disqualified, but it is said that there will be limits imposed upon it. It is a society still in transition; so far, it is much more anti-state than anti-capitalist, but it is undeniable that there is a strong anti-capitalist push from within. Time will show how far the revolutionaries of Rojava are willing to take it. </p>

    <p>The revolution in Rojava is a women’s revolution; the Kurdish movement for liberation places women’s liberation above anything else. In addition to having their own army and autonomous women-only organizations, almost every organizational structure from the municipal governments to the armed PKK formations is run by co-chairmanship of a man and a woman. Quotas are imposed for memberships and other positions, so that equal participation from both genders is ensured. March 8, International Women’s Day, is taken very seriously by Kurdish women, and even more so now with the women’s resistance exemplified by the YPJ (Women’s division of the People’s Defense Units—the YPG). In his writings, Öcalan recognizes patriarchy and the separation of genders as the first social problem in history. Perhaps paradoxically, many Kurdish women militants attribute their liberation to Öcalan and his thought.</p>


    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/3lu1370.jpg">
      <div class="bigimagecaption"><p>YDG-H youth on the border between Turkey and Syria.</p></div>
    </div>

    <h2>The Fighters</h2>

    <p>Even though the Kurdish seizure of power in Rojava went smoothly, the honeymoon was brief. After capturing a large amount of military machinery from Mosul on June 10, 2014, ISIS pushed north in Iraq and in Syria. With its advance came stories of massacres, enslavement, displacement, and rape. A month and a half later, in August, ISIS reached the Yazidi population, a non-Muslim Kurdish speaking community near the Sinjar Mountains, where they killed thousands and displaced near 290,000 people, 50,000 of whom were <a href="http://tr.sputniknews.com/ortadogu/20150804/1016919391.html">stranded on mountains without food or water</a>. ISIS fighters seemed especially keen on wiping out this population belonging to a pre-Islamic faith with many animistic aspects, who had been persecuted for centuries as devil worshipers, withstanding more than seventy massacres in their history. The Iraqi Kurdish Regional Government lacked the agility to intervene with its peshmerga forces—in contrast to the PKK, who mobilized rapidly, traveling across the country from its main base on the Iraqi-Iranian border in Qandil. In coming to the rescue of the Yazidi and arming and training this population for self-defense, the PKK gained credibility in the region run by Barzani and his KDP. Despite the tensions between regional Kurdish forces, all the stories and images ISIS circulated through social media had the effect of unifying the once disparate Kurds, as the PKK/YPG joined with the KDP in an uneasy alliance.</p>

    <p>Of all of the Kurdish armed forces, the YPG is the newest. The people’s defense forces were formed shortly after the revolution, and their numbers quickly swelled with volunteers joining to defend Kurdish territories from ISIS. This wartime mobilization is also supported by conscription, which has started to create tension among young people who are not interested in fighting or who say they have already done their military service with the Assad Regime. But beyond this simmering point, in places such as Kobanê, the YPG and the YPJ are comprised of people defending their own towns and cities. </p>

    <p>Kobanê became ground zero in the resistance as ISIS closed in little by little, taking villages on the outskirts of the city thanks to their recently obtained military superiority. ISIS was especially keen to capture Kobanê, as it occupies the most direct route between the Turkish border and the de facto ISIS capital of Raqqa. In addition, Kobanê was also the launching point of the revolution in Rojava. The YPG and YPJ offered a heroic resistance with the little firepower they had, mostly small arms supported by rocket-propelled grenades and the higher-caliber Russian <em>Dushkas</em> mounted on the backs of pickup trucks. As they retreated further and further into the city proper of Kobanê, the YPG and YPJ reached near-celebrity status, thanks in part to the West’s romanticization and objectification of YPJ women fighting the bearded hordes of ISIS. Everyone from prominent leftist academics to <em>Marie Claire</em> magazine, who featured the YPJ (to the snickering of YPJ members in Kobanê), started singing the praises of the Kurdish fighters. </p>

    <p>One has to admit the neatness of the contrast on the Rojava battlefield: a feminist army courageously resisting misogynist bands of fundamentalists. Apparently, many fighters within ISIS believe that if a woman kills them, they will not enter heaven as glorious martyrs. This belief is known by the members of the YPJ and used in a form of psychological warfare on the front lines. The women of the YPJ make it a point to sound their shrill battle cry, a well-known Kurdish exclamation of rage or suffering called <em>zılgıt,</em> before they enter into battle with ISIS. They are making sure the jihadists know they are about to be sent to hell. </p>

    <p>Hundreds of Kurds from Turkey crossed the border to join the YPG forces defending Kobanê alongside PKK guerrilla units that moved into the region. Turkish leftists also started making the journey, becoming martyrs themselves. In one case, Suphi Nejat Ağırnaslı, a sociology student at one of the most prestigious universities in Istanbul, influenced in his own writings by the French journal <em>Tiqqun,</em> went to Rojava only <a href="http://hayalgucuiktidara.org/">to be martyred</a> after a few weeks. The nom de guerre he had chosen was Paramaz Kızılbaş, a synthesis of the name of a well-known Armenian socialist revolutionary executed by the Ottomons and the Alevi faith, historically repressed in Turkey. This exemplifies the character of solidarity in the region: a Turkish revolutionary, assuming the name of an Armenian one, going to defend the Kurdish revolution. </p>

    <p>As reported in the Western media, many Americans and Europeans also made the journey to join the ranks of fighters in Rojava. Some integrated into the YPG or YPJ; others joined other units, such as the United Freedom Forces (BÖG), <a href="http://www.radikal.com.tr/dunya/kobanide_savasan_turkiyeli_solculara_isidciler_ne_sordu-1282919">comprised of communists and anarchists</a>. Apart from international revolutionaries arriving in solidarity with the Kurdish struggle for liberation, there are also ex-military or military wannabes from the UK or the US who believe that the war against Islamic extremists that they were tricked out of by corrupt British and American governments has finally arrived. Some of these internationals have started to warm to the political philosophy of Democratic Autonomy as practiced by their comrades-in-arms; others quickly got out, realizing they were <a href="http://fortressamerica.gawker.com/christian-fighters-abandon-anti-isis-kurd-group-because-1687800274">among “a bunch of reds.”</a></p>

    <p>The international revolutionaries fighting alongside their Kurdish comrades will return to their homelands with strategic experience in the battlefield and a renewed sense of inspiration and perspective on what is possible when people commit themselves to liberation.</p>

    <p>In the middle of fall 2014, it appeared that Kobanê was about to fall. Solidarity demonstrations were held globally. Riots shook Turkey to pressure Erdoğan to stop supporting ISIS. In the meantime, meetings were held between the regional powers to figure out a response. YPG members in Kobanê recount that it appeared to be a matter of hours before the city would fall; they retreated to a central part of the city, gathering their ammunition to be destroyed rather than captured by ISIS. It was at that moment, rather than a month earlier when ISIS had not even entered the city, that the much-promised US and French airstrikes finally began in earnest.</p>

    <p>Beyond a doubt, without that aerial support, the minimally-armed YPG forces would not have emerged victorious. The fact that the bombardment came at the very last possible minute shows that, aside from whatever backroom negotiations and deals were taking place, NATO countries did not want an ISIS victory; but at the same time, they apparently wanted the Kurds to inherit a completely destroyed city. </p>

    <p>NATO assistance in the Kurdish self-defense is a touchy subject, to say the least—especially considering that the capture of Öcalan was understood as a NATO operation. When this reality is brought up among YPG members in Kobanê, they first joke about “Comrade Obama.” Pushed further, they point out that while the US and Israel are bad, they aren’t nearly as bad as the Arab Regimes. But really, at the end of the day, it is simply a matter of survival. Ideally, the YPG would be able to obtain the necessary weaponry to mount their own defense; but lacking that, if the question is between ideological purity and survival, the choice seems clear.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/tank1370.jpg">
      <div class="bigimagecaption"><p>YPG fighters look for things to salvage after capturing a tank from ISIS.</p></div>
    </div>


    <h2>Kobanê</h2>

    <p>Immediately after its liberation from ISIS, Kobanê was a war-torn ruin in which most buildings had lost their upper floors to artillery fire. Aerial bombardment by coalition forces also did significant damage. Mahmud, a friend and comrade from Kobanê, showed me around the city he had never left in his life; his eyes filled with tears as he remembered all his friends who died in those streets. We were walking in a ghost town where the only people we saw were fighters or the small number of holdouts who had stayed behind or just returned from refugee camps in Turkey. They could be seen digging through the rubble, trying to salvage anything from the wreckage. Unexploded munitions and booby traps left behind by ISIS continued to kill even after their departure, with at least ten dead in the first two weeks following the city’s liberation. Despite the high toll paid by the Kurds—the number of fighters killed was above 2000—there was a sense of excitement and victory in the air, as news came in daily of ISIS units being pushed back further and further. </p>

    <p>Mahmud is one of three brothers, all of whom are members of the YPG in one role or another. Like practically all of the YPG who have been through the conflict, they have shrapnel in their bodies and hearing loss from explosions and gunfire. An experienced machinist by training, he found a role in the ranks as a gunsmith—not only fixing weapons, but also manufacturing new designs, especially long-range sniper rifles. Yet he was only able to play this part until ISIS entered the city limits of Kobanê. After that, everyone took up arms to fight, including his 13-year-old shop assistant.</p>

    <p>Stories of heroism are everywhere, from the sniper who blew up an ISIS tank by shooting his round into its muzzle to others who gallantly climbed on top of another tank to throw a grenade down its hatch. Stories pile upon stories as Mahmud takes me through the city streets, narrating the months-long battle of Kobanê. During one stretch, he didn’t sleep for five days straight—not only because they were under consistent attack, but also because he was so afraid. He said that at one point he wanted to die just so it would be over. From his platoon of about a hundred people, only four are still alive; we spend many hours looking at pictures of his fallen comrades on his phone. Many of the YPG have smartphones, including Mahmud and his brother Arif, who would be reprimanded by their commander for checking Facebook while they were engaged in trench warfare. His brother Arif was a sniper. But he left the YPG after the trauma of shooting a comrade by mistake.</p>

    <p>The stench of death was strong in some neighborhoods, with bodies still under the wreckage and the corpses of ISIS fighters rotting alongside roads littered with abandoned tanks destroyed by the YPG. To prevent the spread of disease, the bodies of ISIS fighters were usually burned; but the sheer number of corpses made it impossible to deal with all of them. Even surrounded by all this death and carnage, joyful moments were common, perhaps due to the news of advances arriving from the front. We spent our evenings hunting chickens with M16s for dinner, then smoking <em>nargile</em> after <em>nargile,</em> singing around a fire, waiting for the sun to rise over the Turkish border in the distance.</p>


    <h2>National Liberation from Borders</h2>

    <p>Surreal as it was for US planes to assist radical leftist fighters, the aerial bombardment started to shift the tide towards the YPG as they took back territory from ISIS bit by bit, eventually pushing them to the western bank of the Euphrates and coming within 40 km of Raqqa. On July 1, 2015, joint operations between the Free Syrian Army and the YPG liberated Tell Abyad from ISIS. The significance of this was multifold. First, this was the most coordination to occur yet between the FSA and the YPG, perhaps appeasing some of the concerns of Syrian revolutionaries who regard the Kurds as pro-Assad. Second, an important ISIS border access point into Turkey was captured, <a href="http://www.independent.co.uk/news/world/middle-east/isis-driven-out-of-syrian-town-of-tal-abyad-by-kurds-and-rebels-near-turkish-border-10322472.html">closing a corridor they had been maintaining into Syria and Raqqa</a>. But perhaps most significantly of all, the taking of Tell Abyad connected the Eastern canton of Cizire with Kobanê, creating an uninterrupted stretch of Rojava and breaking the isolation of Kobanê for the first time. </p>

    <p>The Kurds are one of the many casualties of borders crossing the peoples of the world—in their case, the borders drawn by Sykes-Picot at the end of the First World War. These borders between Turkey, Syria, Iraq, and Iran are the ones the Kurds are attempting to remove, and it is this experience that informs their critique of borders everywhere. The Kurds are often mentioned as a people without a nation-state; the PKK led a national liberation struggle for decades, and the Kurdish liberation struggle can still be classified as such—but not in the classical sense. It is almost like national liberation updated for the 21st century. Both in Turkey and in Syria, the Kurdish movement is trying to provide a common fighting platform for all oppressed peoples, leftist revolutionaries, and others—a collective of peoples they often refer to as “the forces of democracy.” This platform resembles the intercommunalism of Huey Newton in that it promotes solidarity and common action while preserving the autonomy of each constituent.</p>

    <p>This is evident in the politics of the HDP and, more significantly, in the self-governance structures in Rojava—especially in the eastern canton of Cizire, where Kurds, Arabs, and Assyrians live together, participate in communal-self governance, and mobilize fighting forces within the YPG. For a region plagued by ethnic division, the Kurdish proposition is a third way. This is how they refer to their project to contrast it with the choice between ISIS and the Assad regime on one side of the border, and between the AKP and Turkish nationalism on the other.</p>

    <p>This proposition presents democratic modernity as an alternative to capitalist modernity and self-governance via confederalism as an alternative to the nation-state. The Kurds are not the only ones attempting to break the borders of the Middle East. In addition to ISIS who has successfully redrawn the map, Erdoğan also has his own ambitions under the rubric of the “Great Middle East Project,” in which Turkey would assume its rightful role (neo-Ottomanism) as the dominant regional power. Already today, most of the foreign business in Barzani’s Kurdish Region in Northern Iraq is Turkish capital. A strong PYD and PKK in the region would be an obstacle to this project.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/diyar1370.jpg">
      <div class="bigimagecaption"><p>A member of the YPG scavenging the villages on the outskirts of Kobanê.</p></div>
    </div>


    <h2>Elections and a Massacre</h2>

    <p>For thirteen years, the AKP has won overwhelming victories in Turkish national elections, holding power as a single party. The HDP was able to harness anti-Erdoğan sentiment with a clever political strategy during the run-up to the historic elections of June 7, 2015. The Turkish electoral system has a 10% threshold: unless a party receives 10% of the national vote or above, it cannot enter parliament, and votes cast for it are effectively void. To sidestep this, the Kurdish movement has usually run independent candidates who, after winning a seat, would become party members. While this run-around strategy helped to get about thirty-five representatives into parliament, receiving more than 10% of the vote would secure at least twice as many positions.</p>

    <p>The election of June 7 presented the possibility to displace the AKP and sabotage Erdoğan’s ambitions of increasing his powers by means of constitutional changes that would make him the ultimate patriarch of Turkey. Selahattin Demirtaş, the youthful and charismatic co-chairperson of the HDP, made “We won’t let him become president!” one of his main campaign slogans. The hatred of Erdoğan that had culminated in the Gezi uprising intersected with discontent over Erdoğan’s support of ISIS and enthusiasm inspired by the resistance of Kobanê. Consequently, the HDP secured 13% of the national vote and 80 MPs, creating a situation in which no single party could form a government by itself and necessitating that a coalition form to assume power.</p>

    <p>The relationship between the armed PKK and the electoral HDP is delicate yet complementary. The HDP must strike a difficult balance: they receive their legitimacy in the eyes of the Kurdish population as the aboveground wing of the armed struggle, but they also need to distance themselves occasionally in order to play the political game successfully on the national scale. Erdoğan and his cronies, who are shrewd and aware of this, stoke the fires wherever they can by pitting the HDP against the PKK and both of them against Öcalan, whom they portray as more levelheaded—an easy task, when communication with him is controlled by the state and no one has heard from him in five months. The HDP is in a precarious position as a legal and unarmed political party often subject to the same repression as PKK members. </p>

    <p>Following the election, no one could work out how to create a coalition government. As everyone’s attention was focused on the electoral stalemate, Erdoğan made it clear that he would push for early elections to give the population another opportunity to bring the AKP to power. Then came <a href="http://bianet.org/english/2015/7/22">the massacre in Suruç</a>.</p>

    <p>It was just another delegation of young leftists from Istanbul to Kurdistan. This one was organized by the Socialist Youth Associations Federation with the goal of giving a hand in the rebuilding of Kobanê, bringing toys to refugee children, and planting trees in the region. On the morning of July 20, 2015, SGDF organized a press conference at the Amara Cultural Center, the de facto convergence center for volunteers traveling to assist with the refugee camps. In the midst of this, a suicide bomber killed 34 people. This massacre shocked the whole country, setting in motion a downward spiral of events. Two days later, Erdoğan cut a deal with the US to allow them use of the Turkish Incirlik Air Base against ISIS in exchange for their tacit support of a new campaign of annihilation against the PKK. Seizing upon the murder of two police officers the day after the bombing for justification (a retaliation later explicitly disowned by the official channels of the PKK), the Turkish government began a massive air campaign against PKK positions in northern Iraq and southeastern Turkey. In addition, raids took place across the country, resulting in more than 2000 arrests and continuing to this day. So belligerent were the actions of the AKP that they even arrested one of the injured from the socialist delegation bombed in Suruç. </p>

    <p>The AKP claimed that it was going after all the extremist terrorists in the country: the PKK, ISIS, and the Marxist-Leninist group DHKP-C (The Revolutionary Peoples Liberation Party - Front). Of these three, the DHKP-C does not hold a candle to the others in terms of numbers or effectiveness; it seems they were thrown in for good measure. While the AKP and Erdoğan claim in the media that they are also going after ISIS, in reality this is nothing but window dressing. Of the 2544 arrested by the end of August, <a href="http://www.ihd.org.tr/21-temmuz-28-agustos-2015-tarihleri-arasinda-tespit-edilebilen-ihlaller/">less than 5%</a> were arrested on allegations of belonging to ISIS, and many of those were later released. Of the bombing campaign <a href="http://www.ozgur-gundem.com/yazi/133708/akp-kdp-rudaw-ve-45-ucakla-kurdistana-bombardiman">totaling approximately 400 airstrikes</a>, <a href="http://www.evrensel.net/haber/256651/suriyedeki-isid-mevzileri-havadan-vuruldu">only three targeted ISIS</a>. These airstrikes are targeting PKK camps, especially the central one of Qandil—but civilians have also been killed, such as ten <a href="http://www.ozgur-gundem.com/haber/140861/akp-kandilde-katliam-yapti">in the nearby Iraqi village of Zelgele</a>.</p>

    <p>Although the Suruç bombing targeted the Kurdish movement, it is being used as an excuse to decimate it. As of this writing at the beginning of September, <a href="http://www.ihd.org.tr/21-temmuz-28-agustos-2015-tarihleri-arasinda-tespit-edilebilen-ihlaller/">according to the Turkish Human Rights Association</a> more than 47 civilians and 47 PKK guerrillas have been killed. The PKK is hitting back hard wherever it can: as of now, at least 92 policemen or soldiers have been killed, and 24 officials of the state or security forces kidnapped.</p>

    <p>In response to this repression, Kurdish towns and cities rose up with demonstrations and riots in every single town for many nights in a row. The response by the state was brutal; media pundits observed that the country had regressed to the bloody 1990s. While this was certainly the case from the standpoint of the state, the Kurdish movement has evolved: Kurds in more than sixteen towns took the initiative of declaring autonomy from the state and began to emphasize their right to self-defense. These declarations were met with more brutality and arrests. Especially in the towns of <a href="http://www.imctv.com.tr/silopide-keskin-nisanci-endisesi/">Silopi</a> and <a href="http://www.ozgur-gundem.com/haber/143340/cizrede-biri-cocuk-2-kisi-yasamini-yitirdi">Cizre</a>, the state responded by using snipers to go after children and citizens who weren’t even directly involved in the conflicts. House raids and extrajudicial executions soon followed. Bombings of the countryside have resulted in catastrophic forest fires, inflicting yet another form of anguish on the region. Many towns in the region are still declared special security zones, a designation akin to martial law; curfews and operations by special forces are widespread. </p>

    <p>A new early election has been called for November 1, 2015. It is already clear that the run-up to the next election will result in escalations from the AKP and Erdoğan, who has shown that he is willing to do anything to hold on to power, even thrust the country into civil war. It is possible that he will use his executive powers to postpone the election for a year on the grounds that there is a security risk for elections to take place. The successes of the Kurds on both sides of the Turkish-Syrian border, their smart political choices and heroic fighting maneuvers have pushed the AKP and Erdoğan to a breaking point. If the current drive for a truly fascist police state is any indication, his fall from power will be as brutal as his reign.</p>

    <p>I am inspired by the perseverance of the Kurds who are attempting to break out of stale leftist dogmas while still insisting on revolution. The transformation of a social movement of millions does not occur overnight, but they have begun to implement new social relations and structures that aim at abolishing the state and other hierarchies, such as men over women or humans over non-humans. From my observations, I believe that this stubborn multigenerational struggle has the potential to transform the world’s most sectarian region into autonomous zones of cooperation and solidarity. As long as they are able to survive ISIS and the Turkish State and continue constructing their revolution from below, they will have much more to teach those of us fighting for liberation elsewhere. </p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/kurdish/images/zaferbarikati1370.jpg">
      <div class="bigimagecaption"><p>YPG barricades in Kobanê. In the West, the V means peace; everywhere else, it means victory.</p></div>
    </div>


    <div class="footnote">
      <p><em>All photographs by the author.</em></p>
      <br />
      <p><a name="1"></a><span class="footref">1. </span>Geographically, Kurdistan is defined by cardinal directions. So western Kurdistan, which is in northern Syria, is called <em>Rojava</em> (West); northern Kurdistan, which is in southeastern Turkey, is <em>Bakur</em> (North); southern Kurdistan, in northern Iraq, is <em>Bashur</em> (South); and eastern Kurdistan, in southwestern Iran, is <em>Rojhelat</em> (East). <span class="footreturn"><a href="#1return">&#x21A9;&#xFE0E;</a></span></p>
      <br />
      <p><a name="2"></a><span class="footref">2. </span>Known as Atatürk—the great Turk—after 1934. <span class="footreturn"><a href="#2return">&#x21A9;&#xFE0E;</a></span></p>
      <br />
      <p><a name="3"></a><span class="footref">3. </span>Although Turkey has universal conscription, it also has laws which permit one to pay nearly $10,000 to be exempt from it. In addition, those with higher-level education are often able to land safer positions. Thus those who actually fight the wars are predominantly poor. <span class="footreturn"><a href="#3return">&#x21A9;&#xFE0E;</a></span></p>
      <br />
      <p><a name="4"></a><span class="footref">4. </span>Mahir was killed in a military raid during the kidnapping of NATO technicians with the demand of freeing Deniz and two others who would also be executed, Hüseyin Inan and Yusuf Küpeli. Deniz was hung by military rule. <span class="footreturn"><a href="#4return">&#x21A9;&#xFE0E;</a></span></p>
      <br />
      <p><a name="5"></a><span class="footref">5. </span>Although Western leftists are fascinated by the Bookchin-Öcalan connection, it is not as if Kurdish militants are walking around with Bookchin under their arms in the region. Sure, Democratic Confederalism resembles libertarian municipalities, but pointing to Bookchin as the ideological forefather reeks of Eurocentrism. <span class="footreturn"><a href="#5return">&#x21A9;&#xFE0E;</a></span></p>
      <br />
      <p><a name="6"></a><span class="footref">6. </span>There is no question that Muslims were subjected to a conservative secularism in Turkey prior to the AKP. Erdogan’s electoral successes capitalized on the resulting frustration. <span class="footreturn"><a href="#6return">&#x21A9;&#xFE0E;</a></span></p>
    </div>
  }
}

articles << {
  url: "http://www.crimethinc.com/texts/r/next-time-it-explodes/",
  category: "History",
  title: %q{
    Next Time It Explodes
  },
  subtitle: %q{
    Revolt, Repression, and Backlash since the Ferguson Uprising
  },
  image: "http://crimethinc.com/texts/r/next-time-it-explodes/images/header2000.jpg",
  content: %q{
    <p>A year has passed since the murder of Michael Brown, one of over <a href="http://www.killedbypolice.net/kbp2014.html">1100 people</a>, disproportionately black and brown, killed by US law enforcement in 2014. The movement against institutionalized white supremacy and police violence has spread and escalated, gaining leverage on the authorities and the public imagination despite repeated efforts to coopt it. At the same time, we are seeing extra-governmental white supremacist violence reemerge as a force in the US, as it always does whenever state strategies for imposing white supremacy reach their limits. </p>

    <p>The illusion of social peace is evaporating. Over the past year, the National Guard has been called out three times to quell anti-police rioting. White racists have retaliated with <a href="http://talkingpointsmemo.com/cafe/church-burning-race-hate-crimes-underreported">church burnings</a> and <a href="http://www.nytimes.com/2015/08/01/us/dylann-roof-suspect-in-charleston-killings-indicates-desire-to-plead-guilty.html/">murders</a>, while raising <a href="http://www.washingtonpost.com/news/post-nation/wp/2014/09/19/fundraising-still-stalled-for-darren-wilson-the-ferguson-officer-involved-in-the-michael-brown-shooting/">hundreds of thousands of dollars</a> to support murderers in uniform. The lines that are being drawn may determine the geography of racialized conflict in the US for a long time to come. How did we arrive here from the first demonstrations in Ferguson? And how should we position ourselves in these struggles?</p>

    <h2>The Backstory: Crisis and Repression, Cooptation and Revolt</h2>

    <p>The racialized poverty that forms the landscape of Ferguson and so many other predominantly black districts is <a href="http://www.msnbc.com/msnbc/economic-recovery-not-ferguson-and-black-america">not just a consequence</a> of the recession of 2008. The costs of capitalism have always been inflicted first and worst on black people, from slavery and Jim Crow to the contemporary phenomenon of <a href="http://endnotes.org.uk/en/endnotes-misery-and-debt">“surplus humanity”</a> for whom there is no place in the economy. And since the beginning, this has engendered black resistance.</p>

    <p>Fifty years ago, white America faced powder keg of civil rights movements, militant black organizing, and <a href="http://www.slate.com/articles/news_and_politics/crime/2015/04/_1968_baltimore_do_the_riots_after_martin_luther_king_jr_s_assassination.single.html">urban riots</a>. Because the 1960s were a time of comparative abundance and economic growth, the United States government could afford to stabilize society by integrating some people of color into more aspects of political and economic life. But even those concessions took place at a price: while a minority of black people were offered conditional access to the middle class, the more militant organizers and the majority of black communities were ruthlessly repressed. Since then, some of the leaders of the black civil rights movement have become successful politicians, while Black Panthers remain behind bars along with <a href="http://www.naacp.org/pages/criminal-justice-fact-sheet">a million</a> other black people.</p>

    <p>This is the dual operation of repression: kill or imprison the ones who won’t or can’t compromise, while integrating the more tractable <a href="https://escalatingidentity.wordpress.com/2012/04/30/who-is-oakland-anti-oppression-politics-decolonization-and-the-state/">into the power structure</a>.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/pacify1370.jpg">
    <div class="bigimagecaption"><p>Pacify whoever will listen . . .</p></div>
    </div>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/repress1370.jpg">
    <div class="bigimagecaption"><p>. . . and repress the rest.</p></div>
    </div>

    <p>Today, in the age of global austerity, there are few resources available with which to strike bargains with the excluded. The rhetoric from politicians and pundits condemning protesters in Ferguson and Baltimore is a military operation intended to make it possible to use force against them without blowback, but it also shows that the conflict between the two sides is irresolvable: no one in power has any idea what to do about our society’s racial and economic inequalities. Leaders on the left are doing their best to obscure this in order to buy time. When they bought time in the 1960s, that time was used to build the jails and prisons that hold nearly two and a half million people today, to set the stage for the gentrification that is currently demolishing entire communities of color.</p>

    <p>This is why in 2014, neither the repressive force of the state nor the receding lure of economic success were enough to contain black rage. No wonder Ferguson exploded.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/stabilize1370.jpg">
    <div class="bigimagecaption"><p>No amount of force can stabilize an unequal society indefinitely.</p></div>
    </div>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/market1370.jpg">
    <div class="bigimagecaption"><p>The limits of the market.</p></div>
    </div>



    <h2>From Ferguson to Baltimore</h2>

    <p><em>Consult <a href="#appendix">the appendix</a> below for a timeline of the Baltimore uprising.</em></p>
    <p>&nbsp;</p>
    <p style="text-indent: 0px">The post&#8211;1960s strategy of integrating black leaders into the structures of state power has also reached its limits. We saw hints of this in the 2009 uprising following the murder of Oscar Grant in Oakland, a city whose political elite includes civil rights veterans who now oversee police that behave the same as ever towards the black and poor.</p>

    <p>Although Ferguson was a classic example of a black majority terrorized by a violent white elite, the power structure in Baltimore <a href="http://www.washingtonpost.com/blogs/monkey-cage/wp/2015/04/30/baltimore-is-not-ferguson/">includes a number of black authority figures</a>. That extends even into the police department: three of the six officers arrested for the murder of Freddie Gray are black. Yet putting black people in positions of state power <a href="http://www.buzzfeed.com/adamserwer/black-leadership-in-baltimore">hasn’t done away with poverty, police killings, or other forms of structural racism</a> in Baltimore. Black politicians may have been able to ameliorate the situation to some extent, but in the end it took the riots with which people responded to the murder of Freddie Gray to force the issue of white supremacy.</p>

    <p>People of any background can maintain white supremacist institutions. Despite media handwringing about Ferguson’s disproportionately white police force, we don’t just need affirmative action among those who impose structural oppression; we need to make it impossible for these institutions to dominate people in the first place.</p>

    <p>After the initial explosion, chief prosecutor Marilyn Mosby succeeded in averting further confrontations by announcing <a href="http://www.theguardian.com/us-news/2015/may/01/marilyn-mosby-baltimore-states-attorney-freddie-gray">the filing of charges</a> against Freddie Gray’s murderers immediately ahead of the demonstrations scheduled for May Day weekend. Her decision to press charges was exceptional and courageous, but most of those charges would never have been filed if not for clashes like the ones she was trying to forestall. It is a mistake to turn people from means of protest that interrupt the status quo back to ineffective strategies that rely on the institutional channels of redress. Even if the officers responsible for Freddie Gray’s death are found guilty, that will not prove that the system can police itself, but rather that it takes a full-scale uprising to impose even a modicum of consequences on those who maintain it. Rather than setting out to reform the court system one riot at a time, it would make more sense to ask what these uprisings lack to become steps towards revolutionary change.</p>

    <p>In response to that possibility, those who have the greatest cause to fear change—the authorities, the corporate media, and representatives of the middle class—set out to frame the uprising in Baltimore as pathological and puerile. The curfew that was imposed in Baltimore on April 29 along with the National Guard occupation was an extension of the curfew that had <a href="http://www.npr.org/2014/08/31/344643559/for-their-own-good-new-curfew-sends-baltimore-kids-home-early">already been in place</a><sup class="footlink"><a href="#1" name="1return">1</a></sup><sup class="refnumber">1</sup><small><span class="fnumber">1.</span> The 2014 article linked here blithely reassures the reader of the good intentions of the police enforcing the curfew: “The Baltimore Police have recently been trained on dealing with youth. To emphasize that those caught violating curfew are not considered criminals, the city says most children out late will be transported in vans—not in the back of police cars.” Indeed, Freddie Gray was fatally injured in the back of a van, having been arrested for no criminal activity whatsoever. <br/ ><br/ ><span class="fnumber">2.</span> The counterpart of that narrative is the mother who persuaded her son to turn himself in for his role in vandalizing a police car, only to see him <a href="http://www.theguardian.com/us-news/2015/apr/30/baltimore-rioters-parents-500000-bail-allen-bullock/">held on $500,000 bail</a>—afterwards, when it was too late, she regretted telling him to entrust his fate to the authorities.</small> for young people in that city all year. In effect, the April 29 curfew signified the infantilizing of the whole adult population of Baltimore, an intensification of the function that the state always plays in pacifying and sidelining people.</p>

    <p>This is the light in which we must understand the corporate media narrative about the mother <a href="http://www.cnn.com/2015/04/29/us/baltimore-mother-slapping-son/">who hit her son</a> for masking up and throwing rocks on the premise she didn’t want him to become yet another Freddie Gray.<sup class="footlink"><a href="#2" name="2return">2</a></sup><sup class="refnumber">2</sup> That narrative individualizes blame for police violence—in fact, Freddie Gray <a href="http://www.nytimes.com/2015/05/02/us/freddie-gray-autopsy-report-given-to-baltimore-prosecutors.html">was not committing any sort of crime</a> when he was arrested. There is no <em>individual</em> solution for the structural violence directed at Freddie Gray and countless young people like him—and likely no solution that involves obeying the law or waiting for it to take its due course. Waiting on the courts is yet more infantilizing: hush up and let the adults take care of this.</p>

    <p>But that sort of sidelining is becoming less and less feasible. In Ferguson and then in Baltimore, we saw children throwing rocks because their parents had already been incapacitated or imprisoned, just like in Palestine—and because, as in Palestine, they knew that there would be no payoff to behaving themselves. There has been a lot of rhetoric about <a href="http://www.cnn.com/2015/05/02/us/lord-of-the-flies-baltimore/">fatherless children</a>, and indeed a shocking proportion of men have been kidnapped from black communities in places like West Baltimore. But the truth is that black youth succeeded in forcing the issue of police violence where everyone else had failed. In interrupting the functioning of a system that has no place for them, they are the ones opening the possibility of real change, not the black leadership of the previous generation.</p>

    <p>From Ferguson to Baltimore, the cycle of revolt accelerated and intensified. The arc of events that <a href="http://antistatestl.noblogs.org/post/2014/09/18/a-timeline-of-the-ferguson-uprising/">took a week and a half to unfold in Ferguson</a> played out much more rapidly in Baltimore. Large parts of the city were in flames within two days of the first confrontations, and the National Guard was deployed almost immediately; Mosby filed the charges that effectively concluded the uprising just four days later. Despite the speedy quelling of the riots, it seems possible that the state had nearly reached the limit of what it could do to impose white supremacist inequality by main force: with the prisons packed, once the National Guard is deployed, escalating to a higher level of repression would mean declaring open war on the population.</p>

    <p>If multiple uprisings were to occur simultaneously in the same region, control might break down completely. Hence the authorities’ scrambling to mollify people they had been ignoring for years.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/imposing1370.jpg">
    <div class="bigimagecaption"><p>Imposing the peace . . . for now.</p></div>
    </div>


    <h2>From Baltimore to South Carolina</h2>

    <p>A week before the murder of Freddie Gray, a police officer had murdered Walter Scott, an unarmed black man, in North Charleston, South Carolina, shooting him in the back as he fled. The killing was caught on video, and within three days the officer was charged with murder. Even in the birthplace of the Confederacy, the specter of uprising forced the authorities to impose consequences on the police.</p>

    <p>Yet whenever governmental enforcement of white supremacy reaches its limits in the United States, independent white supremacist activity picks up. The classic example of this is the emergence of the Ku Klux Klan and similar organizations like the White League and the Red Shirts after the abolition of slavery. In many cases, it was the same sheriffs, judges, and legislators who enforced racist laws on the books donning robes and hoods to pick up where the laws left off.</p>

    <p>In recent months, we&#8217;ve seen a resurgence of autonomous white supremacist activity, including a spate of <a href="http://www.theatlantic.com/national/archive/2015/06/arson-churches-north-carolina-georgia/396881/">church burnings</a> that <a href="http://www.nbcnews.com/storyline/michael-brown-shooting/michael-brown-sr-s-church-burned-ferguson-n255961">began in Ferguson</a> immediately after the decision not try Darren Wilson for the murder of Michael Brown. But that could be only the tip of the iceberg.</p>

    <p>In response to the uprisings of the past few years, we are seeing police—and the subset of middle-class America from which many of them are drawn—beginning to conceive of their interests as distinct from the rest of the state structure. In 2011, during the peak of Occupy Oakland, Mayor Jean Quan <a href="https://libcom.org/library/who-gives-orders-oakland-police-city-hall-occupy">wrestled</a> with the Oakland Police Department, which repeatedly asserted a contrary agenda. Something similar occurred between the NYPD and Mayor Bill de Blasio in New York City last winter, when New York City police carried out an unofficial strike demanding more unconditional support from the government—in effect, demanding the freedom to employ violence with impunity. After the Baltimore uprising, there was a lot of <a href="http://baltimore.cbslocal.com/2015/04/30/sheriff-michael-lewis-on-the-stand-down-orders-given-to-city-officers/">grumbling among Maryland police</a> who blamed their superiors for not permitting them to use more violence against demonstrators.</p>

    <p>This kind of frustration could give rise to new racist movements that will understand themselves as needing to <em>take the law into their own hands</em> in order to maintain law and order and defend private property. Something similar has occurred in Greece with the emergence of the fascist party Golden Dawn, which now counts a great part of the country’s police officers in its ranks. That makes it especially ominous that the <a href="http://www.nbcnews.com/storyline/michael-brown-shooting/oath-keepers-turn-michael-brown-protests-ferguson-missouri-n407696">Oath Keepers</a>, a paramilitary organization of former policemen and soldiers, have made <a href="http://www.stltoday.com/news/local/crime-and-courts/police-shut-down-mysterious-oath-keepers-guarding-rooftops-in-downtown/article_f90b6edd-acf8-52e3-a020-3a78db286194.html">repeated appearances</a> at demonstrations in Ferguson.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/rival1370.jpg">
    <div class="bigimagecaption"><p>Rival factions within the state: the NYPD versus Mayor de Blasio.</p></div>
    </div>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/supporters1370.jpg">
    <div class="bigimagecaption"><p>Supporters of the police clash with demonstrators in Baltimore.</p></div>
    </div>

    <p>Autonomous movements of all stripes have an advantage today, when government is widely discredited. Like anarchists in contrast to liberals, autonomous white supremacists are more effective than garden-variety racists because they are prepared to use direct action to achieve their goals. What is at stake here is what autonomy will mean in the public imagination: freedom and resistance to oppression, or unchecked racist violence. The discourse of autonomy is strategically precious territory; whoever is able to occupy it will be able to determine the frame within which people conceptualize social change.</p>

    <p>For the state, the intensification of extra-governmental white supremacist activity is an opportunity to change the subject. Such activity enables the government to present itself as protecting people from racist violence, directing attention away from all the normalized ways that the state imposes such violence. The image of the National Guard holding back white vigilantes during integration in the South gave the federal government decades of credibility, even though the same National Guard put down the riots of the late 1960s. If anything like Golden Dawn or the KKK of the 1920s gets off the ground in the US today, many people currently involved in movements against police and prisons will line up behind the government again, legitimizing those institutions as necessary tools against white supremacists even though in the long run they will always be used chiefly against the black, brown, and poor.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/owner1370.jpg">
    <div class="bigimagecaption"><p>Buy owner in Ferguson, August 2014.</p></div>
    </div>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/oath1370.jpg">
    <div class="bigimagecaption"><p>A member of the Oath Keepers brandishing a semiautomatic weapon during protests in Ferguson, August 2015.</p></div>
    </div>


    <p>So far, we have yet to see a surge in organized group violence from fascists or rogue police officers. Autonomous white supremacist violence has remained the province of lone wolves like <a href="http://www.nytimes.com/2015/06/21/us/dylann-storm-roof-photos-website-charleston-church-shooting.html">Dylann Roof</a>, who carried out a racist massacre in Charleston, South Carolina in June 2015, reportedly with the intention of catalyzing a race war. Photographs showed him brandishing a Confederate flag and other racist insignia.</p>

    <p>In response, activists renewed their appeal to the state legislature to remove the Confederate flag from its official place on the grounds of the state capitol. In 1961, Democratic Governor Ernest Hollings had initiated legislation to raise the Confederate flag on the capitol grounds as a symbol of resistance to the civil rights movement. Despite the end of legal segregation, the flag stood, defying an NAACP tourism boycott since 2000.</p>

    <p>On June 21, days after the Emanuel Church massacre, “Black Lives Matter” graffiti appeared on Confederate monuments in Charleston and elsewhere. On June 27, Black Lives Matter activist Brittany Ann Byuarim Newsome was arrested and charged with “defacing a monument” after climbing up the flagpole at the state capitol and removing the Confederate flag. Less than two weeks later, lawmakers voted to remove it from the State Capitol.</p>

    <p>This demonstrates the power of direct action. The tourism boycott had been ineffective; so long as the state perceived no internal threat to order, it could afford to shrug off a few lost tourist dollars and the indignation of activists. But when uprisings elsewhere around the US dovetailed with local outrage, the willingness of a few individuals to break the law hastened a process that otherwise could have dragged on decades longer. The spectacle of a state claiming to oppose racism arresting an activist for removing an officially sanctioned symbol of racism from the headquarters of the state left the lawmakers no choice—especially after the Ku Klux Klan scheduled a rally at the capitol for July 18, <a href="http://www.wsws.org/en/articles/2015/07/10/flag-j10.html">threatening to create an additional spectacle</a> of explicit racists outside the legislature allied with filibustering Republicans within. On July 9, the legislators voted to take down the Confederate flag, rebranding themselves as anti-racists. As in Ferguson and Baltimore, direct action had shifted the terrain, compelling officials to scramble to catch up.</p>

    <p>Yet by focusing attention on removing the Confederate flag from the state capitol, activists had displaced rage against the racist murders in South Carolina onto a symbolic issue that legislators could address. The role of the Ku Klux Klan here aptly illustrates how extra-governmental white supremacist activity can be advantageous for the state.</p>

    <p>This was the context in which Klansmen and women, police, and protesters attending a black-organized counterdemonstration converged upon the state capitol grounds of Columbia, South Carolina on July 18, 2015. The Klansmen hoped to attract the attention of angry whites who felt victimized by recent victories against white supremacy; if they could present themselves as the sole remaining defenders of a flag and a tradition abandoned by the authorities, they would win new adherents for extra-governmental white supremacist organizing. The authorities hoped to preserve order, showing that they could control opponents of the state on both sides, in order to keep the state itself central for all seeking social change. The protesters, as usual, were divided between a variety of goals and methodologies; they ran the gamut from religious pacifists to black separatists to predominantly white anarchists.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/struggle1370.jpg">
    <div class="bigimagecaption"><p>Police struggle to protect Klansmen on July 18, 2015.</p></div>
    </div>


    <p>The day ended in <a href="https://itsgoingdown.org/igd-south-carolina-kkk-rally/">a rout for the Klan</a>, with a multiethnic crowd including anarchists chasing them back to their cars and pelting them with projectiles as the overextended police struggled to protect them. More Klansmen went to the hospital than protesters went to jail. The demonstrators had prevented the Klan from asserting an image of strength, hopefully discouraging dissatisfied white people from joining them. At the same time, compared to the events in Ferguson and Baltimore, the police had ceased to be the chief subject of the demonstrations; Dylann Roof, the controversy about the Confederate flag, and the Klan rally had shifted the subject away from policing and other normalized and fundamental aspects of the white supremacist power structure, towards exceptional and symbolic expressions of white supremacy. As social conflicts polarize and more and more people on both sides break off from state-based strategies, it will be especially important to continue confronting the institutionalized white supremacy of the state.</p>

    <h2>Next Time It Explodes</h2>

    <p>The police in the St. Louis area have continued their pattern of killing someone every month or so since the protests there last August and November. The police in Baltimore and South Carolina will surely continue killing, as well, even if they are more anxious about the consequences; apparently, it <a href="http://www.crimethinc.com/texts/r/bluefuse/index.html">requires this level of perpetual violence</a> to preserve the current social order. It will take more than reforms, more than individual uprisings, to put a stop to police murder.</p>

    <p>Over the past seven years, we have seen a slow, steady escalation in the tactics that protesters in the United States feel entitled to employ. In <a href="https://libcom.org/library/new-school-occupation-perspectives-takeover-building">2008</a> and <a href="https://www.youtube.com/watch?v=ISZrR7qE-Oc">2009</a>, only the most radical student groups went so far as to occupy universities; in 2011, Occupy became the watchword of an entire mass movement. During the Occupy movement, only <a href="http://www.crimethinc.com/texts/atoz/atc-oak.php">the most radical groups</a> went so far as to <a href="http://www.crimethinc.com/blog/2011/11/06/oakland-general-strike-footage/">blockade</a> anything; during the Black Lives Matter protests of November and December 2014, people around the United States employed blockading <a href="http://www.crimethinc.com/texts/r/from-ferguson-to-the-bay/index.html">on a regular basis</a>. During the protests that spread from Ferguson in 2014, only the most enraged participants engaged in vandalism, arson, and looting; yet protesters in Baltimore escalated to vandalism, arson, and looting as soon as their demonstrations escaped police control.
    All this illustrates the value of <a href="http://www.crimethinc.com/blog/2012/09/17/post-debate-debrief-video-and-libretto/">pushing the envelope</a>: demonstrating new tactics, however unpopular they may be at the time, so that they enter the public imagination for future use.</p>

    <p>This escalation has been matched by a shift in popular discourse. During the flashpoints in Ferguson and Baltimore, some media outlets published daring editorials explaining the riots as <a href="http://www.slate.com/articles/news_and_politics/crime/2015/05/baltimore_riots_it_wasn_t_thugs_looting_for_profit_it_was_a_protest_against.html">acts of desperation</a>, or making arguments for why people had <a href="http://www.salon.com/2015/04/28/baltimores_violent_protesters_are_right_smashing_police_cars_is_a_legitimate_political_strategy/">given up</a> on <a href="http://www.theatlantic.com/politics/archive/2015/04/nonviolence-as-compliance/391640/">nonviolence</a>. We have not seen such a public validation of militant tactics in the US for decades.</p>

    <p>Yet there is a big difference between validating and participating. These pundits seem to have obtained all the credibility of endorsing militant tactics without any of the inconveniences of employing them. All of these editorials are concerned only with explaining and legitimizing what they essentially treat as exotic phenomena; the implication is that the rest of us might accept what the rioters are doing from a distance, but certainly not participate in it ourselves. Other aspiring <a href="http://www.indigenousaction.org/accomplices-not-allies-abolishing-the-ally-industrial-complex/">allies</a> arrive at the same conclusion from a different direction, being so careful not to usurp the agency of the most affected communities that they end up standing aside entirely or putting their weight behind lower-risk initiatives.</p>

    <p>But it is dangerous and unethical to leave the greatest risks to the most vulnerable people. If it makes sense for the most marginalized and targeted to risk their lives to interrupt the functioning of the system that is killing them, it makes even more sense for the rest of us to do so. It’s not a question of understanding the uprisings, but of joining and extending them in order to render them unnecessary. That doesn’t necessarily mean invading others’ neighborhoods: the next time a Ferguson or a West Baltimore erupts, it might be most effective for those who wish to show solidarity to initiate actions elsewhere, in order to overextend the authorities. Nor should it mean centralizing ourselves in the narrative: solidarity means taking on the same risks that others are exposed to—nothing more, nothing less.</p>

    <p>The precarious rapport de force that has lasted since the Baltimore uprising will likely persist until another demographic enters the conflict. It’s not clear how much further the state can go to maintain the current order by means of pure force. If uprisings occurred in multiple cities in the same region at the same time, or if a much broader range of people got involved, all bets would be off.</p>

    <p>But as intimated above, the next demographic to enter the space of conflict might well be a reactionary force. South Carolina is <a href="https://olydocuments.wordpress.com/2015/06/01/what-happen-here-the-events-in-olympia-on-the-evening-of-may-the-30th/">not the only place</a> in which struggles against state violence have shifted seamlessly into struggles against autonomous white supremacists. Some anarchists and fellow travelers have glibly invoked <a href="http://theanarchistlibrary.org/library/liam-sionnach-earth-first-means-social-war-becoming-an-anti-capitalist-ecological-social-force">“social war”</a> or <a href="https://translationcollective.files.wordpress.com/2010/04/introcivil_print.pdf">“civil war,”</a> without fully grasping that such wars usually end up playing out along ethnic and <a href="http://www.crimethinc.com/texts/r/kobane/">religious</a> lines in the most reactionary manner.<sup class="footlink"><a href="#3" name="3return">3</a></sup><sup class="refnumber">3</sup><small><span class="fnumber">3.</span> While 19<sup>th</sup> century France saw a series of civil wars fought along class lines, it is telling that the only civil war in the history of the United States was initiated by those who wished to preserve slavery.</small> As the tensions in our society increase, it is up to us to render it possible to imagine other lines of conflict. The Dylann Roofs of the world and their equivalents within the halls of power want nothing better than to see society split into warring racial factions, with poor whites joining police and other defenders of the middle class to suppress the rage of the black and disaffected. White people must not countenance this division, even out of a wrongheaded desire to stand aside out of respect for black autonomy. That would spell doom for the most marginalized people in this struggle, however much good liberals might applaud their courageous efforts from afar. Rather, we have to produce a narrative of multiethnic struggle against white supremacy and capitalism by participating directly in the clashes that are occurring right now—both so that it will be impossible for white supremacists to convince potential converts that the important lines dividing society are racial, and so that those who are more racially and economically marginalized than us will not have cause to conclude that they have indeed been abandoned.</p>

    <p>Fighting white supremacy in this context means spreading the clashes with the authorities, while crushing autonomous racist initiatives wherever they appear. It means confronting fascists—an essentially rearguard battle—but it also means taking the initiative in attacking capitalism and the state, intensifying the struggles we are already in. Only by foregrounding anarchist solutions to the problems of poor people, including poor white people, can we make it impossible for racists to recruit from the ranks of the poor, white, and angry.</p>

    <p>In short: class war, not race war. We may have less time than we know.</p>

    <p>&nbsp;</p>

    <p class="inlinequote">“That left was too lost in delusions of success almost within their hands, delusions of maneuvering together a majority, to bother even really understanding fascism coming up fast in their rear view mirror. The urgent need was to organize a working minority to counter fascism in a much more radical way. Not by trying to defend liberal bourgeois rule. All the real things that had to be done by scattered German anti-fascists later after the Nazis were put into power—such as to survive politically, to significantly sabotage the war effort, to rescue Jews and Romany and gays, to build an underground against the madness of the Third Reich—all these things were attempted bravely but largely unsuccessfully, because they had to be done too late from scratch. This is a much larger subject, too large to dive into now, but it is on the horizon, like the smoke of a distant forest fire.”<br/>
    - J. Sakai, <a href="http://www.kersplebedeb.com/mystuff/books/raceburn.html">“When Race Burns Class”</a></p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/columbia1370.jpg">
    <div class="bigimagecaption"><p>Columbia, South Carolina on July 18, 2015: Don’t make him fight alone.</p></div>
    </div>


    <h2 id="appendix" name="appendix">Appendix I:<br />Timeline of the Baltimore Uprising</h2>

    <p><em>from an interview US anarchists answered for the Greek anarchist news service, <a href="http://issuu.com/apatris_news">Apatris</a></em></p>
    <p>&nbsp;</p>
    <ul class="list">
    <li><p><strong>April 12</strong> — Freddie Gray was arrested for making eye contact with an officer. He was <a href="http://www.nytimes.com/2015/05/01/us/freddie-grays-injury-and-the-police-rough-ride.html?_r=1">intentionally injured</a> in police custody while being transported to jail, and denied proper medical care. He passed away on April 19 as a consequence of these injuries.</p></li>
    <li><p><strong>April 26</strong> — On Saturday, there was a law-abiding protest rally in the afternoon. It concluded with a march in which participants vandalized police cars and clashed with drunk, racist sports fans. The police created a control perimeter, but inside of this space, demonstrators <a href="https://anarchistnews.org/content/last-night-baltimore">reportedly</a> were free to destroy property for some hours. The police had lost control.</p></li>
    <li><p><strong>April 28</strong> — On Monday, a message <a href="http://www.baltimoresun.com/news/maryland/freddie-gray/bs-md-ci-freddie-gray-violence-chronology-20150427-story.html#page=1">reportedly</a> circulated among high school students via social media calling for a “purge” that afternoon at a mall in Baltimore: a reference to a Hollywood movie in which laws and policing are suspended. The mall in question is a major transit center for kids traveling to and from school. Baltimore doesn’t have school buses; kids use public transit. Police preemptively shut down the mall, flooded the streets with officers in riot gear, and shut down public transportation, stopping buses and forcing everyone off of them. In this tense situation, with nowhere to go, youth began to clash with the police. In at least one instance, police officers were documented throwing rocks back at children. </p>

    <p>By nightfall, there were riots and fires all over the city, including some of the whiter neighborhoods. Over a hundred cars were set on fire, including many police cars, and over a dozen buildings were burned, most famously the CVS at the intersection of Penn and North. Corporate media played live footage of looting from helicopters, the newscasters wailing and wringing their hands about the loss of property while describing the people below in pejorative terms. Looking down uncomprehendingly at the people they said were “burning their own neighborhoods,” they offered the perspective of the state—the same perspective as the drones sailing over Pakistan.</p>

    <p>The mayor declared a state of emergency, called in police from around the state along with the National Guard, and announced a seven-day curfew to go into effect Tuesday. The overwhelmed court system was not able to keep up with all the arrestees, some of whom were eventually released without charges.</p></li>
    </ul>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/finest1370.jpg">
    <div class="bigimagecaption"><p>Baltimore’s finest.</p></div>
    </div>


    <ul class="list">
    <li><p><strong>April 29</strong> — On Tuesday, the city was tense. On public transportation, you could hear people bragging about what they’d looted, mostly basic necessities. Witnesses reported a feeling in the air to the effect that “We did what we had to do.” Community organizations sponsored cleanup activities, as in London in 2011, and “peacekeepers” were out hoping to prevent more fighting and rioting from breaking out.</p>

    <p>It’s important to emphasize that because so much of the population of Baltimore is black, there were black people involved in all of these different responses—black politicians, black peacekeepers, black police, black community organizers, black business owners, black rioters.</p>

    <p>On Tuesday, since schools were closed, Red Emma’s (the primary anarchist space in town) provided a place for kids who weren’t in school and for homeless youth from a shelter that had been destroyed in the rioting. Free food was collected and distributed through organizations in other neighborhoods—largely church organizations, which play a role in Baltimore politics, including radical politics.</p>

    <p>The intersection of Penn &amp; North, where the CVS had been burned, became the default space for protestors seeking conflict to gather—similar to the QuikTrip that was burned in Ferguson. The curfew was enforced violently at 10 pm; people fought back against police, but nothing like what had happened on Monday.</p></li>
    <aside>
    <blockquote class="accent">Who owns the dead? Who is entitled to determine what the struggle should look like in their name? Their families? Those who live where they lived? Leaders of the same ethnicity? Everyone on the receiving end of the same threat? Those who will be shot if there are not consequences for the last shooting? Or no one, no one at all?</blockquote>
    </aside>

    <li><p><strong>April 30</strong> — On Wednesday, many groups called for marches, even though the state of emergency banned all public gatherings; these marches were all granted permits at the last minute, acknowledging the leverage protesters had gained against the state. The resulting march, led by black and brown youth, was the largest anyone had seen in Baltimore for a long time, though it was dwarfed by the marches that followed on Friday and Saturday. The march conceded to police demands not to stay in front of City Hall, and made its way back to Penn Station, dispersing around 9 pm so people could get inside by curfew. More fighting ensued after curfew at the intersection of Penn and North.</p></li>
    <li><p><strong>May 1</strong> — More demonstrations were scheduled for May 1 and 2; they were expected to draw people from nearby cities and likely become confrontational again. But on the morning of Friday, May 1, state’s attorney Mosby announced that six police officers would be charged with crimes as a result of Freddie Gray’s death; one of them is being charged with murder.</p>

    <p>There were unpermitted marches around the city all day and late into the night. Most people gathered downtown at City Hall and McKeldin Square, the “free speech zone” where the authorities usually try to keep protestors. The march drew something like 5000 people and proceeded eleven miles, during which it picked up and lost people constantly; some sources estimated 10,000 or more participants altogether. The atmosphere was joyous. Police were not numerous enough to contain the demonstrators, but kept them from taking highways and protected certain targets. In the jail district, prisoners joined in the chanting from behind the walls, mostly “All night, all day, we will fight for Freddie Gray.”</p>

    <p>Pickup trucks overflowing with people joined the march in West Baltimore. It headed back downtown, then slowly dispersed around the time of curfew. However, at City Hall, 50&#8211;100 people stayed past curfew and at least 13 were arrested, many of those arrests violent. There was more curfew violence at the intersection of Penn and North, as well.</p></li>
    <li><p><strong>May 2</strong> — On Saturday, there were more marches. At this point, much of the energy had shifted towards seeking amnesty for arrestees, many of whom faced severe charges. For example, one young man who smashed the windows of a police car, whose parent had convinced him to turn himself in, was being held on $500,000 bail.</p>

    <p>Saturday night saw the broadest anti-curfew organizing. A mostly white group met in a mostly white neighborhood; police showed up in force, but gave warning after warning to disperse and pleaded with the group not to get arrested. People agreed to disperse, since jail support resources were already spread thin. Police reportedly offered to drive people home afterwards. Meanwhile, at the intersection of Penn and North, police beat and pepper-sprayed and arrested people, especially black protestors. A fairly large number of medics and people organizing jail support were arrested at the jail for curfew violation.</p></li>
    <li><p><strong>May 3</strong> — On Sunday, the mayor lifted the curfew two days early, responding to complaints from business owners. Things had calmed down.</p></li>
    </ul>


    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/next-time-it-explodes/images/continued1370.jpg">
    <div class="bigimagecaption"><p>To be continued.</p></div>
    </div>

    <div class="footnote">
    <p><a name="1"></a><span class="footref">1. </span>The 2014 article linked here blithely reassures the reader of the good intentions of the police enforcing the curfew: “The Baltimore Police have recently been trained on dealing with youth. To emphasize that those caught violating curfew are not considered criminals, the city says most children out late will be transported in vans—not in the back of police cars.” Indeed, Freddie Gray was fatally injured in the back of a van, having been arrested for no criminal activity whatsoever. <span class="footreturn"><a href="#1return">↩</a></span></p>
    <p><a name="2"></a><span class="footref">2. </span>The counterpart of that narrative is the mother who persuaded her son to turn himself in for his role in vandalizing a police car, only to see him <a href="http://www.theguardian.com/us-news/2015/apr/30/baltimore-rioters-parents-500000-bail-allen-bullock/">held on $500,000 bail</a>—afterwards, when it was too late, she regretted telling him to entrust his fate to the authorities. <span class="footreturn"><a href="#2return">↩</a></span></p>
    <p><a name="3"></a><span class="footref">3. </span>While 19<sup>th</sup> century France saw a series of civil wars fought along class lines, it is telling that the only civil war in the history of the United States was initiated by those who wished to preserve slavery. <span class="footreturn"><a href="#3return">↩</a></span></p>

    </div>
  }
}

articles << {
  url: "http://www.crimethinc.com/texts/r/battle/",
  category: "Analysis",
  title: %q{
    Report Back from the Battle for Sacred Ground
  },
  subtitle: %q{
  },
  image: "http://crimethinc.com/texts/r/battle/images/header2000.jpg",
  content: %q{
    <p><em>For months, hundreds of people, including members of nearly a hundred different indigenous peoples, have mobilized to <a href="https:/images/nodaplsolidarity.org/">block the construction of the Dakota Access Pipeline.</a> On October 27, <a href="https:/images/warriorpublications.wordpress.com/2016/10/30/nodapl-riot-police-raid-sacred-ground-camp/">police raiding the Sacred Ground camp</a> encountered stiff resistance. We’ve just received the following firsthand report from comrades who participated in the defense of the camp. Describing some of the fiercest clashes indigenous and environmental movements in the region have seen in many years, they pose important questions about solidarity struggles.</em></p>

    <h2>The Battle</h2>

    <p>When we arrive on Wednesday, October 26, we can&#8217;t find our contacts, the friends and friends of friends who have been vouched into the secretive Red Warrior camp. Word around the camp is that eviction is imminent for Sacred Ground, the only camp in the direct path of the proposed Dakota Access Pipeline. The tribe claims this land is territory granted to them in the 1851 Fort Laramie Treaty, and that they were using their own “eminent domain” to take it back when they set up the camp. We decide to set up at Sacred Ground and to figure out how to make ourselves useful in stopping its eviction.</p>

    <p>The Sacred Ground camp is located about two miles north of the main camp on highway 1806. The main camp itself is just north of the Standing Rock Reservation, where two more NoDAPL camps, Rosebud and Sacred Stone, are located. Before arriving, we had seen images of barricades blocking Highway 1806 to the north of the Sacred Ground camp.</p>

    <div class="smallimage"><img src="http://www.crimethinc.com/texts/r/battle/images/map.gif"></div>

    <p>When we walk to that site, however, we find those barricades have been pushed to the sides of the road, the northernmost one turned into a kind of checkpoint. According to the people at the checkpoint, they were ordered to remove the blockade by the camp leaders, who plan on allowing the police to enter and evict the camp. </p>

    <p>The “camp leaders” are hired Nonviolent Direct Action consultants. They are utilizing a classic strategy of nonviolent civil disobedience: they hope that the images of police evicting people in prayer will win them the sympathy of the public. The people we speak with at the checkpoint are clearly not buying this. But what can they do? Their elders have hired these people to stage-manage the moment.</p>

    <p>After some conversation with the folks on the barricades and with the “camp leaders,” it is decided that we&#8217;ll leave the road open until the police actually arrive, and then we&#8217;ll build up the barricades quickly in order to slow their progress. This will hopefully buy time to allow the people who want to get arrested while in prayer to assemble and prepare themselves. For what its worth, this plan was crafted with the approval of the “proper channels.”</p>

    <p>As soon as this course of action is proposed, some new organism bursts into life, and thirty people we&#8217;ve never met are loading logs and tires and barbed wire onto trucks in the middle of the night. A plan comes together for when and how to start blocking the road. The energy is electric; the possibility of a real physical defense of this strategically decisive camp is in the air and in people&#8217;s conversations.</p>

    <p>“I don&#8217;t know who those ‘leaders’ are,” a Native guy tells us as we throw tires on the side of the road. “They&#8217;re not my elders. I came here to defend this camp, and I&#8217;m going to do what I have to.” We still don&#8217;t know where the fabled Red Warrior folks are, but we feel that we&#8217;ve found people we want to support in this battle.</p>

    <p>This is the plan: the folks up the hill at the checkpoint are the first line of defense. When the cops come, they will get in the road and begin a prayer ceremony. They inform us they have no intention of moving until they are arrested or worse. While they block the road, it will be our job to build up the next barricade about a quarter mile down the road to buy time for the prayer circle to assemble in the camp. To us, this is not ideal, because it still means that the eviction will go through. But we also feel that we have very little agency in this situation. We&#8217;re white. We just showed up. At least we&#8217;ll be a part of putting up a fight, we tell ourselves. At least the police won&#8217;t just be invited in.</p>

    <p>We take shifts all night, trying to decode the flying objects in the sky. Is that a drone or a satellite? Is that the moon behind the clouds? Then why is it moving? Why is that surveillance plane flashing those lights over there? For hours, I have the feeling that we&#8217;ve stepped into some deep historical current, that this moment is connected to every other moment in which people waited to defend barricades against overwhelming adversaries. We joke and tell stories, we snap our attention to any movement on the hillside, we speculate and scheme. We receive new names based on stupid things we do or say. The night is long and cold and at dawn the sun is welcome.</p>

    <aside>
    <blockquote class="accent">“All night, we take shifts at the barricades, watching the sky for drones. The night is long and cold and at dawn the sun is welcome.”</blockquote>
    </aside>


    <p>The next morning, we learn that there has been another barricade all along, located on a bridge on Route 134, the only other entrance by which the police can access the Sacred Ground camp since all other entrances go through the Standing Rock reservation. Apparently this is what Red Warrior has been up to, and they have no intention of letting the police through. While that is exciting to hear, we can&#8217;t understand why the same commitment to physically defend the space is absent here on Highway 1806.</p>

    <p>Around midday, a line of police vehicles shows up blaring their sirens—but not on the highway. They are taking the access road beside the pipeline construction, where we have no defenses. People start parking their cars to block the access road and crowds start to gather. Word comes that the police are bringing in armored vehicles on the highway. We run to our posts at the second blockade and begin loading tires into the street. Just then, a truck pulls up and out steps a paid nonviolent consultant who is on his way to negotiate a mass arrest. He gathers the barricade crew in a circle and makes an impassioned plea for us to leave the road clear. “When people see the images of them arresting us and storming our teepees with guns, they will know our struggle is right.”</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/battle/images/1-1370.jpg">
    </div>

    <p>Some people are convinced and begin removing the barbed wire. Our crew has a quick conversation. We aren&#8217;t convinced by this guy, but we don&#8217;t want to be the ones to disobey his orders—we don&#8217;t want to make it easy for the police or media to deploy a narrative about “outside agitators,” and we don&#8217;t want to sabotage the possibility of other anarchists like us participating in this struggle. We decide we will check in with the Native guys we spent the night on the barricade with. When we ask about their reaction to the speech, we get a blunt response: “Fuck that guy.” Our thoughts exactly.</p>

    <p>As we&#8217;re building the barricade, our new friends give us one rule: build it up as much as we want, but their elders say no fire. We agree to this. At this point, people are crowded up the hill at the first checkpoint; we begin to load our barricade materials into the street, leaving one lane open to enable our people to make it to the other side before the cops. We watch from a distance as the armored vehicles approach the crowd up ahead.</p>

    <p>Then a blue car that had been up near the first checkpoint speeds down the hill toward us. It parks, blocking half the road. A Native woman gets out and stabs her own tires with a knife. A team removes her license plates, and soon another car blocks the other side of the road in similar fashion. The cops are heading toward us, and word spreads that the other barricade is already on fire. People and horses are herded to our side of the blockade. Just then, the paid nonviolence consultant gets on top of one of the cars and attempts to deliver a speech to calm everyone down. He can barely get a word out before a Native kid gets up on the other car and starts chanting:</p>

    <p>“BLACK SNAKE KILLAZ! BLACK SNAKE KILLAZ!”</p>

    <p>As the crowd chants this over the guy who just negotiated a carefully orchestrated mass arrest with the cops, the barricade is lit and the fight is on. Bottles and stones are thrown at the police vehicles. But this only lasts for a moment before a line of elders and camp security forms to start pushing the combatants back from the barricade. Shouting matches and fistfights break out. There are Native folks of all ages on both sides of the long and disappointing struggle. Those opposing the physical confrontation succeed in pushing us back, enabling the police to form a line around the north side of the camp where the large crowds are gathered.</p>

    <p>At this point, a truck is parked in the road with two people locked to the underside. Logs are piled up around the truck and two teepees are erected on either side of it. Some try to hold a line against the police, stretching teepee poles across a dozen people. Others hurl stones and logs at the cops and their vehicles. The chaos is overwhelming. A young warrior on horseback is tazed and falls to the ground. All around us, people are screaming from the effects of pepper spray. Flash-bang grenades are bursting in the air, mingling with rubber bullets and beanbag rounds. The screaming matches continue between those who want to fight back and those who want to be arrested while praying. The cops are already in the camp.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/battle/images/2-1370.jpg">
    </div>

    <p>Over a painful hour, we are all pushed south of the only camp that blocked the construction of the Dakota Access Pipeline. Over a hundred people are arrested, many of them charged with “conspiracy to endanger with fire” regardless of whether they were in any proximity to the flaming barricade. This seems calculated to drain our legal fund, since the bail is set at $1500 each. Sacred Ground is lost.</p>

    <h2>Riot on the Prairie</h2>

    <p>As we ride south, smoke rises from a hill in the east. Some clever folks have taken advantage of the chaos to burn construction equipment. This gesture is greeted with cheers. In the other direction, smoke rises from a truck set aflame on the 134 Bridge. People are running to the top of a hill to the east. There we witness a chase: police in military gear pursuing two warriors on horses, who have apparently rallied a herd of buffalo at the police line back at camp. The cops shoot at the horses while trying to cut them off, as people scramble to remove a barbed wire fence for the horses to escape. They succeed with seconds to spare; the police ATVs turn back amid our curses.</p>

    <p>Another barricade goes up where Route 134 meets Highway 1806. A crowd gathers at that intersection. It’s clear that this is the new front. As people are eating and planning their stand, shouts ring out: “STOP THE WHITE TRUCK!” We all run into the road to block a white pickup that is coming from the north. It turns off the road and tries to speed around us. Trucks from our side give chase, and the white truck is eventually rammed off the side of the road. The driver, a DAPL security guard who had pointed a gun at demonstrators up the hill, runs out of the truck carrying an AR&#8211;15 rifle. He is chased into a pond where an hour-long standoff ensues. Meanwhile, his truck is looted, driven up the hill, and flipped onto the new barricade. It is set on fire, along with another car donated for the cause.</p>

    <p>The Bureau of Indian Affairs police arrive from the south, disarm the DAPL security guard, and arrest him. They leave everyone else untouched and head back south. For us anarchists, this is a mind-boggling event. We&#8217;d heard the BIA police were “in support” of the protests, but we never expected them to treat the movement with such respect. Later, we hear a rumor that they actually turned away State Police from entering the reservation from the south, effectively preventing the police from kettling all of us.</p>

    <div class="bigimage" style="background: none;"><img src="http://www.crimethinc.com/texts/r/battle/images/3-1370.jpg">
    </div>

    <p>As a cavalcade of armored vehicles and Hummers approach from the north, everyone falls back to a bridge on Highway 1806. This bridge is not on the reservation, but it is the only entrance from the north. Entire tree trunks are unloaded from trucks, constructing a substantial barricade. It includes a twelve-foot-tall solar-powered highway sign, the batteries from which are skillfully expropriated. The barricade catches fire. The police approach and hold a line.</p>

    <p>For the following eight hours, America is over. Rocks and Molotov cocktails defend the barricade; a wall of plywood shields deflects rubber bullets and tear gas canisters. The partisans of nonviolence are gone, and the kind of combative energy that could have held Sacred Ground emerges in full force. The fight lasts into the early hours of the morning, when the police fire a large number of smoke grenades and use the cover to withdraw and retreat, leaving two military supply trucks blocking the road north of the bridge.</p>

    <p>Those trucks too are set on fire, and the battle for the bridge is won.</p>

    <h2>Aftermath</h2>

    <p>After some sleep, we arrived at the bridge the next morning to find people holding a line north of the burnt military vehicles. The police and the National Guard were erecting concrete highway barriers about 50 feet north of the line—surrendering Highway 1806 as a functioning road, but also blocking those opposed to the pipeline from driving vehicles back toward the former site of the Sacred Ground camp.</p>

    <p>It was just a couple dozen people holding the line with plywood shields; most of them were quite young. News media and other rubberneckers were milling about on the bridge, examining the burnt wreckage from the night before. After a while, an older Native man showed up, stepped out in front of the line, and spoke to us all: “I&#8217;m 78 years old. I&#8217;m an elder. I&#8217;m going to make a deal with the police to get you all off this bridge.” Another older Native man, who had been holding a shield, shouted him down: “I&#8217;m 73 years old, and I am also an elder. And I&#8217;m saying we fight back! We hold our position!”</p>

    <p>Soon camp “security” showed up with orders from their elders to clear the bridge and push us all back. They locked arms and formed a line to force us off the bridge. Tensions grew as those who wanted to hold it, both Native and non-Native, argued with each other. Once again, people who were “on our side,” acting in the name of “the elders,” did the work of the police for them.</p>

    <p>“This is what they have always done to us!” the ones trying to hold the bridge told us. “They turn us against one another to pacify us!”</p>

    <p>The people clearing us from the bridge didn&#8217;t have arguments, just their bodies acting on behalf of “the elders,” ignoring the contradiction that they were clearing elders, among others, from the bridge.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/battle/images/4-1370.jpg">
    </div>

    <p>By the end of the day, not only was the bridge cleared, but the camp security had set up a line about a quarter of a mile up the road and wouldn&#8217;t let anyone close to it. Tensions are high within the camp, as the partisans of physical resistance to the pipeline clash with those who believe that symbolic arrests will somehow stop it, and those who are solely focused on the historic gathering of Native tribes split by centuries of hostility.</p>

    <p>When we return to our camp, we are pulled aside by a Native woman. She explains that she hears there are “agitators” in the camp and she&#8217;s going to keep her eye on us. She is convinced that it wasn&#8217;t Native folks who were fighting back the day before, but outsiders. A white comrade who has been here for months tells us that he was surrounded and threatened by four Native men, and was only saved by the fact that he knew all their names and could find Native warriors to vouch for him. Other contacts in Red Warrior communicate how delicate the situation is, explaining that the significance of the conversations taking place extends far beyond anything we can grasp as non-Native people. Any action we take autonomously could mess things up for everyone. We feel paralyzed, not knowing how to contribute to the efforts of those with whom we felt such intense affinity the night before.</p>

    <p>Late that night, from the top of a hill in Sacred Stone camp, we watch as a two-mile-wide fire burns up the hillside from the main camp in the direction of the construction. We have no idea whether folks on our side set the fire as a sublime gesture of intimidation, or whether the forces of order have set it to scare people in the camp. We decide to believe the former, because we assume we&#8217;ll never know the truth.</p>

    <h2>Considerations for Solidarity</h2>

    <p>The situation here is delicate. While the battle for Sacred Ground revealed that people involved in this struggle are willing and able to fight outside the restrictions of stage-managed civil disobedience, it is not clear how this could take place now that the strategic position blocking the path of the pipeline has been lost. Further, tensions are so high in the camps that it feels dangerous to reveal oneself as a partisan of the combatant energy expressed on Thursday.</p>

    <p>Serious dilemmas confront non-Native anarchists who want to come to support the NoDAPL movement. On the one hand, this is a movement framed around indigenous rights and decolonial struggle. We can understand ourselves as allies or accomplices within this movement; if we assume that role, that means supporting the Native folks whose actions resonate with us while trying not to exacerbate conflicts within Native communities. While this approach may feel daunting in the current situation, more opportunities for support may open up soon.</p>

    <p>On the other hand, this is a struggle against a pipeline and, <a href="http://www.crimethinc.com/texts/r/bluefuse/index.html">like all struggles of our time,</a> against the police who protect it. From this perspective, everyone who drinks water, understands the threat of climate change, and opposes the police has a stake in participating. From this perspective, carrying out autonomous actions seems justified. However, if we take that route, we should be careful not to ignore the decolonial significance of the movement, and not to burn bridges with indigenous people who might be our comrades in the movements to come.</p>

    <p>Moreover, this struggle has received global attention thanks to the work done by people who have been here for months, including indigenous and non-indigenous warriors, some of whom are anarchist comrades. Anyone acting autonomously should consider the impact they will have on the plans and relationships these people have worked so hard to create.</p>

    <div class="bigimage"><img src="http://www.crimethinc.com/texts/r/battle/images/5-1370.jpg">
    </div>

    <aside>
    <blockquote class="accent">“Everyone who drinks water, understands the threat of climate change, or opposes the police has a stake in spreading this conflict worldwide.”</blockquote>
    </aside>

    <p>For now, our plan is to inhabit this space, build relationships, and try to make ourselves useful to those who have chosen to struggle to stop this pipeline by means other than the law. We don’t want to fully embrace the limitations of the “ally” role, nor do we want to act carelessly without an intimate knowledge of the situation in which we find ourselves, a situation we recognize that others have opened up.</p>

    <p>For those who can come, particularly those with relevant skills: come. It is not clear what the next move is, but we will need all the help we can get when it occurs. If you do come, be prepared to spend time learning about the power dynamics at work in this space, and to have less agency than you might want until you have earned people&#8217;s trust.</p>

    <p>For those who cannot come, or who feel they would not be able to act with proper sensitivity to the significance of this moment for indigenous people: now is the time to spread the fight to other locations. We hope to see the whole range of tactics from the anti-police movements of recent years deployed against the infrastructure of extraction and the flows of capital in general. Actions of all sorts are encouraged, though not all of them will be helpful in this specific location.</p>

    <p>This is a strategically crucial struggle in a pivotal moment. <a href="http://www.crimethinc.com/texts/r/reaction/">As our comrades have argued,</a> if we don&#8217;t act fast, we risk ceding the popular idea of resistance to the state to right wing forces that will recuperate our tactics and arguments to serve their own agenda. What has taken hold here in the struggle against the pipeline, and what burst into reality in the hours after the battle for Sacred Ground, has the potential to spread into a much wider resistance to extraction industries and ecocide. Let&#8217;s make it spread—but let&#8217;s do so with a sensitivity to the indigenous warriors and anarchist comrades who have thrown their lives into this struggle for months, who have shown the ability to organize and fight that has built the NoDAPL movement to this point.</p>

    <h2>To Learn More</h2>

    <p><a href="https:/images/warriorpublications.wordpress.com/2016/10/30/nodapl-riot-police-raid-sacred-ground-camp/">#NoDAPL: Riot Police Raid Sacred Ground Camp</a>
    <br />
    Sacred Stone Camp: <a href="http://sacredstonecamp.org/">webpage</a> | <a href="https:/images/fundrazr.com/d19fAf?ref=sh_25rPQa">Legal Defense Fund</a>
    <br />
    Red Warrior Camp: <a href="https:/images/www.facebook.com/RedWarriorCamp/">Facebook page</a> | <a href="https:/images/www.gofundme.com/redwarriorcamp">Fundraiser</a>
    <br />
    Oceti Sakowin Camp: <a href="http://www.ocetisakowincamp.org/">website</a> | <a href="https:/images/www.paypal.me/OcetiSakowinCamp">Fundraiser</a></p>
    <p>&nbsp;</p>
  }
}



# Find the "published" Status id once for reuse on each test Article
published_status = Status.find_by(name: "published")

# Loop through and create the articles
articles.each_with_index do |article_params, index|
  # Delete URL from params before creating Article
  article_params.delete(:url)

  # Delete Category from params before creating Article
  # And create a new Category
  category = Category.find_or_create_by! name: article_params.delete(:category)

  # Delete Theme from params before creating Article
  theme = article_params.delete(:theme)

  # Back date articles to the past 5 days for development
  days_offset  = index + 1
  published_at = Time.current - days_offset.days

  article_params[:published_at]   = published_at
  article_params[:status_id]      = published_status.id
  article_params[:content_format] = "html"

  # Save the Article
  article = Article.create!(article_params)

  # Add the Article to its Category and Theme
  category.articles << article
  if theme.present?
    theme.articles << article
  end
end
