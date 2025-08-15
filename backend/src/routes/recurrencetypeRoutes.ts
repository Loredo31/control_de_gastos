import { Router } from 'express';
import {recurrencetypeController } from '../controllers/recurrencetypeController';


class RecordRoutes {
    public router: Router = Router();
    constructor() {
        this.config();
    }

    config(): void {
        
        this.router.get('/', recurrencetypeController.getAllRecurrenceTypes);
        this.router.post('/', recurrencetypeController.createRecurrenceType);
    }
}

const recordRoutes = new RecordRoutes;
export default recordRoutes.router;
