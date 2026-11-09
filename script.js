(() => {
  "use strict";

  const menuButton = document.querySelector(".menu-toggle");
  const nav = document.querySelector("#site-nav");

  const setMenu = (open) => {
    if (!menuButton || !nav) return;
    menuButton.setAttribute("aria-expanded", String(open));
    menuButton.setAttribute("aria-label", open ? "Close navigation" : "Open navigation");
    nav.classList.toggle("open", open);
    document.body.classList.toggle("menu-open", open);
  };

  if (menuButton && nav) {
    menuButton.addEventListener("click", () => {
      setMenu(menuButton.getAttribute("aria-expanded") !== "true");
    });
    nav.querySelectorAll("a").forEach(link => {
      link.addEventListener("click", () => setMenu(false));
    });
    document.addEventListener("keydown", event => {
      if (event.key === "Escape") {
        setMenu(false);
        menuButton.focus();
      }
    });
    document.addEventListener("click", event => {
      if (nav.classList.contains("open") &&
          !nav.contains(event.target) &&
          !menuButton.contains(event.target)) setMenu(false);
    });
  }

  document.querySelectorAll("[data-year]").forEach(el => {
    el.textContent = new Date().getFullYear();
  });

  // Progressive enhancement: content remains visible if JS or observers are unavailable.
  const revealItems = document.querySelectorAll("[data-reveal]");
  if ("IntersectionObserver" in window && revealItems.length) {
    revealItems.forEach(item => item.classList.add("reveal-pending"));
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add("revealed");
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.08 });
    revealItems.forEach(item => observer.observe(item));
  }

  const copyButton = document.querySelector("[data-copy-account]");
  if (copyButton) {
    copyButton.addEventListener("click", async () => {
      const number = document.querySelector("#accountNo")?.textContent?.trim() || "";
      const status = document.querySelector("#copyStatus");
      try {
        if (navigator.clipboard && window.isSecureContext) {
          await navigator.clipboard.writeText(number);
        } else {
          const field = document.createElement("textarea");
          field.value = number;
          field.setAttribute("readonly", "");
          field.style.position = "fixed";
          field.style.opacity = "0";
          document.body.appendChild(field);
          field.select();
          const copied = document.execCommand("copy");
          field.remove();
          if (!copied) throw new Error("Clipboard unavailable");
        }
        copyButton.textContent = "Copied successfully";
        if (status) status.textContent =
          "Account number copied. Please verify all bank details directly with iMass Innovation before transferring.";
      } catch (_) {
        if (status) status.textContent =
          "Copy is unavailable in this browser. Select the account number and copy it manually, then verify all details with iMass Innovation.";
      }
    });
  }
})();