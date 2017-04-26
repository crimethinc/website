# The Entire Publishing Workflow

First, you need a CMS account for https://crimethinc.com/admin. To see if you do, go there and sign in. If you are able to, you have an account! If you can't, you don't.

If you don't, contact someone who already does. They can create an account for you.

# Creating a New CMS Account for Someone

Firstly, this isn't necessary for every author, especially people who just write a one off thing. This is only for people who need / want to be responsible for publishing articles to the live site.

1. Sign in to the CMS admin: https://crimethinc.com/signin
2. Click `Users` from the `Site Settings` menu (on mobile that's behind the ||| "hamburger menu")
3. Click `NEW` under the `Users` heading
4. Fill out the form on https://crimethinc.com/admin/users/new
  - Required fields are `Username`, `Password`, `Password confirmation`
  - Create a temporary password for them (don't ask them what password they want)
  - Something like `123456789012345678901234567890` (it must be 30+ characters)
5. Click `Sign Up` at the bottom of the form
6. Give the new person their username and temporary password
7. Ask them to change their password before doing anything else
  - After they sign in, they need to go to: https://crimethinc.com/settings

***

# First Time Signing In

After someone creates a CMS account for you and gives you your temporary password, you can sign in and change that to a real password.

1. Go to the sign in page and sign in : https://crimethinc.com/signin
2. Click the `You` menu, then click `Settings` : https://crimethinc.com/settings
3. On the Settings form, you can edit the optional fields if you want (`Name`, `Email`, `Avatar`).
4. Enter you new password into both `Password` and `Confirm Password` fields.
  - Passwords must be at least 30 characters long
  - If you can, use a password manager like 1Password
  - Pass phrases are another way to make a long password that is memorable
  - Example: `mickie fickie firecracker soap on a rope` (don't use that one)
5. Click `Save`

***

# Creating an Article Draft

1. Sign in. Go to the Articles admin. https://crimethinc.com/admin/articles
2. Click `NEW` under the `Articles` heading
3. Don't write the article in the web browser. Write it in some plain text editor,  preferably not a rich text editor like Microsoft Word which does goofy opinionated things to plaintext.
4. All the fields can be filled out iteratively with multiple saves and edits. Anything that is "required" is only required at publish time, not at draft time.
5. Assuming the article author has already written in Markdown, fill out as many fields as you know the values for.
6. Click any of the `Save` buttons. They all do the same thing.
7. An article has now be created with the `Publication Status` of `Draft`. Great job!

## A Description Article CMS Fields

- `Title` is required
- `Subtitle` is optional, but encouraged
- `Content` is required
  - Don't duplicate the `title`/`subtitle` in the `Content`
- `Publication Date & Time` defaults to the `Time.now` whenever you loaded this page.
  - Chances are you're not publishing this article right now, but sometime in the future. If you know the `Publication Date`, set it.
  - For the time, we tend to publish at `2pm EST / EDT` / `11am PST / PDT`. Times are stored as `UTC`/`GMT`. So the offset is from England. That'll be either `18:00` or `19:00` depending on whether it's Daylight Savings Time time.
- `Categories` should have at least one (and typically only one) category checked
- `URL Slug` will be auto-generated from the `title`/`subtitle`. If you leave it blank when you save, you'll get something automatically. However, if you edit your `title`/`subtitle` in subsequent edits, you should clear out the `URL Slug` field to force it to be re-generated.
- `Short URL Path` is required. It's what you want in the short URL in social media posts. http://cwc.im/acab or whatever. (**Note:** at the moment, this doesn't actually create the short URL. That is still a manual separate step discussed below in "Creating a Redirect"). This needs to be URL safe (no spaces, etc) and unique (cwc.im/acab and cwc.im/acab can't each redirect to different articles).
- `Tags` is optional. They are displayed in the footer. Eventually, we'll do a big push to tag all historical articles and be able to use them more meaningfully.
- `Tweet` is required and limited to **115** characters to leave room for the `t.co` URL that Twitter turns all URLs into.
- `Summary` is required and is used in link previews in Facebook, Slack, etc when someone pastes a URL into a post.
- `Header Image` is required. How and where to upload an image is covered in another document.
- `Header Shadow Text` should only be checked if the header image is either very light or has spots of white which make it difficult to read the white header text.
- `Header Background Color`, `Header Text Color`, `Hide the Site Layout?`, `Content Format` are mostly there to support historical articles that don't have a header or have a complete design including layout. You will probably never need to use any of these.
- `PDF Download URL` is optional and is for a URL to a PDF on our CDN if one has been designed. It'll add a download button to the footer of the article.
- `Article Specific CSS` is almost never needed either and should not be used as a hammer. If an article has some truly unique requirements, you can write some CSS here to fulfill them. But be very careful to scope the CSS to only this article and not affect the whole site.

# Editing an Article Draft

1. Sign in.
2. Go to articles admin. https://crimethinc.com/admin/articles
3. Find the article that you want to edit.
4. Click the `Edit`.
5. Fill out any missing fields that you're able to. Edit the `Title`/`Subtitle`/`Content`.
6. If you change the `Title`/`Subtitle` fields, be sure to blank out the `URL Slug` so it gets re-auto-generated.
7. When the article gets to a place where it is done be edited, change the `Publication Status` of `Edited` and click `Save`.

# Publishing an Article

1. Make sure that the `Publication Date & Time` is set properly to what you want. (I.e., not in the past. Not in the distant future.)
2. Make sure the `URL Slug` reflects the current values of `Title`/`Subtitle`.
3. Change the `Publication Status` of `Published` and click `Save`.
4. That's it! At that date and time, the article will show up on the homepage and in our RSS feeds.

# Creating a Redirect

Eventually, this will happen automatically. But as long as these instructions are here, it's still necessary to do manually. It helps to have the CMS open in two browser tabs or windows and to switch back and forth. One with the Redirect form, one with the Article show page.

1. Once an article `Publication Status`'s is `Published`, a `Redirect` can be created for it.
2. If no one filled in the `Short URL Path` for the article, you will need to decide one or ask around to figure out what it should be.
3. If the article has something in the `Short URL Path` field, you can use that.
4. Sign in.
5. Go to the `Site Settings` menu, then click on `Redirects`.
6. Click `NEW` under the `Redirects` heading
7. Fill out the `Source Path` with the value from the article's `Short URL Path`.
8. Fill out the `Target Path` with the article's path or URL. You can copy that from the article show page in the CMS next to `URL:`. Like here: https://crimethinc.com/admin/articles/847. Or if the article is live (on the homepage), you can copy its URL from your browser's address bar when you're viewing that article (not the homepage). Like here: https://crimethinc.com/2017/04/10/inversions-palinodes-and-anti-poems.
9. Leave `Temporary` unchecked, unless your making a special short URL whose destination will likely change in the future. Like `/acab` or `/live`. Those are temporary redirects, meaning that Google et al won't cache them forever as going to wherever they go right now.
10. Click `Save`.

***

- The Redirects manager is pretty smart about doing the right thing with your input. And is also pretty forgiving.
- Technically, what gets saved looks like `/sourcepath` and `/target-path` with leading `/`s and no leading domain (https://crimethinc.com or cwc.im).
- It should strip those out if you ever paste them in. BUT if you ever see something end up as the saved Redirect that doesn't look like `/sourcepath` and `/target-path`, raise a flag because something went wrong.
- External redirects ARE allowed though. `/target-path` can be a fully qualified URL if it's pointing to a different domain.
  - **sourcepath**: `/wtf` and **targetpath**`http://example.com`.
  - `http://` is required if that's the case. `www.example.com` is not enough.
- `Source path` has to be unique. If you try to create a Redirect with a `Source path` that already exists, you'll get an error saying "Source path has already been taken." and you'll need to use something else instead.
  - If whatever you end up using is different from the `Short URL Path` saved on the Article, you should go back to the article and update its `Short URL Path` to match.
- Again, eventually all of this will be automated.

