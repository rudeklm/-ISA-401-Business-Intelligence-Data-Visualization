# Midwest Airbnb Listings: Data Dictionary

**Dataset:** `listings` table in `midwest_airbnb.db` (SQLite), 14,887 rows and 29 columns
**Source:** Inside Airbnb (https://insideairbnb.com/get-the-data/), the detailed `listings.csv.gz` file for each of three regions: Chicago (snapshot 2026-07-20), Columbus (snapshot 2026-07-23), and Twin Cities MSA (snapshot 2026-07-21). Column meanings follow Inside Airbnb's data dictionary and assumptions (https://insideairbnb.com/data-assumptions/).
**Course:** ISA 401, Miami University

> One row is one listing that showed a nightly price on the snapshot date; listings with no price were dropped. Empty cells are stored as SQL `NULL`.

---

## Field Definitions

| Field | Type | Description |
|---|---|---|
| `city` | text | Which Inside Airbnb region the listing came from: `Chicago` (7,439 rows), `Columbus` (2,587), or `Twin Cities` (4,861). The Twin Cities file covers the Minneapolis-St. Paul metro area, not just the two cities. |
| `snapshot_date` | text | Date Inside Airbnb compiled the file, stored as an ISO text string, not a date: `2026-07-20` for Chicago, `2026-07-23` for Columbus, `2026-07-21` for Twin Cities. Every row of a city shares the same value. |
| `id` | text | Airbnb's listing id. Unique across the table (14,887 distinct values). Stored as text even though it looks numeric, so compare it to a quoted string. |
| `name` | text | Listing title as shown on Airbnb (for example "Tiny Studio Apartment 94 Walk Score"). Never empty. |
| `price` | real | Nightly price in U.S. dollars on the snapshot date, with the dollar sign and commas removed. Ranges from 2.56 to 11,412; never `NULL` (rows without a price were dropped). |
| `room_type` | text | Airbnb's four listing categories: `Entire home/apt` (11,652 rows), `Private room` (2,951), `Hotel room` (246), or `Shared room` (38). |
| `host_id` | text | Airbnb's unique identifier for the host. One host can own many listings, so count or group hosts by this column, not by `host_name`. Stored as text even though it looks numeric, so compare it to a quoted string. |
| `host_name` | text | Name of the host, usually just the first name(s) (for example "Rebecca") or a business name (for example "Evolve"). Not unique: many different hosts share a name. |
| `host_since` | text | Date the host's account was created; for hosts who started as Airbnb guests, this can be the date they registered as a guest. Empty (`NULL`) for every row in this extract, so it cannot be used. |
| `host_is_superhost` | text | Whether the host holds Airbnb's Superhost badge: `t` = true, `f` = false, `NULL` = unknown. |
| `neighbourhood` | text | Inside Airbnb's `neighbourhood_cleansed` column: the neighbourhood found by matching the listing's latitude and longitude against official public neighbourhood boundary files (for example `Hyde Park`, `West Town`, or `Lincoln Park` in Chicago). Names repeat only within a city, so filter by `city` too. |
| `latitude` | real | Latitude in the WGS84 system. Airbnb shifts each location slightly for privacy, so it is approximate. Columbus listings sit near 40, Chicago near 42, and the Twin Cities near 45. |
| `longitude` | real | Longitude in the WGS84 system, approximate for the same reason. Columbus listings sit near -83, Chicago near -87.7, and the Twin Cities near -93.3. |
| `property_type` | text | Property type the host selected themselves; hotels and bed and breakfasts are described as such by their hosts here (for example `Entire rental unit`, `Entire home`, or `Private room in condo`). More detailed than `room_type`. |
| `accommodates` | integer | Maximum number of guests the listing can hold (for example 1, 4, or 10). A question about "sleeps N" or "a party of N" means `accommodates >= N`. |
| `bedrooms` | real | Number of bedrooms. Can be `NULL`, often for studios and private rooms. |
| `beds` | real | Number of beds. Can be `NULL`. |
| `bathrooms_text` | text | Number of bathrooms as Airbnb now shows it, as a text description rather than a number: `1 bath`, `1 shared bath`, `1 private bath`, `2.5 baths`. It cannot be summed or averaged without pulling the number out. |
| `minimum_nights` | integer | Minimum number of nights a guest must stay (the calendar's rules for specific dates may differ). Values of 30 or more (for example 32) mark monthly rentals rather than short stays. |
| `availability_365` | integer | Number of nights in the next 365 days that the calendar shows as available, from 0 to 365. A night can be unavailable because a guest booked it or because the host blocked it, so a low value does not always mean high demand. |
| `number_of_reviews` | integer | Total number of reviews the listing has received (for example 22 or 630). |
| `number_of_reviews_ltm` | integer | Number of reviews the listing received in the last 12 months (ltm) before the snapshot date. |
| `first_review` | text | Date of the first (oldest) review, stored as ISO text (`YYYY-MM-DD`). `NULL` if the listing has no reviews. |
| `last_review` | text | Date of the last (newest) review, stored as ISO text (`YYYY-MM-DD`). `NULL` if the listing has no reviews. |
| `review_scores_rating` | real | Average overall guest rating on a 0 to 5 scale; most listings fall between 4.5 and 5. `NULL` when the listing has no reviews. |
| `reviews_per_month` | real | Average reviews per month over the listing's life, calculated by Inside Airbnb as `number_of_reviews` divided by the months since `first_review` (or just `number_of_reviews` if the first review was within 30 days). A rough measure of demand; `NULL` when there are no reviews. |
| `instant_bookable` | text | Whether a guest can book without the host having to accept the request (`t` = true, `f` = false); Inside Airbnb notes this is an indicator of a commercial listing. Empty (`NULL`) for every row in this extract, so it cannot be used. |
| `estimated_revenue_l365d` | real | Inside Airbnb's estimate of the listing's revenue over the last 365 days (l365d), in U.S. dollars: its estimated booked nights in that period times its price. `0` means no estimated bookings. |
| `amenities_count` | integer | Not an Inside Airbnb column: computed for this course as the number of items in each listing's `amenities` list (for example 27, 41, or 77). |
