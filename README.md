lucid-shopify
=============

1. [Installation](#installation)
2. [Setup](#setup)
    * [Configure the API client](#configure-the-api-client)
3. [Webhooks](#webhooks)
    * [Configure webhooks](#configure-webhooks)
    * [Register webhook handlers](#register-webhook-handlers)
    * [Create and delete webhooks](#create-and-delete-webhooks)
4. [Verification](#verification)
    * [Verify callbacks](#verify-callbacks)
    * [Verify webhooks](#verify-webhooks)
5. [Authorisation](#authorisation)
6. [Billing](#billing)
7. [Calling the API](#calling-the-api)
    * [Make API requests](#make-api-requests)
    * [Make unthrottled API requests](#make-unthrottled-api-requests)
    * [Pagination](#pagination)


Installation
------------

Add the gem to your ‘Gemfile’:

    gem 'lucid-shopify'


Setup
-----

### Configure the default API client

    Lucid::Shopify.configure do |config|
      config.api_key = '...'
      config.api_version = '...' # e.g. '2020-01'
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


Webhooks
--------

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


Verification
------------

### Verify callbacks

Verify callback requests with the request params:

    begin
      Lucid::Shopify::VerifyCallback.new.(params)
    rescue Lucid::Shopify::Error => e
      # ...
    end


### Verify webhooks

Verify webhook requests with the request data and the HMAC header:

    begin
      Lucid::Shopify::VerifyWebhook.new.(data, hmac)
    rescue Lucid::Shopify::Error => e
      # ...
    end


Authorisation
-------------

    authorise = Lucid::Shopify::Authorise.new

    access_token = authorise.(credentials, authorisation_code)


Billing
-------

Create a new charge:

    create_charge = Lucid::Shopify::CreateCharge.new

    charge = create_charge.(credentials, charge) # see Lucid::Shopify::Charge

Redirect the user to `charge['confirmation_url']`. When the user
returns (see `config.billing_callback_uri`), activate the accepted
charge:

    activate_charge = Lucid::Shopify::ActivateCharge.new

    activate_charge.(credentials, accepted_charge)


Calling the API
---------------

### Make API requests

    client = Lucid::Shopify::Client.new

    client.get(credentials, 'orders', since_id: since_id)['orders']
    client.post_json(credentials, 'orders', new_order)

Request logging is disabled by default. To enable it:

    Lucid::Shopify.config.logger = Logger.new(STDOUT)

Request throttling is enabled by default. If you're using Redis, throttling
will automatically make use of it; otherwise, throttling will only be
maintained across a single thread.


### Make unthrottled API requests

    client.unthrottled.get(credentials, 'orders')
    client.unthrottled.post_json(credentials, 'orders', new_order)


### Pagination

Since API version 2019-07, Shopify has encouraged a new method for
pagination based on the Link header. When you make a GET request,
you can request the next or the previous page directly from the
response object.

    page_1 = client.get(credentials, 'orders')
    page_2 = page_1.next
    page_1 = page_2.previous

When no page is available, `nil` will be returned.
