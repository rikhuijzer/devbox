# devbox

My development setup for remote machines

## vast.ai

To use this with vast.ai, create a new template with:

Image Path/Tag: `rikhuijzer/devbox` `main`

Docker Options: `TZ=Europe/Amsterdam --hostname vast`

Launch interactive shell with direct SSH.

On-start Script:

```bash
touch ~/.no_auto_tmux; git config --global user.email 'github@huijzer.xyz'; git config --global user.name 'Rik Huijzer'
```

Then, after starting, the only requirement is to run:

```sh
$ su - dev
```
