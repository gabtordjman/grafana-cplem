# Grafana Logon Monitor

## Overview
**Grafana Logon Monitor** is a centralized monitoring solution for Windows authentication events. It captures, analyzes, and visualizes in real-time logins, logoffs, and authentication attempts across your Windows infrastructure.

## 🎯 Features
- **Real-time monitoring** of Windows security events (ID 4624, 4625, 4634, 4647)
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
1. **NXLog Community Edition**: Collects Windows Event Logs
2. **Alloy (Grafana Agent)**: Syslog reception + log parsing
3. **Loki**: Structured log storage
4. **Grafana**: Visualization and dashboards

## 📈 Dashboard
### Dashboard Sections
1. **Login Activity Timeline**:

    - Visualization: Time series graph, Pie Chart

    - Purpose: Shows login attempts over time, and a total of all the methods used to login
    
    - Refresh Rate: Real-time (10s intervals)
