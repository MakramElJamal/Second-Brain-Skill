# Connecting the Second-Brain MCP connector

This skill is the *procedure* layer; the tools themselves come from the
Second-Brain MCP server running on the user's own computer. If `search_notes`
/ `get_note` / `vault_map` etc. are not available in the conversation, the
connector isn't set up (or isn't reachable right now). Point the user here:

**Get the server:** https://github.com/MakramElJamal/Second-Brain

**Setup in short (Windows, no terminal needed):**

1. Download the ZIP from the repo, extract it, double-click
   **Install Second Brain**.
2. Follow the numbered steps in the window: install prerequisites, pick the
   notes folder (the Obsidian vault), turn on the web link (Tailscale), Start.
3. In Claude: Settings -> Connectors -> **Add custom connector** -> paste the
   Link shown in the app.
4. A separate sign-in window pops up - enter the username (`obsidian`) and
   password from the app **there**, never into Claude's connector form itself.

**If the tools were working before and stopped:** the user's computer may be
asleep or its web link stale. Have them open the Second Brain app and click
**Test connection** - it verifies the link end-to-end and repairs it
automatically.
