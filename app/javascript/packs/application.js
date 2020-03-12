require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";

import { submit_spinner } from "../components/submit_spinner"
import { activeClassOnNavbar } from "../components/navbar"
import { addActiveClassToCategory } from "../components/categoryFilter"
import { swapCards } from "../components/swap"


document.addEventListener('turbolinks:load', () => {
  submit_spinner();
  activeClassOnNavbar();
  addActiveClassToCategory();
  swapCards();
});
