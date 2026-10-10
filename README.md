# aws-devops-test-demo

hbe-
hueca-bookstore

Tasks

- Deploy Hellow World app
  - Deploy the infrastructure
    - Deploy vpc (/16)
        * public 
        * private: 
            ** DB
            ** EKS
            ** Others
    - Deploy EKS with helm
  - Deploy the webapp hello workd
    * fe-inventory
    * be-inentory

## Mock bookstore inventory APIs

Both services return fake data and do not persist anything.

Install the Python dependencies from `hueca-bookstore/requirements.txt`, then
run each service from the repository root in a separate terminal:

```bash
uvicorn main:app --app-dir hueca-bookstore/be-inventory --reload --port 8001
uvicorn main:app --app-dir hueca-bookstore/fe-inventory --reload --port 8000
```

The backend serves its fake catalog, including price and stock counts, at
`GET http://localhost:8001/api/books`. The frontend displays the catalog as a
table at `http://localhost:8000/` and serves the same data at
`GET http://localhost:8000/api/books`. Configure `BACKEND_API_URL` if the
backend is at a different address.
  