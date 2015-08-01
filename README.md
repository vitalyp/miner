# Miner
![Miner](https://raw.githubusercontent.com/vitalyp/miner/master/view/logo.png "Miner")


### Usage instruction:

1. clone repository
2. run the server by `ruby miner.rb`
3. open in browser [http://localhost:8080](http://localhost:8080)

### To run tests:

    rake

> 12 runs, 42 assertions, 0 failures, 0 errors, 0 skips

### Known issues:

**1. Game mechanics:**
  - Cross-Diagonal empty cells opens (shouldn't): horizontal and vertical blocked cells not checked.
    * *ETA: 2hr to fix*
  - Cross-Diagonal mines count cell sometimes opens (shouldn't).
    * *ETA: 2hr to fix*

**2. User interface:**
  - Hide game settings board when game starts.
    * *ETA: 0.2hr to fix*
  - Show hidden cells on game over. 
    * *ETA: 0.2hrs to fix.*
  - Process game finish state (message, show hidden cells, show game settings board, etc). 
    * *ETA: 0.5hrs.*

**3. Improvements list:**
  - Right-click in closed cell puts flag mark. ![Flag](http://osiprodwusodcspstoa01.blob.core.windows.net/en-us/media/4699d9b8-f76a-49e4-b402-5943cf40f22d.gif "Flag")
    * *ETA: 1.5hr*
  - Table of high scores (time_elapsed/board_size/mines_count).
    * *ETA: 2hr*
  - Mobile version (jquery mobile for example). ![JQuery](http://www.free-emoticons.com/files/media-emoticons/11186.png "jQuery example")
    * *ETA: 6hrs*
  - Add interface Skins.
    * *ETA: 4hrs*
