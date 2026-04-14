import { fail } from "assert";
import { readFileSync } from "fs";
import { join } from "path";

const dataPath = join(import.meta.dirname, "../data/ports.json");

let ports = JSON.parse(readFileSync(dataPath, "utf-8"));

const ok = (res, data, status = 200) => 
    res.status(status).json({ success: true, data });

const error = (res, message, status = 400) => 
    res.status(status).json({ success: false, error: message });

export const getAllPorts = (req, res) => {
    const { country, status, port_role, page, limit } = req.query;
    let result = [...ports];

    if (country) {
        result=result.filter((p) =>
            p.country.toLowerCase().includes(country.toLowerCase())
        );
    }

    if (status) {
        result=result.filter((p) =>
            p.status.toLowerCase().includes(status.toLowerCase())
        );
    }

    if (port_role) {
        result=result.filter((p) =>
            p.port_role.toLowerCase().includes(port_role.toLowerCase())
        );
    }

    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 10));
    const total = result.length;
    const totalPages = Math.ceil(total / limitNum);
    const start = (pageNum - 1) * limitNum;
    const paginated = result.slice(start, start + limitNum);

    ok(res, { ports: paginated, 
        pagination: { total, page: pageNum, limit: limitNum, totalPages }
     });
};

export const getPortsByCode = (req,res) => {
    const { code } = req.params;
    const port = ports.find(
        (p) => p.unlocode.toLowerCase() === code.toLowerCase()
    );
    if (!port){
        return fail(res, `Port with unlocode ${code} not found`, 404);
    };

    ok(res,port);
};

export const createPort = (req, res) => {
    const { unlocode, name, country } = req.body;

    const missing=[];
    if (!unlocode) missing.push("unlocode");
    if (!name) missing.push("name");
    if (!country) missing.push("country");

    if (missing.length > 0){
        return fail(res, `Missing required field(s): ${missing.join(", ")}`, 400);
    };

    const exists = ports.some(
        (p) => p.unlocode.toLowerCase() === unlocode.toLowerCase()
    );

    if (exists){
        return fail(res, `Port with unlocode ${unlocode} already exists`, 400);
    };

    const newPort = { ...req.body, unlocode: unlocode.toUpperCase() };
    ports.push(newPort);
    ok(res, newPort, 201);
};

export const deletePort = (req, res) => {
    const { code } = req.params;

    const index = ports.findIndex(
        (p) => p.unlocode.toLowerCase() === code.toLowerCase()
    );
    if (index === -1){
        return fail(res, `Port with unlocode ${code} not found`, 404);
    }

    const [removed] = ports.splice(index, 1);;

    ok(res, {message: `Port ${removed.unlocode} deleted successfully`});
}
