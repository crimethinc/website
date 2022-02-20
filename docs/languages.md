# Add a new language to /languages

## Create a new Locale in /admin

https://crimethinc.com/admin/locales

## Add articles/et al in that Locale

When creating an Article, choose the Locale in the Article admin form. After there's at least one Article in a Locale, it'll show up on the `/languages`.

https://crimethinc.com/languages

### Add variations to LocaleService::Locales::LOCALES

In: `app/services/locale_service/locales.rb`.

For example:

```
## cs: czech
Locale.new(locale: 'czech',   lang_code: :cs, canonical: 'cestina'),
Locale.new(locale: 'čeština', lang_code: :cs, canonical: 'cestina'),
Locale.new(locale: 'cestina', lang_code: :cs, canonical: 'cestina'),
```

### Duplicate, rename, and edit locale YAML files

Duplicate these files:

- `config/locales/en.yml`
- `config/locales/en`

Rename them to match the locale abbreviation:

- `config/locales/cs.yml`
- `config/locales/cs`

Edit the root note to match the locale abbreviation:

For example, change this: `en:` to `cs:`.

And then change then value of `name` to the name of the language in that language. For example, `Español`, not `Spanish`.

Continuing with CS as the example:

`  name: Czech`

### Add the new locale to the tests

In these files:

- `spec/factories/articles.rb`
- `spec/factories/locale.rb`
- `spec/system/language_landing_page_spec.rb`

Follow the pattern in each file to add the new locale too.

### Add the locale abbreviation to application.rb

`config/application.rb`

Add the locale abbreviation to the `subdomain_locales` array.
