---
title: "{{ replace .Name "-" " " | title }}"
# description: "Description" # If this is set, it is preferred to the summary in the <meta name="description" tag>
summary: "Summary" # The summary is displayed in the posts overview only
draft: true
date: {{ .Date }}
# creationDate: {{ .Date }}
# weight: 1
# tags: ["tag"] # Google does not use these
# showToc: true
# tocOpen: false
# hidemeta: true
# hidesummary: true
# searchHidden: true
images:
    - "/img/1/twitter-card.png"
cover:
    image: "/img/1/twitter-card.png"
---

