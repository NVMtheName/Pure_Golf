import Foundation

enum MockData {
    // Note: image URLs are public stock/placeholder images; swap with your CDN later.
    static let courses: [Course] = [
        .init(
            name: "Pebble Plains",
            city: "Monterey",
            state: "CA",
            par: 72,
            latitude: 36.567, longitude: -121.948,
            blurb: "Coastal winds and dramatic bunkering with postcard views.",
            imageURL: "https://images.unsplash.com/photo-1542343910-5f2b5ae4ca35?q=80&w=1200&auto=format&fit=crop"
        ),
        .init(
            name: "Whispering Pines",
            city: "Augusta",
            state: "GA",
            par: 72,
            latitude: 33.502, longitude: -82.020,
            blurb: "Tree‑lined fairways, slick greens, and spring azaleas.",
            imageURL: "https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=1200&auto=format&fit=crop"
        ),
        .init(
            name: "Bellagio Hill",
            city: "Bellagio",
            state: "CO",
            par: 70,
            latitude: 40.559, longitude: -105.078,
            blurb: "Mountain air, tight landing zones, and rolling greens.",
            imageURL: "https://images.unsplash.com/photo-1518602164578-cd0074062769?q=80&w=1200&auto=format&fit=crop"
        ),
        .init(
            name: "Lakeside Dunes",
            city: "Traverse City",
            state: "MI",
            par: 71,
            latitude: 44.763, longitude: -85.620,
            blurb: "Links‑style routing with sturdy fescue and lake breezes.",
            imageURL: "https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop"
        ),
        .init(
            name: "Desert Mesa",
            city: "Scottsdale",
            state: "AZ",
            par: 72,
            latitude: 33.494, longitude: -111.926,
            blurb: "Target golf across arroyos with firm, fast fairways.",
            imageURL: "https://images.unsplash.com/photo-1496545672447-f699b503d270?q=80&w=1200&auto=format&fit=crop"
        )
    ]

    static let feed: [FeedItem] = [
        .init(title: "Adam shot +2 at Bethpage", subtitle: "Windy back nine, strong finish"),
        .init(title: "Nicholas sank a 28ft putt", subtitle: "Auto‑tagged clutch putt on 18"),
        .init(title: "Course added: Casa de Campo", subtitle: "New data via ZIP search 00765")
    ]
}
