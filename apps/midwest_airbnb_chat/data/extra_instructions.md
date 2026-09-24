# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

- `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.
- `host_is_superhost` and `instant_bookable` are text columns holding `'t'` (true) or `'f'` (false), not booleans. Filter with `host_is_superhost = 't'`, never `= 1` or `= TRUE`. Leave out rows where the column is NULL, and label the groups "Superhost" / "Not superhost" (or "Instant book" / "Request to book") in tables and charts.
- `city` holds exactly three values: `'Chicago'`, `'Columbus'`, and `'Twin Cities'`. Map what the user types to one of them: Minneapolis, St. Paul, Saint Paul, MSP, or Minnesota means `'Twin Cities'`; Columbus, Ohio or OH means `'Columbus'`; Chicago, Chi-town, or Illinois means `'Chicago'`
- When a question is about hosts, count and group by `host_id`, not `host_name`, because different hosts share the same name.
- Read "sleeps N", "a party of N", or "a group of N" as `accommodates >= N`.
