# Shutdown | PC/Notebook/Server | Saving Electricity
This project created by editing the original script [1] helping to shutdown the devices automatically 5 minutes after it started or helping to shutdown with user choice. The main goal of this project is saving electricity from opened devices. Also, you can deploy by GPO.

![GUI](https://user-images.githubusercontent.com/50519199/114439304-82365100-9bd1-11eb-959d-772af2db7c37.jpg)

[1] https://community.spiceworks.com/topic/544793-shutting-down-pcs-with-user-interactive-user-prompts

# Descriptions
CHOICE|DESCRIPTION
------------ | -------------
Close|Stop the process until next starting time
Shutdown|Shutdown right now
Postpone : 1 Hour|Postpone 1 hour and then shutdown automatically
Postpone : 2 Hours|Postpone 2 hours and then shutdown automatically

# GPO Deploy
1. Create a new GPO and give a name
2. Edit your new created GPO
3. Go to Computer Configuration -> Preferences -> Control Panel Settings -> Scheduled Tasks
4. Create a new scheduled task and give a name
5. Choose a trigger time plan
6. Create an actions
7. Choose PowerShell location on program/script area
8. Choose your script location and add this command before the script location to not see PowerShell window when it starts `-NonInteractive -WindowStyle Hidden` on argument area

![Create-Task](https://user-images.githubusercontent.com/50519199/114445657-fde7cc00-9bd8-11eb-9c90-7f8607f77e44.jpg)

![Create-Action](https://user-images.githubusercontent.com/50519199/114445725-15bf5000-9bd9-11eb-9715-38ab491a2188.jpg)
