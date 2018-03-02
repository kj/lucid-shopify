lucid_shopify
=============

Installation
------------

Add the gem to your ‘Gemfile’:

    gem 'lucid_shopify'


Usage
-----

### Configure the default API client credentials

    LucidShopify.credentials = LucidShopify::Credentials.new(
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

    LucidShopify.webhooks << {topic: 'orders/create', fields: %w(id tags)}
    LucidShopify.webhooks << {topic: '...', fields: %w(...)}


### Register webhook handlers

For each webhook, register one or more handlers:

    delegate_webhooks = LucidShopify::DelegateWebhooks.default

    delegate_webhooks.register('orders/create', OrdersCreateWebhook.new)

See the inline method documentation for more detail.

To call/delegate a webhook to its handler for processing, you will likely want
to create a worker around something like this:

    webhook = LucidShopify::Webhook.new(myshopify_domain, topic, data)

    delegate_webhooks.(webhook)


### Create and delete webhooks

Create/delete all configured webhooks (see above):

    webhooks = LucidShopify::Webhooks.new

    webhooks.create_all(request_credentials)
    webhooks.delete_all(request_credentials)

Create/delete webhooks manually:

    webhook = {topic: 'orders/create', fields: %w(id tags)}

    webhooks.create(request_credentials, webhook)
    webhooks.delete(request_credentials, webhook_id)


### Verification

Verify callback requests with the request params:

    LucidShopify::Verify::Callback.new.(params_hash).success?

Verify webhook requests with the request data and the HMAC header:

    LucidShopify::Verify::Webhook.new.(data, hmac).success?


### Authorization

_TODO_


### Make an API request

_TODO_
