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

    LucidShopify.webhooks << {topic: 'orders/create', fields: %w(id)}
    LucidShopify.webhooks << {topic: '...', fields: %w(...)}


### Register webhook handlers

For each webhook, register one or more handlers:

    webhooks = LucidShopify::DelegateWebhooks.default

    webhooks.register('orders/create', OrdersCreateWebhook)

See the inline method documentation for more detail.


### Call webhook handlers

_TODO_


### Create and delete webhooks

_TODO_


### Verification

_TODO_


### Authorization

_TODO_


### Make an API request

_TODO_
