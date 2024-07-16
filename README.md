# panterm
Command line scripts for managing Drupal websites on Pantheon via terminus commands.



## Requirements
- ddev
- docker
- mkcert
- terminus
- composer



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
