"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const record_controller_1 = require("../controllers/record_controller");
class RecordRoutes {
    constructor() {
        this.router = (0, express_1.Router)();
        this.config();
    }
    config() {
        this.router.get('/', record_controller_1.recordController.view_record);
        this.router.get('/date/:month/:year', record_controller_1.recordController.view_record);
        this.router.post('/', record_controller_1.recordController.created_record);
        this.router.delete('/:id', record_controller_1.recordController.delete_record);
        this.router.put('/', record_controller_1.recordController.update_record);
    }
}
const recordRoutes = new RecordRoutes;
exports.default = recordRoutes.router;
//# sourceMappingURL=record_routes.js.map