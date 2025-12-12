# Uploading the dashboard to your Grafana instance

To upload the dashboard, you just need to copy and paste the code of the dashboard you want in this folder. For example, i can copy the "windows-logon-monitor" json to import it into Grafana. 

## BEFORE UPLOADING ##

You will need to modify the "UID" in the json for it to match with the UID of your Grafana **Loki**. To get it, simply go to your Loki datasource and you should see a URL like this 

https://grafana-ip:3000/connections/datasources/edit/**cf6gwgsp02iv4c**

The text in bold is your Grafana UID and you will need to replace all of them in them in the JSON before uploading. There are 7 UID, which are the same. 
