const headerScrollShadow = () => {
  // Get the desktop header element (we don't want the shadow on mobile)
  const header = document.getElementById("desktop-header")

  // Track scrolling to figure out if the shadow needs to be applied
  window.onscroll = () => {
    if (window.pageYOffset > 0) {
      if (!header.classList.contains('scroll-shadow')) {
        header.classList.add("scroll-shadow")
      }
    } else {
      if (header.classList.contains('scroll-shadow')) {
        header.classList.remove("scroll-shadow")
      }
    }
  }
}

const toggleMobileMenu = () => {
  const menuOpen = document.getElementById('menu-open')
  const menuClose = document.getElementById('menu-close')
  const mobileMenu = document.getElementById('mobile-menu')

  if (window.getComputedStyle(menuOpen).display === 'flex') {
    menuClose.style.display = 'flex'
    menuOpen.style.display = 'none'
    mobileMenu.style.display = 'flex'
  } else {
    menuClose.style.display = 'none'
    menuOpen.style.display = 'flex'
    mobileMenu.style.display = 'none'
  }
}

export { headerScrollShadow, toggleMobileMenu }