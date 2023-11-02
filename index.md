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

{% assign page_paths = site.pages | map: "path" | sort -%}
{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
    <a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a><br/>
  {%- endif -%}
{%- endfor -%}
