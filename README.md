# Seyon

The wiring between the pieces. The agent's identity, the opencode config,
and the launchers that start and stop everything.

This repo deliberately contains **no code**. The five tools beside it are
separate repositories with their own histories, and vendoring them here
would duplicate those histories and make every update a merge conflict.

## What lives here

| File | What it is |
|---|---|
| `AGENTS.md` | who the agent is, and the rules it works by (opencode reads this) |
| `CLAUDE.md` | the same rules, for a Claude Code session |
| `opencode.json` | the agent's own config: which providers and models it may use |
| `Start Seyon.bat` | start the whole stack, with a watchdog watching it |
| `Stop Seyon.bat` | stop the stack, watchdog included |
| `Make Shortcuts.bat` | recreate the three Desktop shortcuts |

## The five repos

Each is its own repository. Clone them as siblings of this one, in the same
parent folder — the launchers and the supervisor look for them by name.

| Folder | What it is |
|---|---|
| `fullstack-agent/` | the supervisor, the launchers, and the Windows hands |
| `ai-memory-vault/` | the agent's memory: plain text notes it reads and writes |
| `backtalk/` | the voice. Whisper in, Kokoro out, with an espeak-ng fallback |
| `ai-visualizer/` | the face, on port 8790 |
| `barehands/` | the hands, a hand-tracked glass board on port 8794 (optional) |

The brain is **opencode** itself, run as `opencode serve` on port 4599. It is
not Claude Code, and nothing here needs a paid subscription.

## Getting started

```
git clone <this repo> my-agent
cd my-agent
git clone <fullstack-agent> <backtalk> <ai-visualizer> <ai-memory-vault>
git clone <barehands>            # optional
```

Then run `Start Seyon.bat`. `Make Shortcuts.bat` puts the launcher shortcuts
on your Desktop.

## How the supervisor behaves

`Start Seyon.bat` runs `fullstack-agent\supervisor.py`, which checks on a
ten-second loop and restarts whatever is missing:

- the opencode brain on port 4599
- the face on port 8790
- the voice
- the hands board on port 8794, **only** once you have opened it

It checks that each service *answers HTTP*, not merely that its port is
bound: a wedged process keeps the port open and would otherwise look healthy
forever. It also refuses to start a second copy of a server that is already
running, and clears duplicates that somehow got bound to the same port.

`Stop Seyon.bat` stops the watchdog first, then the voice, face and hands.
The brain is left running, because other agents share it.

The hands board is opt-in on purpose: it is a tool you open when you want it,
not a service that should pop up a window nobody asked for.

## Tests

```
py -3 fullstack-agent\tests\test_supervisor.py    # the watchdog, no live stack needed
py -3 backtalk\tests\test_e2e.py                 # voice end to end
py -3 backtalk\tests\test_stt_langs.py           # multilingual speech in
py -3 backtalk\tests\test_espeak_fallback.py     # languages Kokoro has no voice for
```

## Licence

This repo holds only the wiring: the agent identity, the config, and the
launchers. The five tools beside it are AGPL-3.0, © 2026 Jared Rhodenizer,
and their licence terms apply to them and to anything derived from them.
Read each repo's LICENSE before redistributing.