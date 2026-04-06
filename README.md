# sydney-restaurants-sql
 # 🍜  Sydney Restaurant Investment Analysis | SQL Case Study
 
## 📊 Interactive Dashboard
🔗 [View on Tableau Public](https://public.tableau.com/app/profile/celia.breteau/viz/DashboardSydneyRestaurantInvestment/DashboardinvestmentrestaurantsSydney)

## The Question
You have $500,000 and you want to open a restaurant in Sydney.
Where do you go? Bondi for the beach crowd? CBD for the foot traffic? 
Manly for the tourists?

I analysed 388 restaurants across 20 Sydney suburbs to find out.

---

## What I Did
- Collected 388 restaurants via Google Maps Places API (Python scripting)
- Enriched data with opening hours, price levels and online presence
- Crossed with ABS SEIFA 2021 demographic data (suburb wealth index)
- Analysed 5 business questions using SQL
- Built an interactive Tableau dashboard for investment scenario planning

**Tools:** Python · SQL · SQLite · Tableau Public · Google Maps API · ABS Open Data

---

## What I Found

### 1. Wealth doesn't predict quality
Marrickville (SEIFA 1087, least wealthy in sample) scores higher (4.61) 
than Coogee (SEIFA 1175, most wealthy, 4.31).
Community dining culture matters more than postcode prestige.

### 2. High volume = market exists, not market served
Coogee Pavilion (8,043 reviews, 4.1 rating) and Grounds of The City 
(6,141 reviews, 4.2) prove the market exists — but leave a clear 
quality gap for a serious competitor to exploit.
High reviews + low rating = investment opportunity, not a warning sign.

### 3. The hidden gem paradox
Restaurants without a website score higher (4.73 vs 4.52) but get 
3x fewer reviews. Quality alone doesn't fill seats.
The winning formula: exceptional food + active digital presence.

### 4. Price doesn't predict quality
Ultra-premium ($$$$) scores lowest (4.38). Budget ($) scores 4.47.
High prices raise expectations — and expectations are harder to meet.

### 5. No correlation between suburb wealth and restaurant quality
The best food is in diverse, community-driven suburbs.
Not in the most expensive postcodes.

---

## Investment Recommendations

**Strategy 1 — Quality play**
Newtown or Surry Hills. Highest ratings, loyal locals, proven dining 
culture. High competition — you must be excellent to survive.

**Strategy 2 — Opportunity play**
Coogee or Randwick. Affluent residents, high foot traffic, 
but current restaurants underperform on quality. 
Easier to differentiate, stronger upside potential.

**Strategy 3 — Volume play**
CBD Sydney. Maximum foot traffic, office workers + tourists.
Highest rent and competition — best suited to fast-casual concepts.

---

## Dataset Limitations
- Sample capped at 20 restaurants per suburb — not exhaustive
- 52% unknown price levels limits price segment analysis
- Data reflects March 2026 snapshot only
- Foot traffic and rent data not included — further research recommended

---

## Files
- `analysis.sql` — 5 business questions with SQL queries and investment insights
- `restaurants_sydney_enriched.csv` — original dataset (388 restaurants)
- `sydney_restaurants_final.csv` — enriched dataset with target audience, weekend status and price score (used for Tableau dashboard)
- `sydney_suburbs.csv` — suburb demographics (ABS SEIFA 2021)
- `collect_sydney_restaurants.py` — data collection script
- `enrich_restaurants.py` — data enrichment script
