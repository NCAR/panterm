# panterm
Command line scripts for managing Drupal websites on Pantheon via terminus commands.



## Setup
Download or copy script and cd into directory with script:

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
review -  pulls down a site into ddev and merges PR in for testing
update -  runs pantheon updates
```

To see instructions for each script:
``./panterm.sh <script> -h``

#### Review script
General usage:
``./panterm.sh review [SITENAME] [PR]``

Where ``SITENAME`` is the site to test the pr on and ``PR`` is the pull request number in 0-9 format.

#### Update script
General usage:
``./panterm.sh update [SITENAME] [ARGUMENTS]``

Where ``SITENAME`` is the site to update and ``ARGUMENTS`` are the extra arguments to pass.

``ARGUMENTS`` are ``-nc|--no-check`` which will skip all update prompts and update the website.



## Notes
If no ``SITENAME``, ``PR``, or ``ARGUMENTS`` passed then the script will prompt for the values.
