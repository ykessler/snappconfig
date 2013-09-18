# Snappconfig

Smarter Rails configuration that works with Heroku. Here's why you want it:

- **Simple**- The only thing you edit is a single YAML file. // The only thing you edit is [some YAML] // No code to write- just edit your YAML
- **Slick**- Nest your configuration values as deep as you want to, and grab them with standard hash notation (e.g. `CONFIG[:this][:that]`)
- **Secure**- Creates a git-ignored config file, so you don’t have to worry about checking any secrets into source control.
- **Flexible**- Write to the nestable `CONFIG` hash *or* to [single-level] `ENV` variables- we won’t tell you how to live.
- **Heroku-friendly**- Use the custom rake task to feed your configuration to Heroku!
- **Best of the rest**- Based on Ryan Bates’ [Railscast](something) and inspired by [Figaro](something),

## Installation  
  
  
  
1) Add it to your Gemfile and run `bundle` to install

    gem 'snappconfig'

2) Use the generator to create the config file:

    $ rails generate snappconfig:install

This will create:  

- A git-ignored config file `/config/application.yml`
- An example config file `/config/application.example.yml` that *should* be stored in source, so that developers will know what values are needed.


## Usage

    token = CONFIG[:secret_token]
    mailer_host = CONFIG[:mail_settings][:host]

## Examples


###In `/config/application.yml`:


####Basic:
secret_token: "024e1460a4fb8271e611d0f53811a382f1f6be121..."
ENV: 
    CUSTOM_1:"value 1"
    CUSTOM_2:"value 2"
development:
  mailer_host: "localhost:3000"
test:
  mailer_host: "test.local"
production:
  mailer_host: "blog.example.com"


####Environment specfic (with defaults)
    mailer_host: "localhost:3000"
    development:
      mailer_host: "localhost:3000"
    test:
      mailer_host: "test.local"
    production:
      mailer_host: "blog.example.com"
(**NOTE:** Default values can also be put in a group named 'defaults')

####Nested values:
    aws: 
      access_key_id: 224bb493288ee170b13e
      secret_key: 12d925784adfb7cb1e42
      s3_bucket: example_dev
    stripe: 
      publishable_key: 5883eeb3cd43cee52585
      secret_key: 0df20bf20903c4404968 
      
    development:
      stripe: 
        publishable_key: 5883eeb3cd43cee52585
        secret_key: 0df20bf20903c4404968      
    production:
      stripe: 
        publishable_key: e753e42725fe43d3994a
        secret_key: e8787290a07b1abecae9

####ENV values:

    ENV: 
        CUSTOM_1:"value 1"
        CUSTOM_2:"value 2"

(**NOTE:** Values you put under an "ENV" key will be accessible in your app via `ENV['MY_VAR']` instead of `CONFIG[:my_var]`. These values can't be nested.)  



## How it works // Deploy it.

Snappconfig looks for a `/config/application.yml` file in your app- if it doesn't find one, it does nothing. 
Just add __ file to your app.

### Hold up- what about Heroku? 

Heroku's file system is readonly, so unless a file is checked in through git you can't add it on your own. "But I thought you said config files in[to] source control was a bad idea." I did- glad you're paying attention. But don't worry, Snappconfig's got you covered- just run the custom rake task:

    $ rake snappconfig:heroku

and your configuration/application file/settings will be automatically passed into Heroku for you! (Told you it was slick.) 


## Extra Info

- All keys in your YAML config get symbolized, so you can access them like `CONFIG[:key]`
- You can create env-specific YAML groups, and an empty group / or named default to provide fallback options
- You can use the special **':ENV'** key in your YAML config to define values that will be written to `ENV`. These values **a)** must be strings, **b)** can only be one level deep, **c)** will not show up in the `CONFIG` object/hash.
- NOTE: If you're working on a team it's not a bad idea to create an example file that IS stored in the repo (e.g. `application.example.yml`), so that developers can have an idea of what values are needed.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
