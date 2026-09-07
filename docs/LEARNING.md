# Learning this setup

**You already know how to use an editor.**  
`Ctrl+C`, `Ctrl+V`, `Ctrl+S`, and the rest are intentional here - see [PHILOSOPHY.md](PHILOSOPHY.md). You do not have to throw them away to “deserve” Neovim.

You also do not need to memorize everything in [SHORTCUTS.md](SHORTCUTS.md) on day one.  
Use the familiar Ctrl keys whenever you want. Add Vim + `Space` when *you* want more speed.

My raw notes while learning: [journal/vimshortcut.md](journal/vimshortcut.md).

---

## Mindset

1. **Familiar keys are allowed forever** - they are not training wheels you must remove.  
2. **Normal mode is home for Vim power.** `Esc` often. Insert is for typing.  
3. **Verb + motion** is the optional upgrade: `d`/`c`/`y` + `w`/`$`/`iw`…  
4. **`Space` is a menu.** Pause after Space; read which-key; pick a letter.  
5. **Three new Vim keys a day** when you choose to learn - not all at once.

---

## Week 1 - survive without the mouse

Already good if you use this config: `hjkl`, `u`, `dd`, `/`, visual + `y`/`d`/`c`.

Practice:

| Day | Keys | Drill |
|-----|------|-------|
| 1 | `i` `a` `A` `I` `Esc` | Enter/leave insert without arrows |
| 2 | `w` `b` `e` `0` `$` | Cross a paragraph using only these |
| 3 | `dw` `de` `d$` `dd` | Delete with intent (see journal lesson 1.2) |
| 4 | `yw` `yy` `p` `P` | Yank and paste without Ctrl+C |
| 5 | `/` `n` `N` `*` | Find without Ctrl+F habit |
| 6 | `u` `Ctrl-R` | Undo stack confidence |
| 7 | `:w` `:q` `:wq` | Still fine; or use Ctrl+S |

Operator formula (from classic Vim tutor - also in the journal):

```text
operator  [count]  motion
   d         2       w     → delete two words
```

---

## Week 2 - select and change like a surgeon

| Keys | Meaning |
|------|---------|
| `v` + motion | Character visual |
| `V` | Line visual |
| `vw` / `viw` | Select word |
| `vig` / `vip` | Larger text objects (feel them) |
| then `y` / `d` / `c` | Yank / delete / change selection |
| `ci"` `di(` `yi{` | Inside delimiters - huge ROI |
| `cgn` then `.` | Change search match, repeat |

Keep using Ctrl+S, Ctrl+P, Ctrl+B when you want. No shame.

---

## Week 3 - leader (`Space`) fluency

Every day open which-key and explore **one** group:

| Day | Open | Try |
|-----|------|-----|
| 1 | `Space` `f` | `ff` files, `fr` recent |
| 2 | `Space` `s` | `sg` grep, `sr` replace |
| 3 | `Space` `g` | `gg` lazygit (if installed) |
| 4 | `Space` `b` | `bd` close buffer |
| 5 | `Space` `c` | `ca` action, `cr` rename |
| 6 | `Space` `x` | `xx` diagnostics |
| 7 | `Space` `?` | Buffer-local map discovery |

Also try LazyVim **Flash**: `s` then type labels to jump.

---

## Week 4 - replace & project flow

| Task | Prefer |
|------|--------|
| Quick find | `/` |
| Replace few matches | `/foo` → `cgn` → edit → `.` |
| Replace many in file | `Ctrl+Shift+H` |
| Replace across repo | `Space` `s` `r` |
| Open file by name | `Ctrl+P` or `Space` `f` `f` |
| Run commands | `Ctrl+Shift+P` or `Space` `s` `C` |

---

## What I personally prefer now

Documented so clones understand the **opinion**, not only the maps:

- **`/` over Ctrl+F widgets`** for searching in a file  
- **`u` over thinking about undo stacks in the GUI**  
- **Visual + operator** (`vig` then `y`/`d`/`c`) over Shift+arrow for big edits  
- **`dd` in normal mode** over “select line then delete”  
- **VS Code chords still OK** for save, tabs, explorer, terminal, LSP labels  

If a VS Code key and a Vim habit conflict in your head, keep both for a while; retire the Ctrl key when the Vim key is faster.

---

## Practice rule (sticky)

> Each day: pick **3** keys. Use them on purpose until they feel boring.  
> Then pick 3 more.

That is enough. The shortcut table is a dictionary, not a homework list.

---

## Next reading

1. [PHILOSOPHY.md](PHILOSOPHY.md) - why  
2. [SHORTCUTS.md](SHORTCUTS.md) - what  
3. [journal/vimshortcut.md](journal/vimshortcut.md) - how I learned lessons 1.1-1.2 in my own words  
4. Upstream: [LazyVim docs](https://www.lazyvim.org/) · Vim tutor: `nvim +Tutor`
