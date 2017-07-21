#!/usr/bin/env python

"""

"""

from pandocfilters import toJSONFilter, Str, Emph
import re
import json

with open('text-expand.json', encoding='utf-8') as data_file:
    data = json.loads(data_file.read())

abbreviations = data["default"]
abbr_emph = data["emph"]

def expand(key, value, _format, _meta):
    if key == 'Str' and ('~' in value):
        r = re.compile('(.*)\~([\w|-]+)(.*)')
        m = r.match(value)

        if m.group(2) in abbr_emph:
            return [Str(m.group(1)), Emph([Str(abbr_emph[m.group(2)])]), Str(m.group(3))]
        elif m.group(2) in abbreviations:
            return [Str(m.group(1)), Str(abbreviations[m.group(2)]), Str(m.group(3))]
        else:
            None

if __name__ == "__main__":
    toJSONFilter(expand)