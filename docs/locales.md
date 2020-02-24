# Adding a locale / language

A runbook


# For translators

***

# For code collective

## Locale code

1. Determine the 2-letter language code for the language you are adding
  - `xx`
  - https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
  - For example, `pt` for Portuguese

## DNS concerns

1. Add the domain to the Heroku app
  - `heroku domains:add [2-letter language code].crimethinc.com`
  - For example, `heroku domains:add pt.crimethinc.com`

1. Copy the HerokuDNS.com URL provided in the output of that command for the `CNAME` record

1. Add the subdomain to DNS host with a `CNAME` record matching the `HerokuDNS.com` URL from the previous step

## Files

1. Duplicate the `en.yml` locale file
