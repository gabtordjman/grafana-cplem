# Grafana Cross-Platform Log & Event Monitor

## *still in development as you can see by the screenshot. Configurations files and dashboard may change in the future, so be sure to update !*

## Overview
**Grafana CPL & EM** is a centralized monitoring solution for Windows and Linux authentication events and system logs. It captures, analyzes, and visualizes in real-time logins, logoffs, authentication attempts and events across your Windows and Linux infrastructure.

## 📸 Screenshots

![Grafana Logon Dashboard](images/logon-dashboard.png)
*Screenshot of the Logon-Monitor*

![Grafana Events Dashboard](images/events-dashboard.png)
*Screenshot of the Events-Monitor*

## 🎯 Features
- **Real-time monitoring** of Windows security events (ID 4776 for successful and failed logins), and RDP login events (ID 25)
- **Automatic extraction** of critical information:
  - Authenticated user
  - Source workstation
  - Event type (success/failure/logoff, Linux system events (DHCP Request, reloaded services)
  - Precise timestamp
- **Intuitive dashboard** in Grafana with clear visualization
- **Lightweight architecture** using NXLog (collector) and Alloy (processor)

## 🏗️ Architecture
Windows/Linux machines → NXLog → Alloy (Grafana Agent) → Loki → Grafana

### Components:
1. **NXLog Community Edition**: Collects Windows and Linux Event Logs and send them to desired agent
2. **Alloy (Grafana Agent)**: Syslog reception + log parsing
3. **Loki**: Structured log storage
4. **Grafana**: Visualization and dashboards

### Configurations
All of the configurations files used in this project are available in the "configs" folder. You'll find the nxLog config, and the alloy config. Be sure to change the **IP** and the **PORT** in the nxLog and Alloy config file if your system is configured differently. 

The dashboard folder contains the dashboards used in this project, same you see with the screenshots. 

## 📈 Dashboard
### Dashboard Sections
1. **Login Activity**:

    - Visualization: Table, Time Series Graph, Pie Chart. 

    - Purpose: Shows login attempts over time, a total of all the methods used to login, who tried to connect and on what service (ex : RDP), a total of events/errors that have happend on a period of time.

## Log Ingestion with GELF

This project centralizes log collection using the Graylog Extended Log Format (GELF). GELF is a modern, JSON-based structured logging format that overcomes the limitations of traditional syslog by supporting compression, chunking, and a clearly defined, parseable structure

### Ingestion Pipeline
Logs are ingested into the observability stack through a dedicated GELF listener, which is a common feature in tools like Grafana's logging components
. This method allows the system to receive structured log data over network protocols such as UDP, providing flexibility for various sources like applications, Docker containers, or syslog forwarders configured to output in GELF format

### Why GELF?

- Structured Data: Logs are ingested as JSON objects, making it easy to parse, query, and extract specific fields (e.g., host, level, message, eventID)

- Efficiency: Supports optional compression to save bandwidth

- Extensibility: Allows for custom fields (prefixed with an underscore _) to be attached to log messages, enabling rich, application-specific context  

