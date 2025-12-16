# Uploading a dashboard to your Grafana instance

To upload a dashboard, you just need to copy and paste the code of the dashboard you want in this folder. For example, i can copy the "logon-dashboard" json to import it into Grafana. 

## BEFORE UPLOADING ##

You will need to modify the "UID" in the json for it to match with the UID of your Grafana **Loki**. To get it, simply go to your Loki datasource and you should see a URL like this 

https://grafana-ip:3000/connections/datasources/edit/cf6gwgsp02iv4c

cf6gwgsp02iv4c is my Grafana UID and it needs to be replaced in the JSON before uploading. There are 7 UID, which are the same, that needs to be replaced

# List of the dashboards

## LOGON DASHBOARD

This dashboard offers monitoring of Windows instances. You are able to see the opened sessions and the failed authentications attemps. For the failed attempts, you can see what

user has been used and on what machine. You also see a pie chart, that shows the total of successful and unsuccessful logins attemps.

On the top left, you can see a Week Log, that shows the total of unsuccessful attemps to login of a user on the current week

## EVENTS DASHBOARD

This dashboard combines Windows & Linux to create a dashboard that shows the errors or events that have happened in the Event Monitor (Windows) and systemd (Linux). You can also see a pie chart with the number of events/errors of Windows & Linux systems combined, to see who got the most errors. 

## AIO DASHBOARD

This All-in-One dashboard uses variables to monitor differents systems in one place. You can filter by the hostname or ip address. Prometheus is used in this dashboard to display usedful status about the system, like

CPU and Memory usage, in a form of a gauge and a time series graph.
