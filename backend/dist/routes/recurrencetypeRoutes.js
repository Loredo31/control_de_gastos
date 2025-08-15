"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const recurrencetypeController_1 = require("../controllers/recurrencetypeController");
class RecordRoutes {
    constructor() {
        this.router = (0, express_1.Router)();
        this.config();
    }
    config() {
        this.router.get('/', recurrencetypeController_1.recurrencetypeController.getAllRecurrenceTypes);
        this.router.post('/', recurrencetypeController_1.recurrencetypeController.createRecurrenceType);
    }
}
const recordRoutes = new RecordRoutes;
exports.default = recordRoutes.router;
//# sourceMappingURL=recurrencetypeRoutes.js.map