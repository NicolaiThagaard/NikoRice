# Ubuntu Server 18.04 and 20.04 ONLY!		              

This is a auto-ricer that changes the look of your Ubuntu Server 18.04 to make a more minimalistic terminal-based desktop enviorment.
This script uses the i3 Window Manager as a template and ZSH combined with Oh-My-Zsh as shell.
Testet on Ubuntu Server 18.04 and 20.04, but might work on other distros too, however, I haven't tested this.

### Important note: 

This script assumes you have a fresh install of Ubuntu Server 18.04 or 20.04 and nothing else!

#### Download:

```
git clone https://github.com/NicolaiThagaard/NikoRice.git 
```
#### INSTALL:

Move folder "NikoRice/NikoRice --> /home/your_user_name/"

Run "AutoRice.sh"-script 1, 2 and 3 from your home folder:

```
bash ./NikoRice/AutoRice_part1.sh
```
```
bash ./NikoRice/AutoRice_part2.sh
```
Run part 3 after a reboot. (The script will tell you).
```
bash ./NikoRice/AutoRice_part3.sh
```
 
A reboot is needed when the script has finished. 
The script will ask you in the prompt.
Everything is now installed.

In case of failures, check the log file.
The script will tell you in the prompt.
The log file can be found here:

```
x@Ubuntu:~$ cat ~/NikoRice/AutoRice_Install.log
```

No log file? No errors!

#### DONE! 

If LightDM does not work (you see the regular Ubuntu login screen):

On the lock screen, tap the Ubuntu icon just above the password bar.
Here you have to choose between "i3" and "i3-debug". Select "i3".
If "i3" cannot be selected then select "i3 debug", go back,
and now select "i3" again.
You can now log in.


#### EKSTRA NOTES:

See ~/.config/scripts for a variety of scripts.
See ~/baggrunde for a variety of background images.
See commands.txt for a long list of useful commands.
See folder VPN for VPN connectivity, excl. user and passwd.

The rest of the "RiceFiles" folder is used for configuration.
