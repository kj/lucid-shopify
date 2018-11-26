lucid_shopify
=============

Installation
------------

Add the gem to your ‘Gemfile’:

    gem 'lucid_shopify'


Usage
-----

### Configure the default API client credentials

    LucidShopify.config = LucidShopify::Config.new(
      '...', # api_key
      '...', # shared_secret
      '...', # scope
      '...', # callback_uri (for OAuth; unused by this gem)
      '...', # billing_callback_uri
      '...', # webhook_uri
    )

Alternatively, a credentials object may be passed as a keyword
argument to any of the classes that make use of it.

Additionally, each API request requires authorization:

    credentials = LucidShopify::Credentials.new(
      '...', # myshopify_domain
      '...', # access_token
    )

If the access token is omitted, the request will be unauthorized.
This is only useful during the OAuth2 process.


### Configure webhooks

Configure each webhook the app will create (if any):

    webhooks = LucidShopify::Container['webhook_list']

    webhooks.register('orders/create', fields: 'id,tags'}


### Register webhook handlers

For each webhook, register one or more handlers:

    handlers = LucidShopify::Container['webhook_handler_list']

    handlers.register('orders/create', OrdersCreateWebhook.new)

See the inline method documentation for more detail.

To call/delegate a webhook to its handler for processing, you will likely want
to create a worker around something like this:

    webhook = LucidShopify::Webhook.new(myshopify_domain, topic, data)

    handlers.delegate(webhook)


### Create and delete webhooks

Create/delete all configured webhooks (see above):

    LucidShopify::CreateAllWebhooks.new.(credentials)
    LucidShopify::DeleteAllWebhooks.new.(credentials)

Create/delete webhooks manually:

    webhook = {topic: 'orders/create', fields: %w(id tags)}

    LucidShopify::CreateWebhook.new.(credentials, webhook)
    LucidShopify::DeleteWebhook.new.(credentials, webhook_id)


### Verification

Verify callback requests with the request params:

    begin
      LucidShopify::VerifyCallback.new.(params)
    rescue LucidShopify::Error => e
      # ...
    end

Verify webhook requests with the request data and the HMAC header:

    begin
      LucidShopify::VerifyWebhook.new.(data, hmac)
    rescue LucidShopify::Error => e
      # ...
    end


### Authorization

    authorize = LucidShopify::Authorize.new

    access_token = authorize.(credentials, authorization_code)


### Billing

Create a new charge:

    create_charge = LucidShopify::CreateCharge.new

    charge = create_charge.(credentials, charge) # see LucidShopify::Charge

Redirect the user to `charge['confirmation_url']`. When the user
returns (see `config.billing_callback_uri`), activate the accepted
charge:

    activate_charge = LucidShopify::ActivateCharge.new

    activate_charge.(credentials, accepted_charge)


### Make API requests

    client = LucidShopify::Client.new

    client.get(credentials, 'orders', since_id: since_id)['orders']
    client.post_json(credentials, 'orders', new_order)

Request logging is disabled by default. To enable it:

    LucidShopify.config.logger = Logger.new(STDOUT)


### Make throttled API requests

    client.throttled.get(credentials, 'orders')
    client.throttled.post_json(credentials, 'orders', new_order)

Note that throttling currently uses a naive implementation that is
only maintained across a single thread.
