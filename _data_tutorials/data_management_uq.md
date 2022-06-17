---
layout: page
title: "Research data management services at UQ"
author: "Emily Kahl"
categories: data
---

Data management is extremely important in research, but the variety of options for managing research
data can be a little overwhelming at first. This guide will explain the options available for 
reliable, long-term research data storage at UQ and will walk through some best-practices for
safely transferring your data from HPC clusters to long-term storage.

# Table of Contents
{:.no_toc}

* TOC
{:toc}

# What options are available for long-term research data storage?
There are two main options for long-term storage of research data for UQ researchers: UQ's [Research Data
Manager](https://rdm.uq.edu.au/) (RDM) and AARNet's [CloudStor](https://www.aarnet.edu.au/cloudstor).
These resources are not mutually exclusive and serve different needs - you can and should make heavy use
of both of them when managing your research data.

## UQ RDM
The Research Data Manager is a long-term research data storage service managed by the University of
Queensland. The service is available to all UQ researchers and research students, and access is organised
as per-project *records*. If you don't already have an RDM record associated with your project, you can
apply through the [RDM web interface](https://rdm.uq.edu.au/create-record). Researchers can be a member 
of more than one record, with access-control handled through the RDM web interface, which also has tools 
for granting access to collaborators from other institutions.

Each RDM record has 1TB of storage, which is backed up across multiple locations both on- and
off-campus. Data is protected against hardware and software failure, but not user-error like accidental 
deletion (it doesn't have file versioning like Dropbox or Google Drive). Data on the RDM is meant to
last beyond the duration of a single project, so it prioritises storage size and robustness beyond 
speedy access. This is not to say the transferring data to and from the RDM is intolerably slow, just 
that it's intended use case is for archival storage rather than as a working directory for simulations.

You can access your data on the RDM through a few different mechanisms but there's no singular "best"
option - all have their use cases and you'll likely find  yourself using all of the above as needed.

### Accessing the RDM through the web interface
You can access your RDM data through the web interface at <cloud.rdm.uq.edu.au>. This will let you 
upload/download files through a web browser and perform rudimentary file-system operations like 
renaming and moving files and folders.

### Accessing the RDM through a mapped drive
You can access your RDM as a folder using your computer's file manager by mounting it as a networked
drive. General instructions can be found [here](https://guides.library.uq.edu.au/for-researchers/uq-research-data-manager/using-mapped-drive),
while AIBN-specific instructions for high-speed access can be found [here](https://guides.library.uq.edu.au/for-researchers/uq-research-data-manager/instructions-for-institutes).

### Accessing the RDM through the Nextcloud and ownCloud sync clients
RDM also supports access through open-source desktop sync clients [NextCloud](https://nextcloud.com/) 
and [ownCloud](https://owncloud.com/) which automatically synchronise files between a folder on
your local computer and the RDM, in a similar fashion to Dropbox. To use Nextcloud to synchronise files 
with your RDM, follow the instructions in [this guide](https://guides.library.uq.edu.au/for-researchers/uq-research-data-manager/uq-rdmcloud-sync-client)
provided by the UQ Library. 

The guide also works for ownCloud (meaning you can use the same
program to synchronise with the RDM and AARNet's CloudStor), with the following exception: in step
2 of [the guide for UQ users](https://guides.library.uq.edu.au/for-researchers/uq-research-data-manager/setting-up-sync-client-uq-users),
you'll need to generate a temporary password to use with ownCloud, since it doesn't natively
support two-factor authentication. You can do this
through the RDM web interface at <cloud.rdm.uq.edu.au>. Log in to the web interface then click on your 
initials in the top right corner of the page and select "settings". In the "security" tab on the left 
side of the settings page, there will be an option to "create new app password" (you may have to scroll down 
to find it); create a new password and give it a descriptive name like "owncloud". Copy the password somewhere
safe before leaving the page - I recommend a secure password manager from [this list](https://web.library.uq.edu.au/research-tools-techniques/digital-essentials/password-management?p=3#3)
by the UQ Library. You can delete the app-password from the same page in the RDM web interface if you no 
longer need it.

Use your UQ email address and the temporary password when prompted to provide a username and password
for ownCloud, then follow the rest of the steps in the UQ library guide.

### Accessing the RDM via SSH/SFTP
You can access your RDM from the command line through the SSH/SFTP interface provided by QCIF's 
[QRISCloud](https://www.qriscloud.org.au/support/qriscloud-documentation/93-using-qrisdata-collections). 
QCIF recommend using the `rsync` command-line tool when transferring data via the SSH interface, as 
it is more robust against network connectivity interruptions - an important requirement when 
transferring large amounts over unreliable networks (e.g. weak WiFi connections). This is the 
only way to directly access the RDM from external clusters like Gadi or Magnus.

The data access servers for QRISCloud have the following addresses:
  - `ssh1.qriscloud.org.au` and `ssh2.qriscloud.org.au`, and
  - `data.qriscloud.org.au`, which is a load-balancer to distribute traffice between the two `ssh` nodes.

QCIF recommends using the `data.qriscloud.org.au` load-balancer for most data transfers, but this may 
cause degraded performance in some cases - use the `ssh1` and `ssh2` addresses directly if this happens.
The basic syntax for transferring data to your RDM record using `rsync` is as follows:

```
rsync -rvz /path/to/your_data <uq_username>@data.qriscloud.org.au
```
where you'd replace `<uq_username>` with the UQ username you use to log in to Tinaroo, etc. The `-r` flag 
tells `rsync` to do a "recursive" copy, so it will copy all the contents of a folder (and any sub-folders)
to the RDM. You need this flag if you're copying a folder, but not if you just want to copy a single file 
(like a compressed archive). The `-v` flag enables "verbose" output and `-z` compresses the data before 
sending it to the QRISCloud server. It's a good idea to use `-z` if you're transferring a lot of data, 
but is unecessary if you've already compressed it with `tar` or `zip`.

### Accessing the RDM from RCC's clusters
The QRISCloud directories are also mounted on RCC clusters (e.g. Tinaroo). These are available under the 
`/QRISData/` mount point and are labelled according to your RDM record Q-number, which can be found on the 
[RDM web interface](rdm.uq.edu.au). For example, if your RDM has the Q-number 9999 then it would be mounted 
on Tinaroo at `/QRISData/Q9999/`. 

The mounted directories behave the same as any other filesystem directory on Tinaroo, with one important
exception: **do not run calculations in `/QRISData`**. The RDM filesystem is not designed to handle lots of
small reads and writes, so you must not run batch jobs in that directory or directly 
output the results of simulations into `QRISData`. You **must** output your simulation results to `/scratch`
first and then copy over to your RDM in one go once it's all finished.

### Accessing the RDM with Rclone
[Rclone](https://rclone.org/) 
is another command-line tool for accessing remote file servers, but with a broader set of 
supported protocols than `rscync`. It is particularly suited to cloud-storage solutions, but can work 
equally well with UQ's RDM. `rclone` is available on [Windows, Mac and 
Linux](https://rclone.org/downloads/), as well as Tinaroo, Gadi and the Pawsey clusters. 
It is the only tool on this list which works identically with both RDM and CloudStor.

You'll need to configure a *remote* with the correct settings before you can connect to RDM, which 
is a long but mostly turnkey process. Before you get started, it's best to create an app-specific password
for `rclone` so you can revoke access if needed without changing your main UQ password. You can do this
through the RDM web interface at <cloud.rdm.uq.edu.au>. Log in to the web interface then click on your 
initials in the top right corner of the page and select "settings". In the "security" tab on the left 
side of the settings page, there will be an option to "create new app password" (you may have to scroll down 
to find it); create a new password and give it a descriptive name like "rclone". Copy the password somewhere
safe before leaving the page - I recommend a secure password manager from [this list](https://web.library.uq.edu.au/research-tools-techniques/digital-essentials/password-management?p=3#3)
by the UQ Library. You can delete the app-password from the same page in the RDM web interface if you no 
longer need it.

Once you've set up the app password, the basic steps to setup `rclone` are as follows:

1.  Run `rclone config` and type `n` to create a new configuration. Give it a descriptive name like `rdm`
2.  Select `webdav` from the list of protocols.
3.  Enter the following remote URL: `https://cloud.rdm.uq.edu.au/remote.php/dav/files/<your_username>@uq.edu.au`
4.  Choose `nextcloud` for "vendor"
5.  Enter `<your_username>@uq.edu.au` when asked for a username
6.  Enter the temporary app password when prompted
7.  Leave the "bearer token" field empty
8.  Select `n` when asked to edit the advanced config
9.  Accept the configuration
10. (Optional) You'll want to encrypt the config if you're using `rclone` on a shared system (like Magnus)
    to make sure nobody else can use the configuration to mess with your RDM. Return to the `rclone config` 
    menu and choose `s) Set configuration password` then enter a password.

You can then use `rclone` to push and pull files from the RDM, as well as run basic queries and filesystem 
operations like listing the contents of directories. A full list of options is available via `rclone --help`,
but the basic commands are as follows:
- `rclone ls <remote>:<directory>` - list the files in `<directory>` in your remote (replace `<remote>`
  with the name you chose in step 1 above). The directory paths must use the project's full name as their 
  root (which is different to the QRISCloud convention, which only uses the numbers), so if your project
  is called `MyProject-Q1234`, then you would do `rclone ls rdm:MyProject-Q1234/some_folder` to list the 
  contents of `some_folder` in your RDM.
- `rclone lsd <remote>:<directory>` - as for `rclone ls`, but lists directories rather than files.
- `rclone copy <src> <dst>` - copy a file or directory from source to destination. Usually at least one 
  of these will be a remote, e.g. `rclone copy some_file <remote>:<directory>` to copy `some_file` to
  your RDM or `rclone copy <remote>:<directory>/some_file ./some_file` to copy `some file` from the 
  RDM to your current directory on whichever machine you're using `rclone` on. It's also possible to 
  copy from remote to remote, e.g. copying data from RDM to CloudStor. Also, from the `rclone copy --help`
  page: "Note that it is always the contents of the directory that is synced, not the directory so when 
  source:path is a directory, it's the contents of source:path that are copied, not the directory name and
  contents.". This means that if you run `rclone copy` on a folder, it will splat the contents in your 
  remote directory without creating a new folder. This means it's usually a good idea to create a folder
  on the RDM first if you want to copy a whole folder to the RDM.
- `rclone mkdir <remote>:<directory>` - create a directory on the remote if it doesn't already exist.
- `rclone --dry-run <command>` - do a dry-run of an `rclone` command, which will show what operations 
  would be performed, but will not actually make any changes. It's a good idea to do a rdy-run before
  running a potentially destructive command to make sure you're not deleting or overwriting anything
  you don't intend to.
- `rclone --progress <command>` - show real time statistics like file uploads while running a command.

Full documentation for Rclone can also be found on the project's website: <https://rclone.org/>.

## AARNet CloudStor
[CloudStor](https://www.aarnet.edu.au/cloudstor) is a cloud storage platform for research data 
provided by AARNet - Australia's Academic and Research Network. [AARNet](https://www.aarnet.edu.au/who-we-are) 
maintains the IT and communications infrastructure used by Australian universities and research 
institutions, including fast fibre connections between institutes and the eduroam wireless network. 
Most Australian universities are connected to AARNet, as are NCI and the Pawsey Centre.

CloudStor is a service which provides secure, high capacity cloud storage free-of-charge to Australian 
researchers and research students as an alternative to commercial services like Dropbox and Google Drive. 
Data on CloudStor is backed up in multiple locations and has file versioning, allowing you to revert files
to previous versions if you make a mistake. CloudStor is on the same high-speed fibre network which 
connects Australian universities, so has very high upload/download speeds on campus, but can also be 
accessed off-campus as well. It supports multiple protocols, including an open-source desktop sync client,
ownCloud, which automatically synchronises file changes when they occur - almost a drop-in replacement
for Dropbox.

Any Australian researcher or research student can create an account with CloudStor, which comes with 
1TB of storage by default. You will also be able to take your data with you when you leave UQ, provided
you stay within the AARNet network (see [this 
link](https://support.aarnet.edu.au/hc/en-us/articles/205819887-What-happens-to-my-data-when-I-leave-my-university-) 
for instructions). The signup page is available at <https://cloudstor.aarnet.edu.au/>,
with detailed instructions [at this link](https://support.aarnet.edu.au/hc/en-us/sections/115000260553-Getting-started).

There are three main methods for transferring data to and from CloudStor: the web app, the ownCloud
desktop client and the Rclone command line tool.

### Accessing CloudStor through the web app
You can log in to the CloudStor web app at the following URL: <https://cloudstor.aarnet.edu.au/>.
The web app can upload/download files through a web browser, and perform rudimentary file-system operations like 
renaming and moving files and folders. 

### Accessing CloudStor with the ownCloud desktop client

First, download the ownCloud desktop client from [this link](https://cloudstor.aarnet.edu.au/client-download/) and
follow the setup instructions in the [CloudStor user guide](https://support.aarnet.edu.au/hc/en-us/sections/115000260553-Getting-started).
You'll need to designate a folder on your computer to sync with CloudStor - by default ownCloud will create
a folder called `ownCloud`, but you can choose a different folder of you want. The contents of this 
folder will be synchronised with CloudStor and any changes (file creations, deletions and modifications) 
will be automatically mirrored
across both copies. You can also install ownCloud on multiple computers which will all be kept
synchronised with each other and with CloudStor. If you've ever used Dropbox, this is functionally the
same behaviour.

### Accessing CloudStor with Rclone
[Rclone](https://rclone.org/) 
is a command-line tool for accessing remote file servers, but with a broader set of 
supported protocols than `rscync`. It is particularly suited to cloud-storage solutions and CloudStor is
no exception.

`rclone` is available on [Windows, Mac and Linux](https://rclone.org/downloads/), as well as RCC and 
Pawsey clusters (but not Gadi), and is the only tool which works identically with both RDM and CloudStor.
 The setup process for using `rsync` with CloudStor is very similar to the process for
UQ's RDM, but with a few small differences in configuration options.

You'll need to configure a *remote* with the correct settings before you can connect to CloudStor, which 
is a long but mostly turnkey process. Before you get started, it's best to create an app-specific password
for `rclone` so you can revoke access if needed without changing your main CloudStor password. You can do this
through the web interface at <https://cloudstor.aarnet.edu.au/client-download/>. 
Log in to the web interface then click the gear in the top right corner of the page to go to the "settings" 
page. In the "security" tab on the left side of the settings page, there will be an option to "create new app 
password" (you may have to scroll down to find it); create a new password and give it a descriptive name like 
"rclone". Copy the password somewhere safe before leaving the page - I recommend a secure password manager 
from [this list](https://web.library.uq.edu.au/research-tools-techniques/digital-essentials/password-management?p=3#3)
by the UQ Library. You can delete the app-password from the same page in the CloudStor web interface if you no 
longer need it.

Once you've set up the app password, the basic steps to setup `rclone` are as follows:

1.  Run `rclone config` and type `n` to create a new configuration. Give it a descriptive name like `cloudstor`
2.  Select `webdav` from the list of protocols.
3.  Enter the following remote URL: `https://cloudstor.aarnet.edu.au/plus/remote.php/webdav/`
4.  Choose `owncloud` for "vendor"
5.  Enter the username you used when signing up for CloudStor. This will most likely be your UQ email 
    `<uq_username>@uq.edu.au`.
6.  Enter the temporary app password when prompted
7.  Leave the "bearer token" field empty
8.  Select `n` when asked to edit the advanced config
9.  Accept the configuration
10. (Optional) You'll want to encrypt the config if you're using `rclone` on a shared system (like Magnus)
    to make sure nobody else can use the configuration to mess with your RDM. Return to the `rclone config` 
    menu and choose `s) Set configuration password` then enter a password.

A detailed guide can be found in the [CloudStor knowledge base](https://support.aarnet.edu.au/hc/en-us/articles/115007168507).

You can then use `rclone` to push and pull files from CloudStor, as well as run basic queries and filesystem 
operations like listing the contents of directories. A full list of options is available via `rclone --help`,
but the basic commands are as follows:
- `rclone ls <remote>:<directory>` - list the files in `<directory>` in your remote (replace `<remote>`
  with the name you chose in step 1 above). The directory paths are relative to the root of your 
  CloudStor repository and, by extension, the sync directory on your computer. For example, if your 
  sync directory is `ownCloud` and you want to find the contents of `ownCloud/my_folder`, then you
  would do `rclone ls cloudstor:/my_folder`.
- `rclone lsd <remote>:<directory>` - as for `rclone ls`, but lists directories rather than files.
- `rclone copy <src> <dst>` - copy a file or directory from source to destination. Usually at least one 
  of these will be a remote, e.g. `rclone copy some_file <remote>:<directory>` to copy `some_file` to
  CloudStor or `rclone copy <remote>:<directory>/some_file ./some_file` to copy `some file` from 
  CloudStor to your current directory on whichever machine you're using `rclone` on. It's also possible to 
  copy from remote to remote, e.g. copying data from your RDM to CloudStor. Also, from the `rclone copy --help`
  page: "Note that it is always the contents of the directory that is synced, not the directory so when 
  source:path is a directory, it's the contents of source:path that are copied, not the directory name and
  contents.". This means that if you run `rclone copy` on a folder, it will splat the contents in your 
  remote directory without creating a new folder. This means it's usually a good idea to create a folder
  in CloudStor first if you want to copy a whole folder to the remote.
- `rclone mkdir <remote>:<directory>` - create a directory on the remote if it doesn't already exist.
- `rclone --dry-run <command>` - do a dry-run of an `rclone` command, which will show what operations 
  would be performed, but will not actually make any changes. It's a good idea to do a dry-run before
  running a potentially destructive command to make sure you're not deleting or overwriting anything
  you don't intend to.
- `rclone --progress <command>` - show real time statistics like file uploads while running a command.

Full documentation for Rclone can also be found on the project's website: <https://rclone.org/>.

# Transferring data to and from HPC clusters
## rsync
RCC, Pawsey and NIC clusters all support using `rsync` for data transfer, either to/from your computer
or another server. The rsync man page (`man rsync`) and [web page](https://rsync.samba.org/) has 
comprehensive documentation with example commands for common operations, but the basic syntax for 
transferring a file or directory from one location (`src`) to another (`dest`) is:

```
rsync <src> <dest>
```

rsync works equally well with both local and remote files, but remote files must be prefaced with a 
host URL to tell rsync where to find them. The remote URL must also contain your username for that 
server, with the general form:

```
rsync <src> <username>@<SSH_URL>:<dest>
rsync <username>@<SSH_URL>:<src> <dest>
```

Files without a remote prefix are assumed to be local to the machine you're running `rsync` on. 
The remote prefixes for each set of clusters are presented in their respective sections below. 
In all cases, you will (probably) need to initiate transfers on your local computer, since it is 
possible to initiate an SSH connection from your computer to the cluster, but not vice versa.

### Tinaroo
The remote prefix to connect to Tinaroo is `uq_username@tinaroo.rcc.uq.edu.au` (the same address
you use for an SSH session). You can also use `rsync` on the cluster (during an SSH session) to
transfer data from Tinaroo to other clusters like Gadi or Magnus. Just log in to the cluster and 
use `rsync` with the desired remote prefix.

### Pawsey clusters - Magnus, Topaz and Zeus
Pawsey clusters have special nodes dedicated to moving data on and off the cluster, which helps
reduce the load on the login nodes. You should use these nodes for large data transfers to
improve data transfer speeds and avoid getting a cranky email from the Pawsey system administrators.
To initiate an `rsync` transfer from your local computer or a non-Pawsey server, use the remote 
prefix `pawsey_username@hpc-data.pawsey.org.au` - this will connect to the filesystem shared 
between all Pawsey clusters. 

To initiate a transfer while logged into a Pawsey cluster, use 
a SLURM batch or interactive job in the `copyq` partition. You'll need to use Zeus - a 
"cloud-like" cluster maintained by Pawsey for high-throughput and data-intensive workloads. 
Log in using the same username and password you use for Magnus, at the SSH address 
`pawsey_username@zeus.pawsey.org.au`. Do not do large data transfers on Magnus, as it does
not have the same optimisations for data movement.

For more detailed instructions and best-practices for data transfers at Pawsey,
see [this page ](https://support.pawsey.org.au/documentation/display/US/Transferring+Files)
in the Pawsey user guide.

### NCI - Gadi
As with Pawsey clusters, Gadi has special nodes dedicated to data transfers on and off clusters.
For `rsync` commands from your local computer or non-NCI servers, use the remote prefix
`nci_username@gadi-dm.nci.org.au`. To initiate a transfer while logged into Gadi, use a PBS job
(batch or interactive) with the `copyq` queue. See [this page](https://opus.nci.org.au/display/Help/0.+Welcome+to+Gadi#id-0.WelcometoGadi-FileTransferto/fromGadi)
in the Gadi user guide for more information.

## Rclone
Rclone is available on Tinaroo (UQ RCC) and Zeus (Pawsey) as a software module. To use it,
you'll need to load the module with `module load rclone` then follow the instructions 
for RDM and/or CloudStor from earlier in this guide. Rclone is also installed on Gadi, but 
is available on login without needing to load a software module.

# Useful links
## UQ RDM
- UQ RDM knowledge base: <https://rdm.uq.edu.au/resources>
- More RDM documentation: <https://guides.library.uq.edu.au/for-researchers/uq-research-data-manager>
## AARNet CloudStor
- AARNet CloudStor knowledge base: <https://support.aarnet.edu.au/hc/en-us/categories/200217608-CloudStor>
- ownCloud desktop client documentation: <https://owncloud.com/docs-guides/>
## Rclone and rsync
- Rclone project website: <https://rclone.org/>
- rsync documentation: <https://rsync.samba.org/documentation.html>
## HPC clusters
- Tinaroo storage system documentation: <http://www2.rcc.uq.edu.au/hpc/guides/index.html?secure/Tinaroo_userguide.html#The-Storage-Subsystem>
- QRISCloud data documentation (for RDM): <https://www.qriscloud.org.au/support/qriscloud-documentation/93-using-qrisdata-collections>
- Pawsey data workflow documentation: <https://support.pawsey.org.au/documentation/display/US/Data+Documentation>
- Gadi user guide: <https://opus.nci.org.au/display/Help/Gadi+User+Guide>