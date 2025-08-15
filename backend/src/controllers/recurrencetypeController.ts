    import { Request, Response } from 'express';
    import pool from '../utils/database';

class RecurrencetypeController {
    public async getAllRecurrenceTypes(req: Request, res: Response) {
        try {
            const result = await pool.query('SELECT * FROM recurrenceType ORDER BY id');
            res.json({
                status: 200,
                mensaje: 'Tipos de recurrencia obtenidos correctamente',
                body: result.rows
            });
        } catch (err) {
            res.status(500).json({ 
                status: 500,
                mensaje: 'Error al obtener tipos de recurrencia',
                body: (err as Error).message
            });
        }
    }

    public async createRecurrenceType(req: Request, res: Response) {
        try {
            const { type } = req.body;
            const result = await pool.query(
                'INSERT INTO recurrenceType (type) VALUES ($1) RETURNING *',
                [type]
            );
            res.status(201).json({
                status: 201,
                mensaje: 'Tipo de recurrencia creado correctamente',
                body: result.rows[0]
            });
        } catch (err) {
            res.status(500).json({
                status: 500,
                mensaje: 'Error al crear tipo de recurrencia',
                body: (err as Error).message
            });
        }
    }

    public async updateRecurrenceType(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const { type } = req.body;
            const result = await pool.query(
                'UPDATE recurrenceType SET type = $1 WHERE id = $2 RETURNING *',
                [type, id]
            );
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
        } catch (err) {
            res.status(500).json({
                status: 500,
                mensaje: 'Error al actualizar tipo de recurrencia',
                body: (err as Error).message
            });
        }
    }

    public async deleteRecurrenceType(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const result = await pool.query(
                'DELETE FROM recurrenceType WHERE id = $1 RETURNING *', 
                [id]
            );
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
        } catch (err) {
            res.status(500).json({
                status: 500,
                mensaje: 'Error al eliminar tipo de recurrencia',
                body: (err as Error).message
            });
        }
    }
}

export const recurrencetypeController = new RecurrencetypeController();
