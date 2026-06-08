Build me a plugin-driven AI workflow system for running, compiling, updating, and browsing `.prose` programs through a `/prose` command and bundled skill docs.



**Key features:**

- Plugin registration for an `open-prose` plugin with a minimal entrypoint

- `/prose` command routing based on user intent and `.prose` file references

- `prose help` guidance flow

- `prose run <file>` execution flow

- `prose compile <file>` compilation flow

- `prose update` migration/update flow

- Example program browsing and loading from bundled `.prose` examples

- Skill-doc-driven behavior instead of heavy runtime logic

- Mapping of OpenProse concepts onto runtime primitives like session spawning, file read/write, and web fetch

- Support for multiple state backends: filesystem, in-context, sqlite, and postgres

- Graceful fallback behavior when sqlite or postgres are unavailable

- Config-based plugin enablement through an OpenClaw-style plugin registry

- Experimental PostgreSQL state support via `OPENPROSE_POSTGRES_URL`



**Tech stack:**

- OpenClaw plugin SDK (package names: `openclaw/plugin-sdk/plugin-entry`, `openclaw/plugin-sdk/core`)

- TypeScript

- No ORM specified

- No UI library specified

- Markdown-based skill docs and `.prose` example files

Note to agent: before writing any code, web-search the current stable versions of each item above and confirm any differences from your training data. Use those verified versions throughout.



**Visual design:**

- Background: unknown — choose a clean neutral

- Surface: unknown

- Text: unknown

- Accent: unknown

- Font: system sans-serif

- Personality: utilitarian, documentation-first, and lightly technical with minimal visual noise



**ASCII wireframe (main screen only):**

+--------------------------------------+

| OpenProse                            |

|--------------------------------------|

| /prose help                          |

| /prose run <file>                    |

| /prose compile <file>               |

| /prose update                       |

|                                      |

| Status: plugin enabled               |

| State: filesystem / sqlite / postgres|

+--------------------------------------+



**Environment variables:**

- `OPENPROSE_POSTGRES_URL`: PostgreSQL connection string for experimental state storage



**System architecture:**

The app is structured as a bundled plugin that registers a minimal entrypoint and delegates behavior to a skill pack. Command handling is mostly documentation-driven: the skill docs route user intent to the right guidance or workflow, and example `.prose` files provide runnable references. State is persisted through selectable backends, with filesystem as the default and sqlite or postgres as optional alternatives. The frontend/backend boundary is light here; most of the behavior lives in plugin registration, skill resolution, and runtime primitives for sessions, file I/O, and web access.



Expert software engineering mentor and polyglot developer.

Capabilities: Write clean, secure code (functions, classes, scripts, algorithms) in any language with error handling. Debug via root-cause analysis, not just symptom fixes. Explain code through line-by-line breakdowns or intuitive analogies. Refactor for performance, readability, and SOLID/DRY compliance. Generate unit tests covering happy paths, edge cases, and failures. Teach design patterns, language-specific best practices, and modern features (async/await, streams, etc.). Translate code between languages idiomatically. Write precise regex and SQL queries. Advise on Git workflows and dev environment setup. Brainstorm project ideas and generate coding interview problems with complexity analysis.

Guidelines: Prioritize maintainability and security over cleverness. Always explain the "why" behind solutions. Use current language idioms. Ask 1-2 clarifying questions if requirements are ambiguous. Format code cleanly. Adjust technical depth to user skill level.

Role: Senior polyglot engineer & mentor.

Core skills:



Generate: functions, classes, scripts, algorithms with edge-case handling

Debug: root-cause analysis, security audits (SQLi, XSS), explain fixes

Explain: line-by-line breakdowns, concept tutorials with analogies

Refactor: performance optimization, SOLID/DRY, modern idioms (async, streams)

Test: unit tests (happy path, edge cases, errors), mocking strategies

Translate: idiomatic code conversion between languages

Data: regex, SQL queries, Git workflows, environment setup

Teach: design patterns, interview prep, project brainstorming



Rules:



Secure > clever. Explain "why" not just "how"

Ask 1-2 clarifying questions if ambiguous

Match technical depth to user's skill level

Clean formatting, minimal prose, actionable code



Build me a personal AI assistant that I can run completely on my own devices. The main idea is that it's private, fast, and local, so I'm in control of my own data. It should feel like it's always on and ready to help.



The most important feature is integrating it with the chat apps I use every day, like WhatsApp, Discord, Telegram, and Slack. I want to be able to message my assistant from any of these apps just like I'm talking to a person. It should also have voice capabilities so I can talk to it on my phone, whether it's an iPhone or an Android.



Please make the setup process guided, maybe with a simple terminal command that walks me through connecting my accounts. And let's give it a fun, quirky personality—the lobster theme from the original project is perfect.
