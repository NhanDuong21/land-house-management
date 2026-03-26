document.addEventListener("DOMContentLoaded", function () {
  const revealItems = document.querySelectorAll(".reveal-up");
  const cards = document.querySelectorAll(".dashboard-card");
  const counters = document.querySelectorAll(".counter");

  // Reveal stagger
  const observer = new IntersectionObserver(
    (entries, obs) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const delay = parseInt(entry.target.dataset.delay || "0", 10);
          setTimeout(() => {
            entry.target.classList.add("show");
          }, delay);
          obs.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.15 },
  );

  revealItems.forEach((item) => observer.observe(item));

  // Format number
  function formatNumber(value) {
    return new Intl.NumberFormat("vi-VN").format(value);
  }

  // Counter animation
  function animateCounter(el) {
    const rawValue = Number(el.dataset.value || 0);
    const suffix = el.dataset.suffix || "";
    const duration = Number(el.dataset.duration || 1600);

    let start = 0;
    const startTime = performance.now();

    function update(now) {
      const progress = Math.min((now - startTime) / duration, 1);

      // easeOutCubic
      const eased = 1 - Math.pow(1 - progress, 3);
      const current = Math.floor(start + (rawValue - start) * eased);

      el.textContent = formatNumber(current) + suffix;

      if (progress < 1) {
        requestAnimationFrame(update);
      } else {
        el.textContent = formatNumber(rawValue) + suffix;
      }
    }

    requestAnimationFrame(update);
  }

  const counterObserver = new IntersectionObserver(
    (entries, obs) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          animateCounter(entry.target);
          obs.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.4 },
  );

  counters.forEach((counter) => counterObserver.observe(counter));

  // 3D Tilt
  cards.forEach((card) => {
    card.addEventListener("mousemove", (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const centerX = rect.width / 2;
      const centerY = rect.height / 2;

      const rotateX = ((y - centerY) / centerY) * -6;
      const rotateY = ((x - centerX) / centerX) * 7;

      card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-8px) scale(1.02)`;

      const shine = card.querySelector(".card-shine");
      if (shine) {
        const shineX = (x / rect.width) * 100;
        shine.style.left = `${shineX - 60}%`;
      }
    });

    card.addEventListener("mouseleave", () => {
      card.style.transform = "";
      const shine = card.querySelector(".card-shine");
      if (shine) {
        shine.style.left = "-120%";
      }
    });
  });

  // Optional: slight floating sparkline movement
  const sparkLines = document.querySelectorAll(".sparkline");
  sparkLines.forEach((line, index) => {
    line.style.animation = `chartFloat 3s ease-in-out ${index * 0.1}s infinite`;
  });
});

// inject keyframes once
(function () {
  const style = document.createElement("style");
  style.textContent = `
        @keyframes chartFloat{
            0%,100%{ transform: translateY(0); }
            50%{ transform: translateY(-2px); }
        }
    `;
  document.head.appendChild(style);
})();
