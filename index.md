---
layout: default
subtitle: Information about various Apple II hardware that I've seen and decided to reverse engineer.
show_repo_link: True
---
This site and related git repository contains information about various Apple II hardware that I've
seen and decided to reverse engineer. For each piece of hardware I try to include as much information
as possible so that the hardware could be cloned if necessary, so usually:

 * Pictures of the front & back of PCBs
 * Reconstructed schematics created by tracing traces with a multimeter
 * ROM dumps
 * Any interesting manuals/datasheets

**Disclaimer:** I don't make any guarantees on accuracy of the information in this repository.
I only do this for learning & fun.

## Hardware List

{% assign sorted_pages = site.pages | where: "layout", "subpage" | sort: "title" %}
{%- for page in sorted_pages -%}
  <a class="page-link" href="{{ page.url | relative_url }}">{{ page.title | escape }}</a><br/>
{%- endfor -%}
