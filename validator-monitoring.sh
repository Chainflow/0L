## OL validator monitoring scripts. The first alerts if a validator is unhealthy. 
## The second confirms validator health. Separate into separate files and run scrips as cron jobs. 
## Ideally someone picks this up and combines the two scripts into a single script.

# Alerts to unhealthy validator, run often, e.g. every 5 minutes.

#!/bin/bash

TOKEN=$YOUR_TELEGRAM_BOT_TOKEN
CHAT_ID=$YOUR_TELEGRAM_CHAT_ID
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
MESSAGE="Ol Validator Unhealthy"

/$HOME/bin/ol health | grep false
RESULT=$?

echo -e "Grep identified as: $RESULT"

if [ $RESULT == 0 ]; then
  echo -e $MESSAGE
  # Send to Telegram
  curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$(echo -e $MESSAGE)"
fi

# Confirm validator health, run a few times per day as a sanity check.

/$YOURPATH/conf-monitor-0l-status.sh

*/5 * * * * /$YOURPATH/conf-monitor-0l-status.sh >> /$YOURPATH/conf-monitor-0l-status.sh.log

#!/bin/bash

TOKEN=$YOUR_TELEGRAM_BOT_TOKEN
CHAT_ID=$YOUR_TELEGRAM_CHAT_ID
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
MESSAGE="Ol Validator Healthy"

/$HOME/bin/ol health | grep false
RESULT=$?

echo -e "Grep identified as: $RESULT"

if [ $RESULT == 1 ]; then
  echo -e $MESSAGE
  # Send to Telegram
  curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$(echo -e $MESSAGE)"
fi
