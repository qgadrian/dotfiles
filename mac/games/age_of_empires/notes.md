# Installing the game

* Downloading [Porting Kit](https://www.portingkit.com/)
* Search and install the _wineskin_ for the AoE 2 DE
* Login into Steam and install the game (you can include the Enhanced Graphics DLC)

## Extra steps to play online on a Macbook with M1

> The following steps worked to fix the "out of sync" error when playing online on a MacBook with M1.
> Macs with Intel chips work out of the box.
> Not all the steps here might be mandatory, but since I'm not sure I'm listing everything that I changed before the online started working. They might even make no sense, but it just works™.

* Enable V-sync in the game
  * Seems that this limits FPS to the monitor's frame rate (60) and massively reduces the CPU temps
* Added `SKIPINTRO` to Steam game launch options
* From Winetricks, right click on the game and select "wine configuration"
  * Select `steam.exe`, go to _libraries_ and add `concrt140` and `ucrtbase` as `Native, then built-in`
* Backup the `ucrtbase.dll` file located at `$HOME/Applications/Age of Empires 2 Definitive Ed.app/Contents/SharedSupport/prefix/drive_c/windows/system32`)
* Replace the file above with (two options):
  * The file in the same path as this document
  * https://community.pcgamingwiki.com/files/file/2081-ucrtbasedll-extracted-from-microsoft-visual-c-2015-redistributable-update-3-rc/

### Credits, useful links

Fixing the online on a M1 based MacBook it's a common problem. Here are listed
some of the useful pages, posts, videos... with valuable information &
discussions.

* https://www.youtube.com/watch?app=desktop&v=d_bjg7pJmzE&t=543s
  * Specially the comment section
* https://forums.ageofempires.com/t/game-out-of-sync-error-after-7-12-2021-update/137102
* https://www.reddit.com/r/aoe2/comments/dwuplr/how_to_run_age_of_empires_2_definitive_edition_on/
* https://forums.ageofempires.com/t/out-of-sync-error-during-multiplayer-using-crossover-for-mac/120661/10

> The logs of the game are at: $HOME/Applications/Age of Empires 2 Definitive Ed.app/Contents/SharedSupport/prefix/drive_c/$USERNAME/Wineskin/Games/Age of Empires 2 DE/logs
