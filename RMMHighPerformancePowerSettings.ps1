#################################################################
# Title: High Performance Power settings
# Author: Blake Pierantoni
# Date: 2019/08/26
# Description: Adjusts the power settings for a machine to run as high performance
#################################################################


#PowerCFG Script

#Set machine to high performance power settings
    Powercfg /SETACTIVE SCHEME_MIN
#Turn off hibernate option
    Powercfg /Hibernate off
#Turn monitor off after 60 minutes (Not sleep)
    Powercfg /Change monitor-timeout-ac 60
    Powercfg /Change monitor-timeout-dc 60
#Turn off sleep 
    Powercfg /Change standby-timeout-ac 0
    Powercfg /Change standby-timeout-dc 0
#Set disk to never turn off
    Powercfg /Change disk-timeout-ac 0
    Powercfg /Change disk-timeout-dc 0