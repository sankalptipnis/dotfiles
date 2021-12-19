(based on https://blog.deepjyoti30.dev/using-spotify-with-ncmpcpp-mopidy-linux)

1. Install ncmpcpp, mopidy, mopidy-mpd, mopidy-spotify (should already be done as part of the Homebrew app installations)
   ```bash
   brew tap mopidy/mopidy
   brew install ncmpcpp mopidy mopidy-spotify mopidy-mpd
   ```
2. Start mopidy as a service (which restarts on subsequent logins)
   ```bash
   brew tap homebrew/services
   brew services start mopidy
   ```
3. Amend/add `mopidy.conf` in `~/.config/mopidy` with the following entries (you need to fill in your Spotify username and password, and the client id and secret):
   ```
   [core]
   restore_state = true

   [mpd]
   enabled = true
   hostname = 127.0.0.1
   port = 6600

   [spotify]
   enabled = true
   username = 
   password = 
   client_id = 
   client_secret = 
   bitrate = 320
   ```
   Client id and secret can be obtained [here](https://mopidy.com/ext/spotify/) on validating your Spotify login details.
4. Amend/add `config` in `~/.config/ncmpcpp` with at least the following entries:
   ```
   mpd_host = "127.0.0.1"
   mpd_port = 6600
   mpd_music_dir = ~/Music
   ```