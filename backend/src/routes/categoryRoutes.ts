import { Router } from "express";
import { categoryController } from "../controllers/categoryController";

class CategoryRoutes {
    public router: Router = Router();

    constructor() {
        this.config();
    }
// http://localhost:3000/api/catego
    config(): void {
        this.router.get("/", categoryController.getAllCategories);
    }
}

const categoryRoutes = new CategoryRoutes();
export default categoryRoutes.router; 
