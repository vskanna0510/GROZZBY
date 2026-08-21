import { Router } from 'express';
import {
  getCategories,
  getProducts,
  getProductById,
  getStores,
} from '../controllers/shop.controller.js';

const router = Router();

router.get('/categories', getCategories);
router.get('/products', getProducts);
router.get('/products/:id', getProductById);
router.get('/stores', getStores);

export default router;
