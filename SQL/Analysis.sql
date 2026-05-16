SYDNEY RESTAURANT INVESTMENT ANALYSIS
Where should you open a restaurant in Sydney?
388 restaurants across 20 suburbs (March 2026)
Data sources: Google Maps API + ABS SEIFA 2021
------------------------------------------------

QUESTION 1: Which suburb has the highest average restaurant quality?

SELECT 
    suburb, 
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_restaurants
FROM restaurants_sydney_enriched
GROUP BY suburb
ORDER BY avg_rating DESC;

INSIGHT Q1:
Newtown (4.63) and Surry Hills (4.62) lead on quality,suggesting a dining culture where locals demand and reward excellence.
Coogee (4.31) sits at the bottom despite being a premium beachside suburb.
INVESTMENT ANGLE: Coogee's low avg rating signals a quality gap,the market exists (high foot traffic, affluent residents, SEIFA 1175)
but is underserved by quality dining. A well-executed restaurant could capture significant market share with less direct quality competition.

--
QUESTION 2a: Where is the highest foot traffic?
(review count as proxy for customer volume)

SELECT 
    name,
    suburb,
    review_count,
    rating,
    price_level,
    CASE 
        WHEN website != '' THEN 'Yes'
        ELSE 'No'
    END AS has_website
FROM restaurants_sydney_enriched
WHERE review_count != ''
ORDER BY CAST(review_count AS INTEGER) DESC
LIMIT 20;

INSIGHT Q2a:
Coogee Pavilion (8,043 reviews), Grounds of The City (6,141) and Elements Smokehouse (7,245) dominate volume.
CBD accounts for 4 of the top 20, driven by office workers and tourists.
INVESTMENT ANGLE: High review count = proven customer demand.
These venues validate their suburbs as active dining markets.
The question for investors is not "is there a market?" but "is the market well-served?" — which Q1 answers.

-

QUESTION 2b: Which restaurants lead on both quality AND popularity?
These are your benchmark competitors by suburb.

SELECT 
    name,
    suburb,
    CAST(review_count AS INTEGER) AS reviews,
    CAST(rating AS REAL) AS rating,
    price_level,
    CASE 
        WHEN CAST(review_count AS INTEGER) >= 1000 
         AND CAST(rating AS REAL) >= 4.5 THEN 'Star'
        WHEN CAST(review_count AS INTEGER) >= 500  
         AND CAST(rating AS REAL) >= 4.5 THEN 'Strong'
        WHEN CAST(review_count AS INTEGER) >= 1000 
         AND CAST(rating AS REAL) < 4.5  THEN 'High volume, quality gap'
        ELSE 'Regular'
    END AS restaurant_tier
FROM restaurants_sydney_enriched
WHERE CAST(review_count AS INTEGER) >= 500
ORDER BY 
    CASE restaurant_tier
        WHEN 'Star' THEN 1
        WHEN 'Strong' THEN 2
        WHEN 'High volume, quality gap' THEN 3
        ELSE 4
    END,
    rating DESC;

RESULTS Q2b:
- Star (1000+ reviews, 4.5+ rating): 54 restaurants
- Strong (500+ reviews, 4.5+ rating): 57 restaurants  
- High volume, quality gap (1000+ reviews, <4.5 rating): 43 restaurants

INSIGHT Q2b:
CBD leads in Star restaurants (8) — foot traffic drives both volume and visibility, but competition is highest here.
Surry Hills, Newtown and Potts Point punch above their weight — strong Star representation despite smaller populations,
indicating loyal local communities that actively support quality dining.

The "High volume, quality gap" tier is the most interesting for investors —
Coogee Pavilion (8,043 reviews, 4.1), Grounds of The City (6,141, 4.2),
Chin Chin (3,897, 4.1) — these venues prove the market exists 
but leave room for a quality competitor to enter and win.

INVESTMENT ANGLE:
- Surry Hills and Newtown = high competition, high quality benchmark.Strong market but you need to be excellent to survive.
- Coogee and CBD = high volume, quality gap = easier to differentiate,but higher rent and tourist dependency.

--
QUESTION 3: Does price level predict restaurant quality?
DATA QUALITY NOTE: 52.2% unknown price levels — interpret with caution.

SELECT 
    price_level,
    COUNT(*) AS total,
    ROUND(AVG(CAST(rating AS REAL)), 2) AS avg_rating,
    ROUND(AVG(CAST(review_count AS INTEGER)), 0) AS avg_reviews
