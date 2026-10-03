# UniFi — banque de captures pour inspiration UX

Captures collectées le 2026-10-03 pour inspirer la plateforme de gestion de flotte de robots
(plans, inventaire des appareils, localisation, multi-sites). Usage interne d'inspiration
uniquement : les images restent la propriété d'Ubiquiti et des auteurs cités.

Ouvrir [index.html](index.html) pour parcourir la galerie (clic = plein écran).

## Contenu

| Dossier | Thème | Images |
|---|---|---|
| [01-floor-plans](01-floor-plans/) | Plans & cartographie — InnerSpace, Design Center, heatmaps Wi-Fi, ancienne vue Map, UID Layout | 31 |
| [02-devices-network](02-devices-network/) | Appareils & inventaire — Listes d'appareils, Port Manager, Radio Manager, détails d'un appareil | 30 |
| [03-sites-multisite](03-sites-multisite/) | Sites & multi-sites — Site Manager, Fabrics, carte du monde des sites, SD-WAN | 31 |
| [04-topology](04-topology/) | Topologie — Arbre et graphe de topologie réseau | 3 |
| [05-alerts-monitoring](05-alerts-monitoring/) | Alertes & monitoring — Alarm Manager, flux de trafic | 4 |
| [06-protect-cameras](06-protect-cameras/) | Protect (caméras) — Vue carte des caméras, grilles live, détections, timeline | 31 |
| [07-access-doors](07-access-doors/) | Access (portes) — Tableau de bord Access, portes, identités | 12 |
| [08-mobile-apps](08-mobile-apps/) | Apps mobiles (App Store) — Captures officielles iPhone/iPad des apps UniFi | 102 |
| [09-settings-other](09-settings-other/) | Réglages & autres écrans — Formulaires, panneaux de configuration, divers | 39 |

## Sources

Le préfixe du nom de fichier indique la provenance :

- `appstore_…` : App Store (fiches officielles Ubiquiti, via iTunes Lookup API)
- `blog_…` : blog.ui.com (articles officiels)
- `ui_…` : ui.com (pages produit officielles)
- `hc_…` : help.ui.com (Help Center officiel)
- `blogs_…` : blogs tiers : jussiroine.com, securingtheuniverse.com, tdsheridanlab.com, dpctechnology.com, lazyadmin.nl

Articles et pages principaux :

- https://blog.ui.com/article/introducing-the-next-generation-of-unifi-design-center
- https://blog.ui.com/article/introducing-unifi-fabrics
- https://blog.ui.com/article/officially-bringing-unifi-fabrics
- https://blog.ui.com/article/unifi-network-9-0-built-to-scale
- https://blog.ui.com/article/introducing-network-10-5
- https://blog.ui.com/article/introducing-unifi-network-10-6
- https://blog.ui.com/article/introducing-protect-7-0 (et 6.0, 6.2, 7.1, 7.2)
- https://ui.com/wifi, /switching, /cloud-gateways, /camera-security, /door-access, /how-it-works
- https://help.ui.com/hc/en-us/articles/18115373633047 (UID Enterprise Layout)
- https://jussiroine.com/2025/08/mapping-out-wi-fi-coverage-at-home-with-unifi-innerspace
- https://securingtheuniverse.com/2025/11/10/unifi-innerspace-managing-floorplans-and-network-coverage/
- https://tdsheridanlab.com/ubiquiti-unifi-adds-useful-wireless-heat-maps/
- https://www.dpctechnology.com/2024/04/a-comparison-of-unifi-inner-space-and-design-center/
- https://lazyadmin.nl/home-network/unifi-network-8-update/ (Port Manager, Radio Manager)
- https://lazyadmin.nl/home-network/unifi-network-complete-guide/

## Captures clés à regarder en premier

- **Plan avec appareils posés + couverture** : `01-floor-plans/blog_introducing-the-next-generation-of-unifi-design-center__*`, `01-floor-plans/blogs_jussiroine_*`, `01-floor-plans/blogs_securingtheuniverse_*`
- **Plan 3D multi-étages** : `01-floor-plans/blog_unifi-7-just-got-even-better__U7_Blog_04_*`, `01-floor-plans/ui_wifi-3-*`
- **Carte des sites sur le globe** : `03-sites-multisite/blog_introducing-unifi-fabrics__*`
- **Caméras positionnées sur une carte** : `06-protect-cameras/blog_introducing-protect-7-0__*` et `blog_welcome-to-protect-7-1__*`
- **Topologie** : `04-topology/blog_introducing-unifi-network-10-6__*`
- **Inventaire / Port Manager** : `02-devices-network/blogs_lazyadmin_network8_*`, `02-devices-network/ui_port-manager-*`

## Limites

- La console UniFi (unifi.ui.com) exige un compte : pas de captures « live » de l'app web, uniquement des captures publiées.
- La recherche du Help Center est protégée par un challenge Cloudflare : seuls les articles trouvés via recherche web ont été parcourus.
- Les notes de version de community.ui.com ne contiennent pas d'images exploitables.
- Images normalisées en JPEG, 1600 px max sur le grand côté.
