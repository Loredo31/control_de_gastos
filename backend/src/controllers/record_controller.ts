import { Request, Response } from 'express';
import pool from '../utils/database';

class RecordController {
    public async created_record(req: Request, res: Response) {
        const { isentry, amount, category_id, concept,
            is_concurrent, id_type, day, week } = req.body;
        const date = new Date();

        const client = await pool.connect();
        try {
            await client.query('BEGIN');


            const record = await client.query(
                `INSERT INTO record_es (isentry, amount, category_id, concept, date) 
             VALUES ($1, $2, $3, $4, $5) RETURNING *`,
                [isentry, amount, category_id, concept, date]
            );

            if (record.rows.length === 0) {
                throw new Error('No se pudo crear el registro principal');
            }

            if (is_concurrent) {
                const id_record = record.rows[0].id;
                const recurrent_record = await client.query(
                    `INSERT INTO recurrence_record (id_record, idtype, day, week, active) 
                 VALUES ($1, $2, $3, $4, $5) RETURNING *`,
                    [id_record, id_type, day, week, true]
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

    public async view_record(req: Request, res: Response){
        try {
            const record = await pool.query("SELECT * FROM record_es");

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


};
export const recordController = new RecordController();
