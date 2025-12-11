# Grafana Logon Monitor

## *still in development as you can see by the screenshot. Configurations files and dashboard may change in the future, so be sure to update !*

## Overview
**Grafana Logon Monitor** is a centralized monitoring solution for Windows authentication events. It captures, analyzes, and visualizes in real-time logins, logoffs, and authentication attempts across your Windows infrastructure.

## 📸 Screenshot

![Grafana Logon Monitor Dashboard](dashboard.png)
*Screenshot of the dashboard*

## 🎯 Features
- **Real-time monitoring** of Windows security events (ID 4624, 4625, 4634, 4647), and RDP login events (ID 25)
- **Automatic extraction** of critical information:
  - Authenticated user
  - Source workstation
  - Event type (success/failure/logoff)
  - Precise timestamp
- **Intuitive dashboard** in Grafana with clear visualization
- **Lightweight architecture** using NXLog (collector) and Alloy (processor)

## 🏗️ Architecture
Windows Machines → NXLog → Alloy (Grafana Agent) → Loki → Grafana

### Components:
1. **NXLog Community Edition**: Collects Windows Event Logs and send them to desired agent
2. **Alloy (Grafana Agent)**: Syslog reception + log parsing
3. **Loki**: Structured log storage
4. **Grafana**: Visualization and dashboards

## 📈 Dashboard
### Dashboard Sections
1. **Login Activity Timeline**:

    - Visualization: Time series graph, Pie Chart, Table

    - Purpose: Shows login attempts over time, a total of all the methods used to login, who tried to connect and on what service (Windows Authentication, RDP...)
  
## Log Ingestion with GELF

This project centralizes log collection using the Graylog Extended Log Format (GELF). GELF is a modern, JSON-based structured logging format that overcomes the limitations of traditional syslog by supporting compression, chunking, and a clearly defined, parseable structure

### Ingestion Pipeline
Logs are ingested into the observability stack through a dedicated GELF listener, which is a common feature in tools like Grafana's logging components
. This method allows the system to receive structured log data over network protocols such as UDP, providing flexibility for various sources like applications, Docker containers, or syslog forwarders configured to output in GELF format

### Why GELF?

- Structured Data: Logs are ingested as JSON objects, making it easy to parse, query, and extract specific fields (e.g., host, level, message, eventID)

- Efficiency: Supports optional compression to save bandwidth

- Extensibility: Allows for custom fields (prefixed with an underscore _) to be attached to log messages, enabling rich, application-specific context  

