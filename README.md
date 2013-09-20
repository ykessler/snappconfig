# Snappconfig

Smarter Rails configuration that works with Heroku. Here's why it rocks:

- **It's Simple**. There's no setup code. Just **edit some YAML** and you're ready to roll.
- It supports **nested values and lists**. Use the data structures you want and access them with standard hash notation (e.g. `CONFIG[:this][:that]`)
- It promotes **secure best practices** that keep your secrets out of source control.
- It lets you write to a nestable `CONFIG` hash *or* to  `ENV` variables- we don’t tell you how to live.
- It's **Heroku-friendly**.
- It's based on Ryan Bates’ excellent [Railscast](http://railscasts.com/episodes/85-yaml-configuration-revised) and inspired by [Figaro](https://github.com/laserlemon/figaro).

## Installation
  
  
  
**1)** Add it to your Gemfile and run `bundle` to install

    gem 'snappconfig'

**2)** Use the generator to create config files (optional):

    $ rails generate snappconfig:install

This will create:  

- A default config file at `config/application.yml`
- A git-ignored config file for secrets at `config/application.secrets.yml`




## Usage

To access config values, just use standard hash notation:

    token = CONFIG[:secret_token]
    stripe_secret = CONFIG[:stripe][:secret_key]
    
Or if you wrote values to **ENV**, get them the way you normally would:

    token = ENV['SECRET_TOKEN']



## YAML file examples



####Environment specfic (with defaults)
    mailer_host: "localhost:3000"
    development:
      mailer_host: "localhost:3000"
    test:
      mailer_host: "test.local"
    production:
      mailer_host: "blog.example.com"
( **NOTE:** Default values can also be put under a 'defaults' group key. )

####Nested values:
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
        BLOG_USERNAME: "admin"
        BLOG_PASSWORD: "secret"

( **NOTE:** Values you put under an **"ENV"** key will be accessible in your app via `ENV['MY_VAR']` instead of `CONFIG[:my_var]`. These values can't be nested. )  



## Multiple files

The number of config files you use is up to you. Stuff it all in a single file, or use multiple files for different versions, environments, etc.

Snappconfig will load all files in the `config/` directory that start with **"application."** and end with **".yml"**, and merge them down in alphabetical order (minus the file extension), with later values taking precedence.

For example, the following files would be processed in order:

- **application**.yml
- **application.2**.yml
- **application.test**.yml


<a name='best_practices'/>
##Best practices


There's nothing to stop you from putting all your configuration into a single `application.yml` file. However, best practices dictate that protected values like **passwords and tokens should not be stored in source control.** 

An obvious solution would be to git-ignore the config file, but that approach has its problems. Not all values need to be secret, and without any config file developers won't know what values are expected or what the defaults should be.

###Separating your secrets

A better approach is to separate the secret values from the configuration values that are useful to share. Snappconfig makes this easy with multi-file support and the `_REQUIRED` keyword.


For instance, if we already have a mailer configuration that works for our app, there's no reason the bulk of it can't go into source control...


**application.yml:**

    secret_token: _REQUIRED
    mail:
      delivery_method: :smtp
      smtp_settings:
        address: "smtp.gmail.com"
        port: '587'
        domain: 'baci.lindsaar.net'
        user_name: 'acmesupport'
        password: _REQUIRED
        authentication: 'plain'
        enable_starttls_auto: true

Using the `_REQUIRED` keyword, we indicate values we expect to be included in the configuration, even though they're not in this file. 

We can then fulfill that obligation by using a git-ignored file that just stores our secrets: 

**application.secrets.yml:**

    secret_token: "024e1460a4fb8271e611d0f53811a382f1f6be121..."
    mail:
      smtp_settings:
        password: 8675309

Now we've got a complete configuration without compromising anything!

The `_REQUIRED` keyword is really handy. You can use it to stub out an entire config file template. If any of the required values are not present at runtime Snappconfig will raise an error, ensuring you never go live without a complete configuration.

###Working with Heroku

The Heroku file system is read-only, so if you're git-ignoring your config files you won't be able to add them in manually.

But don't worry, Snappconfig's got you covered- just run the custom rake task:

    $ rake snappconfig:heroku

and your app configuration will automatically be passed into Heroku for you. Slick!



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
