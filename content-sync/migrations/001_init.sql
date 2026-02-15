PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS sites (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    url TEXT NOT NULL,
    repo TEXT NOT NULL,
    active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    sort_order INTEGER NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS menu_config (
    id TEXT PRIMARY KEY,
    brand TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS menu_items (
    id TEXT PRIMARY KEY,
    menu_id TEXT NOT NULL,
    site_id TEXT NOT NULL,
    label TEXT NOT NULL,
    sort_order INTEGER NOT NULL,
    visible INTEGER NOT NULL DEFAULT 1 CHECK (visible IN (0, 1)),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY (menu_id) REFERENCES menu_config(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_sites_sort_order
    ON sites(sort_order);

CREATE INDEX IF NOT EXISTS idx_menu_items_menu_sort
    ON menu_items(menu_id, sort_order);

