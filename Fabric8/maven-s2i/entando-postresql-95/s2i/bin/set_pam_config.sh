DELETE_SQL="DELETE FROM sysconfig WHERE version='production' AND item='jpkiebpm_config';"
for i in {1..20}
do
    psql -U postgres -d $POSTGRESQL_DATABASE -c "$DELETE_SQL"
    if [[ $? -eq 0 ]]; then
       echo "PAM Config deleted successfully"
       break
    fi
    sleep 5
done
source $(dirname "$0")/parse_url.sh
UPDATE_SQL="INSERT INTO sysconfig (version, item, descr, config) VALUES ('production', 'jpkiebpm_config', 'KIE-BPM service configuration',
'<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<kiaBpmConfigFactory>
   <kieBpmConfigeMap>
      <entry>
         <key>c2916181acd14071a9f2844a2dc0c5ff20180521T225803461</key>
         <value>
            <active>true</active>
            <id>c2916181acd14071a9f2844a2dc0c5ff20180521T225803461</id>
            <name>localBPM</name>
            <username>${PAM_USERNAME:-pamAdmin}</username>
            <password>${PAM_PASSWORD:-bpmsuite1}</password>
            <hostname>$PAM_HOST</hostname>
            <schema>http</schema>
            <port>${PAM_PORT:-80}</port>
            <webapp>$PAM_PATH</webapp>
         </value>
      </entry>
   </kieBpmConfigeMap>
</kiaBpmConfigFactory>
');"
echo $UPDATE_SQL
psql -U postgres -d $POSTGRESQL_DATABASE -c "$UPDATE_SQL"
if [[ $? -eq 0 ]]; then
  echo "PAM Config updated successfully"
fi