FROM restaurants_sydney_enriched
GROUP BY price_level
ORDER BY avg_rating DESC;

INSIGHT Q3:
Price is NOT a reliable quality signal in Sydney.
- Ultra-premium ($$$$) scores lowest (4.38) - high expectations are harder to meet, increasing the risk of negative reviews.
- Budget ($) scores 4.47 — strong community loyalty and lower expectations create a forgiving, repeat-customer environment.
INVESTMENT ANGLE: Mid-range ($$) offers the best balance — 125 restaurants, avg 4.43, avg 1,366 reviews. 
Proven market size, manageable expectations, strong visibility.

--
QUESTION 4: Does online presence drive quality or just visibility?

SELECT 
    CASE 
        WHEN website <> '' THEN 'Has website'
        ELSE 'No website'
    END AS website_status,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(CAST(rating AS REAL)), 2) AS avg_rating,
    ROUND(AVG(CAST(review_count AS INTEGER)), 0) AS avg_reviews
FROM restaurants_sydney_enriched
WHERE CAST(review_count AS INTEGER) >= 50
GROUP BY website_status
ORDER BY avg_rating DESC;

RESULTS (50+ reviews filter):
- No website:  16 restaurants | avg rating 4.73 | avg reviews 303
- Has website: 362 restaurants | avg rating 4.52 | avg reviews 956

INSIGHT Q4:
Restaurants without a website score higher (4.73 vs 4.52) — these are quality-first operators relying on word-of-mouth.
However, restaurants WITH a website get 3x more reviews (956 vs 303),meaning online presence drives discovery and customer volume.
INVESTMENT ANGLE: Quality alone won't fill seats.
A new restaurant needs both — exceptional food AND digital visibility.

The winning formula: hidden gem quality + active online presence.

--
QUESTION 5: Does suburb wealth predict restaurant quality?

SELECT 
    s.suburb,
    s.seifa_score,
    s.region,
    ROUND(AVG(CAST(r.rating AS REAL)), 2) AS avg_rating,
    COUNT(CASE WHEN r.price_level IN ('$$$','$$$$') THEN 1 END) AS premium_count
FROM sydney_suburbs s
LEFT JOIN restaurants_sydney_enriched r ON r.suburb = s.suburb
GROUP BY s.suburb, s.seifa_score, s.region
ORDER BY s.seifa_score DESC;

INSIGHT Q5:
No correlation between suburb wealth (SEIFA) and restaurant quality.
- Erskineville (SEIFA 1185, highest) scores only 4.47 avg rating.
- Marrickville (SEIFA 1087, one of lowest) achieves 4.61 — top 3.
- Coogee (SEIFA 1175) scores lowest overall at 4.31 despite high wealth.
- INVESTMENT ANGLE: Wealthy suburbs don't guarantee restaurant success.
- Community culture, foot traffic patterns and competitive landscape
- matter more than postcode prestige.
- Diverse, community-driven suburbs (Marrickville, Newtown) 
- show stronger dining culture than affluent but transient ones (Coogee).

================================================
 FINAL INVESTMENT RECOMMENDATIONS
================================================

STRATEGY 1 — QUALITY PLAY (High risk, high reward)
- Target suburb: Newtown or Surry Hills
- Why: Highest avg ratings, loyal local base, proven dining culture
- Risk: Most competitive — you must be excellent to survive
- Best fit: Chef-driven concept, strong identity, mid-range pricing ($$-$$$)

- STRATEGY 2 — OPPORTUNITY PLAY (Lower competition, quality gap)
- Target suburb: Coogee or Randwick  
- Why: High foot traffic, affluent residents (SEIFA 1149-1175), but current restaurants underperform on quality
- Risk: Tourist dependency in Coogee, less dining culture than Inner West
- Best fit: Quality casual dining ($$), weekend-focused, beachside positioning

- STRATEGY 3 — VOLUME PLAY (Established market, high visibility)
- Target suburb: CBD Sydney
- Why: Highest review volumes, office worker lunch + tourist dinner market
- Risk: Highest rent, most competition, less community loyalty
- Best fit: Fast-casual ($-$$), lunch-focused, strong digital presence

==============================================
DATA LIMITATIONS:
- Sample capped at 20 restaurants per suburb (not exhaustive)
- 52% unknown price levels limits price segment analysis
- Data collected March 2026 via Google Maps API
- Foot traffic and rent data not included — further research recommended

