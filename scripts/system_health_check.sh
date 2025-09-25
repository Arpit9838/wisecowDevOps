#!/usr/bin/env bash
# system_health_check.sh
# Monitors CPU, Memory, Disk, Processes
# Logs alerts to ./wisecow_monitor.log

LOGFILE="./wisecow_monitor.log"
TIMESTAMP() { date "+%Y-%m-%d %H:%M:%S"; }

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=85
PROC_THRESHOLD=300

# Collect metrics
CPU_USAGE=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk -F'id,' '{print 100 - $2}' | awk '{print int($1)}')
MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
PROC_COUNT=$(ps aux --no-heading | wc -l)

echo "$(TIMESTAMP) -- CPU:${CPU_USAGE}% MEM:${MEM_USAGE}% DISK:${DISK_USAGE}% PROCS:${PROC_COUNT}" | tee -a $LOGFILE

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
  echo "$(TIMESTAMP) -- ALERT: CPU usage $CPU_USAGE% > $CPU_THRESHOLD%" | tee -a $LOGFILE
fi

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
  echo "$(TIMESTAMP) -- ALERT: MEM usage $MEM_USAGE% > $MEM_THRESHOLD%" | tee -a $LOGFILE
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
  echo "$(TIMESTAMP) -- ALERT: DISK usage $DISK_USAGE% > $DISK_THRESHOLD%" | tee -a $LOGFILE
fi

if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
  echo "$(TIMESTAMP) -- ALERT: Proc count $PROC_COUNT > $PROC_THRESHOLD" | tee -a $LOGFILE
fi
