#!/bin/bash

# rename files to match the case in the htmlfiles. Thanks Microsoft and Analog.

# Seemed cleaner than a wide 'sed' script to instead fix the html, but I have doubts

#This will break if the structure of the helpfiles changes, in particular :
# - relative hrefs like href="../OtherFile.htm"...
# - multiple hrefs using a differently-cased variants of the same file, like "href=WeirdCase.htm"..."weiRDcase.htm"
# - probably other edge cases ? parsing html with regex is Evil


##### get 'src=...' refs containing uppercase chars; trim 'src="' prefix, sort, list unique
src_list=$(grep -ohP 'src="[^h][^"]+[A-Z][^"]+' $(find -type f -name '*.htm*') | sed 's/.*\"//' | sort | uniq)

##### same, for 'href='
href_list=$(grep -ohP 'href="[^h][^"]+[A-Z][^"]+' $(find -type f -name '*.htm*') | sed 's/.*\"//' | sort | uniq)

# this is actually slower and not much clearer
# find -type f -name '*.htm*' -exec grep -ohP 'src="[^"]+[A-Z][^"]+' '{}' \; | sed 's/.*\"//' | sort | uniq

# use a () subshell here to isolate change to 'shopt' (will be needed if some files have wrong, mixed-case)
set_proper_name() (
#	shopt -s nocaseglob
	lower_file=$(echo "$@" | tr '[:upper:]' '[:lower:]')
#	echo renaming $lower_file to $@
	mv $lower_file $@
)

for file in $src_list $href_list; do
	if [[ ! -e "$file" ]]; then
		set_proper_name "$file"
	fi
done

