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
        this.router.delete('/:id', recurrencetypeController.deleteRecurrenceType);
        this.router.put('/:id', recurrencetypeController.updateRecurrenceType);
    }
}

const recordRoutes = new RecordRoutes;
export default recordRoutes.router;
