import sys

filepath = "../lexicon.data"
longest = 0
with open(filepath) as lex:
    for line in lex:
        length = len(line.rstrip())
        if (length > longest):
            longest = length
sys.exit(longest)
