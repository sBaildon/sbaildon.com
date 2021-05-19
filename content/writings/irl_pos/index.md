---
draft: true
---

# In Person payments with iOS Shortcuts, Stripe, and Serverless Functions

What do you do if you need to take card payments in person, but don’t have a point of sale?

You build one.

[video]

My partners and I are the business of delivering [choripanes](https://choripan.delivery) from our grill to your door—but for one weekend, we wanted to take them directly to the people.

We checked the forecast and spotted—due in 5 days, on a Saturday—the first predicted sunny day in a while. This would also be the first weekend Londoners could have social gatherings outside since the third lockdown. Perfect alignment!

Our kitchen is online only so we’ve never had a reason to own a physical PoS. We thought about ordering one for the weekend, but it looked unlikely that we’d receive any in time.

Instead, we pieced together a solution using the tools already in our toolbox: Stripe, Cloudflare, and our iPhones.

## Laying the foundations with Stripe

Our checkout is optimised for our online order flow, it wasn’t going to be useful to us in the physical world. Instead of hacking changes onto what existed, I opted to use [Stripe Checkout](https://stripe.com/docs/payments/checkout) to relieve the burden of creating a throwaway experience. For those not in the know:

> Checkout creates a secure, Stripe-hosted payment page that lets you collect payments quickly. It works across devices and can help increase your conversion
> — <cite>https://stripe.com/docs/payments/checkout</cite>

Integrating Checkout is a little easier if used alongside Stripe's [Prices API](https://stripe.com/docs/api/prices).

The only thing required at this step is open Stripe's [dashboard](https://dashboard.stripe.com) and create a new product and set a price. The price ID will be used later when creating the checkout session.

![Stripe Dashboard](media/stripe_dashboard.png)

## Tool two: Serverless Functions

Checkout requires the customer to be redirected via client-side javascript call to the `redirectToCheckout` method. That means we can't just generate a URL on our phones; we have to direct the customer to an intermediary webpage that will perform the redirect.

Rather than add another route to our application's router, hook up a redirect page, cut a release, and deploy to our servers, I decided to use our first serverless function.

Cloudflare already host our DNS—using their serverless function service, [workers](https://blog.cloudflare.com/cloudflare-workers-unleashed/), made sense for us.

The worker is that renders a lone `<script>` element. Its function is to pull a checkout ID from the query parameters and perorm `redirectToCheckout`

### Create a Worker project

[Wrangler](https://github.com/cloudflare/wrangler) makes using workers simple. Install it and follow along.

Create a workers project

```wrangler init```

### Configuration

The worker will need to know your:

* Cloudflare account ID
* Cloudflare zone ID
* Stripe API key

Set up your environment to reference your stripe API keys

```toml
# wrangler.toml
name = "checkout-session-dev"
type = "javascript"
account_id = "cloudflare_account_id"
workers_dev = true
route = ""
zone_id = "cloudflare_zone_id"
usage_model = ""
vars = { STRIPE_API_KEY = "pk_test_abcxyz..." }

[env.prod]
name = "checkout-session"
vars = { STRIPE_API_KEY = "pk_live_abcxyz..." }
```

### The Worker itself

```javascript
// index.js
function html(session_id) {
  return `<!DOCTYPE html>
  <body>
    <h1>Redirecting!</h1>
    <p>This shouldn't take long...</p>
    <script src="https://js.stripe.com/v3/"></script>
    <script>
        var stripe = Stripe("${STRIPE_API_KEY}");
        stripe.redirectToCheckout({ sessionId: "${session_id}" });
    </script>
  </body>`
}

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Respond with hello worker text
 * @param {Request} request
 */
async function handleRequest(request) {
  const { searchParams } = new URL(request.url)
  const session_id = searchParams.get('session_id')

  return new Response(html(session_id), {
    headers: {
      "content-type": "text/html;charset=UTF-8",
    },
  })
}
```

## Tool three: iOS Shortcuts

iOS isn’t known for its developer power tools, but at least its had Shortcuts (by default) since iOS 13.

We need a Stripe secret key for API requests, the Price ID for what we want to sell, and the Serverless function URL for redirects. Stick them all in a dictionary:

[img]



Shortcuts

[Get the shortcut](https://www.icloud.com/shortcuts/411cf26e37ea477da8d81be32f0a1ac6)
