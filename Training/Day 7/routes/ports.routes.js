import { Router } from 'express';
import { getAllPorts, getPortsByCode, createPort, deletePort } from '../controllers/ports.controller.js';

const router = Router();

router.get("/", getAllPorts);
router.get("/:code", getPortsByCode);
router.post("/", createPort);
router.delete("/:code", deletePort);

export default router;