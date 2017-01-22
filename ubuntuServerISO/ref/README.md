### Caveat

Because of my `DIY` **filesystem.squashfs** is newer than disk iso's, it will broke a lot of softwares' depandencies, so installation procedure would failed at `Select and install software` interface.

The resolution method is **install these softwares you need inside filesystem.squashfs** or **install them after system installation is complete** which make the installation procedure not install them again.

So, **do not** select any software in `Software selection` interface ( Finally, I've modified `ubuntu-server.seed` file which makes `Software selection` interface did not show up ).
