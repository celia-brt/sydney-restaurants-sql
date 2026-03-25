import requests
import csv
import time
import os

API_KEY = "Cle API"

SUBURBS = [
    "Surry Hills", "Newtown", "Glebe", "Darlinghurst", "Paddington",
    "Bondi", "Manly", "Balmain", "Leichhardt", "Chippendale",
    "Redfern", "Erskineville", "Marrickville", "CBD Sydney",
    "Pyrmont", "Ultimo", "Potts Point", "Kings Cross", "Coogee", "Randwick"
]

BASE_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json"

PRICE_MAP = {1: "$", 2: "$$", 3: "$$$", 4: "$$$$"}

def fetch_restaurants(suburb):
    restaurants = []
    params = {
        "query": f"restaurants in {suburb} Sydney",
        "type": "restaurant",
        "key": API_KEY,
    }

    while True:
        response = requests.get(BASE_URL, params=params)
        data = response.json()

        if data.get("status") not in ("OK", "ZERO_RESULTS"):
            print(f"  Erreur API pour {suburb}: {data.get('status')}")
            break

        for place in data.get("results", []):
            restaurants.append({
                "name":         place.get("name", ""),
                "suburb":       suburb,
                "address":      place.get("formatted_address", ""),
                "rating":       place.get("rating", None),
                "review_count": place.get("user_ratings_total", None),
                "price_level":  PRICE_MAP.get(place.get("price_level"), "unknown"),
                "cuisine_types": ", ".join(place.get("types", [])),
                "open_now":     place.get("opening_hours", {}).get("open_now", None),
                "place_id":     place.get("place_id", ""),
            })

        next_page_token = data.get("next_page_token")
        if not next_page_token:
            break

        time.sleep(2)
        params = {"pagetoken": next_page_token, "key": API_KEY}

    return restaurants


def main():
    all_restaurants = []
    seen_ids = set()

    for suburb in SUBURBS:
        print(f"Collecte : {suburb}...")
        results = fetch_restaurants(suburb)

        for r in results:
            if r["place_id"] not in seen_ids:
                seen_ids.add(r["place_id"])
                all_restaurants.append(r)

        print(f"  {len(results)} trouvés ({len(all_restaurants)} total unique)")
        time.sleep(1)

    output_file = "restaurants_sydney.csv"
    fieldnames = ["name", "suburb", "address", "rating", "review_count",
                  "price_level", "cuisine_types", "open_now", "place_id"]

    with open(output_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(all_restaurants)

    print(f"\nTerminé ! {len(all_restaurants)} restaurants uniques sauvegardés dans '{output_file}'")


if __name__ == "__main__":
    main()
