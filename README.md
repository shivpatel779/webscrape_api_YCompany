
# README

## API Endpoint

### Scrape Companies

#### Endpoint
`{{url}}/companies/scrape`

#### Method
`POST`

#### JSON Body
```json
{   
    "records": 10,
    "filters": {
        "batch": "W21",           // Filter by YC batch (season)
        "industry": "Healthcare"  // Filter by industry
        // "industry": "B2B",       // Uncomment to filter by B2B industry
        // "region": "Canada",      // Uncomment to filter by region
        // "tags": "B2B",           // Uncomment to filter by tags
        // "team_size": "1-10",     // Uncomment to filter by team size
        // "highlight_women": true, // Highlight companies with women founders
        // "highlight_latinx": true,// Uncomment to highlight Latinx founders
        // "highlight_black": true, // Uncomment to highlight Black founders
        // "top_company": true,     // Uncomment to filter for top companies
        // "isHiring": true,        // Uncomment to filter for companies hiring
        // "nonprofit": true,       // Uncomment to filter for non-profit companies
        // "app_video_public": true,// Uncomment to filter for companies with public app videos
        // "demo_day_video_public": true, // Uncomment to filter for companies with public demo day videos
        // "app_answers": true      // Uncomment to filter for companies with app answers
   }
}
```

### Filters Description

- **batch**: Filter by YC batch (season) (e.g., "W21" for Winter 2021).
- **industry**: Filter by industry (e.g., "Healthcare").
- **region**: Filter by region (e.g., "Canada").
- **tags**: Filter by specific tags (e.g., "B2B").
- **team_size**: Filter by team size (e.g., "1-10").
- **highlight_women**: Highlight companies with women founders.
- **highlight_latinx**: Highlight companies with Latinx founders.
- **highlight_black**: Highlight companies with Black founders.
- **top_company**: Filter for top companies.
- **isHiring**: Filter for companies currently hiring.
- **nonprofit**: Filter for non-profit companies.
- **app_video_public**: Filter for companies with public app videos.
- **demo_day_video_public**: Filter for companies with public demo day videos.
- **app_answers**: Filter for companies with app answers.

### Example Request

```json
{   
    "records": 10,
    "filters": {
        "batch": "W21",
        "industry": "Healthcare"
    }
}
```

### Example Response

```json
{
    "download_csv_url": "http://localhost:3000/company_details_1721298805.csv",
    "company_details": [
        {
            "name": "Reshape Biotech",
            "location": "Copenhagen, Denmark",
            "short_description": "Robots that automate the everyday tasks of microbiologists.",
            "yc_batch": "W21",
            "company_url": "http://reshapebiotech.com/",
            "founders": [
                {
                    "name": "Carl-Emil Grøn Christensen",
                    "linked_in_url": "https://www.linkedin.com/in/carlemilg/"
                },
                {
                    "name": "Magnus Nyborg Madsen",
                    "linked_in_url": "https://www.linkedin.com/in/magnusnm/"
                },
                {
                    "name": "Daniel Storgaard",
                    "linked_in_url": "https://linkedin.com/in/danielstor"
                }
            ]
        },
        {
            "name": "PipeBio",
            "location": "Aarhus, Denmark",
            "short_description": "PipeBio is a SaaS bioinformatics platform to develop antibody drugs.",
            "yc_batch": "W21",
            "company_url": "https://pipebio.com",
            "founders": [
                {
                    "name": "Owen Bodley",
                    "linked_in_url": "https://www.linkedin.com/in/owen-bodley/"
                },
                {
                    "name": "Jannick Bendtsen",
                    "linked_in_url": "https://www.linkedin.com/in/jannickbendtsen/"
                }
            ]
        }
    ],
    "status": 200
}
```

### Notes
- The `records` parameter specifies the number of records to retrieve.
- Uncomment the desired filters to apply them to your request. Only filters that are uncommented will be applied.