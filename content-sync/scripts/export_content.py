#!/usr/bin/env python3
import argparse
import json
import sqlite3
from pathlib import Path


def validate_menu(menu: dict) -> None:
    if not isinstance(menu, dict):
        raise ValueError("menu payload must be an object")
    if "brand" not in menu or not isinstance(menu["brand"], str) or not menu["brand"].strip():
        raise ValueError("menu.brand is required and must be a non-empty string")
    if "items" not in menu or not isinstance(menu["items"], list):
        raise ValueError("menu.items is required and must be an array")

    required_keys = {"id", "label", "url"}
    for idx, item in enumerate(menu["items"]):
        if not isinstance(item, dict):
            raise ValueError(f"menu.items[{idx}] must be an object")
        missing = required_keys - set(item.keys())
        if missing:
            raise ValueError(f"menu.items[{idx}] missing keys: {sorted(missing)}")
        for key in required_keys:
            if not isinstance(item[key], str) or not item[key].strip():
                raise ValueError(f"menu.items[{idx}].{key} must be a non-empty string")


def validate_apps(apps: list) -> None:
    if not isinstance(apps, list):
        raise ValueError("apps payload must be an array")
    required_keys = {"id", "title", "description", "url", "repo"}
    for idx, app in enumerate(apps):
        if not isinstance(app, dict):
            raise ValueError(f"apps[{idx}] must be an object")
        missing = required_keys - set(app.keys())
        if missing:
            raise ValueError(f"apps[{idx}] missing keys: {sorted(missing)}")
        for key in required_keys:
            if not isinstance(app[key], str) or not app[key].strip():
                raise ValueError(f"apps[{idx}].{key} must be a non-empty string")


def main() -> None:
    parser = argparse.ArgumentParser(description="Export content from SQLite to JSON files.")
    parser.add_argument("--db", required=True, help="Path to SQLite database")
    parser.add_argument("--menu-out", required=True, help="Output path for menu JSON")
    parser.add_argument("--apps-out", required=True, help="Output path for apps JSON")
    args = parser.parse_args()

    db_path = Path(args.db)
    if not db_path.exists():
        raise SystemExit(f"Database not found: {db_path}")

    conn = sqlite3.connect(str(db_path))
    conn.row_factory = sqlite3.Row

    menu_cfg = conn.execute(
        "SELECT id, brand FROM menu_config ORDER BY updated_at DESC LIMIT 1"
    ).fetchone()
    if not menu_cfg:
        raise SystemExit("No row found in menu_config")

    menu_items = conn.execute(
        """
        SELECT s.id AS site_id, mi.label, s.url
        FROM menu_items mi
        JOIN sites s ON s.id = mi.site_id
        WHERE mi.menu_id = ? AND mi.visible = 1
        ORDER BY mi.sort_order ASC
        """,
        (menu_cfg["id"],),
    ).fetchall()

    apps_rows = conn.execute(
        """
        SELECT id, title, description, url, repo
        FROM sites
        WHERE active = 1
        ORDER BY sort_order ASC
        """
    ).fetchall()
    conn.close()

    menu_payload = {
        "brand": menu_cfg["brand"],
        "items": [{"id": r["site_id"], "label": r["label"], "url": r["url"]} for r in menu_items],
    }
    apps_payload = [
        {
            "id": r["id"],
            "title": r["title"],
            "description": r["description"],
            "url": r["url"],
            "repo": r["repo"],
        }
        for r in apps_rows
    ]

    validate_menu(menu_payload)
    validate_apps(apps_payload)

    menu_out = Path(args.menu_out)
    apps_out = Path(args.apps_out)
    menu_out.parent.mkdir(parents=True, exist_ok=True)
    apps_out.parent.mkdir(parents=True, exist_ok=True)

    menu_out.write_text(json.dumps(menu_payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    apps_out.write_text(json.dumps(apps_payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
