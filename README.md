# patcharoo3

patcharoo3

## Git Workflow with Cursor IDE

You can pull and push changes directly from [Cursor](https://cursor.sh) using the built-in Source Control panel.

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/melvincramer911/patcharoo3.git
   cd patcharoo3
   ```

2. Open the folder in Cursor:
   ```bash
   cursor .
   ```

### Pull (fetch latest changes)

From the terminal in Cursor:
```bash
git pull origin main
```

Or use the **Source Control** panel (Ctrl+Shift+G / Cmd+Shift+G) → click the **⋯** menu → **Pull**.

### Push (upload your changes)

From the terminal in Cursor:
```bash
git add .
git commit -m "your commit message"
git push origin main
```

Or use the **Source Control** panel to stage, commit, and then click **Sync Changes** (which pulls then pushes).

### Useful shortcuts in Cursor

| Action | Shortcut |
|--------|----------|
| Open Source Control | Ctrl+Shift+G / Cmd+Shift+G |
| Open Terminal | Ctrl+\` / Cmd+\` |
| Command Palette | Ctrl+Shift+P / Cmd+Shift+P |
