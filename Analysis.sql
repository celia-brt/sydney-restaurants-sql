-- ================================================
-- SYDNEY RESTAURANT SCENE ANALYSIS
-- Exploring quality, density and socio-economic patterns
-- across 20 Sydney suburbs (388 restaurants, March 2026)
-- Data sources: Google Maps API + ABS SEIFA 2021
-- ================================================

-- QUESTION 1: Which suburb has the best average rating?
-- Business insight: identifies the areas where restaurant quality is highest

SELECT 
    suburb, 
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_restaurants
FROM restaurants_sydney_enriched
GROUP BY suburb
ORDER BY avg_rating DESC;

-- INSIGHT: Newtown (4.63) and Surry Hills (4.62) lead on quality
-- Coogee (4.31) is a clear outlier — lower quality despite being a 
-- desirable beach suburb. Potential gap for a quality restaurant?

-- QUESTION 2a: Where are the most reviewed restaurants? 
-- (proxy for popularity/foot traffic)

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
-- INSIGHT Q2: High review count ≠ high quality
-- Coogee Pavilion leads in volume (8,043 reviews) but scores only 4.1
-- likely driven by tourist traffic and events rather than food quality.
-- The real sweet spot: restaurants with both high reviews AND high ratings
-- Elements Smokehouse (7,245 reviews, 4.7) and Primi Italian (3,936, 4.7)
-- represent the best combination of visibility and quality.
-- CBD dominates in volume (4 restaurants in top 20) but not in quality.

-- QUESTION 2b: Which restaurants combine high popularity AND high quality?
-- Business angle: these are the benchmark competitors —
-- if you open a restaurant in their suburb, these are who you compete against.
-- They also validate which suburbs have a proven market for quality dining.

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
         AND CAST(rating AS REAL) < 4.5  THEN 'Popular but average'
        ELSE 'Regular'
    END AS restaurant_tier
FROM restaurants_sydney_enriched
WHERE CAST(review_count AS INTEGER) >= 500
ORDER BY 
    CASE restaurant_tier
        WHEN 'Star' THEN 1
        WHEN 'Strong' THEN 2
        WHEN 'Popular but average' THEN 3
        ELSE 4
    END,
    rating DESC;

-- RESULTS Q2b: Restaurant tiers based on popularity + quality
-- Star (1000+ reviews, 4.5+ rating): 54 restaurants
-- Strong (500+ reviews, 4.5+ rating): 57 restaurants  
-- Popular but average (1000+ reviews, <4.5 rating): 43 restaurants
-- Regular: remaining restaurants

-- INSIGHT Q2b:
-- CBD Sydney dominates the "Star" category with 8 restaurants —
-- high foot traffic drives both volume and visibility.
-- However Surry Hills, Newtown and Potts Point punch above their weight —
-- smaller suburbs but strong representation in Star and Strong tiers,
-- suggesting a loyal local clientele rather than tourist-driven traffic.
-- 
-- Italian cuisine appears repeatedly across all tiers and suburbs,
-- confirming it as Sydney's most competitive restaurant category.
--
-- Interesting outlier: Coogee Pavilion (8,043 reviews) and 
-- Grounds of The City (6,141 reviews) land in "Popular but average" —
-- proof that marketing and location drive volume more than quality.
--
-- KEY TAKEAWAY: 
-- If opening a restaurant, Surry Hills and Newtown offer the best balance —
-- strong quality benchmark AND proven local demand outside the CBD.


-- QUESTION 3: What price segment dominates each suburb?
-- DATA QUALITY NOTE - Price Level:
-- 52.2% of restaurants have unknown price level
-- This is a limitation of the Google Maps API —
-- many restaurants don't submit their price range.
-- Results for Q3 should be interpreted with caution.

SELECT 
    price_level,
    COUNT(*) AS total,
    ROUND(AVG(CAST(rating AS REAL)), 2) AS avg_rating,
    ROUND(AVG(CAST(review_count AS INTEGER)), 0) AS avg_reviews
