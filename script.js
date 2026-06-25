document.addEventListener("DOMContentLoaded", () => {
  const menuLinks = document.querySelectorAll('a[href^="#"]');
  const carousels = document.querySelectorAll(".js-carousel");

  menuLinks.forEach((link) => {
    link.addEventListener("click", (event) => {
      const targetId = link.getAttribute("href");

      if (!targetId || targetId === "#") {
        return;
      }

      const target = document.querySelector(targetId);

      if (!target) {
        return;
      }

      event.preventDefault();
      target.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  });

  carousels.forEach((carousel) => {
    const slides = carousel.querySelectorAll(".js-slide");
    const dots = carousel.querySelectorAll(".js-dot");
    const prevButton = carousel.querySelector(".js-prev");
    const nextButton = carousel.querySelector(".js-next");
    let activeIndex = 0;
    let autoplayId;

    if (!slides.length || !prevButton || !nextButton) {
      return;
    }

    const showSlide = (index) => {
      activeIndex = (index + slides.length) % slides.length;

      slides.forEach((slide, slideIndex) => {
        slide.classList.toggle("is-active", slideIndex === activeIndex);
      });

      dots.forEach((dot, dotIndex) => {
        const isActive = dotIndex === activeIndex;

        dot.classList.toggle("is-active", isActive);
        dot.toggleAttribute("aria-current", isActive);
      });
    };

    const nextSlide = () => showSlide(activeIndex + 1);
    const prevSlide = () => showSlide(activeIndex - 1);

    const startAutoplay = () => {
      autoplayId = window.setInterval(nextSlide, 5000);
    };

    const restartAutoplay = () => {
      window.clearInterval(autoplayId);
      startAutoplay();
    };

    prevButton.addEventListener("click", () => {
      prevSlide();
      restartAutoplay();
    });

    nextButton.addEventListener("click", () => {
      nextSlide();
      restartAutoplay();
    });

    dots.forEach((dot, dotIndex) => {
      dot.addEventListener("click", () => {
        showSlide(dotIndex);
        restartAutoplay();
      });
    });

    carousel.addEventListener("keydown", (event) => {
      if (event.key === "ArrowLeft") {
        prevSlide();
        restartAutoplay();
      }

      if (event.key === "ArrowRight") {
        nextSlide();
        restartAutoplay();
      }
    });

    startAutoplay();
  });
});
