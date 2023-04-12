# COMS20011_2020 Labs

The labs are all Jupyter Notebooks.  We recommend that you work at a lab machine, but we also give instructions for working remotely.

## Working locally at a lab machine.
Start by cloning the lab sheet to the machine you're working at (usually the local/remote lab machine)

1. Open the terminal.

2. Clone the lab repository from Github to your lab machine.
```
git clone https://github.com/LaurenceA/COMS20011_2022.git
```
3. Pull the repository each time before the lab to get the latest updates of the repository.
```
cd COMS20011_2022
git pull
```
4. To start Jupyter notebooks, run 
```
/opt/anaconda3-4.4.0/bin/jupyter notebook
```
Jupyter should automatically open a webpage. If not, open your favourite web browser and go to: `localhost:8888/notebooks`.


## Remote access to MVB machines

If you're sat at an MVB workstation, just follow the instructions above.  If not, you need to connect to an MVB machine remotely.

Option 1 and 2 are simpler to set up, and give you a remote desktop (i.e. its just like being sat at an MVB machine). But they can be quite slow.  Option 3 is faster, but is more difficult to set up.

#### Option 1: Linux Remote Desktop (Windows/Linux)
First, follow these instructions to set up the [VPN](https://uob.sharepoint.com/sites/itservices/SitePages/vpn-connect.aspx). Then, follow these guidelines provided by IT Services to set up a [Linux Remote Desktop](https://uob.sharepoint.com/sites/itservices/SitePages/fits-engineering-linux-x2go.aspx).  Should work on Mac, but apparently the required XQuartz software doesn't work well.  This is supported by IT, so any issues with this software can be sent to service-desk@bristol.ac.uk.

#### Option 2: X Remote Desktop (Linux)
If you are running an X server already (i.e. because you're running Linux locally), then open a shell on your machine, and type this command: 
```
ssh -X -J youruserid@seis.bris.ac.uk youruserid@rd-mvb-linuxlab.bristol.ac.uk
```
This method will not work on Windows Linux Subsystem (WSL), you can use Option 3 in WSL, or Option 1 in Windows, instead.

#### Option 3: SSH Port forwarding (WSL/Linux/Mac)
If you can get it working, this method will give the lowest latency.

This allows you to open Jupyter Notebook in a browser on your local machine while still running it on a lab machine.

1. Map a free port on your machine (e.g. 6006) to a free port on the lab machine (e.g. 7373)
```
ssh -L 6006:localhost:7373 -J user@seis.bris.ac.uk user@rd-mvb-linuxlab.bristol.ac.uk
```
       
2. Run Jupyter Notebook on the port mapped to your local machine: 7373
```
/opt/anaconda3-4.4.0/bin/jupyter notebook --no-browser --port 7373
```
      
3. Open localhost:6006 in a web browser on your local machine and enter the token provided by Jupyter Notebook.

*WSL is [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about).

## Locally installing Anaconda

*This is not supported!*

There are lots of options to install Python, but we'd recommend Anaconda, which comes with all the libraries necessary to run the labs:
[https://www.anaconda.com/products/individual](https://www.anaconda.com/products/individual)
