---
draft: true
---

# In Person payments with iOS Shortcuts, Stripe, and Serverless Functions 

What do you do if you need to take card payments in person, but don’t have a point of sale?

You build one.

[video]

My partners and I are the business of delivering [choripanes](https://choripan.delivery) from our grill to your door—but for one weekend, we wanted to take them directly to the people. 

We checked the forecast and spotted—due in 5 days, on a Saturday—the first predicted sunny day in a while. This would also be the first weekend Londoners could have social gatherings outside since the third lockdown. Perfect alignment!

Our store runs online so we’ve never had a reason to own a physical PoS. We thought about ordering one for the weekend, but it looked unlikely that we’d receive any in time. 

Instead, we pieced together a solution using the tools we already had and in our toolbox: Stripe, Cloudflare, and our iPhones.

## Tool one: Stripe

Our checkout is optimised for our online order flow, it wasn’t going to be useful to us in the physical world. Instead of hacking changes onto what existed, I opted to use Stripe Checkout to relieve the burden of creating a throwaway checkout experience. 

* Create a product/price in stripe

## Tool two: Serverless Functions 

Ideally we would have generated the Checkout URL on our phones, but accessing Checkout requires a client side redirect via the `redirectToCheckout` method.

I could have added another route to our applications router, hooked up an blank redirect page, cut a release, and deployed to our servers, but I decided to use our first serverless function.

I wrote a simple Cloudflare worker that renders a lone `<script>` element. It’s function is to pull a checkout ID from the query parameters and perorm `redirectToCheckout`

## Tool three: iOS Shortcuts

iOS isn’t known for its developer power tools, but at least its had Shortcuts (by default) since iOS 13.

We need a Stripe secret key for API requests, the Price ID for what we want to sell, and the Serverless function URL for redirects. Stick them all in a dictionary:

[img]



Shortcuts 

[Get the shortcut](https://www.icloud.com/shortcuts/411cf26e37ea477da8d81be32f0a1ac6)

