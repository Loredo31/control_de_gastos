import { Router } from 'express';
import { recordController } from '../controllers/record_controller';


class RecordRoutes {
    public router: Router = Router();
    constructor() {
        this.config();
    }

    config(): void {
        this.router.get('/', recordController.view_record);
        this.router.post('/', recordController.created_record);
        this.router.delete('/:id', recordController.delete_record);
        this.router.put('/', recordController.update_record);
    }
}

const recordRoutes = new RecordRoutes;
export default recordRoutes.router;
