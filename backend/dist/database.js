"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const pg_1 = require("pg");
const keys_1 = __importDefault(require("./keys"));
const pool = new pg_1.Pool(keys_1.default.database);
pool.connect()
    .then(client => {
    console.log('PostgreSQL conectado en la nube obvis');
    client.release();
})
    .catch(err => {
    console.error('Error conectando a PostgreSQL:', err);
});
exports.default = pool;
//# sourceMappingURL=database.js.map