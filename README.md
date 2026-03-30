# sydney-restaurants-sql
 # 🍜  Sydney Restaurant Investment Analysis | SQL Case Study

## The Question
You have $500,000 and you want to open a restaurant in Sydney.
Where do you go? Bondi for the beach crowd? CBD for the foot traffic? 
Manly for the tourists?

I analysed 388 restaurants across 20 Sydney suburbs to find out.

---

## What I Did
I collected real restaurant data directly from Google Maps API 
in March 2026 — ratings, review counts, price levels, opening hours 
and online presence across 20 suburbs.

I then crossed this data with ABS SEIFA 2021 socio-economic scores 
to understand whether suburb wealth predicts restaurant success.

**Tools:** Python · SQL · DB Browser for SQLite

---

## What I Found

### 1. Forget what you think you know about location

The conventional wisdom says: open where the money is.
The data says otherwise.

Marrickville — one of the least wealthy suburbs in our sample 
(SEIFA 1087) — achieves a higher average rating (4.61) than 
Coogee (SEIFA 1175, rating 4.31), one of the wealthiest.

Wealth doesn't buy good food. Community does.

### 2. Tourist traffic is a trap

Coogee Pavilion has 8,043 reviews — the most in our entire dataset.
Its rating? 4.1 out of 5.

The Grounds of The City: 6,141 reviews. Rating: 4.2.

These venues have mastered marketing and location.
But they haven't mastered food.

Meanwhile, Elements Smokehouse in Darlinghurst has 7,245 reviews 
AND a 4.7 rating. That's the real benchmark.

> High reviews ≠ high quality. But high reviews + high quality = gold.

### 3. The hidden gem paradox

52% of restaurants in our dataset have no price level listed on Google.
These "invisible" restaurants actually score highest — avg rating 4.61.

Restaurants with no website score even higher (4.73 vs 4.52) 
than those with one — but get 3x fewer reviews.

The best restaurants in Sydney are often the ones 
you've never heard of.

### 4. Price doesn't predict quality

You'd expect $$$ restaurants to outperform $ ones.
They don't.

Ultra-premium ($$$$): avg rating 4.38 — the lowest of all price segments.
Budget ($): avg rating 4.47.

High prices raise expectations. Not always the food.

---

## The Verdict

**If I were investing $500,000 in a Sydney restaurant:**

❌ Not Coogee, tourist trap, lowest avg rating (4.31)
❌ Not CBD, high volume, average quality, brutal competition  
❌ Not Bondi, strong brand, weak ratings (4.49 avg)

✅ **Newtown**, highest avg rating (4.63), proven loyal customer base,
diverse cuisine scene, lower rent than CBD
✅ **Surry Hills**, second highest rating (4.62), strong Star restaurant 
benchmark (NOUR, NOMAD), affluent locals who eat out regularly

---

## Dataset Limitations
- Sample capped at 20 restaurants per suburb
- 52% unknown price levels limits price analysis

---

## Files
- `analysis.sql` — all SQL queries with business insights
- `restaurants_sydney_enriched.csv` — main dataset (388 restaurants)
- `sydney_suburbs.csv` — suburb demographics (ABS SEIFA 2021)
- `collect_sydney_restaurants.py` — data collection script
- `enrich_restaurants.py` — data enrichment script
