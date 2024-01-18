// Import and register all your controllers from the importmap under controllers/*

//import { application } from "controllers/application";
// Eager load all controllers defined in the import map under controllers/**/*_controller

import { application } from "./application";

import DropdownController from "./dropdown_controller";
application.register("dropdown", DropdownController);
import NewsletterController from "./newsletter_controller";
application.register("newsletter", NewsletterController);
import HelloController from "./hello_controller";
application.register("hello", HelloController);
