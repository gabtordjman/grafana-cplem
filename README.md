# GRAFANA Logon-Logoff
Un projet Grafana permettant de surveiller les authentifications des utilisateurs sur une machine Windows.

Cela surveille notamment les ouvertures de session, les fermetures de session et les echecs d'ouverture de session (mauvais mot de passe). 

Cela est ensuite récupéré par Alloy, qui les transmet a Loki. Grafana traite ces données pour en générer un graphique. 

