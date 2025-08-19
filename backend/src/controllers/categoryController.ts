import { Request, Response } from 'express';
import pool from '../utils/database';

class CategoryController {
    /*
    http://localhost:3000/api/catego
    */
    
  public async getAllCategories(req: Request, res: Response): Promise<void> {
    try {
      const result = await pool.query("SELECT * FROM category ORDER BY id ASC");
      res.status(200).json({
        status: "Éxitoso",
        message: "Categorías obtenidas correctamente",
        body: result.rows,
      });
    } catch (error) {
      res.status(500).json({
        status: "error",
        message: "Error al obtener categorías",
        error: (error as Error).message,
      });
    }
  }
}

   
export const categoryController = new CategoryController();
