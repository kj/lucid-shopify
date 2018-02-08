lucid_shopify
=============

Installation
------------

Add the following lines to your ‘Gemfile’:

    git_source :lucid { |r| "https://github.com/lucidnz/gem-lucid_#{r}.git" }

    gem 'lucid_shopify', lucid: 'shopify'


Usage
-----

### Configure the default API credentials

    LucidShopify.credentials = LucidShopify::Credentials.new(
        '...', # api_key
        '...', # shared_secret
        '...', # scope
        '...', # billing_callback_uri
        '...'  # webhook_uri
    )

Alternatively, a credentials object may be passed as a keyword
argument to any of the classes that make use of it.


### Configure webhooks

Configure each webhook the app will create (if any):

    LucidShopify.webhooks << {topic: 'orders/create', fields: %w(id tags)}
    LucidShopify.webhooks << {topic: '...', fields: %w(...)}


### Register webhook handlers

For each webhook, register one or more handlers:

    delegate_webhooks = LucidShopify::DelegateWebhooks.default

    delegate_webhooks.register('orders/create', OrdersCreateWebhook.new)

See the inline method documentation for more detail.


### Call webhook handlers

You will likely create a worker class to wrap this.

    deletegate_webhooks = LucidShopify::DelegateWebhooks.default
    webhook = LucidShopify::Webhook.new(myshopify_domain, topic, data)

    delegate_webhooks.(webhook)


### Create and delete webhooks

Create/delete all configured webhooks (see above):

    webhooks = LucidShopify::Webhooks.new(shop_credentials)

    webhooks.create_all
    webhooks.delete_all

Create/delete webhooks manually:

    webhook = {topic: 'orders/create', fields: %w(id tags)}

    webhooks.create(webhook)
    webhooks.delete(webhook_id)


### Verification

Verify callback requests with the request params:

    LucidShopify::Verify::Callback.new.(params_hash).success?

Verify webhook requests with the request data and the HMAC header:

    LucidShopify::Verify::Webhook.new.(data, hmac).success?


### Authorization

_TODO_


### Make an API request

_TODO_
