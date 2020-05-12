# app-secret-store

* Command line wrapper script to manage custom app keys, secrets and passwords.  MacOS KeyChain 
plugin is enabled by default but other provider plugins can be added.  

* Make sure the keystore file is your PATH or symlink it to a file in your PATH. Also make sure 
to copy the lib sub-folder as well.  

* Can be run from the command line e.g. ```keystore add MYKEYNAME MYPASSWORD``` or run from the menu system
by running just ```keystore``` with no parameters.

* Running the keystore menu system will look for a .keystore file in the folder its run from.  If it's not there it will create an empty one.  This file contains the password variable names you want to manage for the project located in this folder.

* For [Z shell](https://en.wikipedia.org/wiki/Z_shell) users there is an autocompletions file included.  Make sure to copy the _keystore file to your $ZSH_COMPLETIONS_DIR directory.

![keystore screenshot](/app-secret-store/images/shreenshot1.png "keystore screenshot")

__*note: On MacOS if you see odd screen artifacts you may need to update the ncurses package. e.g. using brew: ```brew install ncurses```*__
