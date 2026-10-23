# Top App Store complaints (Albertsons: Grocery & Deals, id 542751329)

Source: App Store customer-review RSS feed (`itunes.apple.com/us/rss/customerreviews/page=N/id=542751329/sortby=mostrecent/json`), 500 most recent US reviews pulled 2026-10-23. 136 were 1- or 2-star.

Themes were counted by keyword match over the 1/2-star reviews. Service complaints (delivery drivers, pickup, substitutions, store pricing) were excluded because they can't be fixed in the app itself. The three app-fixable themes below are reproduced as deliberate defects in this repo.

## 1. Coupon clipping is tedious (25 reviews)

No "Clip All" button, and clipped state is unreliable.

- (1★) **App doesn't work correctly anymore** — "Missing clip all button and makes you press it 700 times"
- (1★) **This application sucks!** — "Load times unbearable too much pop up BS slowing its performance. And no simple one button add all deals and coupons feature."
- (1★) **Glitchy** — "It freezes, glitches, and crashes far more often than it should, especially when I'm trying to clip coupons before checking out. Having to restart the app multiple times just to save a few dollars is frustrating."
- (1★) **Current update** — "Clipping the digital deals is now a confusing chore. It used to be easy to do and very concise."
- (2★) **Digital pain** — "Why do we have to search and clip coupons?"
- (1★) **Clipping coupons doesn't work** — "Clipped coupons don't apply when I use my phone number at check out."

In this repo: `DealsView` has a per-coupon Clip button only, and `CouponRow` keeps `clipped` in local `@State`, so the state is lost when the row is recycled or the tab is left.

## 2. Search is broken (19 reviews)

Search hangs or spins forever, and when it does return it matches far too much.

- (1★) **Search function doesn't work after 2026.27.0 update.** — "I won't even shop at Albertsons anymore if I can't search for items in the search bar. Search is not working in the 2026.28.0 version either."
- (2★) **One of the glitchy of apps** — "Search doesn't work it just spins…"
- (1★) **App is broken** — "The search for a specific item hangs up all the time."
- (1★) **Constantly crashes when you search** — "Constantly crashes when you search for specific items in the search bar."
- (1★) **Search function useless** — "When you type a word to search, it used to have to be in the name of the product. Now it is also searching the item description for any of those words. So something like fat free cheese … would give you e[verything]."
- (2★) **Clunky and SLOW** — "The search engine is horrible. Typing in key words like pork or beef or ribs…"
- (2★) **Search is broken for deals** — "No matter the item I search, deals tab always shows 0 results now"

In this repo: `SearchService.search` never returns for multi-word queries (the spinner runs forever) and matches if *any* term appears in the name or description, so "fat free cheese" returns Cheerios.

## 3. Weekly ad items aren't tappable / can't add to cart (8 reviews)

- (2★) **Weekly ad broken** — "If you click the product on the ad it will not open to add those specific items to your cart. Some links in weekly ad work but the majority of them don't."
- (2★) **No longer works right** — "I used to be able to shop straight from the ad and add items to my shopping cart from the Ad. This feature stopped working."
- (2★) **What Happened To the App???** — "Way too difficult to have to search for items you see in the ad. They no longer expand when you touch them."
- (2★) **Always issues with weekly ad** — "There are at least a few items in every weekly ad that are not set as interactive. As a result, you cannot click on them and add them to your list."
- (2★) **Not user friendly.** — "The ads hardly load and when they do, none of the products are linked. You have to manually go search for products if you want to do an online order."
- (2★) **Terrible update** — "We also lost the feature where you can click on an item in the weekly ad and it would open up all eligible products for that sale."

In this repo: only 2 of 9 `AdItem`s have a `linkedProductId`; the other tiles in `WeeklyAdView` are static and there is no way to add an ad item to the cart.
