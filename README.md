# sydney-restaurants-sql
 # 🍜 Sydney Restaurant Scene — SQL Analysis

## Project Overview
Analysis of 388 restaurants across 20 Sydney suburbs to explore 
quality, popularity and socio-economic patterns in Sydney's dining scene.

**Data sources:**
- Google Maps Places API (collected March 2026)
- ABS SEIFA 2021 (Australian Bureau of Statistics)

**Tools:** SQL · SQLite · Python · DB Browser for SQLite

---

## Key Questions
1. Which suburb has the best average restaurant rating?
2. Where are the most popular restaurants — and are they the best?
3. Does price level predict quality?
4. Do restaurants with a website get better ratings?
5. Is there a correlation between suburb wealth and restaurant quality?

---

## Key Findings
- **Newtown and Surry Hills** lead on quality despite not being the wealthiest suburbs
- **High reviews ≠ high quality** — Coogee Pavilion (8,043 reviews) scores only 4.1
- **Price doesn't predict quality** — ultra-premium ($$$$) restaurants score lowest
- **No website = hidden gem** — better rated (4.73 vs 4.52) but 3x less visible
- **Wealth doesn't predict quality** — Marrickville (lower SEIFA) outperforms Coogee (higher SEIFA)

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
