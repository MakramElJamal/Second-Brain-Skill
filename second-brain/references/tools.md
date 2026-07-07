# Tool cheatsheet - exact semantics

Consult this when a call surprises you or you need a parameter you don't
remember. `id` always means the vault-relative path of a note, e.g.
`Projects/X/plan.md` - exactly as returned by search/map tools.

## search_notes(query, limit=5, bucket, tags, date_from, date_to)

Ranked snippets over the whole vault. Returns per hit: `id`, `title`,
`bucket`, `tags`, `created`, `summary` (~240 chars), `snippet` (~180 chars
around the best match), `score` (0..1 relative to top hit).

- `bucket`: top-level folder name (`Projects`, `Areas`, `Resources`,
  `Archives`, `Daily Notes`, `Chat Archive`). Case-insensitive.
- `tags`: note must carry ALL listed tags.
- `date_from`/`date_to`: ISO dates against the note's `created` frontmatter.
- Keyword matching (title/tags weighted over summary over body) - use the
  user's distinctive nouns, drop filler words. Two different phrasings max,
  then report a miss.

## get_note(id, section=None, outline=False)

One note. `outline=true` -> headings only. `section="Heading"` -> that
heading's subtree only (case-insensitive; unknown section errors with the
list of available headings - use that list, don't guess again). Full body
only when neither slice suffices. Result includes `title`, `bucket`, `tags`,
`created`, `source`, `content`.

## related_notes(id)

Wikilink graph, one hop, no bodies. Returns:
- `links_to`: notes this note references via `[[...]]` (alias `|` and
  section `#` parts handled; matched by title or filename), as id+title refs.
- `linked_from`: notes whose body links to this one.
- `unresolved`: link targets with no matching note (broken links - worth
  mentioning to the user if they ask about vault hygiene).
Capped at 30 per list.

## vault_map(recent_limit=10)

The structural overview: `buckets` (name -> note count), `folders` (every
real folder path -> note count, INCLUDING empty folders), `active_projects`
(id/title/status), `tags` (the approved vocabulary - the only tags you may
apply without asking), `recent`, `total_notes`. Cheap (~500 tokens). Call
before any create; never cache it across writes.

## create_note(title, bucket, content="", tags, source, status, folder, approve_new_tags=False, overwrite=False)

Creates a templated, governed note. Result signals to respect:
- `status="created"` - done; `id` is the new note's path.
- `status="exists"` - same title already filed there. Use `edit_note` on the
  returned `id`, or `overwrite=true` only on explicit user instruction.
- `status="needs_bucket"` - bucket unknown; retry with one of `suggestions`.
- `proposed_tags` - tags NOT in the vocabulary, NOT applied. Ask the user;
  retry with `approve_new_tags=true` only after a yes.
- `new_folder=true` + `similar_folders` - it created a brand-new folder;
  if a similar one was meant, `vault_move` the note and say so.
- `folder` may be nested (`"Historic Figures/Napoleon"`); a near-duplicate
  name snaps to the existing folder automatically.

## create_folder(bucket, folder)

Folder only (project/area scaffolding). Same bucket normalization and
snap-to-existing behavior as create_note's folder. Results:
`created`/`exists`/`needs_bucket`/`needs_folder`, plus `path`,
`similar_folders`, `suggestions`. An empty new folder shows up in vault_map
immediately.

## edit_note(id, operation, content="", section, frontmatter, approve_new_tags=False)

- `operation="append"` - adds `content` at the end.
- `operation="replace_section"` - replaces the body under `section`
  (errors if the heading doesn't exist - get the outline first).
- `operation="set_frontmatter"` - merges the `frontmatter` dict; its `tags`
  go through the same governance as create_note (`proposed_tags` returned).
Send only the changed slice; never echo the whole note back.

## vault_move(source, destination, create_dirs=True)

Moves a note OR a whole folder; indexes refresh automatically either way.
Fails if `destination` exists - choose another name, never work around it by
overwriting. Archiving a project = `vault_move("Projects/X", "Archives/X")`.

## archive_chat(title, summary, source, decisions, open_questions, key_points, tags, project, participants, raw_transcript, approve_new_tags=False, continue_id)

Distilled conversation memory into `Chat Archive/`. `source` is the assistant
name (claude/chatgpt/gemini). `project` links by project TITLE (from
vault_map). `continue_id` appends a dated update to an existing archive id
instead of creating a new note. `raw_transcript` stores full text out of
search - only on explicit request. Result: `status`
created/continued/exists, `id`, `raw_id`, `tags_used`, `proposed_tags`.

## vault_search_frontmatter(field, value="", match_type="exact", path_prefix, max_results=20)

Metadata query: notes where frontmatter `field` equals/contains `value`, or
merely exists (`match_type="exists"`). Good for "all notes with
status=active" or "everything with a source field". `path_prefix` scopes to
a folder (use forward slashes).
