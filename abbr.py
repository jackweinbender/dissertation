#!/usr/bin/env python

"""

"""

from pandocfilters import toJSONFilter, Str, Emph
import re

abbreviations = {
    "jub"     : "Jubilees",
    "ga"      : "Genesis Apocryphon",
    "ant"     : "Jewish Antiquities",
    "lab"     : "Liber antiquitatum biblicarum",
    "rwb"     : "RwB",
    "RwB"     : "Rewritten Bible",
    "rwB"     : "rewritten Bible"
}
abbr_emph = {
    "stj-full": "Scripture and Tradition in Judaism: Haggadic Studies",
    "stj"     : "Scripture and Tradition" 
}

def expand(key, value, _format, _meta):
    if key == 'Str' and ('$' in value):
        r = re.compile('(.*)\$([\w|-]+)(.*)')
        m = r.match(value)

        if abbr_emph.has_key(m.group(2)):
            return [Str(m.group(1)), Emph([Str(abbr_emph[m.group(2)])]), Str(m.group(3))]
        else:
            return [Str(m.group(1)), Str(abbreviations[m.group(2)]), Str(m.group(3))]

if __name__ == "__main__":
    toJSONFilter(expand)