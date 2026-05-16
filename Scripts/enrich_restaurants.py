import requests
import csv
import time

API_KEY = "cle_api"

INPUT_FILE  = "/Users/celiabreteau/Downloads/restaurants_sydney.csv"
OUTPUT_FILE = "/Users/celiabreteau/Downloads/restaurants_sydney_enriched.csv"

DETAILS_URL = "https://maps.googleapis.com/maps/api/place/details/json"

FIELDS = [
    "name", "formatted_address", "formatted_phone_number", "website",
    "rating", "user_ratings_total", "price_level",
    "opening_hours", "types", "vicinity"
]

PRICE_MAP = {1: "$", 2: "$$", 3: "$$$", 4: "$$$$"}

DAY_NAMES = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

def get_details(place_id):
    params = {
        "place_id": place_id,
        "fields": ",".join(FIELDS),
        "key": API_KEY,
    }
    r = requests.get(DETAILS_URL, params=params).json()
    if r.get("status") != "OK":
        return None
    return r.get("result", {})

def parse_hours(opening_hours):
    if not opening_hours:
        return {day: "" for day in DAY_NAMES}
    periods = opening_hours.get("weekday_text", [])
    hours = {}
    for i, day in enumerate(DAY_NAMES):
        if i < len(periods):
            # "Monday: 9:00 AM – 10:00 PM" → "9:00 AM – 10:00 PM"
            parts = periods[i].split(": ", 1)
            hours[day] = parts[1] if len(parts) > 1 else ""
        else:
            hours[day] = ""
    return hours

def main():
    with open(INPUT_FILE, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    enriched = []
    seen_ids = set()

    for i, row in enumerate(rows):
        place_id = row.get("place_id", "").strip()
        if not place_id or place_id in seen_ids:
            continue
        seen_ids.add(place_id)

        print(f"[{i+1}/{len(rows)}] {row.get('name', '')}...")

        details = get_details(place_id)
        if not details:
            print(f"  Skipped (no details)")
            continue

        hours = parse_hours(details.get("opening_hours"))
        types = details.get("types", [])
        cuisine = ", ".join([t for t in types if t not in (
            "restaurant","food","point_of_interest","establishment"
        )])

        enriched.append({
            "name":          details.get("name", row.get("name","")),
            "suburb":        row.get("suburb",""),
            "address":       details.get("formatted_address", ""),
            "neighborhood":  details.get("vicinity",""),
            "phone":         details.get("formatted_phone_number",""),
            "website":       details.get("website",""),
            "rating":        details.get("rating",""),
            "review_count":  details.get("user_ratings_total",""),
            "price_level":   PRICE_MAP.get(details.get("price_level"), "unknown"),
            "cuisine":       cuisine,
            "monday":        hours["Monday"],
            "tuesday":       hours["Tuesday"],
            "wednesday":     hours["Wednesday"],
            "thursday":      hours["Thursday"],
            "friday":        hours["Friday"],
            "saturday":      hours["Saturday"],
            "sunday":        hours["Sunday"],
            "place_id":      place_id,
        })

        time.sleep(0.1)

    fieldnames = [
        "name","suburb","address","neighborhood","phone","website",
        "rating","review_count","price_level","cuisine",
        "monday","tuesday","wednesday","thursday","friday","saturday","sunday",
        "place_id"
    ]

    with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(enriched)

    print(f"\nTerminé ! {len(enriched)} restaurants enrichis → '{OUTPUT_FILE}'")

if __name__ == "__main__":
    main()
