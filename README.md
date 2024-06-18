## ReadWeblocFile

I need help figuring out how to read a binary webloc file with swift.   

I have 2 webloc files in the project.   
- link.webloc - is a binary webloc file
- link2.webloc is a text webloc file   


I need to read all the webloc files I have in a links folder and read the url out of each webloc file. Some webloc files are text and some are binary. I wrote a python script that does what I want, but I would like to do it in swift to cut out the step of having to use python to do this.

the python script
```python
import os
import shutil

from os import listdir
from os.path import isfile, join, expanduser
import json
from subprocess import Popen, PIPE

bookmarksPath = 'Links/'

def plist_to_dictionary(filename):
    # https://stackoverflow.com/a/12767662/710793
    "Pipe the binary plist through plutil and parse the JSON output"
    with open(filename, "rb") as f:
        content = f.read()
    args = ["plutil", "-convert", "json", "-o", "-", "--", "-"]
    p = Popen(args, stdin=PIPE, stdout=PIPE)
    out, err = p.communicate(content)
    return json.loads(out)

def get_directories(dirname):
    # https://stackoverflow.com/a/40347279/710793
    subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
    for dirname in list(subfolders):
        subfolders.extend(get_directories(dirname))
    return subfolders

def sanitizeName(file):
    badCharacters = ['(', ')', '[', ']', '⚾️']

    for badCharacter in badCharacters:
        file = file.replace(badCharacter, '')

    if 'Templatemaker' in file:
        q = file.encode('utf-8')
        if b'\xe2\x9c\x82' in q:
            q = q.replace(b'\xe2\x9c\x82', b'')
            file = q.decode('utf-8')
    return file

rootDirectories = get_directories(bookmarksPath)
directories = [*rootDirectories]

files = []
urls = []
count = 0

for directory in directories:
    onlyFiles = [f for f in listdir(directory) if isfile(join(directory, f))]

    onlyFiles.sort()
    for file in onlyFiles:     
        filePath = directory + '/' + file
        if '.webloc' in file: 
            data = ''
            file = sanitizeName(file)
            try: 
                with open(filePath) as f:
                    data = f.read()

                start = data.find('<string>') + 8
                end = data.find('</string>')
                data = data[start:end]
            except:
                try:
                    f = plist_to_dictionary(filePath)
                    data = f['URL']
                except Exception as er:
                    print(er)
                    print('skipped file - ' + filePath)
                    continue
            if count >= 10: break
            files.append(file)
            keyPair = {}
            keyPair['directory'] = directory
            keyPair['link'] = data
            keyPair['title'] = file
            urls.append(keyPair)
```