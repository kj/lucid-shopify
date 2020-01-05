lucid-shopify
=============

Installation
------------

Add the gem to your ‘Gemfile’:

    gem 'lucid-shopify'


Usage
-----

### Configure the default API client

    Lucid::Shopify.configure do |config|
      config.api_key = '...'
      config.api_version = '...' # e.g. '2019-07'
      config.billing_callback_uri = '...'
      config.callback_uri = '...' # (for OAuth; unused by this gem)
      config.logger = Logger.new(STDOUT)
      config.scope = '...'
      config.shared_secret = '...'
      config.webhook_uri = '...'
    end

All settings are optional and in some private apps, you may not
require any configuration at all.

Additionally, each API request requires authorisation:

    credentials = Lucid::Shopify::Credentials.new(
      '...', # myshopify_domain
      '...', # access_token
    )

If the access token is omitted, the request will be unauthorised.
This is only useful during the OAuth2 process.


### Configure webhooks

Configure each webhook the app will create (if any):

    webhooks = Lucid::Shopify::Container['webhook_list']

    webhooks.register('orders/create', fields: 'id,tags'}


### Register webhook handlers

For each webhook, register one or more handlers:

    handlers = Lucid::Shopify::Container['webhook_handler_list']

    handlers.register('orders/create', OrdersCreateWebhook.new)

See the inline method documentation for more detail.

To call/delegate a webhook to its handler for processing, you will likely want
to create a worker around something like this:

    webhook = Lucid::Shopify::Webhook.new(myshopify_domain, topic, data)

    handlers.delegate(webhook)


### Create and delete webhooks

Create/delete all configured webhooks (see above):

    Lucid::Shopify::CreateAllWebhooks.new.(credentials)
    Lucid::Shopify::DeleteAllWebhooks.new.(credentials)

Create/delete webhooks manually:

    webhook = {topic: 'orders/create', fields: %w(id tags)}

    Lucid::Shopify::CreateWebhook.new.(credentials, webhook)
    Lucid::Shopify::DeleteWebhook.new.(credentials, webhook_id)


### Verification

Verify callback requests with the request params:

    begin
      Lucid::Shopify::VerifyCallback.new.(params)
    rescue Lucid::Shopify::Error => e
      # ...
    end

Verify webhook requests with the request data and the HMAC header:

    begin
      Lucid::Shopify::VerifyWebhook.new.(data, hmac)
    rescue Lucid::Shopify::Error => e
      # ...
    end


### Authorisation

    authorise = Lucid::Shopify::Authorise.new

    access_token = authorise.(credentials, authorisation_code)


### Billing

Create a new charge:

    create_charge = Lucid::Shopify::CreateCharge.new

    charge = create_charge.(credentials, charge) # see Lucid::Shopify::Charge

Redirect the user to `charge['confirmation_url']`. When the user
returns (see `config.billing_callback_uri`), activate the accepted
charge:

    activate_charge = Lucid::Shopify::ActivateCharge.new

    activate_charge.(credentials, accepted_charge)


### Make API requests

    client = Lucid::Shopify::Client.new

    client.get(credentials, 'orders', since_id: since_id)['orders']
    client.post_json(credentials, 'orders', new_order)

Request logging is disabled by default. To enable it:

    Lucid::Shopify.config.logger = Logger.new(STDOUT)


### Make throttled API requests

    client.throttled.get(credentials, 'orders')
    client.throttled.post_json(credentials, 'orders', new_order)

Note that throttling currently uses a naive implementation that is
only maintained across a single thread.
