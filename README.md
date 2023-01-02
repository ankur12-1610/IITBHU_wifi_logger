# IITBHU Wifi Logger
The current system has a firewall authentication system and this makes us enter the credentials again and again. We might have also lost our wifi network on curcial time due to this xD. In order to avoid the boring task and losing the network during important times, I created a shell script which currently suports Debian and Mac. I'm planning to make a cross platform GUI for the same so that it can work on other operating sytems as well.

## Prerequisite
Make sure to install `net-tools`
```
sudo apt-get install net-tools
```
## How to run the script
> Note: Make sure to open the terminal in the project directory
- First task is to make the script executable
```
chmod +x ./authentication.sh
```
- Execute the scrip with
```
bash authetication.sh
```
- Adding the script to crontab (so that the script runs after every reboot
  - `crontab -e`
  - Add this command to the opened file `@reboot <path_of_the_script>` <br></br>
  > ![Screenshot from 2023-01-02 13-56-58](https://user-images.githubusercontent.com/76884959/210208364-8179b8fc-9be0-490a-93f4-a65090a23bc5.png)

And voila you've added an automated wifi login system in your system.
