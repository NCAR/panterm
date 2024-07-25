# panterm
Command line scripts for managing Drupal websites on Pantheon via terminus commands. Based off the [Developing with DDEV](https://wiki.ucar.edu/display/WED/Developing+with+DDEV) wiki guide.



## Requirements
### Software
You will need to following installed on your machine:
- [composer](https://getcomposer.org/download/)
- [ddev](https://ddev.com/get-started/)
- [docker](https://docs.docker.com/engine/install/)
- [gh](https://cli.github.com/)
- mkcert
- [terminus](https://docs.pantheon.io/terminus/install)

### Tokens / Keys
You will also need the following tokens and keys:
- [Pantheon machine token](https://docs.pantheon.io/machine-tokens)
- [Pantheon SSH key](https://docs.pantheon.io/ssh-keys)



## Setup
Clone this repo and cd into the directory:

``git clone https://github.com/NCAR/panterm``

``cd panterm``

Make script executable by running:

``chmod 755 panterm.sh``

Then run the script without arguments to see options:

``./panterm.sh``

Or with the -h flag:

``./panterm.sh -h``



## Instructions
Make sure docker is running **before** running the commands below.

General usage:

``./panterm.sh <script> [SITENAME] [ARGUMENTS]``

### Script options
```
review
update
```

To see instructions for each script:

``./panterm.sh <script> -h``

#### Review script
Pulls down a site into a local ddev container and merges PR in for testing. Will disable simplesaml as well as provide a link to login for the entered user.

General usage:

``./panterm.sh review [SITENAME] [PR]``

Where ``SITENAME`` is the site to test the pr on and ``PR`` is the pull request number in 0-9 format.

#### Update script
Runs pantheon updates for a selected site.

General usage:

``./panterm.sh update [SITENAME] [ARGUMENTS]``

Where ``SITENAME`` is the site to update and ``ARGUMENTS`` are the extra arguments to pass.

``ARGUMENTS`` are ``-nc|--no-check`` which will skip all update prompts and update the website.



## Notes
If no ``SITENAME``, ``PR``, or ``ARGUMENTS`` passed then the script will prompt for the values.

## Todo
If using the --no-check flag then will need to stop if upstream updates are not successful in applying to dev. Similar for not passing no-check where script shouldn't allow to continue and only option should be to exit.

For the review script, maybe see if can use an existing cloned down repo from previous review script run to save on space and ddev containers?



## Bugs
Gets hung up on cloning the files down with sites that have large files. For example 6gb hung up or maybe just need to let it sit for a while?
