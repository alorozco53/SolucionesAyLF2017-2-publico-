# Recognizes all dates of the form DD/MM/YYYY
grep -E "\b(0[1-9]|(1|2)\d|3[01])/(0[1-9]|1[012])/\d{4}\b"

# Changes Spanish infinitive verbs to third person singular past tense
sed -E "s/\b(\w*)ar\b/\1ó/g"
sed -E "s/\b(\w*)(er|ir)\b/\1ió/g"

# "Parses" any csv file
pcregrep -M "^(([^\",\s^$]*|\"(\"{2}|[^\"]|\s|^|$)*\")?($|,))*$"

# Changes http to https and .net to .com
sed -E "s/https?:\/\/((www\.)?([^n][^e][^t])*?[^\.]+(\.[^n][^e][^t])?)(\.net)?([\w\-\/~\.@=%&_?]*)/https:\/\/\1\.com\6/g"
