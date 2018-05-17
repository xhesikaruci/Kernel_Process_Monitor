#!/bin/bash 
# Process init in Unix-based OS is the first process started during booting and continues running until system shuts down
# PID of init=1


temp=$(</proc/1/task/1/children); #save the content (running PIDs) of the children file in variable temp.
process_id=( $temp );
tLen=${#process_id[@]};


echo "$(date):
Immediate children of init process with PID=1 are:";
logger "$(date):
Immediate children of init process with PID=1 are:"

for (( i=0; i<${tLen}; i++));
do
  process_name=$( awk '/Name/ {print $2}' < /proc/${process_id[$i]}/status); #go to the status file in the directory of the process to look for parameter:Name
  echo  "$i. $process_name";
  logger "$i. $process_name";
done

vruntime=null;

echo  "$(date): 
Monitoring process:  $process_name with PID= $process_id";


while [ -d /proc/$process_id ];  #checking if PID file of the process being monitored is still in the /proc filesystem
 do
    echo "Process $process_id: Running"; #if it is true, then the process is running
    logger  "Process $process_id: Running";
    
    vruntime=$( awk '/se.vruntime/ {print $3}' < /proc/${process_id[$6]}/sched);
    sleep 5;
done
  #if not, it means that the process has dies and we print the latest se.vruntime values found in sched file of the PID directory
echo "Process $process_name with PID= $process_id just stopped. 
Latest se.vruntime is: $vruntime. "; 
logger "Process $process_name with PID= $process_id just stopped.
Latest se.vruntime is: $vruntime. ";


