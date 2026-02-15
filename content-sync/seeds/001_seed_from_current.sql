PRAGMA foreign_keys = ON;

INSERT INTO sites (
    id, title, description, url, repo, active, sort_order, created_at, updated_at
) VALUES
    ('hub', 'Site principal', 'Portail central des projets IA.', 'https://chab974.github.io/site-principal/', 'https://github.com/Chab974/site-principal', 0, 0, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('autoroute', 'IA: Notre Nouvelle Autoroute', 'Presentation immersive sur l''adoption de l''IA, ses usages et ses limites.', 'https://chab974.github.io/ia-notre-nouvelle-autoroute/', 'https://github.com/Chab974/ia-notre-nouvelle-autoroute', 1, 1, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('quiz', 'Quizz IA', 'Module d''evaluation et de revision autour de l''IA.', 'https://chab974.github.io/quizz-IA/', 'https://github.com/Chab974/quizz-IA', 1, 2, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('neurones', 'Reseau de Neurones Spatial', 'Simulation guidee avec dessin libre et apprentissage interactif des chiffres.', 'https://chab974.github.io/reseau-neurones-spatial-guide/', 'https://github.com/Chab974/reseau-neurones-spatial-guide', 1, 3, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('dorking', 'Laboratoire Google Dorking', 'Tutoriel interactif OSINT / recherche avancee avec scenarios et outils.', 'https://chab974.github.io/laboratoire-google-dorking-osint/', 'https://github.com/Chab974/laboratoire-google-dorking-osint', 1, 4, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z')
ON CONFLICT(id) DO UPDATE SET
    title = excluded.title,
    description = excluded.description,
    url = excluded.url,
    repo = excluded.repo,
    active = excluded.active,
    sort_order = excluded.sort_order,
    updated_at = excluded.updated_at;

INSERT INTO menu_config (id, brand, updated_at) VALUES
    ('main', 'Portail IA', '2026-02-15T00:00:00Z')
ON CONFLICT(id) DO UPDATE SET
    brand = excluded.brand,
    updated_at = excluded.updated_at;

INSERT INTO menu_items (
    id, menu_id, site_id, label, sort_order, visible, created_at, updated_at
) VALUES
    ('mi_hub', 'main', 'hub', 'Site principal', 1, 1, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('mi_autoroute', 'main', 'autoroute', 'Auto ecole de l''IA', 2, 1, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('mi_quiz', 'main', 'quiz', 'Quizz IA', 3, 1, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('mi_neurones', 'main', 'neurones', 'Reseau Neurones', 4, 1, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z'),
    ('mi_dorking', 'main', 'dorking', 'Dorking Lab', 5, 1, '2026-02-15T00:00:00Z', '2026-02-15T00:00:00Z')
ON CONFLICT(id) DO UPDATE SET
    menu_id = excluded.menu_id,
    site_id = excluded.site_id,
    label = excluded.label,
    sort_order = excluded.sort_order,
    visible = excluded.visible,
    updated_at = excluded.updated_at;
