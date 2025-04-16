# headless-game-server-steam

Run your steam games headless when a multiplayer server is required (like Dyson Sphere)

An image aimed at running a steam game headless in order to function like a server. For example Dyson Sphere, with multiplayer mods,running in headless mode works great.

> [!WARNING]  
> This expects you have
> A) purchased the game
> B) have an install that you can copy to mount into the container with it's necessary config
>
> This does not install games for you! You can do an exec into the container and do a steam login/update/install etc.

## Config

### Env Variables

```bash
SLEEP=10 # time to give weston a chance to spin up
GAME_RUN_COMMAND=<big command like wine> # handed to eval and run
```

#### Example

```bash
SLEEP_TIME=20
GAME_RUN_COMMAND=wine "C:\Users\ubuntu\Documents\Dyson Sphere Program\DSPGAME.exe" -nographics -server -batchmode -load resource-start
```

## Build

```bash
docker buildx build . -t headless-game-server-steam:latest
```

## Run

```bash
docker compose -f docker-compose.yml up
```
