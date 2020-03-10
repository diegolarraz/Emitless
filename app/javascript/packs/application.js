require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";

import { submit_spinner } from "../components/submit_spinner"
submit_spinner();

import { activeClassOnNavbar } from "../components/navbar"
activeClassOnNavbar();

const Turbolinks = require("turbolinks")
Turbolinks.start()
