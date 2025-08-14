import { Request, Response} from "express";


class IndexController{
    public index(req : Request, resp : Response){
        resp.send('Hola conexion a este pedo');
    }
}

export const indexController = new IndexController();
