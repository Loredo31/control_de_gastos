import { Request, Response } from 'express';
import pool from '../utils/database';

class RecordController {
    /*
    Ruta: http://localhost:3000/api/records
    Ejemplo de JSON a mandar con post
    {
      "isentry": true,
      "amount": 1500.50,
      "category_id": 2,
      "concept": "Pago de servicios",
      "is_concurrent": true,
      "id_type": 1,
      "days_month": 28,
      "days_week": [1,3,5],
      "working_days": false
    }
    */
    public async created_record(req: Request, res: Response) {
        const { isentry, amount, category_id, concept,
            is_concurrent, id_type, days_month, days_week, working_days } = req.body;
        const date = new Date();

        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            // Insertar en record_es
            const record = await client.query(
                `INSERT INTO record_es (isentry, amount, category_id, concept, date) 
                 VALUES ($1, $2, $3, $4, $5) RETURNING *`,
                [isentry, amount, category_id, concept, date]
            );

            if (record.rows.length === 0) {
                throw new Error('No se pudo crear el registro principal');
            }

            // Si es concurrente, insertar en recurrence_record
            if (is_concurrent) {
                const id_record = record.rows[0].id;
                const recurrent_record = await client.query(
                    `INSERT INTO recurrence_record (idrecordes, idtype, active, day_month, days_week, working_days) 
                     VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
                    [id_record, id_type, true, days_month || null, days_week || null, working_days || false]
                );

                if (recurrent_record.rows.length === 0) {
                    throw new Error('No se pudo crear el registro concurrente');
                }
            }

            await client.query('COMMIT');

            res.status(200).json({
                status: true,
                message: 'Registro creado exitosamente',
                body: record.rows[0]
            });

        } catch (error) {
            await client.query('ROLLBACK');
            res.status(500).json({
                status: false,
                message: `Error al crear el registro: ${error.message}`
            });
        } finally {
            client.release();
        }
    }

    /*
Ruta: http://localhost:3000/api/records
*/

    public async view_record(req: Request, res: Response) {
        try {
            const record = await pool.query(`SELECT res.*, ca.name AS category, 
                rr.id AS recurrence_id, rr.idtype, rr.active, rr.day_month, rr.days_week, rr.working_days
                FROM record_es res 
                INNER JOIN category ca ON res.category_id = ca.id
                LEFT JOIN recurrence_record rr ON rr.idrecordes = res.id`);

            if (record.rows.length === 0) {
                return res.status(400).json({
                    status: false,
                    message: 'No se encontraron registros',
                    body: []
                });
            }

            res.status(200).json({
                status: true,
                message: 'Registros encontrados de forma exitosa',
                body: record.rows
            });

        } catch (error) {
            console.error('Error al consultar registros:', error);
            res.status(500).json({
                status: false,
                message: 'Error interno al obtener los registros'
            });
        }
    }

    /*
Ruta: http://localhost:3000/api/records*/
    public async update_record(req: Request, res: Response) {
        const { id, isentry, amount, category_id, concept, is_concurrent, id_type, days_month, days_week, working_days } = req.body;
        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            // Actualizar record_es
            const record = await client.query(
                `UPDATE record_es 
                 SET isentry = $1, amount = $2, category_id = $3, concept = $4
                 WHERE id = $5
                 RETURNING *`,
                [isentry, amount, category_id, concept, id]
            );

            if (record.rows.length === 0) {
                throw new Error('No se encontró el registro a actualizar');
            }

            // Actualizar o crear recurrence_record si es concurrente
            if (is_concurrent) {
                const existing = await client.query(
                    `SELECT * FROM recurrence_record WHERE idrecordes = $1`,
                    [id]
                );

                if (existing.rows.length > 0) {
                    // Actualizar recurrencia existente
                    await client.query(
                        `UPDATE recurrence_record
                         SET idtype = $1, active = $2, day_month = $3, days_week = $4, working_days = $5
                         WHERE idrecordes = $6`,
                        [id_type, true, days_month || null, days_week || null, working_days || false, id]
                    );
                } else {
                    // Crear recurrencia si no existía
                    await client.query(
                        `INSERT INTO recurrence_record (idrecordes, idtype, active, day_month, days_week, working_days)
                         VALUES ($1, $2, $3, $4, $5, $6)`,
                        [id, id_type, true, days_month || null, days_week || null, working_days || false]
                    );
                }
            }

            await client.query('COMMIT');

            res.status(200).json({
                status: true,
                message: 'Registro actualizado exitosamente',
                body: record.rows[0]
            });

        } catch (error) {
            await client.query('ROLLBACK');
            res.status(500).json({
                status: false,
                message: `Error al actualizar el registro: ${error.message}`
            });
        } finally {
            client.release();
        }
    }


    /*Ruta: http://localhost:3000/api/records/:id*/
    public async delete_record(req: Request, res: Response) {
        const { id } = req.params;
        try {
            const result = await pool.query(
                `DELETE FROM record_es WHERE id = $1 RETURNING *`,
                [id]
            );

            if (result.rows.length === 0) {
                return res.status(404).json({
                    status: false,
                    message: 'No se encontró el registro a eliminar'
                });
            }

            res.status(200).json({
                status: true,
                message: 'Registro eliminado exitosamente',
                body: result.rows[0]
            });

        } catch (error) {
            res.status(500).json({
                status: false,
                message: `Error al eliminar el registro: ${error.message}`
            });
        }
    }

    /*Esta funcion se encarga de traer a todos los resgitrso existentes, por mes y año*/
    public async view_record_date(req: Request, res: Response) {
        try {
            const { month, year } = req.params;
            const monthNum = Number(month);
            const yearNum = Number(year);

            const record = await pool.query(
                `SELECT res.*, ca.name AS category, rr.id AS recurrence_id, rr.idtype, rr.active, rr.day_month, rr.days_week, rr.working_days
                 FROM record_es res
                 INNER JOIN category ca ON res.category_id = ca.id
                 LEFT JOIN recurrence_record rr ON rr.idrecordes = res.id
                 WHERE EXTRACT(MONTH FROM res.date) = $1
                 AND EXTRACT(YEAR FROM res.date) = $2
                 ORDER BY res.date DESC`,
                [monthNum, yearNum]
            );

            if (record.rows.length === 0) {
                return res.status(404).json({
                    status: false,
                    message: 'No se encontraron registros para el mes indicado',
                    body: []
                });
            }

            res.status(200).json({
                status: true,
                message: 'Registros encontrados de forma exitosa',
                body: record.rows
            });

        } catch (error) {
            console.error('Error al consultar registros:', error);
            res.status(500).json({
                status: false,
                message: 'Error interno al obtener los registros'
            });
        }
    }

};
export const recordController = new RecordController();
