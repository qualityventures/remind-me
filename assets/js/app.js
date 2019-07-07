/////////////
// Imports //
/////////////

// Needed because webpack loads the css files through the javascript
import css from '../css/app.sass'

// Default phoenix javascript
import 'phoenix_html'

// Modules
import { headerScrollShadow, toggleMobileMenu } from './modules/header'

/////////////////////
// Main Javascript //
/////////////////////

// Toggle header shadow on scroll
headerScrollShadow()

// Set listener to toggle mobile menu
document.getElementById('mobile-toggle').addEventListener('click', toggleMobileMenu, false)