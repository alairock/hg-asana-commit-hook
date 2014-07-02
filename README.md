Mercurial Commit Hook to Asana
===============================

I like processes that provide free benefits and side affects that increase productivity. One of those is the ability to add commit information to the ticket / issue. This is accomplished through a commit hook that will submit the commit message, changeset information and the files touched to the asana ticket in question.

Get the Asana API key:
The api key is required so your commit hook can post to asana. You can find that on the asana website. In the lower left of the window you will see your name. Click on your name and look for the account settings.

A modal will pop-up. Click on the APPS tab to find a link mid way down called "API Key...". Click the API Key link and you will get the API key. This is the key you will add to your .hgrc file.

Update your .hgrc:

There are two sections you will need to add to your .hgrc if they do not exist:

[asana]

asana-key = {API-KEY}

[hooks]

# update the asana ticket with the commit if there is a ticket number found

commit.asana-update = {PATH_TO asana-update.sh}

Add the commit hook file:
Download the commit hook file to the location in your home directory you specified in the .hgrc file.