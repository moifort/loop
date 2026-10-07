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

## Writing

Slide copy is in French, written in Thibaut's voice: short declarative sentences, plain words, one idea per line,
concrete numbers and names rather than adjectives, no marketing slogans. Correct French spelling and accents.
Code, comments and commit messages are in English.

## Git

- Work directly on `main`, no worktrees and no branches: the preview is served from the main checkout.
- Two people edit this repo. Run `git pull --rebase` before starting and again before pushing.
- One commit per change, conventional commits scoped to the file: `feat(deck): …`, `fix(deck): …`, `docs(deck): …`.
- Pushing publishes the deck to the client-facing URL: only push slides that were checked in the browser.
