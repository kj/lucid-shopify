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
      '...', # billing_callback_uri
      '...', # webhook_uri
    )

Alternatively, a credentials object may be passed as a keyword
argument to any of the classes that make use of it.

Additionally, each API request requires authorization:

    request_credentials = LucidShopify::RequestCredentials.new(
      '...', # myshopify_domain
      '...', # access_token
    )

If the access token is omitted, the request will be unauthorized.
This is only useful during the OAuth2 process.


### Configure webhooks

Configure each webhook the app will create (if any):

    LucidShopify.webhooks.register('orders/create', fields: 'id,tags'}


### Register webhook handlers

For each webhook, register one or more handlers:

    LucidShopify.handlers.register('orders/create', OrdersCreateWebhook.new)

See the inline method documentation for more detail.

To call/delegate a webhook to its handler for processing, you will likely want
to create a worker around something like this:

    webhook = LucidShopify::Webhook.new(myshopify_domain, topic, data)

    LucidShopify.handlers.delegate(webhook)


### Create and delete webhooks

Create/delete all configured webhooks (see above):

    LucidShopify::CreateAllWebhooks.new.(request_credentials)
    LucidShopify::DeleteAllWebhooks.new.(request_credentials)

Create/delete webhooks manually:

    webhook = {topic: 'orders/create', fields: %w(id tags)}

    LucidShopify::CreateWebhook.new.(request_credentials, webhook)
    LucidShopify::DeleteWebhook.new.(request_credentials, webhook_id)


### Verification

Verify callback requests with the request params:

    begin
      LucidShopify::AssertCallback.new.(params)
    rescue LucidShopify::Error => e
      # ...
    end

Verify webhook requests with the request data and the HMAC header:

    begin
      LucidShopify::AssertWebhook.new.(data, hmac)
    rescue LucidShopify::Error => e
      # ...
    end


### Authorization

_TODO_


### Make an API request

_TODO_
