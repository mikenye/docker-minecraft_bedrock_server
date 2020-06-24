# mikenye/minecraft_bedrock_server

This container provides a Minecraft Bedrock server!

- Automatic `bedrock_server` restarting after crash (thanks to [s6-overlay](https://github.com/just-containers/s6-overlay))
- Container health monitoring! (thanks to [mc-monitor](https://github.com/itzg/mc-monitor.git))
- Ability to send server commands via `docker exec` (without attaching), useful for scripting.
- Automated and regular online worldfile backups (using `save hold`, `save query` & `save resume`), with backup rotation.
- Clean shutdown of `bedrock_server` on container stop.
- All `server.properties` variables exposed via environment variables.
- `bedrock_server` binary runs as an unprivileged user.

## Quick Start - Example with `docker run`

### Create docker volumes:

```
docker volume create minecraft_worlds
docker volume create minecraft_backups
docker volume create minecraft_whitelist
docker volume create minecraft_permissions
```

### Create container:

```
docker run \
    -d \
    -it \
    --name=mc \
    --restart=always \
    -e TZ="Australia/Perth" \
    -e MINECRAFT_SERVER_NAME="Distant Lands Server" \
    -e MINECRAFT_GAMEMODE="survival" \
    -e MINECRAFT_DIFFICULTY="easy" \
    -e MINECRAFT_LEVEL_NAME="Distant Lands" \
    -e MINECRAFT_WHITE_LIST="true" \
    -v minecraft_worlds:/opt/minecraft/worlds \
    -v minecraft_backups:/opt/minecraft/worlds_backup \
    -v minecraft_whitelist:/opt/minecraft/whitelist \
    -v minecraft_permissions:/opt/minecraft/permissions \
    -p 19132:19132/udp \
    mikenye/minecraft_bedrock_server
```

### Whitelist yourself:

```
docker exec mc sendcmd whitelist add "yourself"
```

### Op yourself:

```
docker exec mc sendcmd op "yourself"
```

### Watch container logs:

```
docker logs -f mc
```

## Quick Start - Example with `docker-compose`

### Contents of `docker-compose.yml`:

```
version: '3.8'

volumes:
  minecraft_worlds:
    driver: local
  minecraft_backups:
    driver: local
  minecraft_whitelist:
    driver: local
  minecraft_permissions:
    driver: local

services:
  minecraft:
    image: mikenye/minecraft_bedrock_server
    container_name: mc
    tty: true
    restart: always
    ports:
      - "19132:19132/udp"
    environment:
      TZ: "Australia/Perth"
      MINECRAFT_SERVER_NAME: "Distant Lands Server"
      MINECRAFT_GAMEMODE: "survival"
      MINECRAFT_DIFFICULTY: "easy"
      MINECRAFT_LEVEL_NAME: "Distant Lands"
      MINECRAFT_WHITE_LIST: "true"
    volumes:
      - "minecraft_worlds:/opt/minecraft/worlds"
      - "minecraft_backups:/opt/minecraft/worlds_backup"
      - "minecraft_whitelist:/opt/minecraft/whitelist"
      - "minecraft_permissions:/opt/minecraft/permissions"

```

After you've issued the `docker-compose up -d` to bring the environment online, you can then whitelist & op yourself as-per the above commands.

## Environment Variables

### Container Configuration

| Environment Variable | Description                                                                                                    |
|----------------------|----------------------------------------------------------------------------------------------------------------|
| `TZ`                 | Optional. Your local timezone in "TZ database name" format (<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>). Default is `UTC`. |
| `BACKUP_FREQUENCY`   | Optional. Number of hours between automatic server backups. Default is `1`.  Should be a non-negative integer. |
| `BACKUP_RETENTION`   | Optional. Number of hours each backup should be kept for. Default is `24`, which means each backup will be kept for 24 hours. Should be a non-negative integer. |
| `PUID` | Optional. User ID of the user account that runs `bedrock_server` and owns `/opt/minecraft` (but not `/opt/minecraft/worlds_backup`, see backup section below). Default is `1000`. |
| `PGID` | Optional. Group ID of the user account that runs `bedrock_server` and owns `/opt/minecraft` (but not `/opt/minecraft/worlds_backup`, see backup section below). Default is `1000`. |

### Minecraft Server Configuration (`server.properties`)

All of the variables below are optional. If not set, the default value from `server.properties` is used.

| Environment Variable                                 | Description                                          |
|------------------------------------------------------|------------------------------------------------------|
| `MINECRAFT_SERVER_NAME`                              | Used as the server name. Allowed values: Any string. |
| `MINECRAFT_GAMEMODE`                                 | Sets the game mode for new players. Allowed values: "`survival`", "`creative`", or "`adventure`". |
| `MINECRAFT_DIFFICULTY`                               | Sets the difficulty of the world. Allowed values: "`peaceful`", "`easy`", "`normal`", or "`hard`". |
| `MINECRAFT_ALLOW_CHEATS`                             | If true then cheats like commands can be used. Allowed values: "true" or "`false`". |
| `MINECRAFT_MAX_PLAYERS`                              | The maximum number of players that can play on the server. Allowed values: Any positive integer. |
| `MINECRAFT_ONLINE_MODE`                              | If true then all connected players must be authenticated to Xbox Live. Clients connecting to remote (non-LAN) servers will always require Xbox Live authentication regardless of this setting. If the server accepts connections from the Internet, then it's highly recommended to enable online-mode. Allowed values: "`true`" or "`false`".
| `MINECRAFT_WHITE_LIST`                               | If true then all connected players must be listed in the separate whitelist.json file. Allowed values: "`true`" or "`false`".
| `MINECRAFT_VIEW_DISTANCE`                            | The maximum allowed view distance in number of chunks. Allowed values: Any positive integer. |
| `MINECRAFT_TICK_DISTANCE`                            | The world will be ticked this many chunks away from any player. Allowed values: Integers in the range [`4`, `12`]. |
| `MINECRAFT_PLAYER_IDLE_TIMEOUT`                      | After a player has idled for this many minutes they will be kicked. If set to `0` then players can idle indefinitely. Allowed values: Any non-negative integer. |
| `MINECRAFT_MAX_THREADS`                              | Maximum number of threads the server will try to use. If set to `0` or removed then it will use as many as possible. Allowed values: Any positive integer. |
| `MINECRAFT_LEVEL_NAME`                               | Allowed values: Any string. |
| `MINECRAFT_LEVEL_SEED`                               | Use to randomize the world. Allowed values: Any string. |
| `MINECRAFT_DEFAULT_PLAYER_PERMISSION_LEVEL`          | Permission level for new players joining for the first time. Allowed values: "`visitor`", "`member`", "operator". |
| `MINECRAFT_TEXTUREPACK_REQUIRED`                     | Force clients to use texture packs in the current world. Allowed values: "`true`" or "`false`". |
| `MINECRAFT_CONTENT_LOG_FILE_ENABLED`                 | Enables logging content errors to a file. Allowed values: "`true`" or "`false`". |
| `MINECRAFT_COMPRESSION_THRESHOLD`                    | Determines the smallest size of raw network payload to compress. Allowed values: `0`-`65535`. |
| `MINECRAFT_SERVER_AUTHORATIVE_MOVEMENT`              | Enables server authoritative movement. If `true`, the server will replay local user input on the server and send down corrections when the client's position doesn't match the server's. Corrections will only happen if `MINECRAFT_CORRECT_PLAYER_MOVEMENT` is set to `true`. |
| `MINECRAFT_PLAYER_MOVEMENT_SCORE_THRESHOLD`          | The number of incongruent time intervals needed before abnormal behavior is reported. Disabled by `MINECRAFT_SERVER_AUTHORATIVE_MOVEMENT`. |
| `MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD`       | The difference between server and client positions that needs to be exceeded before abnormal behavior is detected. Disabled by `MINECRAFT_SERVER_AUTHORATIVE_MOVEMENT`. |
| `MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD_IN_MS` | The duration of time the server and client positions can be out of sync (as defined by `MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD`) before the abnormal movement score is incremented. This value is defined in milliseconds. |
| `MINECRAFT_CORRECT_PLAYER_MOVEMENT`                  | If `true`, the client position will get corrected to the server position if the movement score exceeds the threshold. |

## Paths

The following paths should be mapped to external volumes to prevent losing your worlds and so your `whitelist.json` & `permissions.json` persist.

You shouldn't map `server.properties`, as this file is created on container start using the environment variables `MINECRAFT_*` (see above).

| Path                             | Purpose                                |
|----------------------------------|----------------------------------------|
| `/opt/minecraft/worlds`          | Location of the live world files.      |
| `/opt/minecraft/worlds_backup`   | Location of the backed up world files. |
| `/opt/minecraft/whitelist`       | Location of `whitelist.json`.          |
| `/opt/minecraft/permissions`     | Location of `permissions.json`.        |

## Ports

The container exposes **UDP** ports `19132` for IPv4 and `19133` for IPv6.

When publishing the container's ports to the host, you should add `/udp` to your publish argument. For example:

- `docker run -p 19132:19132/udp ...`
- For `docker-compose.yml`:

```
...
  ports:
    - "19132:19132/udp"
...
```

## Backups

World file backups are taken every `BACKUP_FREQUENCY`, and the most recent `BACKUP_RETENTION` backups are kept.

For example, if you leave these two variables at their default of `1` and `24` respectively, you will have a maximum of 24 hourly backups.

Manual backups can be triggered via the `manual_backup` command, see below. Manual backups are automatically cleaned up after they exceed the `BACKUP_RETENTION` age.

The backup process is as follows:

1. `bedrock_server` is placed into `save hold` mode to allow a backup to take place while the server is running.
2. Wait intil `save query` reports that the server is ready for an online backup to take place.
3. The files returned in `save query` are copied to temporary directory `/opt/minecraft/worlds_backup/<world name>/<current datetime>`.
4. The files copied are truncated to the sizes returned in `save query`.
5. The files copied are compressed into a `/opt/minecraft/worlds_backup/<world name>/<current datetime>.tar.xz`.
6. The temporary directory `/opt/minecraft/worlds_backup/<world name>/<current datetime>` is removed.
7. Any backups files in `/opt/minecraft/worlds_backup` older than `BACKUP_RETENTION` hours are removed.
8. Any empty directories in `/opt/minecraft/worlds_backup` are removed.

Backups are owned by `root`. This is by design so that in the event the server becomes compromised, your worldfile backups should not be able to be removed (as the server binary runs as an unprivileged user).

To restore from backup, you can uncompress the backup file (`tar -xJvf <.tar.xz file>`) and copy the files into the `/opt/minecraft/worlds/<world name>`, and start up the server. You may need `xz-tools` for your `tar` to be able to understand `.xz` files.

## Management Commands

There are several helper commands built into the container to help with the management of your Minecraft server.

These can be triggered by using the command `docker exec <container> <command>`, where:

- `<container>` is the name of your Minecraft server container (in the examples below, this is `mc`).
- `<command>` is one of the commands below.

| Command                    | Description                                    | Example                        |
|----------------------------|------------------------------------------------|--------------------------------|
| `sendcmd <server command>` | Sends a server command to the console. *Output is shown on the container console.* See below for a list of server commands. | `docker exec mc sendcmd list`  |
| `manual_backup`            | Triggers a manual backup of the current world. | `docker exec mc manual_backup` |
| `clean_backups`            | Triggers a manual clean-up of old backups.     | `docker exec mc clean_backups` |

## Server Commands

The following server commands can be used with `docker exec <container> sendcmd <command>`:

| Command | Description | Example |
|---------|-------------|---------|
| `kick <player name or xuid> <reason>` | Immediately kicks a player. The reason will be shown on the kicked players screen. | `docker exec mc sendcmd kick "somegriefer" "Griefing not tolerated."`
| `stop` | Shuts down the server **and container** gracefully. | `docker exec mc sendcmd stop` |
| `save <hold | resume | query>` | Used to make atomic backups while the server is running. See the backup section for more information, as the backup process is automated in this container. | `docker exec mc manual_backup` |
| `whitelist <on | off | list | reload>` | `on` and `off` turns the whitelist on and off. Note that this does not change the value in the server.properties file - you should use the `MINECRAFT_WHITE_LIST` variable! `list` prints the current whitelist used by the server. `reload` makes the server reload the whitelist from the file. See the Whitelist Management section below for more information. | `docker exec mc sendcmd whitelist list` |
| `whitelist <add | remove> <name>` | Adds or removes a player from the whitelist file. The name parameter should be the Xbox Gamertag of the player you want to add or remove. You don't need to specify a XUID here, it will be resolved the first time the player connects. See the Whitelist section for more information. | `docker exec mc sendcmd whitelist add "myfriendtotoro"` |
| `permission <list | reload>` | `list` prints the current used operator list. `reload` makes the server reload the operator list from the ops file. See the Permissions section below for more information. | `docker exec mc sendcmd permission list` |
| `op <player>` | Promote a player to `operator`. This will also persist if the player is authenticated to XBL. If the player is not connected to XBL, the player is promoted for the current server session and it will not be persisted. | `docker exec mc sendcmd op "myfriendtotoro"` |
| `deop <player>` | Demote a player to `member`. This will also persist if the player is authenticated to XBL. | `docker exec mc sendcmd op "myfriendtotoro"` |
| `changesetting <setting> <value>` | Changes a server setting without having to restart the server. Currently only two settings are supported to be changed, `allow-cheats` (`true` or `false`) and `difficulty` (`peaceful`, `easy`, `normal` or `hard`). They do not modify the value that's specified in `server.properties` (which is set via environment variables). | `docker exec mc sendcmd difficulty peaceful` |

## Whitelist Management

Adding/removing gamertags to/from server's whitelist can be done by either:

- Editing the `whitelist.json` file and issuing the server commend `whitelist reload` (eg: `docker exec <container> sendcmd whitelist reload`); or
- Using server commands, eg:
  - Adding: `docker exec <container> sendcmd whitelist add <Gamertag>`.
  - Removing: `docker exec <container> sendcmd whitelist remove <Gamertag>`.
  - Note: If there is a white-space in the Gamertag you need to enclose it with double quates: `docker exec <container> sendcmd whitelist add "Example Name"`.

## Permissions Management

Adding/removing server permissions can be done by either:

- Editing the `permissions.json` file and issuing the server commend `permission reload` (eg: `docker exec <container> sendcmd permission reload`); or
- Using server commands, eg:
  - Opping: `docker exec <container> sendcmd op <player>`.
  - Deopping: `docker exec <container> sendcmd deop <player>`.
  - Note: If there is a white-space in the player name you need to enclose it with double quates: `docker exec <container> sendcmd op "Example Name"`.

## Getting help

Please feel free to [open an issue on the project's GitHub](https://github.com/mikenye/docker-minecraft_bedrock_server/issues).

## Changelog

### 2020-06-24

- Initial release of image.
