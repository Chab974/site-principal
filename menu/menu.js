(function () {
  "use strict";

  var ROOT_ID = "global-shared-nav-root";
  var STYLE_ID = "global-shared-nav-style";
  if (document.getElementById(ROOT_ID)) return;

  var FALLBACK_CONFIG = {
    brand: "Portail IA",
    items: [
      { id: "hub", label: "Site principal", url: "https://chab974.github.io/site-principal/" },
      { id: "quiz", label: "Quizz IA", url: "https://chab974.github.io/quizz-IA/" },
      { id: "autoroute", label: "Autoroute IA", url: "https://chab974.github.io/ia-notre-nouvelle-autoroute/" },
      { id: "dorking", label: "Dorking Lab", url: "https://chab974.github.io/laboratoire-google-dorking-osint/" },
      { id: "neurones", label: "Reseau Neurones", url: "https://chab974.github.io/reseau-neurones-spatial-guide/" }
    ]
  };

  function injectStyle() {
    if (document.getElementById(STYLE_ID)) return;
    var style = document.createElement("style");
    style.id = STYLE_ID;
    style.textContent = [
      "#global-shared-nav-root{position:fixed;left:50%;bottom:14px;transform:translateX(-50%);z-index:2147483647;max-width:95vw;}",
      "#global-shared-nav-root .gsn-shell{display:flex;align-items:center;gap:10px;padding:8px 10px;border-radius:999px;background:rgba(15,23,42,.88);backdrop-filter:blur(8px);border:1px solid rgba(148,163,184,.35);box-shadow:0 10px 30px rgba(2,6,23,.45);}",
      "#global-shared-nav-root .gsn-brand{font:700 12px/1.1 'Segoe UI',sans-serif;letter-spacing:.02em;color:#e2e8f0;padding:7px 10px;border-radius:999px;background:rgba(30,41,59,.8);white-space:nowrap;}",
      "#global-shared-nav-root .gsn-items{display:flex;gap:6px;overflow-x:auto;max-width:78vw;padding-bottom:2px;scrollbar-width:thin;}",
      "#global-shared-nav-root .gsn-item{display:inline-flex;align-items:center;text-decoration:none;white-space:nowrap;font:600 12px/1.1 'Segoe UI',sans-serif;color:#cbd5e1;border:1px solid rgba(71,85,105,.8);background:rgba(30,41,59,.7);padding:7px 10px;border-radius:999px;transition:all .18s ease;}",
      "#global-shared-nav-root .gsn-item:hover{color:#f8fafc;border-color:rgba(56,189,248,.65);transform:translateY(-1px);}",
      "#global-shared-nav-root .gsn-item.active{color:#082f49;background:linear-gradient(135deg,#38bdf8,#14b8a6);border-color:transparent;}",
      "@media (max-width:700px){#global-shared-nav-root{bottom:8px;}#global-shared-nav-root .gsn-shell{padding:7px 8px;gap:8px;}#global-shared-nav-root .gsn-brand{display:none;}#global-shared-nav-root .gsn-items{max-width:92vw;}}"
    ].join("");
    document.head.appendChild(style);
  }

  function normalizeUrl(url) {
    try {
      var u = new URL(url, window.location.href);
      return (u.origin + u.pathname).replace(/\/+$/, "/");
    } catch (e) {
      return String(url || "");
    }
  }

  function isActive(itemUrl) {
    var current = normalizeUrl(window.location.href);
    var target = normalizeUrl(itemUrl);
    return current === target || current.indexOf(target) === 0;
  }

  function render(config) {
    injectStyle();

    var root = document.createElement("div");
    root.id = ROOT_ID;

    var shell = document.createElement("nav");
    shell.className = "gsn-shell";
    shell.setAttribute("aria-label", "Navigation globale");

    var brand = document.createElement("span");
    brand.className = "gsn-brand";
    brand.textContent = config.brand || "Portail IA";
    shell.appendChild(brand);

    var itemsWrap = document.createElement("div");
    itemsWrap.className = "gsn-items";

    (config.items || []).forEach(function (item) {
      var link = document.createElement("a");
      link.className = "gsn-item";
      link.href = item.url;
      link.textContent = item.label;
      link.rel = "noopener noreferrer";
      if (isActive(item.url)) link.classList.add("active");
      itemsWrap.appendChild(link);
    });

    shell.appendChild(itemsWrap);
    root.appendChild(shell);
    document.body.appendChild(root);
  }

  function getConfigUrl() {
    var currentScript = document.currentScript;
    var scriptSrc = currentScript && currentScript.src
      ? currentScript.src
      : "https://chab974.github.io/site-principal/menu/menu.js";
    return new URL("./menu.json", scriptSrc).href;
  }

  fetch(getConfigUrl(), { cache: "no-store" })
    .then(function (r) {
      if (!r.ok) throw new Error("menu config unavailable");
      return r.json();
    })
    .then(function (cfg) {
      render(cfg);
    })
    .catch(function () {
      render(FALLBACK_CONFIG);
    });
})();
