"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.recurrencetypeController = void 0;
const database_1 = __importDefault(require("../utils/database"));
class RecurrencetypeController {
    getAllRecurrenceTypes(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const result = yield database_1.default.query('SELECT * FROM recurrenceType ORDER BY id');
                res.json({
                    status: 200,
                    mensaje: 'Tipos de recurrencia obtenidos correctamente',
                    body: result.rows
                });
            }
            catch (err) {
                res.status(500).json({
                    status: 500,
                    mensaje: 'Error al obtener tipos de recurrencia',
                    body: err.message
                });
            }
        });
    }
    createRecurrenceType(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const { type } = req.body;
                const result = yield database_1.default.query('INSERT INTO recurrenceType (type) VALUES ($1) RETURNING *', [type]);
                res.status(201).json({
                    status: 201,
                    mensaje: 'Tipo de recurrencia creado correctamente',
                    body: result.rows[0]
                });
            }
            catch (err) {
                res.status(500).json({
                    status: 500,
                    mensaje: 'Error al crear tipo de recurrencia',
                    body: err.message
                });
            }
        });
    }
    updateRecurrenceType(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                const { type } = req.body;
                const result = yield database_1.default.query('UPDATE recurrenceType SET type = $1 WHERE id = $2 RETURNING *', [type, id]);
                if (result.rows.length === 0)
                    return res.status(404).json({
                        status: 404,
                        mensaje: 'Tipo de recurrencia no encontrado',
                        body: null
                    });
                res.json({
                    status: 200,
                    mensaje: 'Tipo de recurrencia actualizado correctamente',
                    body: result.rows[0]
                });
            }
            catch (err) {
                res.status(500).json({
                    status: 500,
                    mensaje: 'Error al actualizar tipo de recurrencia',
                    body: err.message
                });
            }
        });
    }
    deleteRecurrenceType(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                const result = yield database_1.default.query('DELETE FROM recurrenceType WHERE id = $1 RETURNING *', [id]);
                if (result.rows.length === 0)
                    return res.status(404).json({
                        status: 404,
                        mensaje: 'Tipo de recurrencia no encontrado',
                        body: null
                    });
                res.json({
                    status: 200,
                    mensaje: 'Tipo de recurrencia eliminado correctamente',
                    body: result.rows[0]
                });
            }
            catch (err) {
                res.status(500).json({
                    status: 500,
                    mensaje: 'Error al eliminar tipo de recurrencia',
                    body: err.message
                });
            }
        });
    }
}
exports.recurrencetypeController = new RecurrencetypeController();
//# sourceMappingURL=recurrencetypeController.js.map