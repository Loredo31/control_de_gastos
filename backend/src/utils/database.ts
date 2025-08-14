
import { Pool } from 'pg';
import keys from './keys';

const pool = new Pool(keys.database);

pool.connect()
  .then(client => {
    console.log('PostgreSQL conectado en la nube obvis');
    client.release();
  })
  .catch(err => {
    console.error('Error conectando a PostgreSQL:', err);
  });

export default pool;
