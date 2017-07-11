import glob, os, re
from bs4 import BeautifulSoup

notes = []
num = re.compile('dissertation(.*)\.html')
for f in glob.glob("*.html"):
    if num.match(f):
        note_num = num.match(f).group(1)

        with open(f, 'r') as note_file:
            file_content = note_file.read().replace('\n', '')
            # print(file_content)
        html = BeautifulSoup(file_content, "lxml")
        fn = html.findAll("div", { "class" : "footnote-text" })
        notes.append({"n": int(note_num), "f":fn })

notes.sort(key=lambda note: note["n"])

for note in notes:
    print(note["f"][0])