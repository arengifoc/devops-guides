#!/bin/bash
HOY=$(date +%Y%m%d)
ALL=0
YESTERDAY=0
TODAY=0
QUERY=""
BKDIR=""
MAILBOX_EXCLUDE="(ham\.|spam\.|virus-quarantine\.|galsync)"
result=$(mktemp)

# -m <mailbox>
# -r <range> (range: "08/12/2016 08/28/2016")
# -d <directory> (backup directory)
# -f (full backup: all days)
# -a (all mailboxes)
# -y (yesterday's backup)
# -t (today's backup)
while getopts "m:r:d:l:fayt" OPTS
do
  case "$OPTS" in
    m)
      MAILBOX=$OPTARG
      ;;
    r)
      RANGE=$OPTARG
      TYPE="custom"
      ;;
    d)
      BKDIR="$OPTARG"
      ;;
    l)
      LISTFILE="$OPTARG"
      ;;
    f)
      TYPE="full"
      ;;
    a)
      ALL=1
      ;;
    y)
      YESTERDAY=1
      TYPE="day"
      ;;
    t)
      TODAY=1
      TYPE="day"
      ;;
  esac
done

if [ -z "$BKDIR" ]
then
  BKDIR=/mnt/backups
fi
BKDIR=$BKDIR/$HOY/mailboxes
mkdir -p $BKDIR 2> /dev/null
chown zimbra $result $BKDIR 2> /dev/null

if [ -n "$RANGE" ]
then
  TIME_AFTER=$(echo $RANGE | awk '{ print $1 }')
  TIME_AFTER=$(date -d "$TIME_AFTER 1 day ago" +%m/%d/%Y)
  TIME_BEFORE=$(echo $RANGE | awk '{ print $2 }')
  TIME_BEFORE=$(date -d "$TIME_BEFORE +1day" +%m/%d/%Y)
elif [ $YESTERDAY -eq 1 ]
then
  TIME_AFTER=$(date -d "2 days ago" +%m/%d/%Y)
  TIME_BEFORE=$(date +%m/%d/%Y)
elif [ $TODAY -eq 1 ]
then
  TIME_AFTER=$(date -d "1 day ago" +%m/%d/%Y)
  TIME_BEFORE=$(date -d "+1 day" +%m/%d/%Y)
fi

if [ -n "$TIME_AFTER" ] && [ -n "$TIME_BEFORE" ]
then
  RANGE=$(($(date -d "$TIME_BEFORE" +%s) - $(date -d "$TIME_AFTER" +%s)))
  TIME_START=$(date -d "$TIME_AFTER + 1 day" +%Y%m%d)
  TIME_END=$(date -d "$TIME_BEFORE 1 day ago" +%Y%m%d)
  if [ $RANGE -gt 172800 ] # 172800 = 2 days
  then
    TIME="from-${TIME_START}-to-${TIME_END}"
  else
    TIME="${TIME_START}"
    TYPE="day"
  fi
  QUERY="&query=before:$TIME_BEFORE and after:$TIME_AFTER"
elif [ "$TYPE" = "full" ]
then
  TIME=$HOY
fi

backup_mailbox()
{
  if [ -n "$MAILBOX" ]
  then
    echo "selectMailbox $MAILBOX"
    echo "getRestURL -o $BKDIR/mailbox-${TYPE}-$MAILBOX-${TIME}.tgz '//?fmt=tgz$QUERY'"
  fi
}

if [ $ALL -eq 1 ]
then
  su - zimbra -c "zmprov -l gaa" | grep -vE "$MAILBOX_EXCLUDE" |
  while read MAILBOX
  do
    backup_mailbox $MAILBOX
  done > $result
elif [ -e $LISTFILE ] && [ -n "$LISTFILE" ]
then
  su - zimbra -c "zmprov -l gaa" | grep -vE "$MAILBOX_EXCLUDE" |
  while read MAILBOX
  do
    backup_mailbox $MAILBOX
  done < $LISTFILE > $result
else
  backup_mailbox $MAILBOX > $result
fi
su - zimbra -c "zmmailbox -z < $result" > /dev/null 2>&1
rm -f $result
