#  To Change Everything, language translations


## Prerequisites

### Data Gathering

1. determine the 2-letter language code for the language you are adding
  - https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry

2. decide on the new URL (`crimethinc.com/tce/foobar`)
  - we go with the name of the language _in that language_. For example, Spanish is `crimethinc.com/tce/espanol`

3. determine if the language is written left-to-right or right-to-left (`ltr` or `rtl`)
  - Wikipedia is a good way to figure this out

### Software needed

You will need a few tools mostly for processing the PDF and creating the image assets.

#### Image processing

- GIMP, Photoshop, etc: for cropping images
- `Imagemagick`: for creating the various sized versions of the images
- `pdfimages`: for pulling image assets out of the PDF

#### Text processing

- `pdftotext`: for pulling the text out of the PDF

## Getting up and running

You can run the `to_change_everything` generator to get some of the basic wiring set up:

```
rails generate to_change_everything LANG_CODE URL [LANG_DIRECTION] [options]
```

For example, `rails generate to_change_everything es espanol` or `rails generate to_change_everything es espanol rtl`

This generator will:

- Create a language-specific CSS file
- Add URL to `to_change_everything_controller`
- Add a translation yaml

After running the generator run the server (**you will need to restart the server if it was already running**) and try navigating to your new page.

## Slotting in the text

1. Obtain the PDF version of the language

2. Run this command in the terminal to extract the text:

```
pdftotext the-pdf-file.pdf the-pdf-file.txt
```

3. Using the PDF as a guide, put the corresponding text in the corresponding section of the new yaml file

- Wrap every paragraph in html `<p></p>` tags
- Include any internal html tags needed (e.g. `<em>`)
- Every line should be a single line (yes, some will be very long)

## Prepare the images

Woof.

**TODO:** we should explain more about what this means.

## Customize the CSS

¡GLHF!

**TODO:** we should explain more about what this means.

## Polish

There are certain things that vary from language to language. We will just try to work through them on the PR, but some examples are:

### PDF has a custom font

You can usually determine what font the PDF is using via this terminal command:

```
strings the-tce.pdf | grep FontName
```
