"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const categoryController_1 = require("../controllers/categoryController");
class CategoryRoutes {
    constructor() {
        this.router = (0, express_1.Router)();
        this.config();
    }
    // http://localhost:3000/api/catego
    config() {
        this.router.get("/", categoryController_1.categoryController.getAllCategories);
    }
}
const categoryRoutes = new CategoryRoutes();
exports.default = categoryRoutes.router;
//# sourceMappingURL=categoryRoutes.js.map