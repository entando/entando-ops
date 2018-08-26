The sole purpose of this image is to allow new developers to get an Entando 
environmet up and running as easily as possible, and to get quick feeback from
tweaking the Maven project.

Features.
1. Uses an embedded Derby database
2. Restores the local Derby database from the Maven project everytime a build 
is done and a  database backup was found in the source. Other than this it 
is entirely ephemeral and stores no state.