FROM restaurants_sydney_enriched
GROUP BY price_level
ORDER BY avg_rating DESC;

-- INSIGHT Q3 — Price vs Quality:
-- Counter-intuitive finding: unknown price restaurants score highest (4.61)
-- consistent with Q4 finding that less visible restaurants are often better quality.
-- Premium restaurants ($$$) generate the most reviews (1728 avg)
-- suggesting price drives curiosity and engagement.
-- Ultra-premium ($$$$) score lowest (4.38) — possibly due to 
-- higher customer expectations not being met.
-- KEY TAKEAWAY: price level is not a reliable predictor of quality in Sydney.

-- QUESTION 4: Do restaurants with a website get better ratings?
-- Hypothesis: having a website = more professional = better quality

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

-- RESULTS (50+ reviews filter):
-- No website:  16 restaurants | avg rating 4.73 | avg reviews 303
-- Has website: 362 restaurants | avg rating 4.52 | avg reviews 956

-- INSIGHT: Hypothesis is FALSE.
-- Restaurants without a website score higher (4.73 vs 4.52) even after
-- filtering out low-review restaurants to avoid fake review bias.
-- These 16 restaurants are likely genuine hidden gems relying on 
-- word-of-mouth rather than online presence.
-- However: restaurants WITH a website get 3x more reviews (956 vs 303)
-- suggesting online presence drives visibility, not quality.


-- RESULTS Q6: SEIFA score vs average restaurant rating

SELECT 
    s.suburb,
    s.seifa_score,
    s.region,
    ROUND(AVG(CAST(r.rating AS REAL)), 2) AS avg_rating,
    COUNT(CASE WHEN r.price_level = '$$$' 
               OR r.price_level = '$$$$' THEN 1 END) AS premium_restaurants
FROM sydney_suburbs s
LEFT JOIN restaurants_sydney_enriched r ON r.suburb = s.suburb
GROUP BY s.suburb, s.seifa_score, s.region
ORDER BY s.seifa_score DESC;

-- INSIGHT Q6:
-- No clear correlation between suburb wealth and restaurant quality.
-- Wealthier suburbs (Erskineville 1185, Coogee 1175) do NOT 
-- systematically score higher than less wealthy ones.
-- Most surprisingly: Marrickville (SEIFA 1087, one of the lowest) 
-- achieves one of the highest ratings (4.61).
-- Coogee is the biggest outlier — highest wealth area but lowest rating (4.31)
-- possibly explained by tourist-driven, high-volume venues prioritising 
-- location over food quality.
--
-- KEY TAKEAWAY: In Sydney, restaurant quality is driven by 
-- chef culture and local community, not suburb wealth.
-- The best food is often found in less affluent, more diverse suburbs.

-- ================================================
-- FINAL CONCLUSIONS
-- Sydney Restaurant Scene Analysis — March 2026
-- ================================================

-- 1. QUALITY: Newtown and Surry Hills are Sydney's best suburbs 
--    for restaurant quality, consistently outperforming wealthier suburbs.

-- 2. POPULARITY ≠ QUALITY: High review counts don't guarantee quality.
--    Tourist-driven venues (Coogee Pavilion, Grounds of The City) 
--    prove that marketing beats food in the volume game.

-- 3. PRICE ≠ QUALITY: Ultra-premium restaurants ($$$$) score lowest (4.38).
--    The best value is found in $ and $$ segments.

-- 4. ONLINE PRESENCE: Restaurants without a website are hidden gems —
--    better rated (4.73 vs 4.52) but 3x less visible than those with one.

-- 5. WEALTH vs QUALITY: No correlation between suburb wealth (SEIFA) 
--    and restaurant quality. The best food is in diverse, 
--    community-driven suburbs — not the richest ones.

-- DATASET LIMITATIONS:
-- - Sample capped at 20 restaurants per suburb (not exhaustive)
-- - 52% unknown price levels limits price analysis
-- - Data collected March 2026 via Google Maps API
-- ================================================