#!/usr/bin/env python

"""

"""

from pandocfilters import toJSONFilter, Str
import re

abbreviations = {
    "jub"   : "Jubilees",
    "ga"    : "Genesis Apocryphon",
    "ant"   : "Jewish Antiquities",
    "lab"   : "Liber antiquitatum biblicarum"
}

def expand(key, value, format, meta):
  if key == 'Str' and ('$' in value):
    m = re.compile('.*\$(\w+)')

    return Str(m.match(value).group(1) + "MATCH")

if __name__ == "__main__":
  toJSONFilter(expand)