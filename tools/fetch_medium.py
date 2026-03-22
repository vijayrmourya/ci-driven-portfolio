#!/usr/bin/env python3
# tools/fetch_medium.py
import sys, json, os, feedparser
from html import unescape
from datetime import datetime

def excerpt_from_content(entry, length=200):
    if 'summary' in entry and entry['summary']:
        txt = unescape(entry['summary'])
    elif 'content' in entry and entry['content']:
        txt = unescape(entry['content'][0].value)
    else:
        txt = ''
    txt = ' '.join(txt.split())
    return (txt[:length] + '…') if len(txt) > length else txt

def main(output_path):
    username = os.getenv('MEDIUM_USERNAME', 'vjmourya').strip()
    max_posts = int(os.getenv('MAX_POSTS', '6'))
    feed_url = f'https://medium.com/feed/@{username}'
    d = feedparser.parse(feed_url)

    posts = []
    for entry in d.entries[:max_posts]:
        date = None
        if 'published_parsed' in entry and entry.published_parsed:
            date = datetime(*entry.published_parsed[:6]).isoformat()
        posts.append({
            'title': entry.get('title', 'Untitled'),
            'link': entry.get('link'),
            'date': date,
            'excerpt': excerpt_from_content(entry, length=200)
        })

    # ensure output dir exists
    os.makedirs(os.path.dirname(output_path) or '.', exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump({'source': f'https://medium.com/@{username}', 'posts': posts}, f, ensure_ascii=False, indent=2)

if __name__ == '__main__':
    out = sys.argv[1] if len(sys.argv) > 1 else 'assets/medium_posts.json'
    main(out)
