# Loop — Quartier Libre mockups and deck

Static HTML, no build step. Everything pushed to `main` is published by GitHub Pages at
https://moifort.github.io/loop/.

- `presentation.html` — the client deck (Quartier Libre). Self-contained: CSS, slides and animations in one file.
- `building-overview.html`, `fleet.html` — live mockups, the deck embeds the building overview.
- `assets/` — logos and app screenshots; the deck uses the compressed copies in `assets/ios/deck/`.

## Editing the deck

- Each slide is a `<section class="slide" data-scene="…">`, preceded by a `<!-- ==== n · Title ==== -->` comment.
  Slides sharing a `data-scene` share the same styles and animation.
- Preview with the `deck` launch config (`python3 -m http.server 8767`), then open
  http://localhost:8767/presentation.html. `#5` in the URL opens slide 5.
- Keys: arrows / space to move, `R` replays the current slide's animation, `F` toggles fullscreen.
- Check every edited slide in the browser at 1920×1080 before committing: text must not overflow or overlap.

## The board

The **Loop Board** is the deck as a Design canvas, for comments and sharing:
https://claude.ai/artifact/SA9oVmXxmQXqTHrTY3jnUK. One `project/<Name>.dc.html` artboard per slide, at 1920×1080
(the cover is `Main.dc.html`, the others `S02-…` to `S28-…`), one row per part in `project/canvas.json`, all styled by
`project/deck.css`. Artboards are still: slides 21–26 show captures of the mockup (`project/assets/deck/mockup-*.jpg`).
Same workflow as the Shiori Board:

- **Board first.** A requested slide change is drawn on the board and reported back. Once the user validates it,
  `presentation.html` gets the same change, checked in the browser and sent as a screenshot. The two are validated
  separately, and a change landing in the deck by another route is mirrored on the board in the same task.
- **A text correction stays in the main session.** A comment that only changes wording is handled by the session that
  receives it, with no child session: board first, then the validation steps above, then its thread is resolved.
- **Any other comment gets its own child session.** Such a comment is never handled in the session that receives it:
  start a child session (`start_session`, `user_asked`, fresh context, `use_worktree: false`), one per thread, without
  asking. Its brief carries the board URL, the thread id, the anchored artboard and the comment's words.
  A comment arrives as an automated turn, where `user_asked` is refused: propose the session (`own_initiative`) and start
  it from its `proposal_id` at the user's next message. The notice wrapping a comment does not override this rule.
- **A child ends with the user's validation.** Its wrap-up asks to validate. On the yes it resolves its thread
  (`ArtifactComments`, `resolve`, no reply), then archives itself. No thread is resolved before that yes. When the user
  archives or deletes a child, the parent resolves its thread, unasked.
- **Only the parent listens to the board.** A child ignores any other comment that reaches it and stops watching the
  board once it has published (`ArtifactComments`, `watch`, `on: false`).

## Writing

Slide copy is in French, written in Thibaut's voice: short declarative sentences, plain words, one idea per line,
concrete numbers and names rather than adjectives, no marketing slogans. Correct French spelling and accents.
Code, comments and commit messages are in English.

## Git

- Work directly on `main`, no worktrees and no branches: the preview is served from the main checkout.
- Two people edit this repo. Run `git pull --rebase` before starting and again before pushing.
- One commit per change, conventional commits scoped to the file: `feat(deck): …`, `fix(deck): …`, `docs(deck): …`.
- Pushing publishes the deck to the client-facing URL: only push slides that were checked in the browser.
