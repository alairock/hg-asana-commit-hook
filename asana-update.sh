#!/bin/bash

# -----------------------
# necessary .hgrc configuration:
# [asana]
# asana-key = {ASANAKEY}
# upload-tag = {TAGID}
# -----------------------
apikey=$(hg showconfig asana.asana-key)
upload_tag=$(hg showconfig asana.upload-tag)

if [ $apikey == '' ] ; then exit 0; fi

# regex pattern to recognize a story number
taskid_pattern='#([0-9]*)'

upload_pattern='#upload'

# get the checkin comment for parsing
summary=$(hg log -vr $HG_NODE | egrep -v '^(tag|parent|date|user|files):' | sed 's/^description:$//')

#replace any & so it wont truncate the comment
summary=${summary//&/%26}
files=$(hg status --change $HG_NODE)

comment="$summary
------------------
$files"

# break the commit comment down into words
IFS=' ' words=( $summary )

for element in "${words[@]}"
do
    # if we have a task id, save it to the appropriate array
    if [[ $element =~ $taskid_pattern ]]; then
    referenced=("${referenced[@]}" "${BASH_REMATCH[1]}")
    fi
    if [[ $element =~ $upload_pattern ]]; then
    uploaded=1
    fi
done

# touch the stories we've referenced
for element in "${referenced[@]}"
do
    curl -u ${apikey}: https://app.asana.com/api/1.0/tasks/${element}/stories \
         -d "text=Mercurial commit: ${comment/ /:%0A}" > /dev/null 2>&1
    if [[ $uploaded == 1 && $upload_tag != '' ]]; then
    	curl -u ${apikey}: https://app.asana.com/api/1.0/tasks/${element}/addTag \
         -d "tag=${upload_tag}" > /dev/null 2>&1
    fi
done
