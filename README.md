# Second Brain Skill

**The procedure layer for your Second Brain.** This skill teaches Claude (and
any Agent-Skills-compatible assistant) *how* to work with your personal notes
vault - when to search, how deep to read, where to file, and how to leave a
memory of a conversation behind - so you can just talk and the model figures
out the right tool moves by itself.

It pairs with the [Second-Brain MCP server](https://github.com/MakramElJamal/Second-Brain),
which provides the actual tools over your Obsidian/markdown vault:

| Layer | What it provides | Cost in context |
|---|---|---|
| **MCP connector** (the server) | Access: `search_notes`, `get_note`, `vault_map`, `create_note`, `edit_note`, `archive_chat`, … | tool schemas |
| **This skill** | Judgment: the retrieval ladder, filing governance, chat-memory habits, token discipline | ~a few dozen tokens until invoked, one page when active |

Together they form a maximal context layer at minimal token cost: the vault
stays on your machine as the single source of truth, the MCP hands the model
the smallest useful slice of it, and the skill makes the model *ask for* the
smallest useful slice - and file things back the way your vault expects.

## What changes in practice

Without the skill, you have to steer: "search my notes for X", "don't paste
the whole note", "file that under Projects with these tags". With it, saying
things like:

- *"what did I decide about the pitch deck?"* -> snippet-first search of notes
  **and** past-conversation archives, answers cite note ids
- *"create a project for X"* -> a governed folder under Projects plus a
  templated overview note, snapped to your existing tree
- *"archive the X project"* -> the whole folder moves to Archives in one call,
  indexes refresh themselves
- *"save this as a resource note"* -> `vault_map` first, filed into an existing
  folder with approved tags, governance conflicts surfaced instead of forced
- *"remember this conversation"* -> a distilled, searchable memory note
  (decisions / open questions / key points), not a transcript dump
- *"what's connected to this note?"* -> a `related_notes` wikilink-graph hop
  (ids + titles only) instead of fetching bodies

…just works, in any chat where the skill and connector are enabled.

Token tactics baked in: a snippet-first **escalation ladder** (search ->
graph hop -> outline -> section -> full note, never "fetch for context"),
**graph-over-grep** (the vault's wikilinks are a queryable knowledge graph via
`related_notes`), and **progressive disclosure** (the skill body is one page;
exact tool semantics live in `references/tools.md` and load only when
needed).

## Install

### claude.ai (web / desktop / mobile)

1. Zip the skill folder: run `scripts\pack.ps1` (creates
   `dist\second-brain-skill.zip`), or zip the `second-brain/` folder yourself.
2. In Claude: **Settings -> Capabilities -> Skills -> Upload skill** and pick
   the zip.
3. Make sure the Second-Brain MCP connector is also added (see its
   [repo](https://github.com/MakramElJamal/Second-Brain) - the Windows app
   sets it up in minutes).

### Claude Code

Copy the `second-brain/` folder into your skills directory:

```powershell
# personal (all projects)
Copy-Item -Recurse second-brain "$env:USERPROFILE\.claude\skills\second-brain"
# or project-scoped
Copy-Item -Recurse second-brain .claude\skills\second-brain
```

The MCP server connects via `claude mcp add` or an `.mcp.json` entry pointing
at your Second-Brain URL.

## Layout

```
second-brain/
  SKILL.md                       # the skill: triggers + operating discipline
  references/
    tools.md                     # exact tool semantics (loaded on demand)
    connector-setup.md           # loaded only when the connector is missing
scripts/
  pack.ps1                       # zip the skill for claude.ai upload
```

`SKILL.md` follows the [Agent Skills](https://agentskills.io) format (YAML
frontmatter with `name` + trigger-rich `description`, body loaded only when
the skill activates), so it also works with other assistants that support the
standard.

## License

MIT - see [LICENSE](LICENSE).
