# Adding a language

A runbook

# For everyone

## Language code

Everyone reading this will need to know that language code for language you're working on.

1. Determine the 2-letter language code for the language you are adding
  - `xx`
  - https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
  - For example, `pt` for Portuguese




# For translators

## For updating an existing translation

1.https://github.com/crimethinc/website/tree/master/config/locales

## For creating a new translation

1. Send those files to the code collective via tech@crimethinc.com.
  - If PGP/GPG is imporant to you, email them to crimethinc.ex.workers.collective@protonmail.com
  - Our public key can be found at https://crimethinc.com/key.pub

***

# For code collective

## DNS concerns

1. Add the domain to the Heroku app
  - `heroku domains:add [2-letter language code].crimethinc.com`
  - For example, `heroku domains:add pt.crimethinc.com`

1. Copy the HerokuDNS.com URL provided in the output of that command for the `CNAME` record

1. Add the subdomain to DNS host with a `CNAME` record matching the `HerokuDNS.com` URL from the previous step

## Files

1. Duplicate the `en.yml` locale file
