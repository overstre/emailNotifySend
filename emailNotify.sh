#!/bin/bash

# Simple script to display a notification of new messages


FILTER="X-PMX-Version:
User-Agent:
X-Length:
X-UID:
X-KMail-Filtered:
X-BugTraq-notice-type:
X-Authentication-warning:
X-Brightmail-Tracker:
X-Spam-Checker-Version:
X-scm-notification:
X-Antispam:
X-Spam-Status:
X-Spam-Level:
Status:
X-Status:
X-KMail-EncryptionState:  
X-KMail-SignatureState:  
X-KMail-MDN-Sent:
References:
Precedence:
Content-disposition:
by smf-spamd v1.3.1 - http://smfs.sf.net/
version=3.2.5
>"

function escapeHtml {
    sed 's/</\&lt;/g' | sed 's/>/\&gt;/g'
}

MESSAGE=$(cat /dev/stdin)

FROM=$(echo "$MESSAGE" | grep ^From\: | cut --fields="2-" --delimiter=" " \
                       | escapeHtml)
TO=$(echo "$MESSAGE" | grep ^To\: | cut --fields="2-" --delimiter=" " \
                     | escapeHtml)
SUBJECT=$(echo "$MESSAGE" | grep ^Subject\: | cut --fields="2-" --delimiter=" " \
                          | escapeHtml)
BODY=$(echo "$MESSAGE" | grep -v -F "$FILTER" \
                       | grep Content-transfer-encoding -A 5 -m 1 \
                       | grep -v Content-transfer-encoding \
                       | grep -v -- "--Boundary_" | grep -v Content-type \
                       | tr -d '\n' | escapeHtml)

DISPLAY=0:0 /usr/bin/notify-send -u normal -i /usr/share/icons/hicolor/64x64/apps/kmail.png --hint=int:x:1400 --hint=int:y:10 \
"New Message" \
"<b>From:</b> $FROM 
<b>To:</b> $TO
<b>Subject:</b> $SUBJECT
<i>$BODY</i>"
